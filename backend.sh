#!/bin/bash
LOGS_FOLDER="/var/log/expense-mysql"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"
mkdir -p $LOGS_FOLDER


USERID=$(id -u)
R="\e[31m" # color red
G="\e[32m" # color green 
N="\e[0m"  # color normal
Y="\e[33m" # clor yellow

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then 
        echo -e "$R Please run this script with root priveleges $N" | tee -a $LOG_FILE
        exit 1
    fi
}

VALIDATE() {
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 is ...$R FAILED $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is ...$G SUCCESS $N" | tee -a $LOG_FILE
    fi
}


echo "Script started executing at: $(date)" | tee -a $LOG_FILE

CHECK_ROOT

dnf module disable nodejs -y
    VALIDATE $? " Nodejs is Desable"

dnf module enable nodejs:20 -y
    VALIDATE $? "Nodejs:20 is Enable"

if [ $? -ne 0 ]
then
    echo "started to install nodejs"
    dnf install nodejs -y
    VALIDATE $? "Installing Nodejs..."
else
    echo "Nodejs is already installed"
    exit 1
fi
