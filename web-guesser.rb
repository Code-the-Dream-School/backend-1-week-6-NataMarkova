require "sinatra"
enable :sessions

get "/" do
    if !session[:secret]
        session[:secret] = rand(100)+1
    end
    if !session[:counter]
        session[:counter] = 0
    end
    puts "\n\n\n #{session[:secret]}"
    if session[:number] == session[:secret]
        erb :win
    elsif session[:counter] >= 7
        erb :lose
    else
        puts "session_number: " + session[:number].to_s if session[:number]
        erb :form
    end
end
post "/" do
    session[:name] = params[:name]
    session[:number] = params[:number].to_i
    session[:counter] += 1
    redirect "/"
end