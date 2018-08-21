/*
Navicat PGSQL Data Transfer

Source Server         : store
Source Server Version : 90604
Source Host           : localhost:5432
Source Database       : cooking
Source Schema         : users

Target Server Type    : PGSQL
Target Server Version : 90500
File Encoding         : 65001

Date: 2018-08-21 20:13:18
*/


-- ----------------------------
-- Sequence structure for seq_user
-- ----------------------------
DROP SEQUENCE IF EXISTS "seq_user";
CREATE SEQUENCE "seq_user"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 76
 CACHE 1;
SELECT setval('"users"."seq_user"', 76, true);

-- ----------------------------
-- Table structure for t_sessions
-- ----------------------------
DROP TABLE IF EXISTS "t_sessions";
CREATE TABLE "t_sessions" (
"user_id" int8 NOT NULL,
"session" varchar(64) COLLATE "default" NOT NULL,
"expire" timestamp(6) NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of t_sessions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS "t_user";
CREATE TABLE "t_user" (
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
BEGIN;
COMMIT;

-- ----------------------------
-- Function structure for auth_user
-- ----------------------------
CREATE OR REPLACE FUNCTION "auth_user"("p_login" text, "p_pwd" text, "p_expire" timestamp)
  RETURNS "pg_catalog"."text" AS $BODY$
declare
  l_session text  := '';
	l_isConflict bool := true;
	l_user_id int8 := null;
begin

	select t."id" from "users".t_user t where t."login" = p_login and t."password" = p_pwd into l_user_id;

	if l_user_id is NULL then
		return null;
	end if;
  
	while l_isConflict loop
		begin
			l_isConflict := false;
			l_session  := "users".random_string(64);
		
			insert into "users".t_sessions("user_id", "session", "expire") values (l_user_id, l_session, p_expire);
		
			EXCEPTION
			when check_violation  then
				l_isConflict := true;		
			end;			
	end loop;
	
  return l_session;
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for get_user
-- ----------------------------
CREATE OR REPLACE FUNCTION "get_user"("p_session" text)
  RETURNS "pg_catalog"."refcursor" AS $BODY$ DECLARE
	res refcursor;
BEGIN
	OPEN res FOR 
		SELECT 
			t."id",
			t."login",
			t."password",
			t."name" 
	FROM  "users".t_user t, 
        "users".t_sessions 
	WHERE "users".t_sessions."session" = p_session
		and "users".t_sessions."user_id" = t.id;
		
RETURN res;

END; $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for random_string
-- ----------------------------
CREATE OR REPLACE FUNCTION "random_string"("length" int4)
  RETURNS "pg_catalog"."text" AS $BODY$
declare
  chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z}';
  result text := '';
  i integer := 0;
begin
  if length < 0 then
    raise exception 'Given length cannot be less than 0';
  end if;
  for i in 1..length loop
    result := result || chars[1+random()*(array_length(chars, 1)-1)];
  end loop;
  return result;
end;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for save_user
-- ----------------------------
CREATE OR REPLACE FUNCTION "save_user"("p_login" text, "p_password" text, "p_name" text)
  RETURNS "pg_catalog"."int8" AS $BODY$DECLARE
    l_id int8 := null;
BEGIN

	  insert into users.t_user
          ( 
					  login,
						password,
					  name
					)
        values
          ( 
            p_login,
						p_password,
						p_name
					)
		returning id into l_id;

		RETURN l_id;

		EXCEPTION when unique_violation then BEGIN
			return null;
		end;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------

-- ----------------------------
-- Uniques structure for table t_sessions
-- ----------------------------
ALTER TABLE "t_sessions" ADD UNIQUE ("session");

-- ----------------------------
-- Primary Key structure for table t_sessions
-- ----------------------------
ALTER TABLE "t_sessions" ADD PRIMARY KEY ("session");

-- ----------------------------
-- Uniques structure for table t_user
-- ----------------------------
ALTER TABLE "t_user" ADD UNIQUE ("login");

-- ----------------------------
-- Primary Key structure for table t_user
-- ----------------------------
ALTER TABLE "t_user" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Key structure for table "t_sessions"
-- ----------------------------
ALTER TABLE "t_sessions" ADD FOREIGN KEY ("user_id") REFERENCES "t_user" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
