<?php
require_once 'app/models/Recipe.php';
require_once 'Dbconnect.php';

class StorageRecipe
{
    public static function myRecipes($token)
    {
        $sql = "SELECT \"recipe\".get_my_recipe('$token')";
        $result = Dbconnect::dbqueryCursor($sql);
        return $row = pg_fetch_all($result);
    }


    public static function save($model, $token)
    {
        $id = $model->getId() === null ? 'null' : $model->getId();
        $title = $model->getTitle();
        $desc = $model->getDescription();
        $alg = $model->getAlgorithm();
        $img = $model->getImage();
        $ingr = Dbconnect::to_pg_array($model->getIngredients());
        $sql = "SELECT \"recipe\".save_recipe($id,'$token','$title','$desc','$alg','$img','$ingr')";
        $result = Dbconnect::query($sql);
        return $result[0]['save_recipe'];

    }


    public static function getList($token)
    {
        $sql = "SELECT \"recipe\".get_all_by_oldest('$token')";
        $result = Dbconnect::dbqueryCursor($sql);
        return $row = pg_fetch_all($result);
    }


    public static function delete($id, $token)
    {
        $sql = "SELECT \"recipe\".remove($id,'$token')";
        Dbconnect::query($sql);
    }


    public static function vote($id, $token, $rating)
    {
        $sql = "SELECT \"recipe\".vote($id,'$token', $rating)";
        $result = Dbconnect::query($sql);
    }


    public static function getListRating($token)
    {
        $sql = "SELECT \"recipe\".get_all_by_rating('$token')";
        $result = Dbconnect::dbqueryCursor($sql);
        return $row = pg_fetch_all($result);
    }

    public static function getCategoryList($id, $token)
    {
        $sql = "SELECT \"recipe\".get_by_category('$id','$token')";
        $result = Dbconnect::dbqueryCursor($sql);
        return $row = pg_fetch_all($result);
    }

    public static function search($token, $arr)
    {
        $param = [];
        foreach ($arr as $value) {
            array_push($param, '%' . $value . '%');
        }
        $words = Dbconnect::to_pg_array($param);
        $sql = "SELECT \"recipe\".search('$token','$words')";
        $result = Dbconnect::dbqueryCursor($sql);
        return pg_fetch_all($result);
    }
}