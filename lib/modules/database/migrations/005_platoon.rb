Sequel.migration do
  up do
    create_table(:platoonlobbies) do
      primary_key :id
      DateTime :crafted_at
      DateTime :updated_at

      Bignum :lobby_channel_id, unique: true
      Int :child_num, default: 2
      
      foreign_key :server_id, :servers, on_delete: :cascade
    end

    create_table(:platoonrooms) do
      primary_key :id
      DateTime :crafted_at
      DateTime :updated_at

      Bignum :room_channel_id, unique: true, null: false
      Int :room_number, null: false
      
      foreign_key :platoon_lobby_id, :platoonlobbies, on_delete: :cascade
    end

    create_table(:platoonmembers) do
      primary_key :id
      DateTime :crafted_at
      DateTime :updated_at

      Bignum :member_id, unique: true, null: false

      foreign_key :platoon_room_id, :platoonrooms, on_delete: :cascade
    end
  end

  down do
    drop_table(:platoonmembers)
    drop_table(:platoonrooms)
    drop_table(:platoonlobbies)
  end
end
