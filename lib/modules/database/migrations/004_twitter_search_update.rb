Sequel.migration do
  up do
    alter_table(:twittersearches) do
      add_column :since_id, :Bignum
      add_column :updated_at, DateTime
    end
  end

  down do
    alter_table(:twittersearches) do
      drop_column :since_id
      drop_column :updated_at
    end
  end
end
