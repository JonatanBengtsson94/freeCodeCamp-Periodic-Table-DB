PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -A -c"

# Check for argument
if [[ $# -eq 0 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Check type of argument and collect the atomic number
if [[ $1 =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
else
  if [[ ${#1} -gt 2 ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
  fi
fi

# Check if an element was found
if [[ -z "$ATOMIC_NUMBER" ]]
then
  echo "I could not find that element in the database."
  exit 0
fi


# Collect information about the atom from database
RESULT=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
FROM properties JOIN elements ON properties.atomic_number = elements.atomic_number JOIN types on properties.type_id = types.type_id WHERE elements.atomic_number=$ATOMIC_NUMBER")

# Save the data into vars
IFS='|' read NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT <<< "$RESULT"

# Print the result
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
