<?php
require_once 'app/models/Recipe.php';
require_once 'app/dao/StorageRecipe.php';

class ControllerRecipe
{
    public function myRecipes()
    {
        $token = '4QPWQUA6D6PMST19EDF9YCUYP1M6ZY7W2JFLS5334ECUHIQZLI72SHF7P1Y96L3L';
        StorageRecipe::myRecipes($token);
    }
    public function getRecipes(){
        $token = '4QPWQUA6D6PMST19EDF9YCUYP1M6ZY7W2JFLS5334ECUHIQZLI72SHF7P1Y96L3L';
        StorageRecipe::getList($token);

    }
    public function saveRecipe(){
        $token = '4QPWQUA6D6PMST19EDF9YCUYP1M6ZY7W2JFLS5334ECUHIQZLI72SHF7P1Y96L3L';
        $model = new Recipe();
        $model ->setTitle("Кичинес1");
        $model ->setDescription("мазик2");
        $model ->setAlgorithm("мазик+кепчуп3");
        $model ->setImage("/img/img.png");
        StorageRecipe::save($model,$token);
    }
    public function deleteRecipe(){
        $id=5;
        $token ="4QPWQUA6D6PMST19EDF9YCUYP1M6ZY7W2JFLS5334ECUHIQZLI72SHF7P1Y96L3L";
        StorageRecipe::delete($id,$token);
    }
    public function voteRecipe(){
        $id=8;
        $token ="4QPWQUA6D6PMST19EDF9YCUYP1M6ZY7W2JFLS5334ECUHIQZLI72SHF7P1Y96L3L";
        $rating =1;
        StorageRecipe::vote($id,$token,$rating);
    }
}