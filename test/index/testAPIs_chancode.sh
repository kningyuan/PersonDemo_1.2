#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
func=$1
idno=$2
index=$3

#echo ${sindex}

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

ORG2_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=KK&orgName=Org1')
ORG2_TOKEN=$(echo $ORG2_TOKEN | jq ".token" | sed "s/\"//g")

#echo "===========================test person==================="


function index_register()
{
echo "POST invoke chaincode on peers of Org1"
echo

#        \"args\":[${s_idNo},${s_studentNo},${s_schoolName},${s_leaveSchoolTime}, ${s_status},${s_department},${s_branchSchool},${s_schoolingLength},${s_nation},${s_eduType},${s_level},${s_eduForm},${s_gender},${s_className} ,${s_birthDate},${s_realName},${s_enrollmentTime} ,${s_specialty}]

#s_index=`echo ${index} | openssl aes-128-cbc -k 123 -base64 | tr "\n" "\^"`
curl -s -X POST \
  http://localhost:4000/channels/person1/chaincodes/index \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d "{
	\"peers\": [\"peer0.org1.example.com\",\"peer1.org1.example.com\"],
	\"fcn\":\"index_register\",
	\"args\":[\"${idno}\"]
}"
#echo
#echo
}

function index_query() 
{
echo "GET query chaincode on peer1 of Org1"
echo
pull=$(curl -s -X GET \
  "http://localhost:4000/channels/person1/chaincodes/index?peer=peer0.org1.example.com&fcn=index_query&args=%5b%22${idno}%22%5d" \
  -H "authorization: Bearer $ADMIN_TOKEN" \
  -H "content-type: application/json"
)
#echo  $pull | tr "\^" "\n" > ./s_index
#cat s_index| openssl aes-128-cbc -k 123 -base64 -d
echo $pull
#echo  $pull | tr "\^" "\n" | openssl aes-128-cbc -k 123 -base64 -d
#echo
#echo
}


case ${func} in
"index_register")
	index_register
	;;
"index_query")
	index_query
	;;
*)
	echo "error"
esac

echo
#echo "Total execution time : $(($(date +%s)-starttime)) secs ..."

