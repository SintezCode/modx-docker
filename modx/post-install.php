<?php
use Symfony\Component\Dotenv\Dotenv;

require(__DIR__.'/vendor/autoload.php');

$dotenv = new Dotenv();
$dotenv->load(__DIR__.'/.env');

define('MODX_API_MODE', true);
require_once(__DIR__.'/core/config/config.inc.php');
require_once(MODX_BASE_PATH.'index.php');
$modx= new modX();
$modx->initialize('web');

if($_ENV['YANDEX_MAP_API_KEY']){
    $setting = $modx->getObject('modSystemSetting', 'yandex_coords_tv_api_key');
    if($setting){
        $setting->set('value',$_ENV['YANDEX_MAP_API_KEY']);
        $setting->save();
    }
}


