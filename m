From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: RAID down, dont know why!
Date: Sun, 08 Nov 2009 09:00:29 -0500
Message-ID: <4AF6CEFD.60309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I just copied 4+ TiB of information to this array, restarted 5 times and tried to access it.... What is going on?

What kind of logs do you need, I really need help!


This is an automatically generated mail message from mdadm
running on ALEXANDRIA

A Fail event had been detected on md device /dev/md0.

It could be related to component device /dev/sdl1.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid6 sdl1[9](F) sdm1[8] sdi1[10](F) sdj1[11](F) sdk1[12](F) sdh1[3] sdf1[1] sdg1[2] sde1[0]
      6837318656 blocks level 6, 1024k chunk, algorithm 2 [9/5] [UUUU____U]
      
md1 : active raid0 sdc1[1] sdb1[0]
      586067072 blocks 64k chunks
      
unused devices: <none>


-- 
Andrew Dunn
http://agdunn.net

