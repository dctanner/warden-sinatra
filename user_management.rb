require 'environment'

class UserManagement < Sinatra::Default
  disable :run
  enable :static, :session, :methodoverride, :reload
  set :app_file, __FILE__
  # set :env, :production
  
  get '/register/?' do
    @user = User.new
    view :new
  end
  
  get '/unauthenticated/?' do
    status 401
    view :login
  end

  get '/login/?' do
    view :login
  end
  
  post '/login/?' do
    if env['warden'].authenticated?(:password)
      redirect "/user/#{env['warden'].user}"
    else
      view :login
    end
  end
  
  get '/logout/?' do
    env['warden'].logout
    redirect '/login'
  end
  
  post '/register/?' do
    @user = User.new(params[:user])
    if @user.save
      redirect "/user/#{@user.handle}"
    else
      view :new
    end
  end
  
  get '/user/:handle' do |handle|
    @user = User.new(User.by_handle(:key => handle).first)
    view :show
  end
end