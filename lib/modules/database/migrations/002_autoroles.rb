Sequel.migration do
  up do
    create_table(:roles) do
      primary_key :id
      DateTime :crafted_at

      Integer :role_id , null:false
      foreign_key :server_id, :servers, on_delete: :cascade
    end
  end

  down do
    drop_table(:roles)
  end
end