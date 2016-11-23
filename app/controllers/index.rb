get '/' do
  erb :index
end

# get '/:handle' do
#   user = params[:handle]
#   user_data = CLIENT.user_search(user).first

#   @user_id = user_data.id
#   @full_name =user_data.name
#   @url = user_data.profile_image_url("original")

#   @tweets = CLIENT.user_timeline(user, count: 8)
#   erb :twitter_handle
# end

post '/log' do
  user = params[:userName]
  redirect to "/#{user}"
end

get '/:username' do
  puts "*"*100
  puts "Cargando pagina...."
  puts "*"*100
  @user = params[:username]

  tuit_user = TwitterUser.find_or_create_by(name_user: @user)
  tuit_log = Tweet.where(id: tuit_user.id)                                 # busca los twits del este usuario en bd
  user_data = CLIENT.user_search(@user).first                              # busca en API todo de usuario

  @full_name = user_data.name                                              # nombre
  @url = user_data.profile_image_url("original")                           # avatar

  @tweets_c = CLIENT.user_timeline(user_data.user_name)

  if tuit_log.empty?                                                       # La base de datos no tiene tweets?
    @tweets_c.reverse_each do  |t|
      Tweet.create(twitter_user_id: user_data.id, tweet_w: t.text)
    end
  end

  @tiempo = Time.now - @tweets_c.first.created_at                           #desde el ultimo tuit
  if Time.now - @tweets_c.first.created_at > 500                           # si los tuits estan desactualizados
    @tweets_c.reverse_each do  |t|
      if Tweet.find_by(tweet_w: t.text).nil?
        Tweet.create(twitter_user_id: user_data.id, tweet_w: t.text)
      end
    end
  end


  # Se hace una petición por los ultimos 10 tweets a la base de datos. 
  @tweets = Tweet.where(twitter_user_id: user_data.id).order(:created_at).last(10)
  erb :twitter_handle
end

post '/fetch' do
  @tweet = params[:mensaje]
  puts "*"*100
  puts "Publicar un nuevo tweet..."
  puts "*"*100

  unless @tweet.blank?
    CLIENT.update(@tweet)
  end
end

post '/actualiza_lista' do
  @user = params[:userName]
  puts "*"*100
  puts "Recargar lista de tuits..."
  puts "*"*100
  user_data = CLIENT.user_search(@user).first
  @tweets_c = CLIENT.user_timeline(user_data.user_name)

  @tweets_c.reverse_each do  |t|
    if Tweet.find_by(tweet_w: t.text).nil?
      Tweet.create(twitter_user_id: user_data.id.to_s, tweet_w: t.text)
    end
  end

  @tweets = Tweet.where(twitter_user_id: user_data.id).order(:created_at).last(10)
  erb :tweet_list, layout: false 
end