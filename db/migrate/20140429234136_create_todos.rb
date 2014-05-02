class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :body
      t.references :list, index: true
      t.boolean :completed

      t.timestamps
    end
  end
end
