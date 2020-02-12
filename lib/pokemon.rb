class Pokemon < ActiveRecord::Base
    has_many :trainers
    has_many :battles

    def stats
        puts "HP: #{self.hp}, Attack: #{self.attack}, Speed: #{self.speed}"
    end

    def battle_instances
        Battle.all.select{|b| b.winning_pokemon_id == self.id || b.losing_pokemon_id == self.id}
    end

    def number_of_battles
        check = battle_instances.count
        if check == 0
            return "This Pokemon has not battled yet."
        end
        check
    end

    def win_instances
        battle_instances.select{|b| b.winning_pokemon_id == self.id}
    end

    def loss_instances
        battle_instances.select{|b| b.losing_pokemon_id == self.id}
    end

    def wins
       check = battle_instances.select{|b| b.winning_pokemon_id == self.id}.count
       if check == 0
           return "This Pokemon has not won yet."
       end
       check
    end

    def losses
        check = battle_instances.select{|b| b.losing_pokemon_id == self.id}.count
        if check == 0
            return "This Pokemon has not lost yet!"
        end
    end

    def win_rate
        if number_of_battles == "This Pokemon has not battled yet."
            return "This Pokemon has not battled yet."
        end
        if wins == "This Pokemon has not won yet."
            return 0
        end
        (wins.to_f / number_of_battles.to_f) * 100
    end

    def trainer_partners
        if loss_instances.length == 0 && win_instances.length == 0
            return "No trainer has used this Pokemon yet."
        end
        win_list_ids = win_instances.map{|w| w.winning_trainer_id}
        win_list = win_list_ids.map{|w| Trainer.find(w)}.map{|t| t.name}
        loss_list_ids = loss_instances.map{|l| l.losing_trainer_id}
        loss_list = loss_list_ids.map{|l| Trainer.find(l)}.map{|t| t.name}
        total = []
        total << win_list
        total << loss_list
        total.flatten.uniq
    end

    def pokemon_battled
        if loss_instances.length == 0 && win_instances.length == 0
            return "This Pokemon has not battled yet."
        end
        win_list_ids = win_instances.map{|w| w.losing_pokemon_id}
        win_list = win_list_ids.map{|w| Pokemon.find(w)}.map{|p| p.name}
        loss_list_ids = loss_instances.map{|l| l.winning_pokemon_id}
        loss_list = loss_list_ids.map{|l| Pokemon.find(l)}.map{|p| p.name}
        total = []
        total << win_list
        total << loss_list
        total.flatten.uniq
    end

    def arch_rival
        #The Pokemon this Pokemon has lost the most to
        if loss_instances.length == 0
            return "This Pokemon has no rival yet!"
        end
        loss_list_ids = loss_instances.map{|l| l.winning_pokemon_id}
        loss_list = loss_list_ids.map{|l| Pokemon.find(l)}.map{|p| p.name}
        total = []
        total << loss_list
        flat = total.flatten
        p_count = Hash.new(0)
        flat.each {|p_name| p_count[p_name] += 1}
        max_value = p_count.map{|k,v| v}.sort.last
        rivals = p_count.select do |k,v|
            if v == max_value
                k
            end
        end

        if rivals.keys.length == 1
            puts "This Pokemon's rival is #{rivals.keys[0]}"
        else
            puts "This Pokemon has many rivals!"
            rivals.keys.each{|rival| puts "#{rival}"}
        end
    end

    def fav_trainer
        #The trainer this Pokemon has the most wins with
        if win_instances.length == 0
            return "This Pokemon doesn't have a favorite trainer yet."
        end
        win_list_ids = win_instances.map{|w| w.winning_trainer_id}
        win_list = win_list_ids.map{|w| Trainer.find(w)}.map{|t| t.name}
        total = []
        total << win_list
        flat = total.flatten
        t_count = Hash.new(0)
        flat.each {|t_name| t_count[t_name] += 1}
        max_value = t_count.map{|k,v| v}.sort.last
        fav = t_count.select do |k,v|
            if v == max_value
                k
            end
        end

        if fav.keys.length == 1
            puts "#{fav.keys[0]} is your favorite trainer!"
        else
            puts "All of these trainer are this Pokemon's favorite!"
            fav.keys.each{|fav| puts "#{fav}"}
        end
    end

    def not_you_again
        #The Pokemon that this Pokemon has lost to the most
        if loss_instances.length == 0
            return "No Pokemon has beaten this Pokemon yet!"
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
            puts "#{rivals.keys[0]} has beaten you the most"
        else
            puts "All these Pokemon have given you the beat down!"
            rivals.keys.each{|rival| puts "#{rival}"}
        end
    end

    
    def self.the_best
        win_list_ids = Battle.all.map{|w| w.winning_pokemon_id}
        winning_p_list = win_list_ids.map{|w| Pokemon.find(w)}.map{|p| p.name}
        p_count = Hash.new(0)
        winning_p_list.each {|p_name| p_count[p_name] += 1}
        max_value = p_count.map{|k,v| v}.sort.last
        best = p_count.select do |k,v|
            if v == max_value
                k
            end
        end

        if best.keys.length == 0
            puts "There is no best Pokemon yet"
        elsif best.keys.length == 1
            puts "#{best.keys[0]} is the best Pokemon!"
        else
            puts "These are all the best Pokemon:"
            best.keys.each{|b| puts "#{b}"}
        end
    end

    def self.the_worst
        loss_list_ids = Battle.all.map{|l| l.losing_pokemon_id}
        losing_p_list = loss_list_ids.map{|l| Pokemon.find(l)}.map{|p| p.name}
        p_count = Hash.new(0)
        losing_p_list.each {|p_name| p_count[p_name] += 1}
        max_value = p_count.map{|k,v| v}.sort.last
        worst = p_count.select do |k,v|
            if v == max_value
                k
            end
        end

        if worst.keys.length == 0
            puts "There is no worst Pokemon yet"
        elsif worst.keys.length == 1
            puts "#{worst.keys[0]} is the worst Pokemon...."
        else
            puts "These are all the worst Pokemon:"
            worst.keys.each{|w| puts "#{w}"}
        end
    end

    def retire
        self.delete
    end
end