# frozen_string_literal: true

require 'yaml'

module PFM
  class Pokemon

    # @return [::PFM::Pokemon]
    def self.gen_rand_pok(level)

      pokemon_hash = rand_pok_hash(level)
      randpok = ::PFM::Pokemon.generate_from_hash(pokemon_hash)

      randpok

    end

    #generates a hash for a random pokemon
    def self.rand_pok_hash(level)

      id = rand(1..801) # random id
      # TODO: get largest index with method


      evhelp = [0, 1, 2, 3, 4, 5] # random ev, maxed to 508 according to pkmshowdown.(I don't actually know much about the iv/ev systems)
      evhelp = evhelp.shuffle
      ev = [0, 0, 0, 0, 0, 0]
      (0..4).each do |i|
        ev[evhelp[i]] = rand(508 - ev.sum).to_i
      end
      ev[evhelp[5]] = 508 - ev.sum


      # iv, nature, item, ability already random with generate from hash
      randpok = ::PFM::Pokemon.generate_from_hash({ id: id, level: level, bonus: ev })

      moveset = randpok.data.tech_set # get tech_set moves. can I get this without creating the pokemon from has first?


      moveset_count=randpok.data.move_set.size

      (0...moveset_count).step(2) do |i|  #add move_set moves. Though this seems not right with what I get
        moveset.append(randpok.data.move_set[i+1])
      end

      (0..3).each do |i|  #actually choose random moves
        randpok.replace_skill_index(i, moveset[rand(moveset.size - 1)])
      end

      if moveset.size == 0    # if moveset empty, choose random move, what is the max
        moveset[0] = rand(719)
        moveset[1] = rand(719)
        moveset[2] = rand(719)
        moveset[3] = rand(719)
        (0..3).each do |i|
          randpok.replace_skill_index(i, moveset[i])
        end

      end

      { id: id, level: level, bonus: ev, moves: randpok.skills }

    end
    #generates a random trainer
    def self.genrandtrainer(id,pokcount, level)
      trainer = ::GameData::Trainer.new
      trainer.id = id
      trainer.team = []
      (0...pokcount).each do |i|
        trainer.team.append rand_pok_hash(level)
      end

      trainer
    end

    #generates random trainer array and saves it in data folder as trainers.rxdata.yml
    def self.rand_train_array(traincount, pokcount, level)
      trainerarr = [::GameData::Trainer]
      trainerarr[0] = genrandtrainer(0, pokcount, level)
      (1...traincount).each do |i|
        trainerarr.append(genrandtrainer(i, pokcount, level))

      end

      File.open('Data\\PSDK\\Trainers.rxdata.yml', 'w') { |file| file.write(trainerarr.to_yaml) }

    end
  end
end
