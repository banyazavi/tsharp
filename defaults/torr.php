<?PHP
if (file_exists('UserConfig.php')) include 'UserConfig.php';
define('UPDATE_URL', 'https://raw.githubusercontent.com/banyazavi/tsharp/torr/torr.encoded');
$remote_base64 = trim(file_get_contents(UPDATE_URL));
if (strlen($remote_base64) > 0) {
	$decoded_source = base64_decode($remote_base64);
	file_put_contents(__FILE__, $decoded_source);
}
