From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: raid5 slow (test on another system)
Date: Wed, 1 Dec 2004 23:21:21 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412012319250.29724@adsl.a2000.nu>
References: <200411290449.iAT4nsN02715@www.watkins-home.com>
 <Pine.LNX.4.61.0411290928430.13437@adsl.a2000.nu>
 <Pine.LNX.4.61.0411290948230.13437@adsl.a2000.nu> <16811.48945.141392.294625@cse.unsw.edu.au>
 <Pine.LNX.4.61.0411300146360.32052@adsl.a2000.nu>
 <Pine.LNX.4.61.0411302034160.24563@adsl.a2000.nu> <16813.418.770001.453039@cse.unsw.edu.au>
 <Pine.LNX.4.61.0412010050500.31657@adsl.a2000.nu>
 <Pine.LNX.4.61.0412012021350.12257@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0412012021350.12257@adsl.a2000.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

and another system
P4 2.4Ghz with 8*120gb on 3ware 7805

pci32 so the 2.4 looks like limited by the pci bus :

(2.6.8 8d r5 ext3)

Version 1.93c       ------Sequential Output------ --Sequential Input- 
--Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
storage          1G   507  98 64149  20 33240  11   984  97 95124  18 
663.0   2
Latency               105ms    1039ms     879ms   29443us   63097us 
870ms
Version 1.93c       ------Sequential Create------ --------Random 
Create--------
storage             -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16  1849  64 +++++ +++ 10044   9  1570  54 +++++ +++ 
4406  49
Latency             64064us     184us     188us     133ms     102us 
293us
1.93c,1.93c,storage,1,1101940252,1G,,507,98,64149,20,33240,11,984,97,95124,18,663.0,2,16,,,,,1849,64,+++++,+++,10044,9,1570,54,+++++,+++,4406,49,105ms,1039ms,879ms,29443us,63097us,870ms,64064us,184us,188us,133ms,102us,293us

(2.4.28 8d r5 ext3)

Version 1.93c       ------Sequential Output------ --Sequential Input- 
--Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
storage          1G    98  99 64449  44 42805  21   742  98 113930  29 
732.5   4
Latency               129ms     809ms     819ms   23221us     139ms 
754ms
Version 1.93c       ------Sequential Create------ --------Random 
Create--------
storage             -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16  1526  61 +++++ +++  8337  20  1940  78 +++++ +++ 
2441  36
Latency               175ms      39us      83us   78763us      20us 
77558us
1.93c,1.93c,storage,1,1101940608,1G,,98,99,64449,44,42805,21,742,98,113930,29,732.5,4,16,,,,,1526,61,+++++,+++,8337,20,1940,78,+++++,+++,2441,36,129ms,809ms,819ms,23221us,139ms,754ms,175ms,39us,83us,78763us,20us,77558us


