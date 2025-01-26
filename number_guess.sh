#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"


if [[ $1 ]]
then
  echo $1
fi


echo "Enter your username:"
read USERNAME


USER=$($PSQL "SELECT username FROM datagamer WHERE username='$USERNAME'")

GAMES_PLAYED=$($PSQL "SELECT games_played FROM datagamer WHERE username='$USERNAME'")

BEST_GAME=$($PSQL "SELECT best_game FROM datagamer WHERE username='$USERNAME'")

RANDOM_NUMBER=$(( 1 + $RANDOM % 1000 ))

GAMES_PLAYED_NOW=0



#if [[ $USER ]]
#then
  #echo -e "Welcome back, $USER! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
#fi


if [[ -z $USER ]]
then
  echo -e "Welcome, $USERNAME! It looks like this is your first time here."
  GAMES_PLAYED=0
  BEST_GAME=999
  NEW_USER=$($PSQL "INSERT INTO datagamer(username, games_played, best_game) VALUES('$USERNAME', $GAMES_PLAYED, $BEST_GAME)")
else
  echo -e "Welcome back, $USER! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi



echo -e "Guess the secret number between 1 and 1000:"

if [[ $1 ]]
then
  echo $1
fi


while [[ true ]] 
do 
  read ANSWER
  (( GAMES_PLAYED_NOW++ ))

  #se a resposta do usuário for numérica...
  if [[ $ANSWER =~ ^[0-9]+$ ]] 
  then 
    if [[ $ANSWER -gt $RANDOM_NUMBER ]] 
    then
      echo -e "It's lower than that, guess again:"
      #(( GAMES_PLAYED_NOW++ ))
    elif [[ $ANSWER -lt $RANDOM_NUMBER ]]
    then
      echo -e "It's higher than that, guess again:"
      #(( GAMES_PLAYED_NOW++ ))
    else
      echo -e "You guessed it in $GAMES_PLAYED_NOW tries. The secret number was $RANDOM_NUMBER. Nice job!"
      #(( GAMES_PLAYED_NOW++ )) 
      break 
    fi
  #the answer is not a number...
  else 
    echo -e "That is not an integer, guess again:"
    #(( GAMES_PLAYED_NOW++ ))
  fi 
done


if [[ $BEST_GAME < $GAMES_PLAYED_NOW ]]
then
  BEST_GAME=$BEST_GAME
else
  BEST_GAME=$GAMES_PLAYED_NOW
fi


#update user's result:
#GAMES_PLAYED=$(( GAMES_PLAYED + 1 ))
#GAMES_PLAYED=$(( $GAMES_PLAYED + 1 ))
FINAL_GAME_RESULT=$($PSQL "UPDATE datagamer SET games_played= (( $GAMES_PLAYED + 1 )), best_game=$BEST_GAME WHERE username='$USERNAME'")

