task delete_old_todos: :environment do
  Todo.where("created_at <= ?", Time.now - 7.days).destroy_all
end
