#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    SELECTED_ROW="$($PSQL "SELECT * FROM elements FULL JOIN properties using(atomic_number) FULL JOIN types using(type_id) WHERE atomic_number=$1")"
  else
    SELECTED_ROW="$($PSQL "SELECT * FROM elements FULL JOIN properties using(atomic_number) FULL JOIN types using(type_id) WHERE symbol='$1' or name='$1'")"
  fi

  if [[ -z $SELECTED_ROW ]]
  then
    echo "I could not find that element in the database."    
  else
    echo $SELECTED_ROW | while IFS="|" read ID NUM SYMBOL NAME MASS MELT BOIL TYPE
    do 
      echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
fi
