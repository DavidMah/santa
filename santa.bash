#!/bin/bash

entries="$(cat <&0 | tr '[:upper:]' '[:lower:]')"
until awk '{ if($1 == $3) {exit 1}}' <(echo "$merged_entries")
do
  shuffled_entries="$(echo "$entries" | sort -R)"
  merged_entries="$(paste <(echo "$entries") <(echo "$shuffled_entries"))"
done
alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"

gawk '{
  gifter=$1
  gifter_email=$2
  giftee=$3

  cmd="head -c 200 /dev/urandom | tr -dc [a-z]"
  cmd | getline lolsalt
  close(cmd)

  cmd="tr [a-z] [n-za-m]"
  print lolsalt""giftee""lolsalt |& cmd
  close(cmd, "to")
  cmd |& getline rot13_giftee
  close(cmd)

  print gifter_email
  print "Oyo "gifter", youre a secret santa! You need to give a gift to "rot13_giftee"."
  print "huehuehue yup, thats rot13ed. Once you rot13 it back, look for the name of your giftee somewhere in the middle of the text blob."
  print ""

}' <(echo "$merged_entries")
