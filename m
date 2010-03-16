From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: async/X threads and rebuild slowdown
Date: Tue, 16 Mar 2010 12:41:13 +0000
Message-ID: <hnnu9c$tsj$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi - It seems our MD raid rebuild speeds are very slow with the new Fedora 
2.6.32.9-70 kernel. We're only getting ~13MB/s:

[root@xback2 ~]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 sdb1[0] sdj1[10](S) sdk1[9] sdl1[8] sdi1[7] sdh1[6] 
sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1]
      8788959360 blocks level 5, 32k chunk, algorithm 2 [10/10] [UUUUUUUUUU]
      [=====>...............]  resync = 29.3% (286397320/976551040) 
finish=897.2min speed=12819K/sec
      
The maximum rebuild speed is at the default 200000K/s. The drives are 
connected to a 3ware 9650SE-16ML controller on PCI-Express.

There seem to be hundreds of async/X threads, where X goes up to 129 at 
least. The md0_raid5 process is using at least 80% of the CPU on this dual 
core Athlon 7750 system.

Has anything changed recently in the kernel. I don't remember md0_raid5 
being so processor inefficient, slow at rebuilding or creating hundreds of 
kernel threads.

Are these async/X threads documented anywhere?

Thanks

Jeremy



