require "sinatra"
enable :sessions

def generate_secret_number(secret_number, guess_number)
    secret_number = rand(100)
    max_try = 7
    try = 1
    guess_number = ""
    while try <= max_try && guess_number != secret_number
        puts "Enter a number between 1 and 100"
        guess = gets.chomp.to_i
        if guess_number == secret_number
            puts "Congrats! You win! The secret number number is #{@secret_number}"
            break
        elsif guess_number > secret_number
            diff = guess_number - secret_number
            if diff <= 10
                puts "Your guess is close but too high"
            else diff > 10
                puts "Your guess is much too high"
            end
        elsif guess_number < secret_number
            diff = secret_number - guess_number
            if diff <= 10
                puts "Your guess is close but too low"
            else diff > 10
                puts "Your guess is much too low"
            end

        end
        try += 1
    end

    if guess_number != secret_number
        puts "Sorry, you lose. The secret number was #{secret_number}"
    end
end

get "/" do
    # session[:secret_number] = rand(100).to_i
    erb :form
end

get "/form" do
    puts "The secret number is #{session[:secret_number]}"
    if session[:lost]
        "You lose"
        redirect "/"
    else
        puts "session number: " + session[:secret_number].to_s if session[:secret_number]
        erb :form
    end
end

post "/form" do
    # params.inspect
    # secret_number = session[:secret_number]
    
    unless session[:guess_number]
        session[:guess_number] = [params[:guess_number].to_i]
    else
        if session[:guess_number].count > 6
            session[:lost] = true
            puts "The game is over"
        else
            generate_secret_number(session[:secret_number], session[:guess_number].to_i) unless session[:secret_number].nil?
            session[:guess_number].push(params[:guess_number].to_i)
            puts "Secret number is #{session[:secret_number]}"
            puts "guess number: #{session[:guess_number]}"
        end
    end
    redirect "/"
end
