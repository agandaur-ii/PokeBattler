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
end