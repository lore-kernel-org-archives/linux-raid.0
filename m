From: Tom Peters <tpeters@mixcom.com>
Subject: Compaq SmartArray seems slow
Date: Sun, 05 Feb 2006 23:47:51 -0600
Message-ID: <5.1.0.14.2.20060205234730.0c2c3590@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My Compaq SmartArray 3200 under SuSE 9.2 seems pretty slow. Is there so=
me=20
voodoo in the BIOS of a Compaq machine that makes it work properly? I d=
on't=20
have a Compaq machine, just the SmartArray card cabled externally to a=20
Proliant with everything disabled and unplugged except the power supply=
,=20
case fans, and Compaq array cages.

The test results didn't change materially when I added another controll=
er=20
(the promise Ultra 100 ATA).

The docs say you can use both external connections if you don't use the=
=20
inside ones, so I did that. I have a 5-drive hotswap cage cabled to one=
=20
external connector, and a 3-drive hotswap cage cabled to the other.

The third group is the Compaq array controller.

Benchmark test results, Bonnie++

bonnie++ -m Tolkien -d /max40/test  # Maxtor 40gb drive on Promise Ultr=
a=20
100 ATA controller
Version 1.01d       ------Sequential Output------ --Sequential Input- -=
-Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--=20
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  =
/sec %CP
Tolkien       1256M 17878  85 35175  57 16413  36 19369  86 40031  51 1=
80.2   1
                     ------Sequential Create------ --------Random=20
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read---=20
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec=20
%CP  /sec %CP
                  16   254  88 +++++ +++ 24774  90   268  88 +++++=20
+++  1672  88
Tolkien,1256M,17878,85,35175,57,16413,36,19369,86,40031,51,180.2,1,16,2=
54,88,+++++,+++,24774,90,268,88,+++++,+++,1672,88

bonnie++ -m Tolkien -d /test  # Built in IDE controller
Version 1.01d       ------Sequential Output------ --Sequential Input- -=
-Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--=20
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  =
/sec %CP
Tolkien       1256M 12668  75 14649  29  5970  13  8376  38  8771  12 1=
62.0   1
                     ------Sequential Create------ --------Random=20
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read---=20
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec=20
%CP  /sec %CP
                  16  3644  90 +++++ +++  3210  76  3745  91 +++++=20
+++  3427  91
Tolkien,1256M,12668,75,14649,29,5970,13,8376,38,8771,12,162.0,1,16,3644=
,90,+++++,+++,3210,76,3745,91,+++++,+++,3427,91

bonnie++ -m Tolkien -d /movies/test  #  Compaq 3200 / Smart-2/P Raid=20
controller, 8 x 18gb SCSI ultra-3 drives
Version 1.01d       ------Sequential Output------ --Sequential Input- -=
-Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--=20
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  =
/sec %CP
Tolkien       1256M  2454  14  2524   4  1439   3  9611  44 17958  25 2=
89.5   3
                     ------Sequential Create------ --------Random=20
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read---=20
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec=20
%CP  /sec %CP
                  16  3872  86 +++++ +++  3462  84  3804  88 +++++=20
+++  3061  85
Tolkien,1256M,2454,14,2524,4,1439,3,9611,44,17958,25,289.5,3,16,3872,86=
,+++++,+++,3462,84,3804,88,+++++,+++,3061,85








[Internet] .sigs are the bumper stickers of the information
superhighway.
--... ...--  -.. .  -. ----. --.- --.- -...
tpeters@nospam.mixcom.com   (remove "nospam") N9QQB (amateur radio)
"HEY YOU" (loud shouting)  WEB ADDRESS http//www.mixweb.com/tpeters
43=B0 7' 17.2" N by 88=B0 6' 28.9" W,  Elevation 815',  Grid Square EN5=
3wc
WAN/LAN/Telcom Analyst, Tech Writer, MCP, CCNA, Registered Linux User 3=
85531



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
