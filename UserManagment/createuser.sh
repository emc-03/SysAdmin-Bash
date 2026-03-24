#!/bin/bash
#This script is used to create a new user on the system with specified username and password.

#color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


read -p "Enter username: " USERNAME
 #validate username is not empty
 if [[ -z "$USERNAME" ]]; then
    echo -e "${RED}Error: Username cannot be empty.${NC}"
    exit 1
fi

# Validate username format (alphanumeric and underscores, 3-16 characters
if [[ ! "$USERNAME" =~ ^[a-zA-Z0-9_]{3,16}$ ]]; then
    echo -e "${RED}Error: Invalid username format. Use 3-16 characters (letters, numbers, underscores).${NC}"
    exit 1
fi

#Check if user already exists
if id "$USERNAME" &>/dev/null; then
    echo -e "${YELLOW}Warning: User '$USERNAME' already exists. Please choose a different username.${NC}"
    exit 1
fi

#Check if username is reserved (sys users)
if [ $(id -u "$USERNAME" 2>/dev/null) -lt 1000 ] 2>/dev/null; then
    echo -e "${RED}Error: '$USERNAME' is a reserved system username.${NC}"
    exit 1
fi

#Create new user
if sudo useradd -m -s /bin/bash "$USERNAME"; then
    echo -e "${GREEN}User '$USERNAME' created successfully.${NC}"
    else
    echo -e "${RED} ERROR: Failed to create user '$USERNAME' .${NC}"
    exit 1
fi

#Set password for new user 
if sudo passwd $USERNAME; then
    echo -e "${GREEN}Password for user '$USERNAME' set successfully.${NC}"
    else
    echo -e "${RED} ERROR: Failed to set password for user '$USERNAME' .${NC}"
for '$USERNAME' .${NC}"
    #Cleanup: remove user if password setup fails"
    sudo userdel -r "$USERNAME" 
    echo -e "${YELLOW}User '$USERNAME' has been removed due to password setup failure. ${NC}"
    exit 1
fi

echo -e "${GREEN}User '$USERNAME' has been created and ready to use! ${NC}"
