# == Schema Information
#
# Table name: matches
#
#  id                    :bigint(8)        not null, primary key
#  player_id             :bigint(8)        not null
#  player_team_id        :integer          not null
#  challenger_id         :integer
#  challenger_team_id    :integer          not null
#  scenery_id            :bigint(8)        not null
#  winner_id             :integer
#  started_at            :datetime
#  ended_at              :datetime
#  total_time_in_seconds :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  status                :string(50)       not null
#

class Match < ApplicationRecord
  belongs_to :player
  belongs_to :player_team, class_name: 'Team',
                           foreign_key: 'player_team_id',
                           inverse_of: 'matches'

  belongs_to :challenger, class_name: 'Player',
                          foreign_key: 'challenger_id',
                          inverse_of: 'challenger_matches',
                          optional: true

  belongs_to :challenger_team, class_name: 'Team',
                               foreign_key: 'challenger_team_id',
                               inverse_of: 'challenger_matches'

  belongs_to :winner, class_name: 'Player',
                      foreign_key: 'winner_id',
                      inverse_of: 'wins',
                      optional: true

  belongs_to :scenery

  has_many :game_boards, dependent: :destroy

  validate :invalid_winner
  validate :challenger_and_player_are_same_person

  scope :awaiting_challenge, -> { where(challenger_id: nil, started_at: nil) }

  state_machine :status, initial: :awaiting_challenge do
    event :join do
      transition [:awaiting_challenge] => :setting_game_board
    end

    event :play do
      transition [:setting_game_board] => :playing
    end

    event :done do
      transition [:playing] => :game_over
    end

    event :cancel do
      transition [:awaiting_challenge] => :canceled
      transition [:setting_game_board] => :canceled
      transition [:playing] => :canceled
    end
  end

  def awaiting_challenge?
    challenger_id.blank? && started_at.blank?
  end

  def occurring?
    !awaiting_challenge? && ended_at.blank?
  end

  def join_challenger!(challenger)
    if self.challenger.present?
      errors.add(:challenger, :challenger_already_defined)
      raise ActiveRecord::RecordInvalid, self
    end

    self.challenger = challenger
    join
    save!
  end

  def winner!(player)
    self.winner = player
    done
    save!
  end

  private

  def invalid_winner
    return if winner.blank?
    errors.add(:winner_id, :invalid_winner) \
    if player != winner && challenger != winner
  end

  def challenger_and_player_are_same_person
    errors.add(:winner_id, :challenger_and_player_are_same_person) \
    if player == challenger
  end
end
