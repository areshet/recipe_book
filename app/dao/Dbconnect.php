<?php
require_once 'app/config/db.php';

class Dbconnect
{
    private function connect()
    {
        $dbhost = DBHOST;
        $port = DBPORT;
        $dbname = DBNAME;
        $dbuser = DBUSER;
        $dbpassword = DBPASS;
        $config = "host=$dbhost port=$port dbname=$dbname user=$dbuser password=$dbpassword";
        $connect = pg_connect($config);
        if (!$connect) die('connection failed');

        return $connect;
    }

    public static function query($query){
        $query = pg_query(Dbconnect::connect(),$query);
        $result = pg_fetch_all($query);
        return $result;
    }

    public static function dbquery( $query)
    {
        pg_query(Dbconnect::connect(), "BEGIN;");
        $tr = pg_query(Dbconnect::connect(), $query);
        $r = pg_fetch_row($tr);
        $name = $r[0];
        $rs = pg_query(Dbconnect::connect(), "FETCH ALL IN \"" . $name . "\";");
        pg_query(Dbconnect::connect(), "END;");
        return $rs;
    }
}