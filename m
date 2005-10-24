From: Jeff Breidenbach <jeff@jab.org>
Subject: split RAID1 during backups?
Date: Mon, 24 Oct 2005 03:57:56 -0700
Message-ID: <E1EU01c-0001sZ-00@toko.jab.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi all,

I have a two drive RAID1 serving data for a busy website. The
partition is 500GB and contains millions of 10KB files. For reference,
here's /proc/mdstat

Personalities : [raid1]
md0 : active raid1 sdc1[0] sdd1[1]
      488383936 blocks [2/2] [UU]

For backups, I set the md0 partition to readonly and then use dd_rescue
+ netcat to copy the parition over a gigabit network. Unfortuantely,
this process takes almost 10 hours. I'm only able to copy about 18MB/s
from md0 due to disk contention with the webserver. If I had the full
attention of a single disk, I could read at nearly 60MB/s.

So - I'm thinking of the following backup scenario.  First, remount
/dev/md0 readonly just to be safe. Then mount the two component
paritions (sdc1, sdd1) readonly. Tell the webserver to work from one
component partition, and tell the backup process to work from the
other component partition. Once the backup is complete, point the
webserver back at /dev/md0, unmount the component partitions, then
switch read-write mode back on.

Am I insane? 

Everything on this system seems bottlenecked by disk I/O. That
includes the rate web pages are served as well as the backup process
described above. While I'm always hungry for perforance tips, faster
backups are the current focus. For those interested in gory details
such as drive types, NCQ settings, kernel version and whatnot, I
dumped a copy of dmesg output here: http://www.jab.org/dmesg

Cheers,
Jeff
