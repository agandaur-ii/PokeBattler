require_relative 'config/environment.rb'

ash = Trainer.create(name: "Ash")
misty = Trainer.create(name: "Misty")
brock = Trainer.create(name: "Brock")
gary = Trainer.create(name: "Gary")
red = Trainer.create(name: "Red")
blue = Trainer.create(name: "Blue")


#HP = HP + Def + SpDef
#Attack = (Attack + SpAtt) / 4
#Speed = Speed
eevee = Pokemon.create(name: "Eevee", hp: 170, attack: 50, speed: 55)
flareon = Pokemon.create(name: "Flareon", hp: 235, attack: 56, speed: 65)
jolteon = Pokemon.create(name: "Jolteon", hp: 220, attack: 44, speed: 130)
vaporeon = Pokemon.create(name: "Vaporeon", hp: 285, attack: 44, speed: 65)
espeon = Pokemon.create(name: "Espeon", hp: 220, attack: 49, speed: 110)
umbreon = Pokemon.create(name: "Umbreon", hp: 335, attack: 31, speed: 65)
glaceon = Pokemon.create(name: "Glaceon", hp: 270, attack: 48, speed: 65)
leafeon = Pokemon.create(name: "Leafeon", hp: 260, attack: 43, speed: 95)
sylveon = Pokemon.create(name: "Sylveon", hp: 290, attack: 44, speed: 60)

Trainer.delete_all
Pokemon.delete_all