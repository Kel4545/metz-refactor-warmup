class Score

  def score(scoring_dice, game)
    @scoring_dice = scoring_dice
    rejected_dice = @scoring_dice
    tally
    game.available_dice += rejected_dice.length
    @tally_score
  end

  private

  def tally
    @tally_score = 0
    evaluate_dice
    score_one
    score_five
  end

  def straight_score
    @tally_score = 1500
    @scoring_dice.clear
  end

  def three_pairs_score
    @tally_score = 750
    @scoring_dice.clear
  end

  def six_of_a_kind_score
    kind = @scoring_dice.find { |dice| @scoring_dice.count(dice) == 6 }
    if kind == '1'
      @tally_score = 1000 * 4
    else
      @tally_score = kind.to_i * 100 * 2 * 2 * 2
    end
    @scoring_dice.delete(kind)
  end

  def two_three_of_a_kind_score
    kind_0 = @scoring_dice[0]
    kind_1 = @scoring_dice[3]
    if kind_0 == '1'
      @tally_score = 1000 + kind_1.to_i * 100
    else
      @tally_score = kind_0.to_i * 100 + kind_1.to_i * 100
    end
    @scoring_dice.clear
  end

  def five_of_a_kind_score
    kind = @scoring_dice.find { |dice| @scoring_dice.count(dice) == 5 }
    if kind == '1'
      @tally_score = 1000 * 3
    else
      @tally_score = kind.to_i * 100 * 2 * 2
    end
    @scoring_dice.delete(kind)
  end

  def four_of_a_kind_score
    kind = @scoring_dice.find { |dice| @scoring_dice.count(dice) == 4 }
    if kind == '1'
      @tally_score = 1000 * 2
    else
      @tally_score = kind.to_i * 100 * 2
    end
    @scoring_dice.delete(kind)
  end

  def three_of_a_kind_score
    kind = @scoring_dice.find { |dice| @scoring_dice.count(dice) == 3 }
    if kind == '1'
      @tally_score = 1000
    else
      @tally_score = kind.first.to_i * 100
    end
    @scoring_dice.delete(kind)
  end

  def evaluate_dice
    tally = Tally.new(@scoring_dice)

    if tally.straight
      straight_score
    elsif tally.three_pairs
      three_pairs_score
    elsif tally.six_of_a_kind
      six_of_a_kind_score
    elsif tally.two_three_of_a_kind
      two_three_of_a_kind_score
    elsif tally.five_of_a_kind
      five_of_a_kind_score
    elsif tally.four_of_a_kind
      four_of_a_kind_score
    elsif tally.three_of_a_kind
      three_of_a_kind_score
    end
  end

  def score_five
  @tally_score += @scoring_dice.count('1') * 100 if @scoring_dice.count('1') > 0 && @scoring_dice.count('1') < 3
  @scoring_dice.delete('1')
  end

  def score_one
  @tally_score += @scoring_dice.count('5') * 50 if @scoring_dice.count('5') > 0 && @scoring_dice.count('5') < 3
  @scoring_dice.delete('5')
  end
  end
