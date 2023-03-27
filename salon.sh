#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"


MAIN_MENU(){

  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "Welcome to My Salon, how can I help you?\n"

  
  SERVICE_SELECTOR
}


SERVICE_SELECTOR(){
    SERVICES=$($PSQL "SELECT * FROM services")

  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE 
    do
      echo -e "$SERVICE_ID) $SERVICE"
    done

  echo "Choose service"
  read SERVICE_ID_SELECTED

  # if input is not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
  MAIN_MENU "This is not a valid option pls input number"
  else
  DB_SERVICE_ID=$($PSQL "SELECT * FROM services WHERE service_id = $SERVICE_ID_SELECTED");
  #echo "$ID_IS_VALID"
    if [[ -z $DB_SERVICE_ID ]]
    then
    MAIN_MENU "sike" #WRONG ID OR NOT EXIST
    else 
    #ALL GOOD
      echo -e "\nWhat's your phone number?"
      read CUSTOMER_PHONE

      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      if [[ -z $CUSTOMER_NAME ]]
        then
          # get new customer name
          echo -e "\nWhat's your name?"
          read CUSTOMER_NAME

          # insert new customer
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
      fi
       # get customer_id
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

      echo -e "What time do you prefer?"
      read SERVICE_TIME

      INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(time,customer_id,service_id) VALUES ('$SERVICE_TIME','$CUSTOMER_ID','$SERVICE_ID_SELECTED')")
      NAME_OF_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED' ")
      echo -e "I have put you down for a$NAME_OF_SERVICE at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
    fi
  fi
}


MAIN_MENU
