require 'sinatra'

enable :sessions

helpers do
  def guessed_number
    session[:number]
  end

  def secret_number
    session[:secret]
  end

  def guess_description
    if guessed_number > secret_number
        diff = guessed_number - secret_number
        if diff <= 10
            too_what = "close but too high"
        else diff > 10
            too_what = "much too high"
        end
    elsif guessed_number < secret_number
        diff = secret_number - guessed_number
        if diff <= 10
            too_what = "close but too low"
        else diff > 10
            too_what = "much too low"
        end
    end

    puts "Your guess of #{guessed_number} was #{too_what}."
    session[:message] = "Try Again! Your guess of #{guessed_number} is #{too_what}."
  end
end

get '/' do
    set_secret_number
    set_counter
    set_message
    puts "\n\n\nsession_secret=#{session[:secret]}"
    erb :form
end

post "/" do
    session[:number] = params[:number].to_i if params[:number]
    session[:counter] += 1

    if guessed_correctly?
        puts "\n\n\nYOU WIN"
        erb :win
    elsif session[:counter] >= 7
        puts "\n\n\nYOU LOSE"
        erb :lose  
    else
        guess_description
        session[:message]
        erb :form
    end
end

private

def guessed_correctly?
    session[:number] == session[:secret]
end

def set_secret_number
    session[:secret] = rand(100)+1
end

def set_counter
    session[:counter] = 0
end

def set_message
    session[:message]= ""
end
