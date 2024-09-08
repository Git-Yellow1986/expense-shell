#!/bin/bash

LOGS_FOLDER="/var/log/backend"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R Please run this script with root priveleges $N" | tee -a $LOG_FILE
        exit 1  
          fi
}


VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is...$R FAILED $N"  | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}


echo "Script started executing at: $(date)" | tee -a $LOG_FILE

CHECK_ROOT
       dnf list installed nginx 
       if [ $? -ne 0 ]
        then 
        echo -e"$R Nginx is not installed, going to install it $N"
        dnf install nginx -y &>>$LOG_FILE
        VALIDATE $? "Installing Nginx"
        else
        echo -e "$G Nginx is already installed, nothing to do....$N"
        fi

       systemctl enable nginx &>>$LOG_FILE
       VALIDATE $? "Enable Nginx "

       systemctl restart nginx &>>$LOG_FILE
       VALIDATE $? "Restart Nginx"
