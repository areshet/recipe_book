<?php
require_once 'app/dao/StorageUser.php';
require_once 'app/models/User.php';


class ControllerUser
{
    public function getUser()
    {
        $token = $_COOKIE['token'];
        $user = StorageUser::getUser($token);
        echo json_encode($user, JSON_UNESCAPED_UNICODE);
    }

    public function regUser()
    {
        $model = new User();
        $reg_result = json_encode(['registration' => false], JSON_UNESCAPED_UNICODE);
        !empty($_POST['login']) ? $login = $_POST['login'] : die($reg_result);
        !empty($_POST['password']) ? $pass = $_POST['password'] : die($reg_result);
        !empty($_POST['name']) ? $name = $_POST['name'] : die($reg_result);

        $model->setLogin($login);
        $model->setPassword($pass);
        $model->setName($name);

        $result = StorageUser::regUser($model);
        if (empty($result)) die($reg_result);

        echo json_encode(['registration' => true], JSON_UNESCAPED_UNICODE);
    }

    public function authUser()
    {
        $auth_result = json_encode(['auth' => false], JSON_UNESCAPED_UNICODE);
        !empty($_POST['login']) ? $login = $_POST['login'] : die($auth_result);
        !empty($_POST['password']) ? $pass = $_POST['password'] : die($auth_result);

        $model = new User();
        $model->setLogin($login);
        $model->setPassword($pass);

        $token = StorageUser::authUser($model);
        if (empty($token)) die($auth_result);
        $expire = time() + User::$date / 1000;

        setcookie("token", $token, $expire, '/', null, null, true);

        echo json_encode(['auth' => true], JSON_UNESCAPED_UNICODE);

    }


}