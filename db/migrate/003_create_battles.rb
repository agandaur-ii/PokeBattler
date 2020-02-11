class CreateBattles < ActiveRecord::Migration[5.0]
    def change
        create_table :battles do |t|
            t.integer :pokemon_1_id
            t.integer :pokemon_2_id
            t.integer :winning_pokemon_id
        end
    end
end