From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: raid5 slow (test on another system)
Date: Wed, 1 Dec 2004 20:23:21 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412012021350.12257@adsl.a2000.nu>
References: <200411290449.iAT4nsN02715@www.watkins-home.com>
 <Pine.LNX.4.61.0411290928430.13437@adsl.a2000.nu>
 <Pine.LNX.4.61.0411290948230.13437@adsl.a2000.nu> <16811.48945.141392.294625@cse.unsw.edu.au>
 <Pine.LNX.4.61.0411300146360.32052@adsl.a2000.nu>
 <Pine.LNX.4.61.0411302034160.24563@adsl.a2000.nu> <16813.418.770001.453039@cse.unsw.edu.au>
 <Pine.LNX.4.61.0412010050500.31657@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0412010050500.31657@adsl.a2000.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

today runned a test on another machine
(dual p3-733 with 4*9gb scsi)

looks like on this system the difference is arround the 10%
maybe you need more disks/faster disks to get a bigger difference

results :

2.6.10-rc2 4d r5 ext3

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
linuxtest.expl 496M 10364  99 39689  55 22184  36 11485  96 52559  46 
632.0   4
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16   512  99 +++++ +++ 32502  99   528  99 +++++ +++ 
1938  97
linuxtest.explainerdc.local,496M,10364,99,39689,55,22184,36,11485,96,52559,46,632.0,4,16,512,99,+++++,+++,32502,99,528,99,+++++,+++,1938,97

2.4.20 4d r5 ext3

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
linuxtest.expl 496M 10087 100 53021  63 20934  34 11746  98 58858  34 
665.3   4
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16   573  99 +++++ +++ 30886  99   592  99 +++++ +++ 
2264  96
linuxtest.explainerdc.local,496M,10087,100,53021,63,20934,34,11746,98,58858,34,665.3,4,16,573,99,+++++,+++,30886,99,592,99,+++++,+++,2264,96


