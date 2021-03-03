class Interpreter
  RAND_POK_LEVEL= 50

  $trainer_counter = -1

  #generates full trainer array, callable in event script (necessary?)
  def gen_rand_trainer_arr(pokcount)
      ::PFM::Pokemon.rand_train_array(280, pokcount, RAND_POK_LEVEL)
  end

  # This replaces the current party with new random pokemon and starts a fight with
  # the next random trainer according to $trainer_counter
  # I don't know what is necessary and what not in this method, code copied from start_trainer_battle
  def start_battle_loop(bgm: DEFAULT_TRAINER_BGM, disable: 'A', enable: 'B', troop_id: 3)
    replace_team(RAND_POK_LEVEL, $pokemon_party.size)
    $trainer_counter += 1
    if $trainer_counter < 0

      #set_self_switch(false, disable, @event_id) # Better to disable the switch here than in defeat
      original_battle_bgm = $game_system.battle_bgm
      $game_system.battle_bgm = RPG::AudioFile.new(*bgm)
      $game_variables[Yuki::Var::Trainer_Battle_ID] = $trainer_counter
      $game_temp.battle_abort = true
      $game_temp.battle_calling = true
      $game_temp.battle_troop_id = troop_id
      $game_temp.battle_can_escape = false
      $game_temp.battle_can_lose = false
      $game_temp.battle_proc = proc do |n|
        yield if block_given?
        #set_self_switch(true, enable, @event_id) if n == 0
        $game_system.battle_bgm = original_battle_bgm
      end

    else
      trainer_regen
      #exit(true)
    end
  end

  # creates new random trainer.rxdata.yml file and restores it to the projects trainers.rxdata file.
  def trainer_regen
    puts 'start trainer_regen'
    ::PFM::Pokemon.rand_train_array(280, 2, RAND_POK_LEVEL)
    system('cmd.exe /c Game --util=restore')
  end

  def replace_team(level, pokcount)
    $pokemon_party.remove_pokemon(0)
    $pokemon_party.add_pokemon(PFM::Pokemon.gen_rand_pok(level))

    (0...pokcount).each do |i|  #remove pokemon from party
      $pokemon_party.remove_pokemon(i)
    end

    (1...pokcount).each do |i|  #add random pokemon to party
      $pokemon_party.add_pokemon(PFM::Pokemon.gen_rand_pok(level))
    end


  end
end
