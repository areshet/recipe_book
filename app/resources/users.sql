/*
Navicat PGSQL Data Transfer

Source Server         : store
Source Server Version : 90604
Source Host           : localhost:5432
Source Database       : cooking
Source Schema         : users

Target Server Type    : PGSQL
Target Server Version : 90604
File Encoding         : 65001

Date: 2018-08-19 23:09:20
*/


-- ----------------------------
-- Sequence structure for seq_user
-- ----------------------------
DROP SEQUENCE IF EXISTS "users"."seq_user";
CREATE SEQUENCE "users"."seq_user"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 76
 CACHE 1;
SELECT setval('"users"."seq_user"', 76, true);

-- ----------------------------
-- Table structure for t_sessions
-- ----------------------------
DROP TABLE IF EXISTS "users"."t_sessions";
CREATE TABLE "users"."t_sessions" (
"user_id" int8 NOT NULL,
"session" varchar(64) COLLATE "default" NOT NULL,
"expire" timestamp(6) NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of t_sessions
-- ----------------------------

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS "users"."t_user";
CREATE TABLE "users"."t_user" (
"id" int8 DEFAULT nextval('"users".seq_user'::regclass) NOT NULL,
"login" text COLLATE "default" NOT NULL,
"password" text COLLATE "default",
"name" text COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of t_user
-- ----------------------------

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------

-- ----------------------------
-- Uniques structure for table t_sessions
-- ----------------------------
ALTER TABLE "users"."t_sessions" ADD UNIQUE ("session");

-- ----------------------------
-- Primary Key structure for table t_sessions
-- ----------------------------
ALTER TABLE "users"."t_sessions" ADD PRIMARY KEY ("session");

-- ----------------------------
-- Uniques structure for table t_user
-- ----------------------------
ALTER TABLE "users"."t_user" ADD UNIQUE ("login");

-- ----------------------------
-- Primary Key structure for table t_user
-- ----------------------------
ALTER TABLE "users"."t_user" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Key structure for table "users"."t_sessions"
-- ----------------------------
ALTER TABLE "users"."t_sessions" ADD FOREIGN KEY ("user_id") REFERENCES "users"."t_user" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
