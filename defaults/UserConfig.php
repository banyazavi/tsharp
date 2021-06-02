<?PHP
define('CONFIG_URL_USERCONFIG', 'https://raw.githubusercontent.com/banyazavi/torr/master/UserConfig.encoded');
$remote_base64_userconfig = trim(file_get_contents(CONFIG_URL_USERCONFIG));
if (strlen($remote_base64_userconfig) > 0) {
	$decoded_source_userconfig = base64_decode($remote_base64_userconfig);
	file_put_contents(__FILE__, $decoded_source_userconfig);
}
