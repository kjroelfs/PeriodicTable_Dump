
#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number::VARCHAR = '$1' OR symbol = '$1' OR name = '$1'")

  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT_INFO=$($PSQL "SELECT name, symbol, atomic_mass, type, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.atomic_number = $ELEMENT")

    echo "$ELEMENT_INFO" | while IFS='|' read NAME SYMBOL MASS TYPE MELTING BOILING
    do
      echo "The element with atomic number $ELEMENT is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi

