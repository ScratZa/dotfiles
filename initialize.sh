sudo apt-get update -y
sudo apt-get upgrade -y 
sudo apt-get install xclip fzf tmux zsh stow gcc ripgrep -y

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

sudo ~/.ubuntu/scripts/cleansetup.sh
