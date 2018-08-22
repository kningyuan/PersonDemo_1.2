#!/bin/bash
./testAPIs_chancode.sh query_authority_list 341221199202235792 Jim
read

echo "register"
./testAPIs_chancode.sh authority_register 341221199202235792  OK
./testAPIs_chancode.sh query_authority_list 341221199202235792 Jim
read

echo "user authorize"
./testAPIs_chancode.sh user_authorize 341221199202235792 authorize User
./testAPIs_chancode.sh query_authority_list 341221199202235792 Jim
read

echo "admin authorize"
./testAPIs_chancode.sh admin_authorize 341221199202235792 Jim authorize User
./testAPIs_chancode.sh query_authority_list 341221199202235792 Jim
read

echo "admin trust cancel"
./testAPIs_chancode.sh admin_trust 341221199202235792 cancel
./testAPIs_chancode.sh query_authority_list 341221199202235792 Jim
read

echo "user authorize cancel"
./testAPIs_chancode.sh user_authorize 341221199202235792 cancel User
./testAPIs_chancode.sh query_authority_list 341221199202235792 Jim
read

echo "admin authorize cancel"
./testAPIs_chancode.sh admin_authorize 341221199202235792 Jim cancel User
./testAPIs_chancode.sh query_authority_list 341221199202235792 Jim
read


echo "admin trust"
./testAPIs_chancode.sh admin_trust 341221199202235792 trust
./testAPIs_chancode.sh query_authority_list 341221199202235792 Jim
read

echo "admin authorize cancel"
./testAPIs_chancode.sh admin_authorize 341221199202235792 Jim cancel User
./testAPIs_chancode.sh query_authority_list 341221199202235792 Jim
read

./testAPIs_chancode.sh check_authority 341221199202235792 Jim
