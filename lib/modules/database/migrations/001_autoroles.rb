Sequel.migration do
  up do
    create_table(:autoroles) do
      primary_key :id
      DateTime :created_at
      DateTime :updated_at

      String :server_id, unique: true, null: false
      String :server_name
      String :author_id
      String :author_name
      Integer :enable_autorole, default:false, null:false # t/f
    end

    create_table(:roles) do
      primary_key :id

      Integer :role_id , unique: true , null:false
      foreign_key :autorole_id, :autoroles, on_delete: :cascade
    end

  end

  down do
    drop_table(:autoroles)
    drop_table(:roles)
  end
end