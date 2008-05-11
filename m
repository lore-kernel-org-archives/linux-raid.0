From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: What to do when repair does not fix mismatch_cnt to 0 (2.6.25.1)?
Date: Sun, 11 May 2008 10:39:57 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805111038060.22970@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

p34:~# cat /sys/block/md3/md/mismatch_cnt
256

p34:~# echo repair > /sys/block/md3/md/sync_action

.. wait awhile ..

md3 : active raid5 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1] sdc1[0]
       1318680576 blocks level 5, 1024k chunk, algorithm 2 [10/10] [UUUUUUUUUU]
       [=================>...]  resync = 85.0% (124634296/146520064) finish=7.9min speed=46113K/sec

.. done ..

md3 : active raid5 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1] sdc1[0]
       1318680576 blocks level 5, 1024k chunk, algorithm 2 [10/10] [UUUUUUUUUU]

now check again:

p34:~# cat /sys/block/md3/md/mismatch_cnt
256
p34:~#

# uname -r
2.6.25.1

Usually a reboot will take care of it but I would like to know the root 
cause of it and why repair does not fix it?


