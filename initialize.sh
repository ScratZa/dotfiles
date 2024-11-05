for dir in */  
do  
    stow --verbose --target="$HOME" "${dir%/}"  
    if [ $? -ne 0 ]  
    then  
        echo "Error: Unable to stow directory $dir."  
    else  
        echo "Successfully stowed directory $dir."  
    fi  
done  
