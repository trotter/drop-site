set_unless[:users] = { node[:main_user] => {} }
set_unless[:ssh][:port] = 22
set_unless[:ssh][:allow_passwords] = "no"
set_unless[:ssh][:use_pam] = "yes"
