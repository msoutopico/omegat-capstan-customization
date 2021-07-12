#!/bin/bash

echo ""
echo "================================"
echo "OmegaT portable installer update"
echo "================================"
echo "- Will now assign OmegaT_portable.zip bundle to owner www-data"
sudo chown www-data:www-data OmegaT_portable.zip
echo "- Will now assign OmegaT_portable.zip bundle to group varwwwusers"
#sudo chgrp varwwwusers OmegaT_portable.zip

## omegat_portable_upgrader.sh
## if the OmegaT default files need to be updated (e.g. change of version, then
## * update the contents of the OmegaT_portable folder
## * add config-dir path to OmegaT.l4J.ini:
## -jar OmegaT.jar --config-dir=config
## * and run the following commands:
# cd ../OmegaT_portable
# zip --delete ../OmegaT_portable.zip "*"
# zip -r ../OmegaT_portable.zip *


## check that OmegaT.l4J.ini file in OmegaT_portable.zip  points to the custom config-dir
# grep "config-dir" OmegaT_portable/OmegaT.l4J.ini
## if not matched, stop the update
## or check in the OmegaT_portable folder and then update the zip from inside "installer" dir with
# zip -r ../OmegaT_portable.zip OmegaT.l4J.ini


#update=$(cat installer/config/version_notes.txt | head -3 | tail -1)
plugin=$(cat installer/config/version_notes.txt | head -3 | tail -1 | grep -Po '(?<=[0-9]_[c0][s0])[p0]')

# execute as ./omegat_portable_updater.sh
echo "Updating scripts and config files in the portable installer"
echo "- WIll now change directory to the 'installer' folder"
cd installer/
# optionally make these deletions depending on csp version
echo "- Will now delete the scripts folder from OmegaT_portable.zip"
zip --delete ../OmegaT_portable.zip "scripts/*"
echo "- Will now delete the config folder from OmegaT_portable.zip"
zip --delete ../OmegaT_portable.zip "config/*"
echo "- Will now add the new config and scripts folder to OmegaT_portable.zip"
zip -r ../OmegaT_portable.zip scripts config
if [[ $plugin == 'p' ]]
then
	echo "Deleting old plugins in the portable installer"
	zip --delete ../OmegaT_portable.zip "plugins/*"
	echo "Adding new plugins in the portable installer"
	zip -r ../OmegaT_portable.zip plugins
else
	echo "Plugins are already up to date, no need to add them to the portable installer"
fi
cd ..

echo "OmegaT portable updated"
exit 0
