class CreateBattles < ActiveRecord::Migration[5.0]
    def change
        create_table :battles do |t|
            t.integer :pokemon_1
            t.integer :pokemon_2
            t.integer :winning_pokemon
        end
    end
end