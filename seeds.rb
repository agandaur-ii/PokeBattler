require_relative 'config/environment.rb'

ash = Trainer.new(name: "Ash")
misty = Trainer.new(name: "Misty")
brock = Trainer.new(name: "Brock")
gary = Trainer.new(name: "Gary")
red = Trainer.new(name: "Red")
blue = Trainer.new(name: "Blue")


#HP = HP + Def + SpDef
#Attack = (Attack + SpAtt) / 2
#Speed = Speed
eevee = Pokemon.new(name: "Eevee", hp: 170, attack: 50, speed: 55)
flareon = Pokemon.new(name: "Flareon", hp: 235, attack: 56, speed: 65)
jolteon = Pokemon.new(name: "Jolteon", hp: 220, attack: 44, speed: 130)
vaporeon = Pokemon.new(name: "Vaporeon", hp: 285, attack: 44, speed: 65)
espeon = Pokemon.new(name: "Espeon", hp: 220, attack: 49, speed: 110)
umbreon = Pokemon.new(name: "Umbreon", hp: 335, attack: 31, speed: 65)
glaceon = Pokemon.new(name: "Glaceon", hp: 270, attack: 48, speed: 65)
leafeon = Pokemon.new(name: "Leafeon", hp: 260, attack: 43, speed: 95)
sylveon = Pokemon.new(name: "Sylveon", hp: 290, attack: 44, speed: 60)

