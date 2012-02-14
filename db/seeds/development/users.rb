user = User.new(
  :name => '管理者',
  :email => 'admin@example.com',
  :password => 'iamhero')
user.is_admin = true
user.save 
