<?php
require_once 'app/dao/StorageUser.php';
require_once 'app/models/User.php';


class ControllerUser
{
    public function getUser()
    {
        $token = '4LKGFY5F3BHAELPO4KGHPYF8DM1871WHDEFADKJY6ST8C9L5W7J2CR02RF1ZMOKY';
        StorageUser::getUser($token);

    }

    public function regUser()
    {
        $model = new User();
        $model->setLogin("pacanka");
        $model->setPassword("pacan123");
        $model->setName("pacanchik");
        StorageUser::regUser($model);
    }

    public function authUser()
    {
        $model = new User();
        $model->setLogin("pacanka");
        $model->setPassword("pacan123");
        StorageUser::authUser($model);
    }


}