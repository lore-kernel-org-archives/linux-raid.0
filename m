From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: mdadm --wait doesn't (part II) [was: Re: question about bitmaps and
	dirty percentile]
Date: Tue, 8 Sep 2009 13:23:43 -0500
Message-ID: <cccedfc60909081123n36363d83ne6f39fd323ea0f47@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Regarding an earlier issue, I've also found that mdadm (v3.0 - 2nd
June 2009, openSUSE 11.1) doesn't wait if a recovery is in progress if
the recovery proceeds beyond 100% (due to a kernel bug).

turnip:~ # mdadm --wait /dev/md1
turnip:~ # echo $?
1
turnip:~ # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid10] [raid0] [raid1]
md1 : active raid1 sdf[2](W) md2[0]
      72612920 blocks super 1.1 [2/1] [U_]
      [=========================>]  recovery =125.7%
(45641024/36306460) finish=5320721999329.4min speed=28890K/sec
      bitmap: 29/139 pages [116KB], 256KB chunk

md2 : active raid1 nbd0[2](W) sde[0]
      72612988 blocks super 1.1 [2/2] [UU]
      bitmap: 1/139 pages [4KB], 256KB chunk

md0 : active raid6 sda4[0] sdc4[5] sdd4[4] sdb4[1]
      613409536 blocks super 1.1 level 6, 64k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>
turnip:~ #


-- 
Jon
