From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: raid5 slow (test on another system)
Date: Thu, 2 Dec 2004 23:01:25 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412022258270.27676@adsl.a2000.nu>
References: <200411290449.iAT4nsN02715@www.watkins-home.com>
 <Pine.LNX.4.61.0411290928430.13437@adsl.a2000.nu>
 <Pine.LNX.4.61.0411290948230.13437@adsl.a2000.nu> <16811.48945.141392.294625@cse.unsw.edu.au>
 <Pine.LNX.4.61.0411300146360.32052@adsl.a2000.nu>
 <Pine.LNX.4.61.0411302034160.24563@adsl.a2000.nu> <16813.418.770001.453039@cse.unsw.edu.au>
 <Pine.LNX.4.61.0412010050500.31657@adsl.a2000.nu>
 <Pine.LNX.4.61.0412012021350.12257@adsl.a2000.nu>
 <Pine.LNX.4.61.0412012319250.29724@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0412012319250.29724@adsl.a2000.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

and another system
p4 2.8Ghz with 2*300gb (normal ide ports)

i created a degraded raid5

25% difference in read performance :

2.4.20 :

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
gx270.a2000.nu   1G 29724  79 41447  15 17575   6 33146  80 55494  12 
267.6   0
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16  2539  98 +++++ +++ +++++ +++  2523  98 +++++ +++ 
6307  96
gx270.a2000.nu,1G,29724,79,41447,15,17575,6,33146,80,55494,12,267.6,0,16,2539,98
,+++++,+++,+++++,+++,2523,98,+++++,+++,6307,96

2.6.9-ac11 :

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
gx270.a2000.nu   1G 21190  52 37804   8 10092   2 34726  80 68587   9 
263.1   0
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16  3305  99 +++++ +++ +++++ +++  3372 100 +++++ +++ 
10428  98
gx270.a2000.nu,1G,21190,52,37804,8,10092,2,34726,80,68587,9,263.1,0,16,3305,99,+
++++,+++,+++++,+++,3372,100,+++++,+++,10428,98
