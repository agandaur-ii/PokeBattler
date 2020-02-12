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
        choice
    end

    def current_pokemon
        self.pokemons[0].name
    end

    def battle_instances
        Battle.all.select{|b| b.winning_trainer_id == self.id || b.losing_trainer_id == self.id}
    end

    def number_of_battles
        battle_instances.count
    end

    def win_instances
        battle_instances.select{|b| b.winning_trainer_id == self.id}
    end

    def loss_instances
        battle_instances.select{|b| b.losing_trainer_id == self.id}
    end

    def wins
        battle_instances.select{|b| b.winning_trainer_id == self.id}.count
    end

    def losses
        battle_instances.select{|b| b.losing_trainer_id == self.id}.count
    end

    def win_rate
        (wins.to_f / number_of_battles.to_f) * 100
    end

    def pokemon_used
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
    end

    def fav_pokemon
        #pokemon that has gotten you the most wins
    end

    def not_you_again
        #pokemon you have lost to the most
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
        if result == self.id
            puts "You won!"
        else
            puts "You lost."
        end
    end

    def retire
        user_pokemon = Pokemon.all.find{|p| p.trainer_id == self.id}
        user_pokemon.update(trainer_id: nil)
        self.delete
    end
end