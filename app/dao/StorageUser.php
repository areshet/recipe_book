<?php
require_once 'Dbconnect.php';
require_once 'app/models/User.php';

class StorageUser
{

    public static function getUser($token)
    {
        $sql = "SELECT \"users\".get_user('$token')";
        $query = Dbconnect::dbqueryCursor($sql);
        while ($row = pg_fetch_assoc($query)) {
            print_r(json_encode($row));
        }
    }

    public static function regUser($modl)
    {
        $login = $modl->getLogin();
        $password = hash('sha256', $modl->getPassword());
        $name = $modl->getName();
        $sql = "SELECT \"users\".save_user('$login', '$password', '$name')";
        $result = Dbconnect::query($sql);
        print_r(json_encode($result));
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
        print_r(json_encode($result));
    }


}