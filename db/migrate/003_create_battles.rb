class CreateBattles < ActiveRecord::Migration[5.0]
    def change
        create_table :battles do |t|
            t.integer :pokemon_1_id
            t.integer :pokemon_2_id
            t.integer :winning_pokemon_id
            t.integer :winning_trainer_id
            t.integer :losing_pokemon_id
            t.integer :losing_trainer_id
        end
    end
end