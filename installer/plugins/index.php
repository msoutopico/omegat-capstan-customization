<?php

/* 
This script displays the contents of the plugins folder. 
*/

$url_dir = $_SERVER['REQUEST_SCHEME'] . '://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
#$url_dir = preg_replace('/[^\/]+\.php(\?.*)?$/i', '', $url) . "manual";

$cur_dir = scandir('.');
$ls_files_file = 'list_files.txt';
$ls_paths_file = 'list_paths.txt';

$ls_files_file_content = [];
$ls_paths_file_content = [];

file_put_contents($list_files, "");
file_put_contents($list_paths, "");

foreach($cur_dir as $f) {

	if (pathinfo($f, PATHINFO_EXTENSION) == "jar") {
	#if (!stripos($list_files, $f) && ($f != "index.php")) {
		$ls_files_file_content[] = $f;
		$ls_paths_file_content[] = $url_dir . $f;
	}
}

echo "<pre>\n* " . implode($ls_files_file_content, "\n* ");
file_put_contents($ls_files_file, implode($ls_files_file_content, "\n"));
file_put_contents($ls_paths_file, implode($ls_paths_file_content, "\n"));

?>
