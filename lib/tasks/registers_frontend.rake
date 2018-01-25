namespace :registers_frontend do
  desc "populate previous entries"
  task populate_previous_entry: :environment do
    Spina::Register.find_each do |register|
      entries_by_key =  Entry.where(spina_register_id: register.id).group_by(&:key)
      entries_with_history = entries_by_key.select {|key,entries| entries.length > 1}
      entries_with_history.each do |key, entries|
        entries.each_cons(2) {|current, previous|
          puts "register #{register.name} setting key #{key} #{current.entry_number} previous entry to #{previous.entry_number}"
          Entry.update(current.id, previous_entry_number: previous.entry_number)
        }
      end
    end
  end
end
