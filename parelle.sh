task(){
   sleep 0.5; echo "$1";
}

function main(){
    for thing in a b c d e f g; do 
        task "$thing" &
    done
}

main


