From: Stephan van Hienen <raid@a2000.nu>
Subject: RE: raid5 slow (looks like 2.6 problem)
Date: Tue, 30 Nov 2004 01:06:40 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411300034340.32052@adsl.a2000.nu>
References: <200411291713.iATHDtN05760@www.watkins-home.com>
 <Pine.LNX.4.61.0411291901510.32052@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0411291901510.32052@adsl.a2000.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

just rebooted my system with an old 2.4.20 kernel (got from backup)

(2.4.20 13d r5 ext3)

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
storage.a2000.nu 2G 21931  99 96429  99 79370  73 28970  99 280316  84 
675.7   3
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16  1444  71 +++++ +++ +++++ +++  2024  99 +++++ +++ 
5563  98
storage.a2000.nu,2G,21931,99,96429,99,79370,73,28970,99,280316,84,675.7,3,16,1444,71,+++++,+++,+++++,+++,2024,99,+++++,+++,5563,98


again rebooted to 2.6.9-ac11 :
(previous score was from xfs, so retested with ext3)
(2.6.9-ac11 13d r5 ext3)

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
storage.a2000.nu 2G 21711  99 99906  95 67559  79 24099  92 138763  72 
606.4   3
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16  1470  79 +++++ +++ +++++ +++  1447  78 +++++ +++ 
4546  96
storage.a2000.nu,2G,21711,99,99906,95,67559,79,24099,92,138763,72,606.4,3,16,1470,79,+++++,+++,+++++,+++,1447,78,+++++,+++,4546,96

looks like something is wrong with the 2.6 code ?
i'm now compiling normal 2.6.9 (and maybe 2.6.8 after this?) to check for 
results

any ideas ?
