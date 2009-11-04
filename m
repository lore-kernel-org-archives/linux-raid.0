From: James Lee <james.lee@cantab.net>
Subject: Slow raid5 grow performance, with iostat showing unexpected behavior
Date: Wed, 4 Nov 2009 20:44:05 +0000
Message-ID: <ef2613f30911041244h258de090sdc79612a08b38339@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I'm currently running a grow operation to add a third drive to a
2-drive RAID5 array.  After increasing speed_limit_min and
speed_limit_max, to large values, the reshape is progressing at a
fairly constant 8 - 8.5 MB/s.  This isn't crazily slow, but I'd expect
faster - I've had a bit of a dig and am seeing some unexpected
behavior.


Here's what /proc/mdstat shows (md1 is the array being reshaped, sde2
is the new device):

james@james-server:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md1 : active raid5 sde2[2] sdd2[0] sdf2[1]
      419922944 blocks super 0.91 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      [===>.................]  reshape = 18.5% (78052736/419922944)
finish=688.5min speed=8272K/sec

md0 : active raid5 sde1[3] sda1[0] sdg1[5] sdf1[4] sdd1[2] sdb1[1]
      1562481280 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]


I'd expect iostat to show reads and writes for sdd2 and sdf2, and
writes for sde2, and not a lot else (the system is idle other than
this reshape).  What it actually shows is:

james@james-server:~$ iostat
Linux 2.6.24-25-server (james-server)     11/04/2009

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.15    0.02    3.27    0.30    0.00   96.26

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
sda              12.91      7705.76         0.04  625173188       3224
sdb              12.60      7705.81         0.03  625177270       2744
md0               0.84         6.68         0.02     542154       1440
sdc               0.56        11.55         4.94     937168     400472
sdd              33.75     11604.87      1954.45  941509808  158565904
sde              20.40         0.11      9658.00       9288  783558900
sdf              32.18     11604.88      1954.46  941510562  158566272
sdg              15.20      7705.83         0.03  625178358       2728
md1               0.16         1.28         0.00     103608          0
dm-0              0.99         7.92         0.02     642418       1440


So we see what we'd expect for the three drives in the md1 array, but
I also see reads on the drives in the md0 array (which isn't being
reshaped, resynced, or read from).  That would presumably explain why
the reshape is running more slowly than expected - assuming 7.8 MB/s
is being read from each device in md0 (which includes partitions on
the same drives as md1 devices) then sdd and sdf are going to be
seeking like crazy reading data for the md0 array and the md1 array at
the same time.  This is potentially also causing contention on the PCI
bus.

One thing which might be relevant is that I've got LVM on top of these
arrays (each array is a PV, and the PVs form a single LV).  I'd have
thought the reshape would have been transparent to LVM though.  Also
I'd have thought that if something was genuinely trying to read data
from md0, iostat would report reads on the array, which it doesn't.

Any ideas?  How can I tell what's causing the reads to the devices in
md0?  In case it's relevant, I'm running Ubuntu 8.04 with unmodified
kernel and mdadm:

james@james-server:~$ uname -r
2.6.24-25-server
james@james-server:~$ mdadm --version
mdadm - v2.6.3 - 20th August 2007

Thanks,
James Lee
