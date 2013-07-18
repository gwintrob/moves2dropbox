class Identity < ActiveRecord::Base
  belongs_to :user

  attr_accessible :provider, :secret, :token, :uid

  def self.find_or_create_with_omniauth(auth)
    provider, uid = %w{provider uid}.map { |key| auth[key].to_s }
    identity = find_by_provider_and_uid(provider, uid)
    return identity if identity.present?
    secret, token = %w{secret token}.map { |key| auth['credentials'][key].to_s }
    create(:provider => provider, :secret => secret, :token => token, :uid => uid)
  end

  def to_s
    [provider, uid].join(' - ')
  end
end
