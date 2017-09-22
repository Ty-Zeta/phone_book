require 'pg'
load './local_env.rb' if File.exist?('./local_env.rb')

db_params = {
    host: ENV['host'],
    port: ENV['port'],
    dbname: ENV['db_name'],
    user: ENV['user'],
    password: ENV['password']
}

$db = PG::Connection.new(db_params)

def prep_query(info_hash)

    first_name = info_hash[:searched_first_name]
    phone = info_hash[:searched_phone_number]

    if first_name != '' && phone != ''
        print("SELECT * FROM user_given_data_table WHERE first_name = '#{first_name}' AND phone_number = '#{phone}'")
        "SELECT * FROM user_given_data_table WHERE first_name = '#{first_name}' AND phone_number = '#{phone}'"
    elsif first_name != ''
        print("SELECT * FROM user_given_data_table WHERE first_name = '#{first_name}'")
        "SELECT * FROM user_given_data_table WHERE first_name = '#{first_name}'"
    elsif phone != ''
        print("SELECT * FROM user_given_data_table WHERE phone_number = '#{phone}'")
        "SELECT * FROM user_given_data_table WHERE phone_number = '#{phone}'"
    else
        print("SELECT * FROM user_given_data_table")
        "SELECT * FROM user_given_data_table"
    end
end

def response_object(query)
    response = $db.exec(query)
    response
end

def prep_html(response_object)
    html = ''
    html << "<table>
    <tr>
        <td> First Name </td>
        <td> Last Name </td>
        <td> Street Address </td>
        <td> City </td>
        <td> State </td>
        <td> Zip Code </td>
        <td> Phone Number </td>
        <td> Email Address </td>
    </tr>"

    response_object.each do |row_value|
        html << "\t</tr>"
    end

    html << "</table>"

    html
end

def full_search_table_render(form_input_hash)
    query = prep_query(form_input_hash)
    response = response_object(query)
    html = prep_html(response)
    html
end

print full_search_table_render({"searched_first_name"=>"Ty", "searched_phone_number"=>""})