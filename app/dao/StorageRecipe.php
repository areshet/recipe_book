<?php
require_once 'app/models/Recipe.php';
require_once 'Dbconnect.php';

class StorageRecipe
{
    public static function myRecipes($token)
    {
        $sql = "SELECT \"recipe\".get_my_recipe('$token')";
        $result = Dbconnect::dbqueryCursor($sql);
        while ($row = pg_fetch_assoc($result)) {
            echo "<pre>";
            print_r(json_encode($row, JSON_UNESCAPED_UNICODE));
        }
    }


    public static function save($model,$token) {
        $id = $model->getId() === null ? 'null' : $model->getId();
        $title = $model->getTitle();
        $desc = $model->getDescription();
        $alg = $model->getAlgorithm();
        $img = $model->getImage();
        $sql = "SELECT \"recipe\".save_recipe($id,'$token','$title','$desc','$alg','$img')";
        $result = Dbconnect::query($sql);
        print_r(json_encode($result));

    }
    public static function getList($token) {
        $sql = "SELECT \"recipe\".get_all('$token')";
        $result = Dbconnect::dbqueryCursor($sql);
        while ($row = pg_fetch_assoc($result)) {
            echo "<pre>";
            print_r(json_encode($row, JSON_UNESCAPED_UNICODE));
        }
    }
    public static function delete($id,$token){
        $sql = "SELECT \"recipe\".remove($id,'$token')";
        $result = Dbconnect::query($sql);
        print_r(json_encode($result));
    }
    public static function vote($id,$token,$rating){
        $sql ="SELECT \"recipe\".vote($id,'$token',$rating)";
        $result = Dbconnect::query($sql);
        print_r(json_encode($result));
    }
}