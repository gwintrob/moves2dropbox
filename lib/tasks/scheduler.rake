require 'dropbox_sdk'

desc 'Backup daily Moves data'
task :backup_moves => :environment do
  User.all.each do |user|
    identities = user.identities
    dropbox = identities.find { |identity| identity.provider == 'dropbox' }
    moves = identities.find { |identity| identity.provider == 'moves' }
    next unless dropbox.present? && moves.present?

    moves_client = Moves::Client.new(moves.token)
    date = Date.today - 1.days
    date_string = date.strftime('%Y_%m_%d.json')
    storyline = moves_client.daily_storyline(date, :trackPoints => true)
    storyline_string = storyline.to_json

    puts '===UPLOADING==='
    puts date_string
    puts storyline_string

    file = Tempfile.new(date_string)
    file.write(storyline_string)
    file.rewind

    dropbox_session = DropboxSession.new(ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET'])
    dropbox_session.set_access_token(dropbox.token, dropbox.secret)
    dropbox_client = DropboxClient.new(dropbox_session)
    response = dropbox_client.put_file("/#{date_string}", file)

    puts '===RESPONSE==='
    puts response
  end
end
