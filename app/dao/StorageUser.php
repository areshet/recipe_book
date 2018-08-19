<?php
require_once 'Dbconnect.php';
require_once 'app/models/User.php';

class StorageUser
{

    public static function getUser($token)
    {
        $sql = "SELECT \"users\".get_user('$token')";
        $result = Dbconnect::dbqueryCursor($sql);
        $row = pg_fetch_assoc($result);
        return $row;
    }

    public static function regUser($modl)
    {
        $login = $modl->getLogin();
        $password = hash('sha256', $modl->getPassword());
        $name = $modl->getName();
        $sql = "SELECT \"users\".save_user('$login', '$password', '$name')";
        $result = Dbconnect::query($sql);
        return $result[0]['save_user'];
    }

    public static function authUser($model)
    {
        $expire = round(microtime(true) * 1000) + User::$date;
        $seconds = $expire / 1000;
        $end_date = date("Y-m-d H:i:s", $seconds);
        $login = $model->getLogin();
        $password = $model->getPassword();
        $sql = "SELECT \"users\".auth_user('$login', '$password', '$end_date')";
        $result = Dbconnect::query($sql);
        $token = $result[0]['auth_user'];
        return $token;
    }


}