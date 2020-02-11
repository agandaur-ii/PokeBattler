class CreatePokemons < ActiveRecord::Migration[5.0]
    def change
        create_table :pokemons do |t|
            t.string :name
            t.integer :hp
            t.integer :attack
            t.integer :speed
            t.integer :trainer_id
        end
    end
end