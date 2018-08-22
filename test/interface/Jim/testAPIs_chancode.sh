#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
func=$1
idno=$2
index=$3
index1=$4
index2=$5
echo
#echo "POST request Enroll on Org1  ..."
#echo
ORG1_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Jim&orgName=Org1')
ORG1_TOKEN=$(echo $ORG1_TOKEN | jq ".token" | sed "s/\"//g")
#echo
#echo "ORG1 token is $ORG1_TOKEN"
#echo

ADMIN_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=admin&orgName=Org1')
ADMIN_TOKEN=$(echo $ADMIN_TOKEN | jq ".token" | sed "s/\"//g")


#echo "===========================test person==================="



function user_authorize()
{
#echo "POST invoke chaincode on peers of Org1"
#echo
curl -s -X POST \
  http://localhost:4000/channels/person1/chaincodes/interface \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"peers\": [\"peer0.org1.example.com\",\"peer1.org1.example.com\"],
	\"fcn\":\"user_authorize\",
	\"args\":[\"$idno\",\"$index\",\"$index1\"]
}"
#echo
#echo
}

function admin_authorize()
{
#echo "POST invoke chaincode on peers of Org1"
#echo
curl -s -X POST \
  http://localhost:4000/channels/person1/chaincodes/interface \
  -H "authorization: Bearer $ADMIN_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"peers\": [\"peer0.org1.example.com\",\"peer1.org1.example.com\"],
	\"fcn\":\"admin_authorize\",
	\"args\":[\"$idno\",\"$index\",\"$index1\",\"$index2\"]
}"
#echo
#echo
}

function admin_trust()
{
#echo "POST invoke chaincode on peers of Org1"
#echo
curl -s -X POST \
  http://localhost:4000/channels/person1/chaincodes/interface \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"peers\": [\"peer0.org1.example.com\",\"peer1.org1.example.com\"],
	\"fcn\":\"admin_trust\",
	\"args\":[\"$idno\",\"$index\"]
}"
#echo
#echo
}

function check_authority()
{
#echo "GET query chaincode on peer1 of Org1"
#echo
pull=$(curl -s -X GET \
  "http://localhost:4000/channels/person1/chaincodes/interface?peer=peer0.org1.example.com&fcn=check_authority&args=%5b%22${idno}%22%2c%22${index}%22%5d" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
)
echo $pull
#echo
#echo
}

function query_authority_list() 
{
#echo "GET query chaincode on peer1 of Org1"
#echo
pull=$(curl -s -X GET \
  "http://localhost:4000/channels/person1/chaincodes/authority?peer=peer0.org1.example.com&fcn=query_authority_list&args=%5b%22${idno}%22%2c%22${index}%22%5d" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
)
echo $pull
#echo
#echo
}

function data_register()
{
#echo "POST invoke chaincode on peers of Org1"
#echo
s_index=`echo ${index} | openssl aes-128-cbc -k 123 -base64 | tr "\n" "\^"`
curl -s -X POST \
  http://localhost:4000/channels/person1/chaincodes/interface \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"peers\": [\"peer0.org1.example.com\",\"peer1.org1.example.com\"],
	\"fcn\":\"data_register\",
	\"args\":[\"${idno}\",\"${s_index}\"]
}"
#echo
#echo
}

function data_query() 
{
#echo "GET query chaincode on peer1 of Org1"
#echo
pull=$(curl -s -X GET \
  "http://localhost:4000/channels/person1/chaincodes/interface?peer=peer0.org1.example.com&fcn=data_query&args=%5b%22${idno}%22%2c%22${index}%22%5d" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
)
echo $pull
echo  $pull | tr "\^" "\n" | openssl aes-128-cbc -k 123 -base64 -d
#echo
#echo
}


function index_query() 
{
#echo "GET query chaincode on peer1 of Org1"
#echo
pull=$(curl -s -X GET \
  "http://localhost:4000/channels/person1/chaincodes/index?peer=peer0.org1.example.com&fcn=index_query&args=%5b%22${idno}%22%5d" \
  -H "authorization: Bearer $ADMIN_TOKEN" \
  -H "content-type: application/json"
)
echo $pull
#echo
#echo
}



case ${func} in
"index_query")
	index_query
	;;
"data_register")
	data_register
	;;
"data_query")
	data_query
	;;
"query_authority_list")
	query_authority_list
	;;
"user_authorize")
	user_authorize
	;;
"admin_authorize")
	admin_authorize
	;;
"admin_trust")
	admin_trust
	;;
*)
	echo	
	echo "***************Use Age*******************"
	echo "authority_register idNo OK\NG     "
	echo "query_authority_list idNo	User	       "
	echo "user_authorize idNo flg User	       "
	echo "admin_authporize idNo User flg User      "
	echo "admin_trust idNo trust/cancel	       "
	echo "check_authority idNo User		       "
	echo "*****************************************"
	echo
	echo 
esac

echo
#echo "Total execution time : $(($(date +%s)-starttime)) secs ..."

