Sequel.migration do
  up do
    create_table(:servers) do
      primary_key :id
      DateTime :created_at
      DateTime :updated_at

      String :server_id, unique: true, null: false
      String :server_name
      String :author_id
      String :author_name

      # 0 => true / 1 => false
      Integer :enable_autorole, default:1, null:false # t/f
    end
  end

  down do
    drop_table(:server)
  end
end