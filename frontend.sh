#!/bin/bash
LOGS_FOLDER="/var/log/expense-frontend"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"
mkdir -p $LOGS_FOLDER


R="\e[31m" # color red
G="\e[32m" # color green
N="\e[0m"  # color normal

CHECK_ROOT(){
   
    if [ $USERID -ne 0 ]
    then 
        echo "Please run this script with root priveleges"
        exit 1
    fi
}

VALIDATE() {
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 is ...$2 FAILED $N"
        exit 1
    else
        echo -e "$2 is ...$2 SUCCESS $N"
    fi
}

CHECK_ROOT

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "Install Nginx"

systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "Enable Nginx"

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "Started Nginx"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
#VALIDATE $? "Removed exists html code"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE
#VALIDATE $? "Downloading frontend application code"


cd /usr/share/nginx/html

unzip /tmp/frontend.zip &>>$LOG_FILE
#VALIDATE $? "Extracting forntend code"

/home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOG_FILE

systemctl restart nginx 
VALIDATE $? "Restarted Nginx"

