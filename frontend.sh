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
       dnf list installed nginx &>>$LOG_FILE

    #    if [ $? -ne 0 ]
        # then 
        #echo -e "$R Nginx is not installed, going to install it $N"
        dnf install nginx -y
        VALIDATE $? "Installing Nginx"
        #else
        #echo -e "$G Nginx is already installed, nothing to do....$N"
        #fi

       systemctl enable nginx &>>$LOG_FILE
       VALIDATE $? "Enable Nginx "

       systemctl start nginx &>>$LOG_FILE
       VALIDATE $? "Restart Nginx"

       rm -rf /usr/share/nginx/html/* # remove content in html folder
       VALIDATE $? "Delet content from html folder"

       curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE
       VALIDATE $? "Downloading the frontend code" 

        cd /usr/share/nginx/html &>>$LOG_FILE
        VALIDATE $? "Change the directory to nginx/html"        

        unzip /tmp/frontend.zip &>>$LOG_FILE
        VALIDATE $? "Extract the frontend file"

       # vim /etc/nginx/default.d/expense.conf

        # cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf
        #systemctl restart nginx &>>$LOG_FILE
        systemctl restart nginx