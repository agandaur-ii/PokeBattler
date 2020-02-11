class Trainer < ActiveRecord::Base
    has_many :pokemons
    has_many :battles, through: :pokemons
end