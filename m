From: "Edward Siefker" <hatta00@fastmail.fm>
Subject: Raid 5 to 6 grow stalled
Date: Sat, 09 Apr 2011 09:23:52 -0700
Message-ID: <1302366232.12096.1439264077@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 3 disk raid-5 array I want to convert to a 4 disk raid-6 array.
I added the 4th disk as a spare, and thought that it would get used
automatically when I converted it to 6, but instead it created a
degraded
raid 6 array.  So I removed the spare and added it back to the array to
get it to rebuild.  It did start rebuilding, but stalled out. 

Here's some console output showing what I did:

root@iblis:/home/hatta# mdadm --grow /dev/md2 --level 6 --raid-devices 4
--backup-file=/mnt/sda6/yo
mdadm level of /dev/md2 changed to raid6
root@iblis:/home/hatta# cat /proc/mdstat
Personalities : [raid10] [raid6] [raid5] [raid4]
md2 : active (auto-read-only) raid6 sdd1[0] sde1[3](S) sdf1[2] sdc1[1]
      2930271872 blocks level 6, 64k chunk, algorithm 18 [4/3] [UUU_]

root@iblis:/home/hatta# mdadm /dev/md2 --remove /dev/sde1
mdadm: hot removed /dev/sde1 from /dev/md2
root@iblis:/home/hatta# mdadm /dev/md2 --add /dev/sde1
mdadm: re-added /dev/sde1
root@iblis:/home/hatta# cat /proc/mdstat  
Personalities : [raid10] [raid6] [raid5] [raid4]
md2 : active raid6 sde1[4] sdd1[0] sdf1[2] sdc1[1]
      2930271872 blocks level 6, 64k chunk, algorithm 18 [4/3] [UUU_]
      [>....................]  recovery =  0.0% (8192/1465135936)
      finish=11899.9min speed=2048K/sec
...
...
...
md2 : active raid6 sde1[4] sdd1[0] sdf1[2] sdc1[1]
      2930271872 blocks level 6, 64k chunk, algorithm 18 [4/3] [UUU_]
      [>....................]  recovery =  0.0% (8192/1465135936)
      finish=2954174.4min speed=8K/sec


What's going on here?
-- 
  
  hatta00@fastmail.fm

-- 
http://www.fastmail.fm - Does exactly what it says on the tin

