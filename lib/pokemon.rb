class Pokemon < ActiveRecord::Base
    has_many :trainers
    has_many :battles

    def retire
        self.delete
    end
end