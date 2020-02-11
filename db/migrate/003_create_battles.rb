class CreateBattles < ActiveRecord::Migration[5.0]
    def change
        create_table :battles do |t|
            t.integer :pokemon_id_1
            t.integer :pokemon_id_2
            t.integer :winning_pokemon_id
        end
    end
end