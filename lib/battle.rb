class Battle < ActiveRecord::Base
    has_many :trainers, through: :pokemons
    has_many :pokemons

    
end