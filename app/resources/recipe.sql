/*
Navicat PGSQL Data Transfer

Source Server         : store
Source Server Version : 90604
Source Host           : localhost:5432
Source Database       : cooking
Source Schema         : recipe

Target Server Type    : PGSQL
Target Server Version : 90604
File Encoding         : 65001

Date: 2018-08-19 23:09:09
*/


-- ----------------------------
-- Sequence structure for seq_recipe
-- ----------------------------
DROP SEQUENCE IF EXISTS "recipe"."seq_recipe";
CREATE SEQUENCE "recipe"."seq_recipe"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 15
 CACHE 1;
SELECT setval('"recipe"."seq_recipe"', 15, true);

-- ----------------------------
-- Table structure for t_categories
-- ----------------------------
DROP TABLE IF EXISTS "recipe"."t_categories";
CREATE TABLE "recipe"."t_categories" (
"id" int4 NOT NULL,
"title" text COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of t_categories
-- ----------------------------
INSERT INTO "recipe"."t_categories" VALUES ('1', 'Суп');
INSERT INTO "recipe"."t_categories" VALUES ('2', 'Салат');
INSERT INTO "recipe"."t_categories" VALUES ('3', 'Пицца');
INSERT INTO "recipe"."t_categories" VALUES ('4', 'Паста');
INSERT INTO "recipe"."t_categories" VALUES ('5', 'Другое');

-- ----------------------------
-- Table structure for t_recipe
-- ----------------------------
DROP TABLE IF EXISTS "recipe"."t_recipe";
CREATE TABLE "recipe"."t_recipe" (
"id" int8 DEFAULT nextval('"recipe".seq_recipe'::regclass) NOT NULL,
"user_id" int8,
"title" text COLLATE "default",
"description" text COLLATE "default",
"algorithm" text COLLATE "default",
"rating" int4 DEFAULT 0 NOT NULL,
"image" text COLLATE "default",
"ingredients" _text,
"category" int4 DEFAULT 5
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of t_recipe
-- ----------------------------

-- ----------------------------
-- Table structure for t_votes
-- ----------------------------
DROP TABLE IF EXISTS "recipe"."t_votes";
CREATE TABLE "recipe"."t_votes" (
"user_id" int8 NOT NULL,
"recipe_id" int8 NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of t_votes
-- ----------------------------

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table t_categories
-- ----------------------------
ALTER TABLE "recipe"."t_categories" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_recipe
-- ----------------------------
ALTER TABLE "recipe"."t_recipe" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Key structure for table "recipe"."t_recipe"
-- ----------------------------
ALTER TABLE "recipe"."t_recipe" ADD FOREIGN KEY ("user_id") REFERENCES "users"."t_user" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "recipe"."t_recipe" ADD FOREIGN KEY ("category") REFERENCES "recipe"."t_categories" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "recipe"."t_votes"
-- ----------------------------
ALTER TABLE "recipe"."t_votes" ADD FOREIGN KEY ("recipe_id") REFERENCES "recipe"."t_recipe" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "recipe"."t_votes" ADD FOREIGN KEY ("user_id") REFERENCES "users"."t_user" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
