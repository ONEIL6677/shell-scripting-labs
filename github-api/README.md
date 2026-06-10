**Prerequisites for running this Project**

#Export your github username
command is: export username="your github username"

#Export token from host owner account
**How to get Github API token**
Go to host account 
click on-> profie picture on your top left
click on-> sttings
click on-> developer settings
click on-> personal acces tokens a dropdown will apear
click on> token (classic)
on your topright conner
click on-> Generate new token
grant accesses and 
click on-> Generate token 
copy token 

command is: export token="past your github token"

**How to execute script**
You need two command line argurments
1. you need to provide the organization name 
2. you need to provide the repository name

before that grant all access permision to this file
chmod 777 list-users.sh

command-> sh list-users.sh organisationName repositiryName #one way to run the script
           OR
command-> ./list-users.sh organisationName repositiryName #another way to run shell script

You can get an error saying-> "Jq command not found" all you need to do in install it

command-> sudo apt install jq

Run the script again and you will see list of all user that haave acces to you repository

NB. To reuse this code Make sure to authenticate with your organisations github acount before tryng to check access to a particular repo

