Rails.application.config.middleware.use OmniAuth::Builder do
  provider :moves, ENV['MOVES_KEY'], ENV['MOVES_SECRET']
  provider :dropbox, ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET']
end
