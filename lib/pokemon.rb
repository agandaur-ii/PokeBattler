class Pokemon < ActiveRecord::Base
    has_many :trainers
    has_many :battles

    def stats
        puts "HP: #{self.hp}, Attack: #{self.attack}, Speed: #{self.speed}"
    end

    def retire
        self.delete
    end
end