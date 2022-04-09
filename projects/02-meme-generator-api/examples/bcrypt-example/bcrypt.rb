require 'bcrypt'

plain_password = 'r4nd0m p4$$w0rD'

p "Password type: #{BCrypt::Password.create(plain_password).class}"

p "Hashing returns different results each time, due to the salt. See the bcrypt gem readme"
hash1 = BCrypt::Password.create(plain_password).to_s
p "Hash1: #{hash1}"

hash2 = BCrypt::Password.create(plain_password).to_s
p "Hash2: #{hash2}"

p "hash1 == hash2 => #{hash1 == hash2}"
p "BCrypt::Password.new(hashed_password1) == plain_password => #{BCrypt::Password.new(hash1) == plain_password}"
