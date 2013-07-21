From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: 3.10.1: echo repair > sync_action causes hang on RAID-1 (2 x SSD)
Date: Sun, 21 Jul 2013 06:26:55 -0400
Message-ID: <000501ce85fc$d3a60a10$7af21e30$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

When I run repair on an MD-RAID1 sync_action, the speed slows down and it
stays like this (below) for hours.  

The system is then completely unresponsive to user input.  I have replaced a
failing SSD; however, after a check, mismatch_cnt seems to increase over
time.  When I run repair, the system freezes to user-input.  Has anyone else
run into this issue with a RAID-1 volume (2 x SSD) using 0.90 metadata?
Long ago I used to use this same configuration with two physical disks and
there was never a problem.

Even though I left a root shell open, this has no effect to break the
resync:
# echo idle > /sys/devices/virtual/block/md1/md/sync_action

Every 1.0s: cat /proc/mdstat                            Sun Jul 21 06:15:38
2013

Personalities : [raid1]
md1 : active raid1 sdc2[0] sdb2[1]
      233381376 blocks [2/2] [UU]
      [>....................]  resync =  0.0% (151616/233381376)
finish=36171.5min speed=107K/sec

md0 : active raid1 sdc1[0] sdb1[1]
      1048512 blocks [2/2] [UU]

unused devices: <none>

10 minutes later:

      233381376 blocks [2/2] [UU]
      [>....................]  resync =  0.0% (151616/233381376)
finish=52219.3min speed=74K/sec

Where it hangs (151616) or elsewhere, has been different each time I watched
it, it does not appear to be hanging at the same block each time.

Justin.

