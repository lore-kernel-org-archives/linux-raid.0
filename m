From: Christopher Smith <csmith@nighthawkrad.net>
Subject: RAID resync stalled at 99.7% ?
Date: Fri, 02 Sep 2005 19:10:02 +1000
Message-ID: <1125652202.3454.10.camel@chris.syd.nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In doing some benchmarking, I've found a curious problem - after
creating an array the resync has stalled at 99.7%:

[root@justinstalled ~]# cat /proc/mdstat
Personalities : [raid6]
md0 : active raid6 sdm1[11] sdl1[10] sdk1[9] sdj1[8] sdi1[7] sdh1[6]
sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
      4963200 blocks level 6, 32k chunk, algorithm 2 [12/12]
[UUUUUUUUUUUU]
      [===================>.]  resync = 99.7% (496320/496349)
finish=0.0min speed=628K/sec
unused devices: <none>
[root@justinstalled ~]#                                     

It's been sitting like this for some time now, and since the resync up
until this point progress at about 15M/sec, I can't see any reason to
think it will suddenly finish.

mdadm -S /dev/md0 simply hangs.

This problem is reproducible as well - if I reboot the machine the
resync will complete successfully, then if I delete it and try to create
another array, exactly the same thing will happen.

It's also not a problem with, for example, bad sectors on one of the
components, as creating a larger array stalls right near the end as well
(the exact percentage varies, but it's always around the 99% part).

Does anyone have any ideas ?



Some relevant info:

The command used to create the aray was:

mdadm -C /dev/md0 -l6 -n12 -c 32 -z 496349 /dev/sd[b-m]1

It's a Fedora Core 4 box:

[root@justinstalled ~]# uname -a
Linux justinstalled.syd.nighthawkrad.net 2.6.12-1.1398_FC4smp #1 SMP Fri
Jul 15 01:30:13 EDT 2005 i686 i686 i386 GNU/Linux
[root@justinstalled
~]#                                                             

The components are 12x400GB drives attached to a 3ware 9500s-12
controller.  They are configured as "single disks" on the controller,
ie: no hardware RAID is involved.

Regards,
Chris Smith

