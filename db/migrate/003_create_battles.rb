class CreateBattles < ActiveRecord::Migration[5.0]
    def change
        create_table :battles do |t|
            t.string :pokemon_1
            t.string :pokemon_2
            t.string :winning_pokemon
        end
    end
end