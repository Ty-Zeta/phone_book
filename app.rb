require 'sinatra'
require 'pg'
enable :sessions
load './local_env.rb' if File.exist?('./local_env.rb')

db_params = {
    host: ENV['host'],
    port: ENV['port'],
    dbname: ENV['db_name'],
    user: ENV['user'],
    password: ENV['password']
}

db = PG::Connection.new(db_params)

get '/' do
    phonebook = db.exec("Select * From user_given_data_table")
    erb :index, locals: {phonebook: phonebook}
end

post '/index' do
    fname = params[:user_given_first_name]
    lname = params[:user_given_last_name]
    street = params[:user_given_street_address]
    city = params[:user_given_city]
    state = params[:user_given_state]
    zip = params[:user_given_zip]
    phone = params[:user_given_phone_number]
    email = params[:user_given_email]

    db.exec("INSERT INTO public.user_given_data_table(first_name, last_name, street_name, city, state, zip, phone_number, email) VALUES('#{fname}', '#{lname}', '#{street}', '#{city}', '#{state}', '#{zip}', '#{phone}', '#{email}')");

    redirect '/'
end

post '/updated_table_cell' do
    new_entry = params[:new_entry]
    old_entry = params[:old_entry]
    cell = params[:new_table_cell]

    case cell
        when 'new_first_name'
            db.exec("UPDATE user_given_data_table SET first_name = '#{new_entry}' WHERE first_name = '#{old_entry}'");
        when 'new_last_name'
            db.exec("UPDATE user_given_data_table SET last_name = '#{new_entry}' WHERE last_name = '#{old_entry}'");
        when 'new_street_address_name'
            db.exec("UPDATE user_given_data_table SET street_name = '#{new_entry}' WHERE street_name = '#{old_entry}'");
        when 'new_city'
            db.exec("UPDATE user_given_data_table SET city = '#{new_entry}' WHERE city = '#{old_entry}'");
        when 'new_state'
            db.exec("UPDATE user_given_data_table SET state = '#{new_entry}' WHERE state = '#{old_entry}'");
        when 'new_zip'
            db.exec("UPDATE user_given_data_table SET zip = '#{new_entry}' WHERE zip = '#{old_entry}'");
        when 'new_phone_number'
            db.exec("UPDATE user_given_data_table SET phone_number = '#{new_entry}' WHERE phone_number = '#{old_entry}'");
        when 'new_email'
            db.exec("UPDATE user_given_data_table SET email = '#{new_entry}' WHERE email = '#{old_entry}'");
    end
    redirect '/'
end

post '/delete_table_row' do
    deleted = params[:user_deleting_data]
    row = params[:old_table_row]

    case row
        when 'delete_first_name'
            db.exec("DELETE FROM user_given_data_table WHERE first_name = '#{deleted}'");
        when 'delete_last_name'
            db.exec("DELETE FROM user_given_data_table WHERE last_name = '#{deleted}'");
        when 'delete_street_address_name'
            db.exec("DELETE FROM user_given_data_table WHERE street_name = '#{deleted}'");
        when 'delete_city'
            db.exec("DELETE FROM user_given_data_table WHERE city = '#{deleted}'");
        when 'delete_state'
            db.exec("DELETE FROM user_given_data_table WHERE state = '#{deleted}'");
        when 'delete_zip'
            db.exec("DELETE FROM user_given_data_table WHERE zip = '#{deleted}'");
        when 'delete_phone_number'
            db.exec("DELETE FROM user_given_data_table WHERE phone_number = '#{deleted}'");
        when 'delete_email'
            db.exec("DELETE FROM user_given_data_table WHERE email = '#{deleted}'");
    end
    redirect '/'
end