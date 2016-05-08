class CreateComments < MIGRATION_CLASS
  def change
    create_table :comments do |t|
      t.integer :user_id, null: false
      t.timestamps null: false
    end
    add_index :comments, :user_id, name: "comment_index"
  end
end
