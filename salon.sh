#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU (){
if [[ $1 ]]
then
  echo -e "\n$1"
else
  echo "Welcome to My Salon, how can I help you?"
fi
echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
read SERVICE_ID_SELECTED
case $SERVICE_ID_SELECTED in
  1) MAKE_APPOINTMENT "cut" ;;
  2) MAKE_APPOINTMENT "color" ;;
  3) MAKE_APPOINTMENT "perm" ;;
  4) SMAKE_APPOINTMENT "style" ;;
  5) MAKE_APPOINTMENT "trim" ;;
  *) MAIN_MENU "I could not find that service. What would you like today?";;
esac
}

MAKE_APPOINTMENT()
{
  SERVICE_NAME=$1
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  # find customer name, or insert if it does not exist
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi


  echo -e "\nWhat time would you like your $SERVICE_NAME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
  read SERVICE_TIME
  SERVICE_ID_NUMBER=$($PSQL "SELECT service_id FROM services WHERE name='$SERVICE_NAME'")
  SERVICE_ID_NUMBER_FORMATTED=$(echo $SERVICE_ID_NUMBER | sed 's/ |/"/')
  CUSTOMER_ID_NUMBER=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_ID_NUMBER_FORMATTED=$(echo $CUSTOMER_ID_NUMBER | sed 's/ |/"/')
  ADD_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID_NUMBER_FORMATTED, $SERVICE_ID_NUMBER_FORMATTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
}

MAIN_MENU
