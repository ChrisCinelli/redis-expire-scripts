  #!/bin/bash
  
  # Go through 100 keys at the time - The higher the fastest but als othe longest redis is irresponsixe and 
  # It may create a command line too long
  keys_for_step=100

  if [ $# -lt 1 ]
  then
    echo "Expire keys from Redis matching a pattern using SCAN & EXPIRE"
    echo "Usage: $0 <pattern> [<host>] [<port>] [<db>]"
    exit 1
  fi

  host=$2
  if [ -z "$2" ]; then host="127.0.0.1"; else host=$2; fi

  cursor=-1
  keys=""

  while [[ $cursor -ne 0 ]]; do
    if [[ $cursor -eq -1 ]]
    then
      cursor=0
    fi

    reply=$(redis-cli  -h $host -p ${3:-6379} -n ${4:-0} --raw SCAN $cursor MATCH $1 COUNT $keys_for_step)
    cursor=$(expr "$reply" : '\([0-9]*[0-9 ]\)')
    echo "Cursor: $cursor"
    keys=$(echo $reply | tr -d '\r' | awk '{for (i=2; i<=NF; i++) print $i}')
    [ -z "$keys" ] && continue

    keya=( $keys )
    count=$(echo ${#keya[@]})
    #docker exec -it myredis 
    redis-cli  -h $host -p ${3:-6379} -n ${4:-0} EVAL "$(cat expire-sessions.lua)" $count $keys
  done
