#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU(){
  if [[ $1 ]]
    then
    echo $1
  fi
  # Get service list
  SERVICE_LIST=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  # Format and print
  echo "$SERVICE_LIST" | while read SERVICE_ID BAR SERVICE_NAME
    do
    echo "$SERVICE_ID) $SERVICE_NAME"
    done
  # 
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) NAILS ;;
    2) HAIR ;;
    3) LASHES ;;
    4) EXIT ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac

}

SERVICING(){
  if [[ $1 ]]
    then
    echo $1
  fi
}

# placeholders
NAILS(){
 GET_CUSTOMER_INFO
}

HAIR(){
 GET_CUSTOMER_INFO
}

LASHES(){
  GET_CUSTOMER_INFO
}

#
GET_CUSTOMER_INFO(){
  #get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo $SERVICE_NAME
  # get customer id
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # if not found
  if [[ -z $CUSTOMER_ID ]]
    then
    echo -e "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    #insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    #get customer id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    else 
    #get name
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
    fi
  echo "What time would you like your$SERVICE_NAME,$CUSTOMER_NAME?"
  read SERVICE_TIME
  # Insert appointment
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU