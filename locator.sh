fullPATH=$(realpath "$EM_CACHE" 2> /dev/null)
echo $EM_CACHE

if [ ! -w "$fullPATH" ]
then
    if [ ! -w "$HOME" ]
    then

    else
        export EM_CACHE="$HOME/.cache/emscripten"
        mkdir -p $EM_CACHE
    fi
else
fi


