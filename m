From: Dragon <Sunghost@gmx.de>
Subject: Raid6 Root crashed
Date: Wed, 30 Apr 2014 11:44:45 +0200
Message-ID: <trinity-90b4c7d3-4ba3-45e8-8416-be2cc7835aa7-1398851085504@3capp-gmx-bs55>
References: <trinity-97a7ea27-17c1-4edb-b2bc-d09d87f74e73-1398850867149@3capp-gmx-bs66>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
 
i have a 6x3TB SW Raid6 under Debian Wheezy. md0 is for the system, md1 is for swap and md2 for files. While i copy some files from a 8disk to the md2 i got a kernel panic and the system halts. i have to shut it down on the hard way. After that i reboot and got a problem with md0 and the system wont boot.
 
Mesage:

md0: cannot start dirty degraded array
md0: failed to run raid set
failed to run_array md0 inpu/output error
...
md0 is already in use
gave up waiting for root device common problems...
alert! dev/disk/by-uuid/eb8r..... does not exist.
dropping to a shell!
cant access tty job control turned off
((initframs)

proc/mdstat:

md0: inactive sda2[0] sdf2[5] sde2[4] sdd2[3] sdc2[2] sdb2[1]

So Partition sdg2 is missing. SDG was the last i added to the raid.

mdadm detail shows:

Raid Devices: 7
Total Devices: 6
Active D: 6
Working D: 6
Failed D: 0
Spare D: 0
Number
0...active sync sda2
...
5...active sync sdf2
6 removed 

This shows me that sdg2 is missing.
I do an examine on sdg2 and it shows no problems, superblock is persistant. The UUID's for all 3 mds are correct in the mdadm.conf. I am unsure what to do next. I think it must be a mdadm --assemble --force /dev/md0 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2 /dev/sde2 /dev/sdf2 missing.
 
Sorry but i cant connect via ssh and must write the lines from screen. What should i do next?
