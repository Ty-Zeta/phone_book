require 'sinatra'
require 'pg'
require_relative 'phonebook_search.rb'
enable 'sessions'
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
    login_info = db.exec("Select * From phonebook_username_password_login_table")
    erb :login_page, locals: {login_info: login_info}
end

post '/signup' do
    new_username = params[:sign_up_username]
    new_password = params[:sign_up_password]

    db.exec("INSERT INTO public.phonebook_username_password_login_table(username_column, password_column) VALUES('#{new_username}', '#{new_password}')");

    redirect '/'
end

post '/login' do
    checked_username = params[:user_given_username]
    checked_password = params[:user_given_password]
    
    correct_login = db.exec("SELECT * FROM phonebook_username_password_login_table WHERE username_column = '#{checked_username}'")
    login_data = correct_login.values.flatten
    
    if login_data[0] == checked_username && login_data[1] == checked_password
        redirect '/index'
    else
        redirect '/'
    end
end

get '/index' do
    phonebook = db.exec("Select * FROM user_given_data_table")
    erb :index, locals: {phonebook: phonebook}
end

post '/index' do
    fname = params[:user_given_first_name].capitalize
    lname = params[:user_given_last_name].capitalize
    street = params[:user_given_street_address]
    city = params[:user_given_city]
    state = params[:user_given_state]
    zip = params[:user_given_zip]
    phone = params[:user_given_phone_number]
    email = params[:user_given_email]

    $db.exec("INSERT INTO public.user_given_data_table(first_name, last_name, street_name, city, state, zip, phone_number, email) VALUES('#{fname}', '#{lname}', '#{street}', '#{city}', '#{state}', '#{zip}', '#{phone}', '#{email}')");

    redirect '/index'
end

get '/search_results' do
    erb :search_results
end

post '/index_search_form' do
    @params = params
    session[:search_results_table] = full_search_table_render(@params)
    redirect '/search_results'
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
    redirect '/index'
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
    redirect '/index'
end