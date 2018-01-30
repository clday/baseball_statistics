class ImportPlayerCSV
  include CSVImporter

  model Player

  column :player_id, as: [/player.?id/i], required: true
  column :first_name, as: [/first.?name/i, /name.?first/i], required: true
  column :last_name, as: [/last.?name/i, /name.?last/i], required: true
  column :birth_year, as: [/birth.?year/i]
end
