From: Niccolo Rigacci <niccolo@rigacci.org>
Subject: New FAQ entry? (was IBM xSeries stop responding during RAID1 reconstruction)
Date: Wed, 21 Jun 2006 18:09:07 +0200
Message-ID: <20060621160907.GA20630@rigacci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks to the several guys in this list, I have solved my problem 
and elaborated this, can be a new FAQ entry?



Q: Sometimes when a RAID volume is resyncing, the system seems to 
locks-up: every disk activity is blocked until resync is done.

A: This is not strictly related to Linux RAID, this is a problem 
related to the Linux kernel and the disk subsytem: in no 
circumstances a process should get all the disk resources 
preventing others to access them.

You can control the max speed at which RAID reconstruction is 
done by setting it, say at 5 Mb/s:

  echo 5000 > /proc/sys/dev/raid/speed_limit_max

This is just a workaround, you have to determine the max speed 
that does not lock your system by trial and error and you cannot 
predict what will be the disk load in the future when the RAID 
will be resyncing for some reason.

Starting from version 2.6, Linux kernel has several choices about 
the I/O scheduler to be used. The default is the anticipatory 
scheduler, which seems to be sub-optimal on resync high load. If 
your kernel has the CFQ scheduler compiled in, use it during 
resync.

From the command line you can see which schedulers are supported 
and change it on the fly (remember to do it for each RAID disk):

  # cat /sys/block/hda/queue/scheduler
  noop [anticipatory] deadline cfq
  # echo cfq > /sys/block/hda/queue/scheduler

Otherwise you can recompile your kernel and set CFQ as the 
default I/O scheduler (CONFIG_DEFAULT_CFQ=y in Block layer, IO 
Schedulers, Default I/O scheduler).


-- 
Niccolo Rigacci
Firenze - Italy

Iraq, missione di pace: 38475 morti - www.iraqbodycount.net
