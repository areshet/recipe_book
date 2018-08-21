<?php

Class Route
{
    static function start()
    {
        $routes = explode('/', $_SERVER['REQUEST_URI']);

        if ($routes[1] != 'webapi') return;

        $_SERVER['REQUEST_METHOD'] != 'POST' ? Route::error():null;

        if (!empty($routes[2]) && !empty($routes[3])) {
            $controller_name = strtolower($routes[2]);
            $method = strtolower($routes[3]);

            $controller_name = 'Controller' . ucfirst($controller_name);


            $controller_file = $controller_name . '.php';
            $controller_path = "app/controllers/" . $controller_file;
            if (file_exists($controller_path)) {
                include $controller_path;
            } else {
                Route::Error();
            }

            $controller = new $controller_name;

            if (method_exists($controller, $method)) {
                $controller->$method();
            } else {
                Route::Error();
            }
        } else {
            echo "recept service api";
        }


    }


    function Error()
    {
        header('HTTP/1.1 404 Not Found');
        exit();
    }
}

?>