require "tty-prompt"

class CommandLineInterface
    prompt = TTY::Prompt.new

    def splash_page

    end
    
    def welcome
        puts "Welcome to PokeBattler! Please enter your name."
        @name = gets.chomp
        @user = Trainer.create(name: @name)
        puts "Registered as trainer #{@name}"
    end

    def get_pokemon
        prompt = TTY::Prompt.new
        puts "Let's see who your Pokemon will be!"
        input = prompt.select("Get Pokemon or Exit?", %w(Pokemon Exit))
        if input == "Pokemon"
            @user.pick_pokemon
        else
            exit
        end
        main_menu
    end

    def main_menu
        prompt = TTY::Prompt.new
        input = prompt.select("What would you like to do?", %w(New_Pokemon Battle Exit))
        if input == "New_Pokemon"
            get_pokemon
        elsif input == "Battle"
            battle
        else
            exit
        end

    end

    def battle
        @user.battle!
        main_menu
    end

    def exit
        puts "Thanks for using PokeBattler!"
        return
    end

    def run
        splash_page
        welcome
        get_pokemon
    end
end