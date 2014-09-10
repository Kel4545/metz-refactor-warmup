class GamesController < ApplicationController

  def new
    @game = Game.new({})
  end

  def create
    @game = Game.new(params[:players])
    @game.save
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find(params[:id])
    if @game.last_roll.any? && Score.new.score(@game.last_roll.map { |die| "#{die[0]}" }, @game) == 0
      @bust = true
      @game.bust
      @game.save!
    end
  end

  def update
    @game = Game.find(params[:id])
    scoring_dice = [params[:dice_0],
                    params[:dice_1],
                    params[:dice_2],
                    params[:dice_3],
                    params[:dice_4],
                    params[:dice_5],].compact
    if params[:first_roll]  || params[:busted] || scoring_dice.length >0
      if params[:commit] == 'Roll'
        @game.roll_again(scoring_dice)
      elsif turn_finished?
        @game.stay(scoring_dice)
      end
    end
    redirect_to game_path
  end

  private

  def turn_finished?
    params[:commit] == 'Stay' || params[:commit] == 'Awww, man!'
  end

end
