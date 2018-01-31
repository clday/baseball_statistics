require 'rails_helper'

describe 'Players', type: :feature do
  let!(:player) do
    Player.create!(first_name: 'Rafael',
                   last_name: 'Devers',
                   player_id: 'rafade01')
  end

  let!(:batting_statistics) do
    player.batting_statistics.create!(team_id: 'BOS',
                                      player: player,
                                      year: 2017,
                                      league: 'AL',
                                      games: 58,
                                      at_bats: 222,
                                      runs: 34,
                                      hits: 63,
                                      doubles: 14,
                                      triples: 0,
                                      home_runs: 10,
                                      runs_batted_in: 30,
                                      stolen_bases: 3,
                                      caught_stealing: 1)
  end

  let!(:player_two) do
    Player.create!(first_name: "Xander",
                   last_name: "Bogaerts",
                   player_id: "bogaxa01")
  end

  describe 'show' do
    it 'shows the requested player' do
      visit "/players/#{player.id}"

      expect(page).to have_content 'First name: Rafael'
      expect(page).to have_content 'Last name: Devers'

      batting_statistics_table_headers = 'Year League Team Games At Bats Runs ' +
                                         'Hits Doubles Triples Home Runs RBIs ' +
                                         'Stolen Bases Caught Stealing Batting ' +
                                         'Average Slugging Percentage'
      expect(page).to have_content batting_statistics_table_headers

      individual_season_line = "2017 AL BOS 58 222 34 63 14 0 10 30 3 1 0.284 0.482"
      expect(page).to have_content individual_season_line

      total_line = "Total 58 222 34 63 14 0 10 30 3 1 0.284 0.482"
      expect(page).to have_content total_line
    end

    context 'without batting statistics' do
      before { player.batting_statistics.destroy_all }
      it 'says that there are no batting statistics for the player' do
        visit "/players/#{player.id}"
        expect(page).to have_content 'No batting statistics for this player'
      end
    end
  end

  describe 'edit/update' do
    it 'is allows editing the requested player' do
      visit "/players/#{player.id}"
      click_link('Edit')

      fill_in 'First name', with: 'Raphael'
      fill_in 'Last name', with: 'Danvers'

      click_button 'Update Player'

      expect(page).to have_content 'First name: Raphael'
      expect(page).to have_content 'Last name: Danvers'
      expect(page).to have_content 'Player was successfully updated'
      expect(page).to have_link 'Edit'
    end

    it 'shows errors if invalid update' do
      visit "/players/#{player.id}"
      click_link('Edit')

      fill_in 'First name', with: ''
      fill_in 'Last name', with: 'Danvers'

      click_button 'Update Player'

      expect(page).not_to have_content 'Danvers'
      expect(page).to have_content "error prohibited this player from being saved: First name can't be blank"
    end
  end

  describe 'destroy'do
    it 'destroys the player' do
      visit "/players"
      expect(page).to have_content "Xander"
      expect(page).to have_content "Bogaerts"

      expect { first(:link, 'Destroy').click }.to change{ Player.count }.from(2).to(1)

      expect(page).to have_content "Player was successfully destroyed"
      expect(page).not_to have_content "Xander"
      expect(page).not_to have_content "Bogaerts"
    end
  end

  describe 'new' do
    it 'creates a new player' do
      visit "/players/new"
      fill_in 'First name', with: 'Dustin'
      fill_in 'Last name', with: 'Pedroia'
      fill_in 'Player', with: 'dustpe01'

      expect { click_button('Create Player') }.to change{ Player.count }.from(2).to(3)

      expect(page).to have_content('Player was successfully created')
      expect(page).to have_content('Dustin')
      expect(page).to have_content('Pedroia')
      expect(page).to have_content('dustpe01')
    end
  end
end
