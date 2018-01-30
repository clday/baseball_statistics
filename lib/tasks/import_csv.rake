desc 'Imports from a CSV local to the repository'

task :import_csv, [:model_name, :csv_path] => :environment do |t, args|
  importer_klass = "Import#{args.model_name.classify}CSV".safe_constantize
  unless importer_klass
    raise "Invalid model name #{args.model_name}"
  end

  puts "Beginning import"
  counter = 0
  total_rows = 0
  importer = importer_klass.new(path: args.csv_path) do
    after_save do
      counter += 1
      print "\r\e[0K#{counter} of #{total_rows} rows imported"
    end
  end

  total_rows = importer.rows.count
  importer.run!
  puts "\n#{importer.report.message}"
  if importer.report.invalid_rows.any?
    importer.report.invalid_rows.each do |row|
      error_messages = row.errors.map { |key, message| "#{key} #{message}" }
      puts "Error in row #{row.line_number}: #{error_messages.join(", ")}"
    end
  end
end
