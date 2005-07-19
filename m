From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: assemble/hot add problem with bitmap raid1
Date: Tue, 19 Jul 2005 16:41:43 +0300
Message-ID: <112626180.20050719164143@netvision.net.il>
Reply-To: Maxim Kozover <maximkoz@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil!
I have the problem with the following scenario if using raid1 with
bitmap on 2.6.12.2 (with drivers/md and include/linux/raid taken from
2.6.13) with pached mdadm-2.0-devel-2.
1. create raid1 from /dev/sdb and /dev/sdc, wait for resync to finish,
make /dev/sdc not ready, use the array so it feels /dev/sdc is Faulty,
stop the array, make /dev/sdc available again, assemble the array.
At this point both with bitmap and without the bitmap I get messages
about md: kicking non-fresh sdc from array! - is it OK?
2. If I'm not using bitmap, I can hot-add /dev/sdc and the resync starts.
However, if I'm using bitmap this /dev/sdc remains in Faulty state in
/proc/mdstat.

# mdadm -A /dev/md0 --bitmap /bitmap /dev/sdb /dev/sdc
mdadm: /dev/md0 has been started with 1 drive (out of 2).
# more /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdb[0]
      16777208 blocks [2/1] [U_]
      bitmap: 0/2048 pages [0KB], 4KB chunk, file: /bitmap

unused devices: <none>
# mdadm --manage /dev/md0 -a /dev/sdc
mdadm: added /dev/sdc
# more /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdc[1](F) sdb[0]
      16777208 blocks [2/1] [U_]
      bitmap: 0/2048 pages [0KB], 4KB chunk, file: /bitmap

unused devices: <none>

------------------------------------------------------

Now without bitmap:

# mdadm -S /dev/md0
# mdadm -A /dev/md0 /dev/sdb /dev/sdc
mdadm: /dev/md0 has been started with 1 drive (out of 2).
# more /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdb[0]
      16777208 blocks [2/1] [U_]

unused devices: <none>
# mdadm --manage /dev/md0 -a /dev/sdc
mdadm: added /dev/sdc
# more /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdc[2] sdb[0]
      16777208 blocks [2/1] [U_]
      [>....................]  recovery =  0.6% (101568/16777208) finish=8.2min
speed=33856K/sec

unused devices: <none>

Why is it, Neil?

Thanks,

Maxim Kozover.

