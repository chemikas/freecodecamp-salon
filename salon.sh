#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

#get available services
AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name from services ORDER  BY service_id")

# display available services
echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
do 
  echo "$SERVICE_ID) $NAME"
done
}

MAIN_MENU
read SERVICE_ID_SELECTED

SERVICE_NAME=$($PSQL "SELECT name from services where service_id = '$SERVICE_ID_SELECTED'")
# if no service available
  if [[ -z $SERVICE_NAME ]]
  then
    # send to main menu
    MAIN_MENU "I could not find that service. What would you like today?"
  else
     # get customer info
      echo -e "\nWhat's your phone number?"
      read CUSTOMER_PHONE

      CUSTOMER_NAME=$($PSQL "SELECT name from customers WHERE phone = '$CUSTOMER_PHONE'")
      

      # if customer doesn't exist
        if [[ -z $CUSTOMER_NAME ]]
        then
          # get new customer name
          echo -e "\nI don't have a record for that phone number, what's your name?"
          read CUSTOMER_NAME

          # insert new customer
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 

          echo -e "\nWhat time would you like your cut,$CUSTOMER_NAME?"
          read SERVICE_TIME
        else 
          echo -e "\nWhat time would you like your cut,$CUSTOMER_NAME?"
          read SERVICE_TIME
        fi   
  fi

#get customer id
CUSTOMER_ID=$($PSQL "SELECT customer_id from customers WHERE phone = '$CUSTOMER_PHONE'")

#insert appointment
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES('$SERVICE_ID_SELECTED', '$CUSTOMER_ID', '$SERVICE_TIME')") 

#print appointment
echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."