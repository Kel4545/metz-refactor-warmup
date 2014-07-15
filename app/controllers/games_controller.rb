class GamesController < ApplicationController

  def new
    @game = Game.new
  end

  def create
    @game = Game.new
    @game.new_with_defaults
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find(params[:id])
    if @game.score(@game.last_roll.map { |die| "#{die[0]}" }) == 0
      @bust = true
      @game.current_score = 0
      @game.available_dice = 6
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
    if params[:commit] == 'Roll'
      @game.roll_again(scoring_dice)
    elsif params[:commit] == 'Stay'
      @game.stay(scoring_dice)
    elsif params[:commit] == 'New play'
      @game.roll_again(@game.last_roll.map { |die| "#{die[0]}" })
      @game.current_score = 0
      @game.save
    end
    redirect_to game_path
  end

end
