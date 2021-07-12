#!/bin/bash

echo ""
echo "Hi, welcome to the OmegaT customization"

echo ""
echo "You've just installed OmegaT in your machine, right?"
echo "If that's the case, you may proceed, otherwise please quit and install it first!"

read -n1 -r -p "Press SPACE to continue or Ctrl+C to quit..." key

if [ "$key" = '' ]; then
    # Space pressed, do something
    # echo "blabla"
    # echo [$key] is empty when SPACE is pressed # uncomment to trace

	echo ""
	echo "Now I will run OmegaT for the first time."
    echo "If you need to approve the first execution, just press the Open button."
	read -p "Press ENTER to run OmegaT..."
    open -a OmegaT
    echo "Ok, it runs fine, thanks. Now I'll close it, hands off now! :)"
	sleep 5
    # #echo "Killing OmegaT"
    kill $(ps aux | grep OmegaT | grep java | awk '{print $2}')
    # ##killall java
    sleep 5

    ##echo "Downloading custom files"
    ##curl -0 https://cat.capstan.be/OmegaT/manual/config.zip 

    ## unnecessary if OmegaT is run
    #pushd ~/Library/Preferences/
    #mkdir OmegaT 
    #popd 

	echo "Moving custom files to the right location"
    unzip -o config.zip -d ~/Library/Preferences/OmegaT
    unzip -o plugins.zip -d ~/Library/Preferences/OmegaT/plugins
    unzip -o scripts.zip -d /Applications/OmegaT.app/Contents/Java/scripts

    # Adding the path to the scripts folder to omegat.prefs
    perl -pi -e 's~^(\s*)(?=<scripts_quick_1>)~$1<scripts_dir>/Applications/OmegaT.app/Contents/Java/scripts</scripts_dir>\n$1~' ~/Library/Preferences/OmegaT/omegat.prefs

    echo "Customization complete! Running OmegaT now. You can close the Terminal."
    open -a OmegaT
    # if it doesn't run, output a message: there's a problem with OmegaT, contact cApStAn OmegaT helpdesk
    exit 0
else
    # Anything else pressed, do whatever else.
    echo [$key] not empty
fi

