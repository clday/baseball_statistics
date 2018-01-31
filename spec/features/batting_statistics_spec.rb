require 'rails_helper'

describe 'Batting Statistics', type: :feature do
  let!(:player) do
    Player.create!(first_name: 'Rafael',
                   last_name: 'Devers',
                   player_id: 'rafade01')
  end

  let!(:player_two) do
    Player.create!(first_name: "Javier",
                   last_name: "Baez",
                   player_id: "baezja01")
  end


  before do
    player.batting_statistics.create!(team_id: 'BOS',
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

    player_two.batting_statistics.create!(team_id: 'CHC',
                                          year: 2017,
                                          league: 'NL',
                                          games: 145,
                                          at_bats: 469,
                                          runs: 75,
                                          hits: 128,
                                          doubles: 24,
                                          triples: 2,
                                          home_runs: 23,
                                          runs_batted_in: 75,
                                          stolen_bases: 10,
                                          caught_stealing: 3)

    player_two.batting_statistics.create!(team_id: 'CHC',
                                          year: 2016,
                                          league: 'NL',
                                          games: 142,
                                          at_bats: 421,
                                          runs: 50,
                                          hits: 115,
                                          doubles: 19,
                                          triples: 1,
                                          # I fudged this so sorting would be different
                                          home_runs: 24,
                                          runs_batted_in: 59,
                                          stolen_bases: 12,
                                          caught_stealing: 3)

  end

  describe '/leaderboard' do
    it 'default sorts by batting_average' do
      visit '/leaderboard'

      header_row = first('tr')
      headers = "Team Player Year League Games At bats Runs Hits Double " +
                "Triples Home runs Runs batted in Stolen bases Caught stealing " +
                "Batting Average Slugging Percentage"
      expect(header_row).to have_content(headers)


      first_result_row = page.all('tr')[1]
      top_batting_average = "BOS Rafael Devers 2017 AL 58 222 34 63 14 0 10 30 " +
                            "3 1 0.284 0.482"
      expect(first_result_row).to have_content(top_batting_average)
    end

    it 'allows filtering by league' do
      visit '/leaderboard'
      select 'NL'
      click_button 'Refresh'

      first_result_row = page.all('tr')[1]
      nl_top_batting_average = "CHC Javier Baez 2017 NL 145 469 75 128 24 2 23 75 " +
                               "10 3 0.273 0.480"
      expect(first_result_row).to have_content(nl_top_batting_average)

      # doesn't include players in different league
      expect(page).not_to have_content 'Rafael Devers'
    end

    it 'allows filtering by team' do
      visit '/leaderboard'
      select 'BOS'
      click_button 'Refresh'

      first_result_row = page.all('tr')[1]
      bos_top_batting_average = "BOS Rafael Devers 2017 AL 58 222 34 63 14 0 10 30 " +
                                "3 1 0.284 0.482"
      expect(first_result_row).to have_content(bos_top_batting_average)

      # doesn't include players in different team
      expect(page).not_to have_content 'Javier Baez'
    end

    it 'allows filtering by season' do
      visit '/leaderboard'
      select '2016'
      click_button 'Refresh'

      first_result_row = page.all('tr')[1]
      top_batting_average_2016 = "CHC Javier Baez 2016 NL 142 421 50 115 19 1 24 " +
                                 "59 12 3 0.273 0.494"
      expect(first_result_row).to have_content(top_batting_average_2016)

      # doesn't include stats from other years
      within('table') do
        expect(page).not_to have_content '2017'
      end
    end

    it 'allows sorting by slugging percentage' do
      visit '/leaderboard'
      select 'Slugging'
      click_button 'Refresh'

      first_result_row = page.all('tr')[1]
      top_slugging_percentage = "CHC Javier Baez 2016 NL 142 421 50 115 19 1 24 " +
                                "59 12 3 0.273 0.494"
      expect(first_result_row).to have_content(top_slugging_percentage)
    end
  end
end
