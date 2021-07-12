<?php

require_once( dirname(__FILE__) . '/../../vega_auth_fake.php');
#require_once('../../vega_auth_fake.php');
#include_once "functions_DEV_beta.php";
include( dirname(__FILE__) . '/../../functions_DEV_beta.php');
include( dirname(__FILE__) . '/../../db_queries.php');
#include '../../db_queries.php';
#var_dump($ets_omt_correspondence);
$i = 0;
$text[$i] = <<<'EOT'
/**
 * Usage : Put this script in <ScriptsDir>/project_changed folder. Create a folder if it doesn't exists.
 *
 * @authors 	Yu Tang, Manuel Souto Pico
 * @version 	0.5.2 (dynamic)
 * @date 		2020.11.24
 */

import static org.omegat.core.events.IProjectEventListener.PROJECT_CHANGE_TYPE.*


// prepare
String dir
def replacePair

def skipTraverse(eventType) {
    if (!eventType.metaClass.hasProperty(eventType, 'skipTraverse')) {
        eventType.metaClass.skipTraverse = false
    }
    eventType.skipTraverse
}

switch (eventType) {
    case LOAD:
        // Skip traverse
        if (skipTraverse(LOAD)) {
			LOAD.skipTraverse = false // reset the flag
			return
        }

        dir = project.projectProperties.sourceRoot
        replacePair = [
			// locks tu's corresponding to titles (OVERDOING: it hides S1, etc.)
			//// [find: /(?<=<trans-unit\s)[^>]*?(?=>[\s\n]+<source.+?>(?:[CQSPMRF]{1,2}\d+(?:.+?)?|.+?Q\d+)<\/source>)/, replacement: {it.contains('translate')? it : /$it translate="no"/}],
			// locks tu's corresponding to titles (OK, only unit titles)
	  			// [find: /(?<=<trans-unit\s)[^>]*?(?=>[\s\n]+<source.+?>(?:[CQSPMRF]{1,2}\d{2}(\d|[KG]).+?(Q\d+)?)<\/source>)/, replacement: {it.contains('translate')? it : /$it translate="no"/}],
	  		// removes the source segment in the alternative translation
			[find: /<alt-trans[^>]*>\n\s*<source.+?>.+?\/source>/, replacement: /<alt-trans>/],
			// removes doctype declaration
			[find: /\n<!DOCTYPE xliff [^>]+ "http[^>]+xliff.dtd">/, replacement: / /],
			// switches the approved status from no to yes, otherwise translation might not show with Okapi XLIFF filter (if it's identical to source)
			[find: /approved="no"/, replacement: /approved="yes"/],
			// adds attribute-value pair approved=yes, otherwise translation does not show with Okapi XLIFF filter (if it's identical to source)
			[find: /(?<=<trans-unit\s)[^>]*?(?=>)/, replacement: {it.contains('approved')? it : /$it approved="yes"/}],
			// sets xml:space to preserve to avoid leading and trailing spaces being removed in exported files
			[find: /xml:space="(?!preserve)[^"]+"/, replacement: /xml:space="preserve"/],
			// adds the xml:space = preserve if it's not there
			[find: /(?<=<file\s)[^>]*?(?=>)/, replacement: {it.contains('xml:space')? it : /$it xml:space="preserve"/}],
			// converts ETS language codes to OmegaT language codes
EOT;

asort($ets_omt_correspondence);
foreach($ets_omt_correspondence as $omt => $ets) {
	$text[++$i] = '			[find: /"' . $ets . '"/, replacement: /"' . $omt . '"/],';
}

$text[++$i] = <<<'EOT'
		]
		break
	case COMPILE:
		dir = project.projectProperties.targetRoot
		// restores ETS language codes
		replacePair = [
EOT;

ksort($ets_omt_correspondence);
foreach($ets_omt_correspondence as $omt => $ets) {
	$text[++$i] = '			[find: /"' . $omt . '"/, replacement: /"' . $ets . '"/],';
}

$text[++$i] = <<<'EOT'
        ]
        break
    default:
        return null // No output
}

String ENCODING = 'UTF-8'
File rootDir = new File(dir)
int modifiedFiles = 0

// options as map
def options = [
    type       : groovy.io.FileType.FILES,
    nameFilter : ~/.*\.xlf/
]

// replacer as closure
def replacer = {file ->
    String text = file.getText ENCODING
    String replaced = text
    replacePair.each {replaced = replaced.replaceAll it.find, it.replacement}
    if (text != replaced) {
        file.setText replaced, ENCODING
        console.println "modified: $file"
        modifiedFiles++
    }
}

def reloadProjectOnetime = {
    LOAD.skipTraverse = true    // avoid potentially infinity reloading loop
    javax.swing.SwingUtilities.invokeLater({
        org.omegat.gui.main.ProjectUICommands.projectReload()
    } as Runnable)
}

// do replace
rootDir.traverse options, replacer

/*if (modifiedFiles > 0 && eventType == LOAD) {
    console.println "$modifiedFiles file(s) modified."
    reloadProjectOnetime()
}*/
EOT;

#$file = "cat/OmegaT/installer/scripts/project_changed/pisaconv.groovy";
$file = dirname(__FILE__) . "/installer/scripts/project_changed/pisaconv.groovy";
unlink($file);
#unlink($file_installer);

echo "<h3>Writing the following to file $file</h3><hr/>";

echo "<pre>";
foreach($text as $line) {
	print $line . "<br/>";
	file_put_contents($file, $line.PHP_EOL, FILE_APPEND);
	#file_put_contents($file_installer, $line.PHP_EOL, FILE_APPEND);
}
echo "</pre>";

?>
