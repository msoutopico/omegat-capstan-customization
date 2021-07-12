#!/bin/bash

# execute as ./omegat_portable_updater.sh

echo ""
echo "======================================="
echo "OmegaT manual installation files update"
echo "======================================="

echo "Getting new custom pattern (after editing tagValidation_customPattern)"
customPattern=$(perl -pe 's/((\s*|^)#\s.*)?(\n|\Z)|^\s+//g' tagValidation_customPattern)
echo "Update omegat.prefs with the new custom pattern"
perl -epi 's~(?<=<tagValidation_customPattern>).+?(?=</tagVa)~${customPattern}~g' installer/config/omegat.prefs


echo "Recreating pisaconv.groovy"
php -f write_pisaconv_script.php > /dev/null

# back up current version
v=`unzip -qc manual/config.zip version_notes.txt | head -3 | tail -1 | cut -c11-16`
mkdir -p archive/manual_${v}
echo "Archiving manual bundles..."
mv manual/*.zip archive/manual_${v}

#update manual installation
#echo "Removing previous files..."
#rm -r manual/* # unneed anymore, moved to backup
echo "Updating config files for manual customization"
cd installer/config/  && zip -r ../../manual/config.zip * && cd ../..
echo "Updating scripts for manual customization"
cd installer/scripts/ && zip -r ../../manual/scripts.zip * && cd ../..
echo "Updating plugins for manual customization"
cd installer/plugins/ && zip -r ../../manual/plugins.zip * && cd ../..
echo "OmegaT manual customization files updated"
echo "--"

echo "Creating customization bundle for Mac"
cp omtmac_customizer.sh manual
cd manual/ && zip -r ../mac/omtmac_custom.zip *
rm omtmac_customizer.sh
cd ..
echo "Customization bundle for Mac created at https://cat.capstan.be/OmegaT/mac/omtmac_custom.zip"
echo "--"

exit 0
