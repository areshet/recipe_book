/*
Navicat PGSQL Data Transfer

Source Server         : store
Source Server Version : 90604
Source Host           : localhost:5432
Source Database       : cooking
Source Schema         : recipe

Target Server Type    : PGSQL
Target Server Version : 90500
File Encoding         : 65001

Date: 2018-08-21 20:12:02
*/


-- ----------------------------
-- Sequence structure for seq_recipe
-- ----------------------------
DROP SEQUENCE IF EXISTS "seq_recipe";
CREATE SEQUENCE "seq_recipe"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 15
 CACHE 1;
SELECT setval('"recipe"."seq_recipe"', 15, true);

-- ----------------------------
-- Table structure for t_categories
-- ----------------------------
DROP TABLE IF EXISTS "t_categories";
CREATE TABLE "t_categories" (
"id" int4 NOT NULL,
"title" text COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of t_categories
-- ----------------------------
BEGIN;
INSERT INTO "t_categories" VALUES ('1', 'Суп');
INSERT INTO "t_categories" VALUES ('2', 'Салат');
INSERT INTO "t_categories" VALUES ('3', 'Пицца');
INSERT INTO "t_categories" VALUES ('4', 'Паста');
INSERT INTO "t_categories" VALUES ('5', 'Другое');
COMMIT;

-- ----------------------------
-- Table structure for t_recipe
-- ----------------------------
DROP TABLE IF EXISTS "t_recipe";
CREATE TABLE "t_recipe" (
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
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for t_votes
-- ----------------------------
DROP TABLE IF EXISTS "t_votes";
CREATE TABLE "t_votes" (
"user_id" int8 NOT NULL,
"recipe_id" int8 NOT NULL
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Records of t_votes
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Function structure for get_all_by_oldest
-- ----------------------------
CREATE OR REPLACE FUNCTION "get_all_by_oldest"("p_session" text)
  RETURNS "pg_catalog"."refcursor" AS $BODY$ 
	DECLARE
		res refcursor;
	  l_user_id int8 := null;
BEGIN
	select "user_id" from "users".t_sessions where "session" = p_session into l_user_id;

	OPEN res FOR 
		select a.*,  (
			SELECT "id" in (select "recipe_id" from "recipe".t_votes where "user_id" = l_user_id) as "disabled"
		) from (SELECT t.*, c.title as category_title FROM "recipe".t_recipe t, "recipe".t_categories c
							where t."user_id" = l_user_id
								and t."category" = c.id
							ORDER BY t."id" DESC
		) a;

  RETURN res;
END; $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for get_all_by_rating
-- ----------------------------
CREATE OR REPLACE FUNCTION "get_all_by_rating"("p_session" text)
  RETURNS "pg_catalog"."refcursor" AS $BODY$ 
	DECLARE
		res refcursor;
	  l_user_id int8 := null;
BEGIN
	select "user_id" from "users".t_sessions where "session" = p_session into l_user_id;

	OPEN res FOR 
		select a.*, (
			SELECT "id" in (select "recipe_id" from "recipe".t_votes where "user_id" = l_user_id) as "disabled"
		) from (
			SELECT t.*, c.title as category_title FROM "recipe".t_recipe t, "recipe".t_categories c 
					where t.user_id = user_id
						and t."category" = c.id
						ORDER BY t."rating" DESC
		) a;

  RETURN res;
END; $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for get_by_category
-- ----------------------------
CREATE OR REPLACE FUNCTION "get_by_category"("p_category_id" int4, "p_session" text)
  RETURNS "pg_catalog"."refcursor" AS $BODY$ 
	DECLARE
		res refcursor;
		l_user_id int8 := null;
BEGIN
	select "user_id" from "users".t_sessions where "session" = p_session into l_user_id;

	OPEN res FOR 
		select a.*, (
			SELECT "id" in (select "recipe_id" from "recipe".t_votes where "user_id" = l_user_id) as "disabled"
		) from (
			SELECT t.*, c.title as category_title FROM "recipe".t_recipe t, "recipe".t_categories c 
					where t.user_id = user_id
						and t."category" = c.id
						and t."category" = p_category_id
						ORDER BY t."rating" DESC
		) a;

  RETURN res;
END; $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for get_my_recipe
-- ----------------------------
CREATE OR REPLACE FUNCTION "get_my_recipe"("p_session" text)
  RETURNS "pg_catalog"."refcursor" AS $BODY$ 
	DECLARE
		res refcursor;
BEGIN
	open res for 
		select a.*, c.title as category_title from "recipe".t_recipe a,
		 "users".t_user t, "users".t_sessions s,
		 "recipe".t_categories c
			where s.session = p_session
				and s.user_id = t.id
				and t.id = a.user_id
				and c.id = a.category;

  RETURN res;

END; $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for get_recipes
-- ----------------------------
CREATE OR REPLACE FUNCTION "get_recipes"("p_session" text, "p_page" int4)
  RETURNS "pg_catalog"."refcursor" AS $BODY$ DECLARE	
	res refcursor;
	l_user_id int8 := null;
BEGIN
	select "user_id" from "users".t_sessions where "session" = p_session into l_user_id;

	OPEN res FOR 
		select a.*, (
			SELECT "id" in (select "recipe_id" from "recipe".t_votes where "user_id" = l_user_id) as "disabled"
		) from (SELECT * FROM "recipe".t_recipe t 
					where t.user_id = user_id
						ORDER BY t."rating" ASC
						limit 9 offset 9 * (p_page - 1)
		) a;
		
RETURN res;

END; $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for remove
-- ----------------------------
CREATE OR REPLACE FUNCTION "remove"("p_id" int8, "p_session" text)
  RETURNS "pg_catalog"."void" AS $BODY$ 
DECLARE
	l_user_id int8 := null;
BEGIN
	select "user_id" from "users".t_sessions where "session" = p_session into l_user_id;
	
	delete from "recipe".t_votes t where t.recipe_id = p_id;
	delete from "recipe".t_recipe t where t."id" = p_id and t."user_id" = l_user_id;
END; $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for save_recipe
-- ----------------------------
CREATE OR REPLACE FUNCTION "save_recipe"("p_id" int8, "p_session" text, "p_title" text, "p_desc" text, "p_alg" text, "p_image" text, "p_ingredients" _text)
  RETURNS "pg_catalog"."int8" AS $BODY$DECLARE
    l_id int8 := p_id;
		l_user_id int8 := null;
		l_count int4 := 0;
BEGIN
		select "user_id" from "users".t_sessions where "session" = p_session into l_user_id;
	
		if l_user_id is null then
			return null;
		end if;

		select "count"(*) from "recipe".t_recipe where "id" = p_id and "user_id" = l_user_id into l_count;

		if l_count = 0 then
			return null;
		end if;

    if l_id is null then
	    insert into recipe.t_recipe
          ( 
					  user_id,
						title,
						description,
						algorithm,
						image,
					  ingredients
					)
        values
          ( 
            l_user_id,
						p_title,
						p_desc,
						p_alg,
						p_image,
						p_ingredients
					)
         returning id
              into l_id;
    else
	    update recipe.t_recipe
           set id      = p_id,
               user_id = l_user_id,
							 title   = p_title,
						   description = p_desc,
							 algorithm = p_alg,
						   image   = p_image,
							 ingredients = p_ingredients
         where id = l_id;
    end if;

    return l_id;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for search
-- ----------------------------
CREATE OR REPLACE FUNCTION "search"("p_session" text, "p_words" _text)
  RETURNS "pg_catalog"."refcursor" AS $BODY$ 
	DECLARE
		res refcursor;
	  l_user_id int8 := null;
BEGIN
	select "user_id" from "users".t_sessions where "session" = p_session into l_user_id;
	
	open res FOR	
		select a.*, (
			SELECT "id" in (select "recipe_id" from "recipe".t_votes where "user_id" = l_user_id) as "disabled"
		) from (
			SELECT t.*, c.title as category_title, u.name FROM 
				 "recipe".t_recipe t,
				 "recipe".t_categories c,
				 "users".t_user u
					where t.user_id = user_id
						and t."category" = c.id
						and t.user_id = u.id
						and (
							u.name  ilike any (p_words)
							or t.title ilike any (p_words)
							or c.title ilike any (p_words)
							or array_to_string(t.ingredients, ', ') ilike any (p_words)
						)
						ORDER BY t."rating" DESC
		) a;
  
	RETURN res;
END; $BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Function structure for vote
-- ----------------------------
CREATE OR REPLACE FUNCTION "vote"("p_recipe_id" int8, "p_session" text, "p_count" int4)
  RETURNS "pg_catalog"."void" AS $BODY$DECLARE
	l_user_id int8 := null;
	l_counts int4 := 0;
BEGIN
	select "user_id" from "users".t_sessions where "session" = p_session into l_user_id;
	
	select "count"(*) from "recipe".t_votes t where t.user_id = l_user_id and t.recipe_id = p_recipe_id into l_counts;

	if l_counts > 0 THEN
		return;
	end if;
	

	insert into "recipe".t_votes (user_id, recipe_id)
	VALUES (l_user_id, p_recipe_id);

  update "recipe".t_recipe set
			rating = rating + p_count
	where id = p_recipe_id;
END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table t_categories
-- ----------------------------
ALTER TABLE "t_categories" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_recipe
-- ----------------------------
ALTER TABLE "t_recipe" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Key structure for table "t_recipe"
-- ----------------------------
ALTER TABLE "t_recipe" ADD FOREIGN KEY ("user_id") REFERENCES "users"."t_user" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "t_recipe" ADD FOREIGN KEY ("category") REFERENCES "t_categories" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Key structure for table "t_votes"
-- ----------------------------
ALTER TABLE "t_votes" ADD FOREIGN KEY ("recipe_id") REFERENCES "t_recipe" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "t_votes" ADD FOREIGN KEY ("user_id") REFERENCES "users"."t_user" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
