From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Re: stuck tasks
Date: Mon, 12 Apr 2010 12:14:51 +0100
Message-ID: <hpuvbb$13t$1@dough.gmane.org>
References: <hputbs$qq2$1@dough.gmane.org> <4BC2FE9E.9040802@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

MRK wrote:

> You need to lower the sync speed by catting a value into
> /sys/block/md{n}/md/sync_speed_max
> the value should be about 1/3 lower than the max speed you see (cat
> /proc/mdstat) now that it's not yet limited.
> Set up a script to set it at boot.

Thanks - I'll try it. It didn't happen in a raid sync, just during an rsync 
run. Would this have any effect on normal operation?
 
> If it was not happening for you on older kernels might be a good sign:
> it might mean that the resync is faster now...
> 
> What is the sync speed you see (cat /proc/mdstat)? How many drives do
> you have and what type of raid is that?

We're only getting 30MB/s. I thought it used to be quite a lot faster. It 
seems to slow down as the sync progresses:

[root@xback2 ~]#  cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 sdb1[0] sdj1[10](S) sdk1[9] sdl1[8] sdi1[7] sdh1[6] 
sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1]
      8788959360 blocks level 5, 32k chunk, algorithm 2 [10/10] [UUUUUUUUUU]
      [>....................]  resync =  1.4% (14078544/976551040) 
finish=501.4min speed=31990K/sec
      
     
unused devices: <none>

The drives are connected to a single 3ware Inc 9650SE SATA-II RAID PCIe card 
on this particular system. They're SATA 1GB drives.

Jeremy

