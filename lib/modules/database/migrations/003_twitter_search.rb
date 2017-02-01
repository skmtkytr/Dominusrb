Sequel.migration do
  up do
    create_table(:twittersearches) do
      primary_key :id
      DateTime :created_at

      Bignum :channel_id, unique: true, null: false
      String :keyword, null: false

      # 0 => true / 1 => false
      Integer :enable_twittersearch, default: 1, null: false #t/f
      foreign_key :server_id, :servers, on_delete: :cascade
    end
  end

  down do
    drop_table(:twittersearches)
  end
end