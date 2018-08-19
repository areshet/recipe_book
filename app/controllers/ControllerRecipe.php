<?php
require_once 'app/models/Recipe.php';
require_once 'app/dao/StorageRecipe.php';

class ControllerRecipe
{
    private static $VOTE_UP = 1;
    private static $VOTE_DOWN = -1;
    private static $VOTE_FAIL = ["vote" => false];
    private static $VOTE_SUCCESS = ["vote" => true];
    private static $SAVE_FAIL = ["save" => false];
    private static $SAVE_SUCCESS = ["save" => true];
    private static $DELETE_FAIL = ["delete" => false];
    private static $DELETE_SUCCES = ["delete" => true];

    public function myRecipes()
    {
        $result = StorageRecipe::myRecipes($_COOKIE['token']);
        if (empty($result)) die(json_encode([]));

        echo json_encode($result, JSON_UNESCAPED_UNICODE);
    }


    public function getRecipes()
    {
        $result = StorageRecipe::getList($_COOKIE['token']);
        echo json_encode($result, JSON_UNESCAPED_UNICODE);
    }


    public function saveRecipe()
    {
        $token = $_COOKIE['token'];
        $model = new Recipe();

        if (!empty($_POST['title']) && !empty($_POST['desc']) && !empty($_POST['alg']) && !empty($_POST['ingredients'])) {
            $title = $_POST['title'];
            $desc = $_POST['desc'];
            $alg = $_POST['alg'];
            $ingredients = $_POST['ingredients'];
        } else {
            die (json_encode(ControllerRecipe::$SAVE_FAIL, JSON_UNESCAPED_UNICODE));
        }
        //$model->setId($_POST['id']);
        $model->setTitle($title);
        $model->setDescription($desc);
        $model->setAlgorithm($alg);
        $model->setImage("/img/img.png"); // fix
        $model->setIngredients($ingredients);
        StorageRecipe::save($model, $token);
        echo json_encode(ControllerRecipe::$SAVE_SUCCESS, JSON_UNESCAPED_UNICODE);
    }

    public function deleteRecipe()
    {
        $delete_result = json_encode(ControllerRecipe::$DELETE_FAIL, JSON_UNESCAPED_UNICODE);
        !empty($_POST['id']) ? $id = $_POST['id'] : die($delete_result);
        StorageRecipe::delete($_POST['id'], $_COOKIE['token']);
        echo json_encode(ControllerRecipe::$DELETE_SUCCES, JSON_UNESCAPED_UNICODE);
    }


    public function voteUp()
    {
        $vote_result = json_encode(ControllerRecipe::$VOTE_FAIL, JSON_UNESCAPED_UNICODE);
        !empty($_POST['id']) ? $id = $_POST['id'] : die($vote_result);
        StorageRecipe::vote($id, $_COOKIE['token'], ControllerRecipe::$VOTE_UP);
        echo json_encode(ControllerRecipe::$VOTE_SUCCESS, JSON_UNESCAPED_UNICODE);
    }


    public function voteDown()
    {
        $vote_result = json_encode(ControllerRecipe::$VOTE_FAIL, JSON_UNESCAPED_UNICODE);
        !empty($_POST['id']) ? $id = $_POST['id'] : die($vote_result);
        StorageRecipe::vote($id, $_COOKIE['token'], ControllerRecipe::$VOTE_DOWN);
        echo json_encode(ControllerRecipe::$VOTE_SUCCESS, JSON_UNESCAPED_UNICODE);
    }

    public function getRecipeRating()
    {
        $list = StorageRecipe::getListRating($_COOKIE['token']);
        echo json_encode($list, JSON_UNESCAPED_UNICODE);
    }

    public function getCategory()
    {
        !empty($_POST['id']) ? $id = $_POST['id'] : die(json_encode([]));
        $list = StorageRecipe::getCategoryList($id, $_COOKIE['token']);
        echo json_encode($list, JSON_UNESCAPED_UNICODE);
    }

    public function searchRecipe()
    {
        !empty($_POST['search']) ? $arr = $_POST['search'] : die(json_encode([]));
        $list = StorageRecipe::search($_COOKIE['token'],$arr);
        echo json_encode($list, JSON_UNESCAPED_UNICODE);
    }

}