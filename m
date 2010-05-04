From: Andrew Dunn <andrew.g.dunn.dod@gmail.com>
Subject: Compatible Hardware Controllers (Smartctl, 8 port, SFF-8087)
Date: Tue, 4 May 2010 14:45:29 -0400
Message-ID: <g2mbfcaab951005041145y88e4b350le3e6e2a691160231@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am running two decent sized mdadm arrays:

####################################################

storrgie@MINERVA:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md2 : active raid6 sdi1[4] sdl1[7] sdf1[1] sdk1[6] sdj1[5] sdh1[3]
sdg1[2] sde1[0]
      11721071616 blocks level 6, 512k chunk, algorithm 2 [8/8] [UUUUUUUU]
      [===>.................]  check = 18.8% (368163248/1953511936)
finish=504.2min speed=52401K/sec

md0 : active raid6 sdn1[4] sdt1[6] sdm1[3] sdr1[7] sdq1[0] sds1[2]
sdo1[1] sdd1[5]
      5860558848 blocks level 6, 512k chunk, algorithm 2 [8/8] [UUUUUUUU]
      [==============>......]  check = 71.2% (696254448/976759808)
finish=87.8min speed=53242K/sec

md1 : active raid0 sdc1[1] sdb1[0]
      586067072 blocks 64k chunks

unused devices: <none>

####################################################

These two arrays are on this controller:

http://www.supermicro.com/products/accessories/addon/AOC-USAS-L8i.cfm
http://blog.agdunn.net/?p=391

The problem with this controller is that if you try to use smartctl or
smartd to monitor your drives, the controller will become unresponsive
and offline an arbitrary amount of drives. This causes a huge problem
in raid because then the drives get marked as failed and I have to
force add them back into the array.

My solution is basically to move from raid5 to raid6 so that I can
afford a single drive failure, because I am not preempting a drive
malfunction.

I would very much like to know if any of you are running budget
($100-300) controller cards that work well with both mdadm and
smartctl. I would very much like the card to support SFF-8087
connectors but they don't have to.

Thank you all in advance.
