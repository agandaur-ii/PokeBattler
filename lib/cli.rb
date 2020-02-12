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
        elsif input == "Exit"
            return exit
        end
        main_menu
    end

    def main_menu
        prompt = TTY::Prompt.new
        input = prompt.select("What would you like to do?", %w(New_Pokemon My_Pokemon Battle Stats Exit))
        if input == "New_Pokemon"
            get_pokemon
        elsif input == "My_Pokemon"
            name = @user.current_pokemon
            main_menu
        elsif input == "Battle"
            battle
        elsif input == "Stats"
            stats 
        elsif input == "Exit"
            return exit
        end

    end

    def stats 
        prompt = TTY::Prompt.new
        choices = %w(Wins Losses Win_Rate Pokemon_Used Trainers_Battled Arch_Rival Favorite_Pokemon Not_You_Again Best_Trainer Worst_Trainer Best_Pokemon Worst_Pokemon Main_Menu Exit)
        input = prompt.select("Pick a stat to see.", choices)
        if input == "Main_Menu"
            main_menu
        elsif input == "Wins"
            puts @user.wins
            stats
        elsif input == "Losses"
             puts @user.losses
             stats
        elsif input == "Win_Rate"
            puts @user.win_rate
            stats
        elsif input == "Pokemon_Used"
            puts @user.pokemon_used
            stats
        elsif input == "Trainers_Battled"
            puts @user.trainers_battled
            stats
        elsif input == "Arch_Rival"
            puts @user.arch_rival
            stats
        elsif input == "Favorite_Pokemon"
            puts @user.fav_pokemon
            stats
        elsif input == "Not_You_Again"
            puts @user.not_you_again
            stats
        elsif input == "Best_Trainer"
            Trainer.the_best
            stats
        elsif input == "Worst_Trainer"
            Trainer.the_worst
            stats
        elsif input == "Best_Pokemon"
            Pokemon.the_best
            stats
        elsif input == "Worst_Pokemon"
            Pokemon.the_worst
            stats
        elsif input == "Exit"
           return exit
        end
    end

    def battle
        @user.battle!
        get_pokemon
    end

    def exit
        return "Thanks for using PokeBattler!"
    end

    def run
        splash_page
        welcome
        get_pokemon
    end
end