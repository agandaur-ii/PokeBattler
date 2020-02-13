require "tty-prompt"

class CommandLineInterface
    prompt = TTY::Prompt.new
    
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
            puts @user.pick_pokemon
        elsif input == "Exit"
            return exit
        end
        main_menu
    end

    def main_menu
        prompt = TTY::Prompt.new
        array = ["New Pokemon", "My Pokemon", "Battle", "Stats", "Exit"]
        input = prompt.select("What would you like to do?", array)
        if input == "New Pokemon"
            get_pokemon
        elsif input == "My Pokemon"
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
        choices = ("Wins", "Losses", "Win Rate", "Pokemon Used", "Trainers Battled", "Arch Rival", "Favorite Pokemon", "Not You Again", "Best Trainer", "Worst Trainer", "Best Pokemon", "Worst Pokemon", "Main Menu", "Exit")
        input = prompt.select("Pick a stat to see.", choices)
        if input == "Main Menu"
            main_menu
        elsif input == "Wins"
            puts @user.wins
            stats
        elsif input == "Losses"
             puts @user.losses
             stats
        elsif input == "Win Rate"
            puts @user.win_rate
            stats
        elsif input == "Pokemon Used"
            puts @user.pokemon_used
            stats
        elsif input == "Trainers Battled"
            puts @user.trainers_battled
            stats
        elsif input == "Arch Rival"
            puts @user.arch_rival
            stats
        elsif input == "Favorite Pokemon"
            puts @user.fav_pokemon
            stats
        elsif input == "Not You Again"
            puts @user.not_you_again
            stats
        elsif input == "Best Trainer"
            Trainer.the_best
            stats
        elsif input == "Worst Trainer"
            Trainer.the_worst
            stats
        elsif input == "Best Pokemon"
            Pokemon.the_best
            stats
        elsif input == "Worst Pokemon"
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

    def splash_page

    end
end