From: "Eric S. Johansson" <esj@harvee.org>
Subject: trouble with mega-raid 150 and considering other alternatives
Date: Wed, 09 Jan 2008 15:04:45 -0500
Message-ID: <478528DD.7080802@harvee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(originally posted through gmane but after few hours I haven't seen it come 
through hence the potential repost)

Ububtu 6.06
LSI Megaraid 150-4

what I am looking for is a bit of education about how to diagnose raid five 
performance problems and whether or not I'm barking up the wrong tree with the 
megaraid 150 card I'm using.

as you can see by the bonnie runs, I have a significant difference in 
performance between a raid five array and a standalone  disc.  I expect some 
performance difference but, this is a bit much.  I've tried to look at options 
for configuring the array but unfortunately, LSI doesn't make it easy.

I'm considering saying "to hell with hardware raid" and heading back to software 
raid.  at the same time, I would like to try and understand what's
causing the failure because it appears that I'm having a similar failure with
another raid system.  The performance problem was detected because I was running
virtual machines on the server and every time the application ran, on the host,
wait state would climb significantly, sometimes as high as the mid-90s.  Load
average would climb around 5-6.  On the other machine  which is causing me fits
(promise raid array on the other end of the SCSI bus from an Adaptec 160 SCSI
controller, has wait state frequently in the mid-80s to mid 90s and load
averages around 15 to 20.  I figure if I learn enough to solve the problem on my
system, I can solve it on the other.

thanks

---eric


root@vesta:/var/backup# bonnie -d /var/backup/bonnie -u esj
Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
vesta         2528M  6945  24  7739   2  3771   1  6633  23  9427   2 118.7   1
                     ------Sequential Create------ --------Random Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                  16   526   9 +++++ +++   546   5   515   6 +++++ +++   573   5
vesta,2528M,6945,24,7739,2,3771,1,6633,23,9427,2,118.7,1,16,526,9,+++++,+++,546,5,515,6,+++++,+++,573,5

on single disk:
root@vesta:/var/backup# bonnie -d /tmp -u esj
Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
vesta         2528M 16524  65 53783  24 20995   8 19121  67 54373  13 128.8   1
                     ------Sequential Create------ --------Random Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                  16  1112  76 +++++ +++ +++++ +++  1296  86 +++++ +++  2666  83
vesta,2528M,16524,65,53783,24,20995,8,19121,67,54373,13,128.8,1,16,1112,76,+++++,+++,+++++,+++,1296,86,+++++,+++,2666,83 


