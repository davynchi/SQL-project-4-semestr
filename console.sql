CREATE TABLE "title" (
  "title" varchar NOT NULL UNIQUE,
  PRIMARY KEY ("title")
);

CREATE TABLE "merch" (
  "merch_id" serial,
  "name" varchar NOT NULL,
  "title_base" varchar NOT NULL,
  "edition" smallint CHECK (edition > 0),
  "merch_cnt" int CHECK (merch_cnt > 0),
  "release_dt" date,
  "cost" money CHECK (cost > 0::money),
  PRIMARY KEY ("merch_id"),
  CONSTRAINT "FK_merch.title_base"
    FOREIGN KEY ("title_base")
      REFERENCES "title"("title")
);

CREATE TABLE "buyer" (
  "buyer_id" serial UNIQUE,
  "discount_card_type" varchar CHECK (discount_card_type = 'common' OR
                                      discount_card_type = 'medium' OR
                                      discount_card_type = 'premium'),
  "phone_no" varchar NOT NULL,
  "currency_begin_dtm" timestamp NOT NULL,
  "currency_end_dtm" timestamp NOT NULL,
  PRIMARY KEY ("buyer_id", "currency_begin_dtm")
);

CREATE TABLE "store" (
  "store_id" serial,
  "name" varchar NOT NULL,
  "address" varchar NOT NULL UNIQUE,
  PRIMARY KEY ("store_id")
);

CREATE TABLE "bill" (
  "bill_id" serial,
  "buyer_id" serial NOT NULL,
  "store_id" serial NOT NULL,
  "bill_dtm" timestamp NOT NULL,
  PRIMARY KEY ("bill_id"),
  CONSTRAINT "FK_bill.buyer_id"
    FOREIGN KEY ("buyer_id")
      REFERENCES "buyer"("buyer_id"),
  CONSTRAINT "FK_bill.store_id"
    FOREIGN KEY ("store_id")
      REFERENCES "store"("store_id")
);

CREATE TABLE "bill_cons_basket_merch" (
  "bill_id" serial NOT NULL,
  "merch_bought_id" serial NOT NULL,
  "merch_bought_cnt" int CHECK(merch_bought_cnt > 0),
  PRIMARY KEY ("bill_id", "merch_bought_id"),
  CONSTRAINT "FK_bill_cons_basket_merch.bill_id"
    FOREIGN KEY ("bill_id")
      REFERENCES "bill"("bill_id")
);

CREATE TABLE "store_detailed_merch" (
  "store_id" serial NOT NULL,
  "merch_id" serial NOT NULL,
  "merch_cnt" int CHECK (merch_cnt >= 0),
  PRIMARY KEY ("store_id", "merch_id"),
  CONSTRAINT "FK_store_detailed_merch.store_id"
    FOREIGN KEY ("store_id")
      REFERENCES "store"("store_id"),
  CONSTRAINT "FK_store_detailed_merch.merch_id"
    FOREIGN KEY ("merch_id")
      REFERENCES "merch"("merch_id")
);

CREATE TABLE "bill_cons_basket_manga" (
  "bill_id" serial NOT NULL,
  "manga_bought_id" serial NOT NULL,
  "manga_bought_cnt" int CHECK(manga_bought_cnt > 0),
  PRIMARY KEY ("bill_id", "manga_bought_id"),
  CONSTRAINT "FK_bill_cons_basket_manga.bill_id"
    FOREIGN KEY ("bill_id")
      REFERENCES "bill"("bill_id")
);

CREATE TABLE "mangaka" (
  "mangaka_id" serial,
  "name" varchar NOT NULL UNIQUE,
  PRIMARY KEY ("mangaka_id")
);

CREATE TABLE "manga" (
  "manga_id" serial,
  "title" varchar NOT NULL,
  "volume" smallint CHECK (volume > 0),
  "edition" smallint CHECK (edition > 0),
  "drawing_cnt" int CHECK (drawing_cnt > 0),
  "coloured_flg" boolean NOT NULL,
  "mangaka_id" serial NOT NULL,
  "print_dt" date,
  "cost" money CHECK (cost > 0::money),
  PRIMARY KEY ("manga_id"),
  CONSTRAINT "FK_manga.mangaka_id"
    FOREIGN KEY ("mangaka_id")
      REFERENCES "mangaka"("mangaka_id"),
  CONSTRAINT "FK_manga.title"
    FOREIGN KEY ("title")
      REFERENCES "title"("title")
);

CREATE TABLE "store_detailed_manga" (
  "store_id" serial NOT NULL,
  "manga_id" serial NOT NULL,
  "manga_cnt" int CHECK (manga_cnt >= 0),
  PRIMARY KEY ("store_id", "manga_id"),
  CONSTRAINT "FK_store_detailed_manga.store_id"
    FOREIGN KEY ("store_id")
      REFERENCES "store"("store_id"),
  CONSTRAINT "FK_store_detailed_manga.manga_id"
    FOREIGN KEY ("manga_id")
      REFERENCES "manga"("manga_id")
);

CREATE TABLE "store_detailed_merch_history" (
  "store_id" serial NOT NULL,
  "merch_id" serial NOT NULL,
  "merch_cnt" int CHECK (merch_cnt >= 0),
  "change_dtm" timestamp NOT NULL,
  PRIMARY KEY ("store_id", "merch_id", "change_dtm"),
  CONSTRAINT "FK_store_detailed_merch_history.store_id"
    FOREIGN KEY ("store_id", "merch_id")
      REFERENCES "store_detailed_merch"("store_id", "merch_id")
);

CREATE TABLE "store_detailed_manga_history" (
  "store_id" serial NOT NULL,
  "manga_id" serial NOT NULL,
  "manga_cnt" int CHECK (manga_cnt >= 0),
  "change_dtm" timestamp NOT NULL,
  PRIMARY KEY ("store_id", "manga_id", "change_dtm"),
  CONSTRAINT "FK_store_detailed_manga_history.store_id"
    FOREIGN KEY ("store_id", "manga_id")
      REFERENCES "store_detailed_manga"("store_id", "manga_id")
);

BEGIN;
INSERT INTO store("name", address)
    VALUES ('Mandarake Complex', '3 Chome-11-12 Sotokanda, Chiyoda City, Tokyo 101-0021, Япония'),
           ('Comic ZIN Akihabara', 'Япония, 〒101-0021 Tokyo, Chiyoda City, Sotokanda, 1 Chome−11−7 高和秋葉原ビル'),
           ('Komiyama Book Store', 'Япония, 〒101-0051 Tokyo, Chiyoda City, Kanda Jinbocho, 1 Chome−７'),
           ('Blister', '4 Chome-3-10 Sotokanda, Chiyoda City, Tokyo 101-0021, Япония'),
           ('animate Kinshicho shop', 'Япония, 〒130-0013 Tokyo, Sumida City, Kinshi, 2 Chome−13−6 Sハルヤマビル 1F'),
           ('AmiAmi', 'Япония, 〒101-0021 Tokyo, Chiyoda City, 11, 千代田区 外神田１丁目１１−５スーパービル3F・4F'),
           ('JUMP SHOP', '1 Chome-9-1 Marunouchi, Chiyoda City, Tokyo 100-0005, Япония'),
           ('Shosen Book Tower', '1 Chome-11-1 Kanda Sakumacho, Chiyoda City, Tokyo 101-0025, Япония'),
           ('Kumazawa Book Store', 'Япония, 〒134-0091 Tokyo, Edogawa City, Funabori, 4 Chome−1−1 タワーホール船堀 1F'),
           ('Kobayashi Book Store', '1 Chome-18-17 Todaijima, Urayasu, Chiba 279-0001, Япония');
COMMIT;

BEGIN;
INSERT INTO title
    VALUES ('GTO: Great Teacher Onizuka'), ('Fairy Tail'),
           ('Attack on Titan'), ('Parasyte'),
           ('Mysterious Girlfriend X'), ('Rent-A-Girlfriend'),
           ('That Time I Got Reincarnated as a Slime'), ('Vinland Saga'),
           ('His Extra-Large, Ever-So-Lovely...'), ('The Ghost in the Shell');
COMMIT;

BEGIN;
INSERT INTO mangaka("name")
    VALUES ('Toru Fujisawa'), ('Hiro Mashima'),
           ('Hajime Isayama'), ('Hitoshi Iwaaki'),
           ('Riichi Ueshiba'), ('Reiji Miyajima'),
           ('Fuse and Taiki Kawakami'), ('Makoto Yukimura'),
           ('Omoimi'), ('Shirow Masamune');
COMMIT;

BEGIN;
INSERT INTO manga(title, volume, edition, drawing_cnt, coloured_flg, mangaka_id, print_dt, cost)
    VALUES
        ('GTO: Great Teacher Onizuka', 1, 10, 50000, true,
            (SELECT mangaka_id FROM mangaka WHERE "name" = 'Toru Fujisawa'), '2020-06-01', '8.9'),
        ('GTO: Great Teacher Onizuka', 1, 11, 30000, true,
            (SELECT mangaka_id FROM mangaka WHERE "name" = 'Toru Fujisawa'), '2021-06-01', '9'),
        ('GTO: Great Teacher Onizuka', 4, 8, 50000, true,
            (SELECT mangaka_id FROM mangaka WHERE "name" = 'Toru Fujisawa'), '2020-06-10', '9'),
        ('Attack on Titan', 9, 2, 100000, true,
            (SELECT mangaka_id FROM mangaka WHERE "name" = 'Hajime Isayama'), '2015-11-21', '12'),
        ('Attack on Titan', 19, 4, 60000, true,
            (SELECT mangaka_id FROM mangaka WHERE "name" = 'Hajime Isayama'), '2018-10-09', '13.5'),
        ('Attack on Titan', 27, 1, 100000, true,
            (SELECT mangaka_id FROM mangaka WHERE "name" = 'Hajime Isayama'), '2019-08-14', '15'),
        ('Attack on Titan', 30, 1, 100000, true,
            (SELECT mangaka_id FROM mangaka WHERE "name" = 'Hajime Isayama'), '2020-04-14', '16'),
        ('Mysterious Girlfriend X', 1, 14, 10000, true,
            (SELECT mangaka_id FROM mangaka WHERE "name" = 'Riichi Ueshiba'), '2013-01-18', '7'),
        ('His Extra-Large, Ever-So-Lovely...', 2, 2, 5000, false,
            (SELECT mangaka_id FROM mangaka WHERE "name" = 'Omoimi'), '2016-03-01', '7'),
        ('His Extra-Large, Ever-So-Lovely...', 2, 3, 5000, false,
            (SELECT mangaka_id FROM mangaka WHERE "name" = 'Omoimi'), '2017-03-01', '7');
COMMIT;

BEGIN;
INSERT INTO "merch" ("name", title_base, edition, merch_cnt, release_dt, cost)
    VALUES
        ('Furyu Super Sonico Fairy Tail Special figure Princess Of The Apple', 'Fairy Tail',
            4, 5000, '2015-01-30', '57'),
        ('Furyu Super Sonico Fairy Tail Special figure Princess Of The Apple', 'Fairy Tail',
            5, 5000, '2015-06-30', '57'),
        ('Furyu Super Sonico Fairy Tail Special figure Princess Of The Apple', 'Fairy Tail',
            6, 5000, '2015-11-30', '57'),
        ('FAIRY TAIL figure Lucy Heartfilia Aquarius Form Ver. POP UP PARADE JAPAN', 'Fairy Tail',
            2, 5000, '2013-06-26', '60.68'),
        ('FAIRY TAIL figure Lucy Heartfilia Aquarius Form Ver. POP UP PARADE JAPAN', 'Fairy Tail',
            3, 5000, '2013-12-26', '60.68'),
        ('NEW Funko Pop! Attack On Titan #22 Eren Titan Vinyl Action Figure Toys WITH BOX', 'Attack on Titan',
            1, 10000, '2014-09-02', '27.99'),
        ('NEW Funko Pop! Attack On Titan #22 Eren Titan Vinyl Action Figure Toys WITH BOX', 'Attack on Titan',
            4, 5000, '2014-10-02', '29.99'),
        ('Anime Attack on titan Shingeki no Kyojin Cosplay Mikasa Ackerman Scarf Dark Red', 'Attack on Titan',
            5, 1000, '2017-03-11', '9.99'),
        ('That Time I Got Reincarnated as a Slime BENIMARU 2-04 R Japanese Card Anime', 'That Time I Got Reincarnated as a Slime',
            1, 20000, '2018-05-04', '4.99'),
        ('Poster Anime That Time I Got Reincarnated as a Slime shion Wall Scroll 60*90cm', 'That Time I Got Reincarnated as a Slime',
            1, 3000, '2020-09-01', '23.99');
COMMIT;

BEGIN;
INSERT INTO buyer(discount_card_type, phone_no, currency_begin_dtm, currency_end_dtm)
    VALUES
        ('common', '+81–3–1234567', '2021-11-11 11:11:11','9999-12-31 23:59:59'),
        ('common', '+81–3–1234568', '2021-11-12 11:11:11','9999-12-31 23:59:59'),
        ('common', '+81–3–1234569', '2021-11-13 11:11:11','9999-12-31 23:59:59'),
        ('common', '+81–3–7654321', '2020-11-11 11:11:11','9999-12-31 23:59:59'),
        ('common', '+81–3–5555555', '2019-11-11 11:11:11','9999-12-31 23:59:59'),
        ('common', '+81–3–4444444', '2017-12-31 19:11:11','9999-12-31 23:59:59'),
        ('medium', '+81–3–2234567', '2021-11-19 11:41:11','9999-12-31 23:59:59'),
        ('medium', '+81–3–5553535', '2018-12-21 09:11:33','9999-12-31 23:59:59'),
        ('medium', '+81–9–1234567', '2022-02-24 10:10:10','9999-12-31 23:59:59'),
        ('premium', '+81–19–1234567', '2016-11-11 11:11:00','9999-12-31 23:59:59');
COMMIT;

BEGIN;
INSERT INTO bill(buyer_id, store_id, bill_dtm)
    VALUES
        ((SELECT buyer_id FROM buyer WHERE phone_no = '+81–3–7654321'),
     (SELECT store_id FROM store WHERE "name" = 'Mandarake Complex'),
     '2020-11-11 11:14:34'),
        ((SELECT buyer_id FROM buyer WHERE phone_no = '+81–3–7654321'),
     (SELECT store_id FROM store WHERE "name" = 'Mandarake Complex'),
     '2020-11-21 15:22:30'),
        ((SELECT buyer_id FROM buyer WHERE phone_no = '+81–3–7654321'),
     (SELECT store_id FROM store WHERE "name" = 'JUMP SHOP'),
     '2020-11-18 17:44:22'),
        ((SELECT buyer_id FROM buyer WHERE phone_no = '+81–3–7654321'),
     (SELECT store_id FROM store WHERE "name" = 'AmiAmi'),
     '2021-02-28 09:33:33'),
        ((SELECT buyer_id FROM buyer WHERE phone_no = '+81–3–4444444'),
     (SELECT store_id FROM store WHERE "name" = 'Mandarake Complex'),
     '2017-12-31 18:00:02'),
        ((SELECT buyer_id FROM buyer WHERE phone_no = '+81–3–4444444'),
     (SELECT store_id FROM store WHERE "name" = 'Mandarake Complex'),
     '2018-01-06 10:14:34'),
        ((SELECT buyer_id FROM buyer WHERE phone_no = '+81–3–4444444'),
     (SELECT store_id FROM store WHERE "name" = 'Komiyama Book Store'),
     '2020-11-11 11:14:34'),
        ((SELECT buyer_id FROM buyer WHERE phone_no = '+81–9–1234567'),
     (SELECT store_id FROM store WHERE "name" = 'Shosen Book Tower'),
     '2022-02-25 11:14:34'),
        ((SELECT buyer_id FROM buyer WHERE phone_no = '+81–9–1234567'),
     (SELECT store_id FROM store WHERE "name" = 'Mandarake Complex'),
     '2020-02-25 12:14:34'),
        ((SELECT buyer_id FROM buyer WHERE phone_no = '+81–19–1234567'),
     (SELECT store_id FROM store WHERE "name" = 'Mandarake Complex'),
     '2018-02-13 14:14:14');
COMMIT;

BEGIN;
INSERT INTO bill_cons_basket_manga
    VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3), (6, 10, 2), (6, 9, 2),
           (7, 3, 1), (8, 5, 1), (8, 6, 1), (8, 7, 1), (10, 8, 25);
COMMIT;

BEGIN;
INSERT INTO bill_cons_basket_merch
    VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 7, 1), (5, 5, 1),
           (5, 2, 1), (6, 4, 3), (9, 10, 2), (9, 9, 2), (10, 8, 25);
COMMIT;

BEGIN;
INSERT INTO store_detailed_manga
    VALUES (1, 1, 30), (1, 2, 30), (7, 3, 25), (1, 10, 40), (1, 9, 30),
           (3, 3, 25), (8, 5, 20), (8, 6, 40), (8, 7, 15), (1, 8, 50);
COMMIT;

BEGIN;
INSERT INTO store_detailed_merch
    VALUES (1, 1, 30), (1, 2, 30), (7, 3, 25), (6, 7, 15), (1, 5, 50),
           (10, 10, 10), (1, 4, 15), (1, 10, 50), (1, 9, 35), (1, 8, 100);
COMMIT;

BEGIN;
INSERT INTO store_detailed_manga_history
    VALUES (1, 1, 31, '2020-11-11 11:14:34'), (1, 2, 32, '2020-11-21 15:22:30'),
           (7, 3, 28, '2020-11-18 17:44:22'), (1, 10, 42, '2018-01-06 10:14:34'),
           (1, 9, 32, '2018-01-06 10:14:34'), (3, 3, 26, '2020-11-11 11:14:34'),
           (8, 5, 21, '2022-02-25 11:14:34'), (8, 6, 41, '2022-02-25 11:14:34'),
           (8, 7, 16, '2022-02-25 11:14:34'), (1, 8, 75, '2018-02-13 14:14:14');
COMMIT;

BEGIN;
INSERT INTO store_detailed_merch_history
    VALUES (1, 1, 31, '2020-11-11 11:14:34'), (1, 2, 32, '2020-11-21 15:22:30'),
           (7, 3, 28, '2020-11-18 17:44:22'), (6, 7, 16, '2021-02-28 09:33:33'),
           (1, 5, 51, '2017-12-31 18:00:02'), (1, 2, 33, '2017-12-31 18:00:02'),
           (1, 4, 18, '2018-01-06 10:14:34'), (1, 10, 52,'2020-02-25 12:14:34'),
           (1, 9, 37, '2020-02-25 12:14:34'), (1, 8, 125, '2018-02-13 14:14:14');
COMMIT;

SELECT store_id, count(buyer_id) FROM bill
GROUP BY store_id
HAVING count(buyer_id) > 1;
/*Запрос находит для тех магазинов, в которых было совершено хотя бы 2 покупки, суммарное количество покупок
  и выодит id магазина и количество покупок в нем.
 */

SELECT title_base, cost, release_dt,
       avg(CAST(cost AS numeric)) OVER (PARTITION BY title_base ORDER BY release_dt) FROM merch;
/* Для каждой манги-основы и для каждого мерча показывает, чему равна была средняя стоимость
   по этой манге-основе на момент выхода мерча
   */

SELECT ROW_NUMBER() OVER (ORDER BY currency_begin_dtm), * FROM buyer
WHERE discount_card_type = 'common';
/* Выбираю и нумерую по дате начала действия карты всех покупателей из buyer, где обычный тип карты*/

SELECT title, drawing_cnt, cost FROM manga
ORDER BY drawing_cnt desc;
/* вывожу тайтлы манги и их тираж из таблицы manga в порядке убывания (то есть стараюсь оценить популярность манги)*/

SELECT store_id, merch_id, change_dtm,
       LAG(change_dtm, 1, change_dtm) OVER (ORDER BY change_dtm) AS prev_change_dtm,
       change_dtm - LAG(change_dtm, 1, change_dtm) OVER (ORDER BY change_dtm) AS data_interval
    FROM store_detailed_merch_history;
/*Для истории покупки мерча (то есть в таблице store_detailed_merch_history) сортирую колонки по дате изменения
  и вывожу предыдущую дату покупки и время, которое прошло с момента последней покупки.
 */

SELECT name, address FROM store
WHERE store_id IN (SELECT DISTINCT store_id FROM
                    manga m JOIN store_detailed_manga s ON m.manga_id = s.manga_id
                    WHERE coloured_flg = true);
/* Вывожу названия и адреса всех магазинов, где продается цветная манга.*/

BEGIN;
CREATE VIEW mangaka_and_title
AS SELECT "name", title
   FROM manga, mangaka
WHERE manga.mangaka_id = mangaka.mangaka_id;
COMMIT;
/* Для кажддого мангаки выводит его мангу*/
