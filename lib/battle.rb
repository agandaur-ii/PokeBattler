class Battle < ActiveRecord::Base

    attr_accessor :p_id_one, :p_id_two, :t_id_one, :t_id_two
    has_many :trainers, through: :pokemons
    has_many :pokemons

    def who_goes_first?
        puts "#{@@user_mon.name}'s health:"
        puts user_mon_health
        puts ""
        puts "#{@@rival_mon.name}'s health:"
        puts rival_mon_health
        puts ""
        @player_one = nil
        @player_two = nil
        list = [@@user_mon, @@rival_mon]

        if @pokemon_1_temp_speed == @pokemon_2_temp_speed
            @player_one = list.delete(list.sample)
            @player_two = list[0]
        end

        if @pokemon_1_temp_speed > @pokemon_2_temp_speed
            @player_one = @@user_mon
            @player_two = @@rival_mon
        else
            @player_one = @@rival_mon
            @player_two = @@user_mon
        end
    end

    def attack(player_num)
        option = [1, 2, 3, 4, 5, 6, 7, 8]
        pick = option.sample
        crit_chance = rand().to_f.round(4)
        miss_chance = rand().to_f.round(4)
        if player_num == @@user_mon
            puts "Your turn".colorize(:green)
            puts "Your #{@@user_mon.name} attacks your oppenent's #{@@rival_mon.name}!"
            if miss_chance <= 0.0500 
                puts ""
                puts "Your attack missed!".colorize(:yellow)
            elsif crit_chance <= 0.0625 
                puts ""
                puts "A CRITICAL HIT".colorize(:color => :black, :background => :green)
                @pokemon_2_temp_hp -= ((@pokemon_1_temp_attack * 1.5) + pick)
            else
                puts ""
                puts "A hit!"
                @pokemon_2_temp_hp -= (@pokemon_1_temp_attack + pick)
            end
        else
            puts "Opponent's Turn".colorize(:red)
            puts "Your opponent's #{@@rival_mon.name} attacks your #{@@user_mon.name}!"
            if miss_chance <= 0.0500  
                puts ""
                puts "Their attack missed!".colorize(:yellow)
            elsif crit_chance <= 0.0625 
                puts ""
                puts "A CRITICAL HIT".colorize(:color => :black, :background => :red)
                @pokemon_1_temp_hp -= ((@pokemon_2_temp_attack * 1.5) + pick)
            else
                puts ""
                puts "A hit!"
                @pokemon_1_temp_hp -= (@pokemon_2_temp_attack + pick)
            end
        end
    end

    def boost(player_num)
        option = [1, 2]
        pick = option.sample
        if player_num == @@user_mon
            if pick == 1
                puts "Your turn".colorize(:green)
                puts "Your #{@@user_mon.name}'s attack increased!"
                @pokemon_1_temp_attack += 20
            else
                puts "Your turn".colorize(:green)
                puts "Your #{@@user_mon.name}'s speed increased!"
                @pokemon_1_temp_speed += 20
            end
        else
            if pick == 1
                puts "Opponent's Turn".colorize(:red)
                puts "Opposing #{@@rival_mon.name}'s attack increased!"
                @pokemon_2_temp_attack += 20
            else
                puts "Opponent's Turn".colorize(:red)
                puts "Opposing #{@@rival_mon.name}'s speed increased!"
                @pokemon_2_temp_speed += 20
            end
        end
    end

    def turn(player_num)
        prompt = TTY::Prompt.new
        if player_num == @@user_mon
            input = prompt.select("What would you like to do?", %w(Attack Boost))
                if input == "Attack"
                    attack(player_num)
                elsif input == "Boost"
                    boost(player_num)
                end
        else 
            option = [1, 1, 1, 2]
            pick = option.sample
            if pick == 1
                attack(player_num)
            else
                boost(player_num)
            end
        end
        @round_count += 0.5
    end

    def user_mon_health
        health = {
            100 => "==========|".colorize(:green), 
            90 => "========= |".colorize(:green), 
            80 => "========  |".colorize(:green), 
            70 => "=======   |".colorize(:green), 
            60 => "======    |".colorize(:green), 
            50 => "=====     |".colorize(:green), 
            40 => "====      |".colorize(:green), 
            30 => "===       |".colorize(:red), 
            20 => "==        |".colorize(:red), 
            10 => "=         |".colorize(:red)
        }
        current_health = (@pokemon_1_temp_hp.to_f / @@user_mon.hp.to_f) * 100
        temp_health = nil
        if current_health > 91
            temp_health = health[100]
        elsif current_health.between?(80,91)
            temp_health = health[90]
        elsif current_health.between?(70,81)
            temp_health = health[80]
        elsif current_health.between?(60,71)
            temp_health = health[70]
        elsif current_health.between?(50,61)
            temp_health = health[60]
        elsif current_health.between?(40,51)
            temp_health = health[50]
        elsif current_health.between?(30,41)
            temp_health = health[40]
        elsif current_health.between?(20,31)
            temp_health = health[30]
        elsif current_health.between?(10,21)
            temp_health = health[20]
        elsif current_health.between?( 0,11)
            temp_health = health[10]
        end
        return temp_health
    end

    def rival_mon_health
        health = {
            100 => "==========|".colorize(:green), 
            90 => "========= |".colorize(:green), 
            80 => "========  |".colorize(:green), 
            70 => "=======   |".colorize(:green), 
            60 => "======    |".colorize(:green), 
            50 => "=====     |".colorize(:green), 
            40 => "====      |".colorize(:green), 
            30 => "===       |".colorize(:red), 
            20 => "==        |".colorize(:red), 
            10 => "=         |".colorize(:red)
        }
        current_health = (@pokemon_2_temp_hp.to_f / @@rival_mon.hp.to_f) * 100
        temp_health = nil
        if current_health > 91
            temp_health = health[100]
        elsif current_health.between?(80,91)
            temp_health = health[90]
        elsif current_health.between?(70,81)
            temp_health = health[80]
        elsif current_health.between?(60,71)
            temp_health = health[70]
        elsif current_health.between?(50,61)
            temp_health = health[60]
        elsif current_health.between?(40,51)
            temp_health = health[50]
        elsif current_health.between?(30,41)
            temp_health = health[40]
        elsif current_health.between?(20,31)
            temp_health = health[30]
        elsif current_health.between?(10,21)
            temp_health = health[20]
        elsif current_health.between?( 0,11)
            temp_health = health[10]
        end
        return temp_health
    end

    def start

        pmon_1 = Pokemon.find(self.p_id_one)
        pmon_2 = Pokemon.find(self.p_id_two)
        t_1 = Trainer.find(self.t_id_one)
        t_2 = Trainer.find(self.t_id_two)

        @@user_mon = pmon_1
        @@rival_mon = pmon_2

        puts "#{t_1.name} and their #{@@user_mon.name} challenge #{t_2.name} and their #{@@rival_mon.name} to a battle!".colorize(:yellow)
        puts ""

        @pokemon_1_temp_hp = @@user_mon.hp
        @pokemon_1_temp_attack = @@user_mon.attack
        @pokemon_1_temp_speed = @@user_mon.speed
        @pokemon_2_temp_hp = @@rival_mon.hp
        @pokemon_2_temp_attack = @@rival_mon.attack
        @pokemon_2_temp_speed = @@rival_mon.speed
        
        @round_count = 1

        until @pokemon_1_temp_hp <= 0 || @pokemon_2_temp_hp <= 0 do  
          puts ""
          puts "+++++++++++++++++++++++++++++++++++++++"
          puts "++++++++        ROUND #{@round_count.to_int}        ++++++++"
          puts "+++++++++++++++++++++++++++++++++++++++"
          puts ""
          who_goes_first?
          turn(@player_one)
          if @pokemon_1_temp_hp <= 0 || @pokemon_2_temp_hp <= 0
            puts "End of match!"
            break
          end
          turn(@player_two)
        end

        if @pokemon_1_temp_hp <= 0 
            winner = @@rival_mon
            loser = @@user_mon
        else
            winner = @@user_mon
            loser = @@rival_mon
        end

        self.winning_pokemon_id = winner.id
        self.winning_trainer_id = winner.trainer_id
        self.losing_pokemon_id = loser.id
        self.losing_trainer_id = loser.trainer_id
        self.save
        winner.trainer_id
    end
end