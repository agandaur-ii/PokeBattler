class CommandLineInterface

    def splash_page

    end
    
    def welcome
        puts "Welcome to PokeBattler! Please enter your name."
        @name = gets.chomp
        puts "Registered as trainer #{@name}"
    end

    def get_pokemon

    end

    def menu

    end

    def battle

    end

    def exit
        puts "Thanks for using PokeBattler!"
        return
    end

    def run
        splash_page
        welcome
        get_pokemon
        menu
    end
end