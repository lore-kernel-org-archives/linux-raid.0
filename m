From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Linux MD Raid Bug(?) w/Kernel sync_speed_min Option
Date: Tue, 8 May 2007 08:27:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705080821350.16228@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kernel: 2.6.21.1

Here is the bug:

md2: RAID1 (works fine)
md3: RAID5 (only syncs at the sync_speed_min set by the kernel)

If I do not run this command:
echo 55000 > /sys/block/md3/md/sync_speed_min

I will get 2 megabytes per second check speed for RAID 5.

However, the odd part is I can leave it the default for RAID1 and it will 
use the maximum IO available between both drives to run the check.

I think there is some kind of bug, essentially with RAID5 check's-- it 
only runs at the minimum value set (default in the kernel for raid5 is 
~2mb/s).

md2 : active raid1 sdb3[1] sda3[0]
       55681216 blocks [2/2] [UU]
       [===========>.........]  check = 59.1% (32937536/55681216) 
finish=7.4min speed=50947K/sec

md3 : active raid5 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[3] 
sde1[
2] sdd1[1] sdc1[0]
       1318686336 blocks level 5, 128k chunk, algorithm 2 [10/10] 
[UUUUUUUUUU]
       [====>................]  check = 24.2% (35578816/146520704) 
finish=33.3min speed=55464K/sec

Set to default kernel settings, either 2000 or 2100:

echo 2000 > /sys/block/md3/md/sync_speed_min

Then,

md3 : active raid5 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[3] 
sde1[
2] sdd1[1] sdc1[0]
       1318686336 blocks level 5, 128k chunk, algorithm 2 [10/10] 
[UUUUUUUUUU]
       [======>..............]  check = 31.5% (46191744/146520704) 
finish=715.7min speed=2335K/sec

There is some kind of nasty bug going on here with RAID 5 devices in the 
kernel.  Also, incase you wondered, there is little to no I/O on the RAID 
5 device when this check is being run, same for the root volume.

Justin.
