class User < ActiveRecord::Base
  has_many :identities

  attr_accessible :moves_id

  def self.find_or_create_with_moves(identity)
    moves_id = identity.uid
    user = find_by_moves_id(moves_id)
    user ||= create(:moves_id => moves_id)
  end
end
