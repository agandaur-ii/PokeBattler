class Trainer < ActiveRecord::Base
    has_many :pokemons
    has_many :battles, through: :pokemons

    def pick_pokemon
        remove_id_if_found = Pokemon.all.find{|p| p.trainer_id == self.id}
        if remove_id_if_found != nil
            remove_id_if_found.trainer_id = nil
            remove_id_if_found.save
        end
        available_list = Pokemon.all.select{|p| p.trainer_id == nil}
        choice = available_list.sample
        choice.trainer_id = self.id
        choice.save
        "You got #{choice.name}!"
    end

    def current_pokemon
        mon = Pokemon.all.select{|p| p.trainer_id == self.id}
        if mon.length == 0
            return "You have not selected a Pokemon yet!"
        end
        "Your current Pokemon is #{mon[0].name}"
    end

    def battle_instances
        Battle.all.select{|b| b.winning_trainer_id == self.id || b.losing_trainer_id == self.id}
    end

    def number_of_battles
        check = battle_instances.count
        if check == 0
            return "You have not battled yet."
        end
        check
    end

    def win_instances
        battle_instances.select{|b| b.winning_trainer_id == self.id}
    end

    def loss_instances
        battle_instances.select{|b| b.losing_trainer_id == self.id}
    end

    def wins
       check = battle_instances.select{|b| b.winning_trainer_id == self.id}.count
       if check == 0
           return "You have not won yet."
       end
       check
    end

    def losses
        check = battle_instances.select{|b| b.losing_trainer_id == self.id}.count
        if check == 0
            return "You have not lost yet!"
        end
        check
    end

    def win_rate
        if number_of_battles == "You have not battled yet."
            return "You have not battled yet."
        end
        if wins == "You have not won yet."
            return 0
        end
        (wins.to_f / number_of_battles.to_f) * 100
    end

    def pokemon_used
        if loss_instances.length == 0 && win_instances.length == 0
            return "You haven't used any Pokemon yet."
        end
        win_list_ids = win_instances.map{|w| w.winning_pokemon_id}
        win_list = win_list_ids.map{|w| Pokemon.find(w)}.map{|pokemon| pokemon.name}
        loss_list_ids = loss_instances.map{|l| l.losing_pokemon_id}
        loss_list = loss_list_ids.map{|l| Pokemon.find(l)}.map{|pokemon| pokemon.name}
        total = []
        total << win_list
        total << loss_list
        total.flatten.uniq
    end

    def trainers_battled
        if loss_instances.length == 0 && win_instances.length == 0
            return "You haven't battled yet."
        end
        win_list_ids = win_instances.map{|w| w.losing_trainer_id}
        win_list = win_list_ids.map{|w| Trainer.find(w)}.map{|trainer| trainer.name}
        loss_list_ids = loss_instances.map{|l| l.winning_trainer_id}
        loss_list = loss_list_ids.map{|l| Trainer.find(l)}.map{|trainer| trainer.name}
        total = []
        total << win_list
        total << loss_list
        total.flatten.uniq
    end

    def arch_rival
        #trainer you have lost to the most
        if loss_instances.length == 0
            return "You have no rival yet!"
        end
        loss_list_ids = loss_instances.map{|l| l.winning_trainer_id}
        loss_list = loss_list_ids.map{|l| Trainer.find(l)}.map{|trainer| trainer.name}
        total = []
        total << loss_list
        flat = total.flatten
        trainer_count = Hash.new(0)
        flat.each {|trainer_name| trainer_count[trainer_name] += 1}
        max_value = trainer_count.map{|k,v| v}.sort.last
        rivals = trainer_count.select do |k,v|
            if v == max_value
                k
            end
        end

        if rivals.keys.length == 1
            "Your rival is #{rivals.keys[0]}"
        else
            puts "You have many rivals!"
            rivals.keys.each{|rival| puts "#{rival}"}
        end
    end

    def fav_pokemon
        #pokemon that has gotten you the most wins
        if win_instances.length == 0
            return "You don't have a favorite Pokemon yet."
        end
        win_list_ids = win_instances.map{|w| w.winning_pokemon_id}
        win_list = win_list_ids.map{|w| Pokemon.find(w)}.map{|pokemon| pokemon.name}
        total = []
        total << win_list
        flat = total.flatten
        pokemon_count = Hash.new(0)
        flat.each {|pokemon_name| pokemon_count[pokemon_name] += 1}
        max_value = pokemon_count.map{|k,v| v}.sort.last
        fav = pokemon_count.select do |k,v|
            if v == max_value
                k
            end
        end

        if fav.keys.length == 1
            "#{fav.keys[0]} is your favorite Pokemon!"
        else
           puts "All of these Pokemon are your favorite!"
            fav.keys.each{|fav| puts "#{fav}"}
        end
    end

    def not_you_again
        #pokemon you have lost to the most
        if loss_instances.length == 0
            return "No Pokemon has beaten you yet!"
        end
        loss_list_ids = loss_instances.map{|l| l.winning_pokemon_id}
        loss_list = loss_list_ids.map{|l| Pokemon.find(l)}.map{|pokemon| pokemon.name}
        total = []
        total << loss_list
        flat = total.flatten
        pokemon_count = Hash.new(0)
        flat.each {|pokemon_name| pokemon_count[pokemon_name] += 1}
        max_value = pokemon_count.map{|k,v| v}.sort.last
        rivals = pokemon_count.select do |k,v|
            if v == max_value
                k
            end
        end

        if rivals.keys.length == 1
            "#{rivals.keys[0]} has beaten you the most"
        else
            puts "All these Pokemon have given you the beat down!"
            rivals.keys.each{|rival| puts "#{rival}"}
        end
    end

    def battle!
        available_list = Trainer.all.select{|t| t != self}
        rival = available_list.sample
        rival.pick_pokemon
        user_pokemon = Pokemon.all.find{|p| p.trainer_id == self.id}
        rival_pokemon = Pokemon.all.find{|p| p.trainer_id == rival.id}
        battle = Battle.create(pokemon_1_id: user_pokemon.id, pokemon_2_id: rival_pokemon.id)
        battle.p_id_one = user_pokemon.id
        battle.p_id_two = rival_pokemon.id
        battle.t_id_one = user_pokemon.trainer_id
        battle.t_id_two = rival_pokemon.trainer_id
        result = battle.start
        rival_pokemon.update(trainer_id: nil)
        #user_pokemon.update(trainer_id: nil)
        #user_pokemon.trainer_id = nil
        if result == self.id
            puts "You won!"
        else
            puts "You lost."
        end
    end

    def self.the_best
        win_list_ids = Battle.all.map{|w| w.winning_trainer_id}
        winning_trainer_list = win_list_ids.map{|w| Trainer.find(w)}.map{|trainer| trainer.name}
        trainer_count = Hash.new(0)
        winning_trainer_list.each {|trainer_name| trainer_count[trainer_name] += 1}
        max_value = trainer_count.map{|k,v| v}.sort.last
        best = trainer_count.select do |k,v|
            if v == max_value
                k
            end
        end

        if best.keys.length == 0
            puts "There is no best trainer yet"
        elsif best.keys.length == 1
            puts "#{best.keys[0]} is the best trainer!"
        else
            puts "These are all the best trainers:"
            best.keys.each{|b| puts "#{b}"}
        end
    end

    def self.the_worst
        loss_list_ids = Battle.all.map{|l| l.losing_trainer_id}
        losing_trainer_list = loss_list_ids.map{|l| Trainer.find(l)}.map{|trainer| trainer.name}
        trainer_count = Hash.new(0)
        losing_trainer_list.each {|trainer_name| trainer_count[trainer_name] += 1}
        max_value = trainer_count.map{|k,v| v}.sort.last
        worst = trainer_count.select do |k,v|
            if v == max_value
                k
            end
        end

        if worst.keys.length == 0
            puts "There is no worst trainer yet"
        elsif worst.keys.length == 1
            puts "#{worst.keys[0]} is the worst trainer...."
        else
            puts "These are all the worst trainers:"
            worst.keys.each{|w| puts "#{w}"}
        end
    end

    def retire
        user_pokemon = Pokemon.all.find{|p| p.trainer_id == self.id}
        user_pokemon.update(trainer_id: nil)
        self.delete
    end
end