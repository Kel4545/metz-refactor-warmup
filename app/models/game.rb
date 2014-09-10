class Game < ActiveRecord::Base
  serialize :last_roll, Array
  has_many :players

  def initialize(params)
    player_1_name = params.delete("player_1")
    player_2_name = params.delete("player_2")

    super(params)
    self.players.new(player_name: player_1_name, total_score: 0, current_score: 0)
    self.players.new(player_name: player_2_name, total_score: 0, current_score: 0)
    self.available_dice = 6
    self.player_iterator = 0
  end

  def current_player
    if new_record?
      self.players.first
    else
      self.players.order(:id)[self.player_iterator]
    end
  end

  def roll_again(scoring_dice)
    player = current_player
    self.available_dice -= scoring_dice.length
    self.save
    score = Score.new.score(scoring_dice, self)
    player.current_score += score
    self.available_dice = 6 if self.available_dice == 0
    self.last_roll = roll_dice if scoring_dice == [] || score > 0
    self.save
    player.save
  end

  def bust
    player = current_player
    player.current_score = 0
    player.save
  end

  def stay(scoring_dice)
    player = current_player
    self.player_iterator += 1
    self.player_iterator = 0 if self.player_iterator >= self.players.length
    self.last_roll = []
    self.available_dice = 0
    self.save
    player.total_score ||= 0
    player.current_score ||=0
    player.current_score += Score.new.score(scoring_dice, self)
    player.total_score += player.current_score
    player.current_score = 0
    player.save
  end

  def roll_dice
    dice = {1 => '⚀',
            2 => '⚁',
            3 => '⚂',
            4 => '⚃',
            5 => '⚄',
            6 => '⚅',
    }
    (1..self.available_dice).map { rand(1..6) }.sort.map { |face| [face, dice[face]] }
  end
end
