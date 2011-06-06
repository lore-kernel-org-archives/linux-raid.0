From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: md array does not detect drive removal: mdadm 3.2.1, Linux 2.6.38
Date: Mon, 6 Jun 2011 11:20:33 -0700
Message-ID: <BANLkTikv0avX6tYoG8g+pgUznopHCA4tyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, fibre raid <fibreraid@gmail.com>
List-Id: linux-raid.ids

Hello,

I am running Linux kernel 2.6.38 64-bit version with mdadm 3.2.1. The
server hardware has dual socket Westmere CPUs (4 cores each), 24 GB of
RAM, and 24 hard drives connected via SAS.

I create an md0 array with 23 active drives, 1 hot-spare, RAID 5, and
64K chunk. After synchronization is complete, I have:

root::~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdf1[23](S) sdi1[22] sdh1[21] sdg1[20] sde1[19]
sdd1[18] sdc1[17] sdo1[16] sdn1[15] sdq1[14] sdp1[13] sdr1[12]
sdm1[11] sdl1[10] sdk1[9] sdj1[8] sdv1[7] sdu1[6] sdt1[5] sds1[4]
sdy1[3] sdx1[2] sdb1[1] sdw1[0]
      2149005056 blocks super 1.2 level 5, 64k chunk, algorithm 2
[23/23] [UUUUUUUUUUUUUUUUUUUUUUU]

Then I remove an active drive from the system by unplugging it. udev
catches the event, and fdisk -l reports one less drive. In this case,
I remove /dev/sdv.

However, /proc/mdstat remains unchanged. It's as if md has no idea
that the drive disappeared. I would expect md at this point to have
detected the removal, and to have automatically kicked-off a resync
using the included hot-spare. But this does not occur.

If I then run mdadm -R /dev/md0, in an attempt to "wake up" md, then
md does realize the change, and does start the resyncing.

I do not believe this is normal behavior. Can you advise?

Thank you!
-Tommy
