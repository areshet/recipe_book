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

    public static function query($query)
    {
        $query = pg_query(Dbconnect::connect(), $query);
        $result = pg_fetch_all($query);

        return $result;
    }

    public static function dbqueryCursor($query)
    {
        pg_query(Dbconnect::connect(), "BEGIN;");
        $query = pg_query(Dbconnect::connect(), $query);
        $row = pg_fetch_row($query);
        $name = $row[0];
        $result = pg_query(Dbconnect::connect(), "FETCH ALL IN \"" . $name . "\";");
        pg_query(Dbconnect::connect(), "END;");

        return $result;
    }
    static function to_pg_array($set) {
        settype($set, 'array'); // can be called with a scalar or array
        $result = array();
        foreach ($set as $t) {
            if (is_array($t)) {
                $result[] = Dbconnect::to_pg_array($t);
            } else {
                $t = str_replace('"', '\\"', $t);
                if (! is_numeric($t))
                    $t = '"' . $t . '"';
                $result[] = $t;
            }
        }
        return '{' . implode(",", $result) . '}';
    }
}