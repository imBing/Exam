EMAIL='isaachan@qq.com'
PASSWORD='1234abcd'

function clean_up {
  echo "Clean up environment ..."
  docker ps -a | grep one-auth | awk '{print $1}' | xargs docker rm -f > /dev/null
}

function setup {
    echo "Install all docker instancces ..."
    /bin/bash ./go.sh install > /dev/null
    
    echo "Start one-auth api service"
    output=`curl localhost:8000 2>&1 | grep 404`;
    until [[ -n $output ]]; do
        echo "  waiting api starting ..."
        sleep 3
        output=`curl localhost:8000 2>&1 | grep 404`
    done
}

function create_user {
    echo "create user with $1"
    python3 e2e/create_user.py $1
}

function get_validation_code {
    e2e/validation_code.sh
}

function verify_validation_code {
    python3 e2e/verify_validation_code.py $1 $2
}

function update_password {
    python3 e2e/update_password.py $1 $2 $3
}

function get_access_token_with_email_and_password {
    auth_token=`echo -n $1:$2 | base64`
    auth_header="Basic $auth_token"
    
    python3 e2e/get_access_token.py "$auth_header" > ./.access_code_tmp
    cat ./.access_code_tmp
}

function validate_user_with_email_and_access_token {
    auth_token=`echo -n $1:$2 | base64`
    auth_header="Basic $auth_token"

    python3 e2e/validate.py "$auth_header"
}

clean_up
setup
create_user $EMAIL
validation_code=`get_validation_code`
verify_validation_code $EMAIL $validation_code
update_password $EMAIL $PASSWORD $validation_code
access_token=`get_access_token_with_email_and_password $EMAIL $PASSWORD`
validate_user_with_email_and_access_token $EMAIL $access_token
clean_up
