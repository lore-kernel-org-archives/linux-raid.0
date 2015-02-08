From: Marc Widmer <metafor@gmail.com>
Subject: raid md126, md127 problem after reboot, howto fix?
Date: Sun, 08 Feb 2015 20:03:51 +0100
Message-ID: <54D7B317.5010809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi List

I have no deep unterstand about raids, beside setting them up initially and
replacing disks if needed. So this error has never happened to me before:

After a reboot i have a really strange behaviour on my server. Disks are
not marked faulty, but raid is "fallend apart".

/proc/mdstat shows me:

md126 : active raid1 sda1[0]
       10485696 blocks [2/1] [U_]

md127 : active raid1 sda2[0]
       721558464 blocks [2/1] [U_]

md1 : active raid1 sdb1[1]
       10485696 blocks [2/1] [_U]

md2 : active raid1 sdb2[1]
       721558464 blocks [2/1] [_U]

wished would be something similar to:
md1 : active raid1 sdb1[1] sda1[0]
       10238912 blocks [2/2] [UU]

md2 : active raid1 sdb2[1] sda2[0]
       1942746048 blocks [2/2] [UU]

Currently only md1, md2 are running. nmon shows me, that only disks sdb is
active, sda is not doing anything.

I run debian squeeze.

I am a bit concerned what to do, because at the moment i run on one disk
only and if things go wrong i end up with a server not running (downtime)
and possible data loss (beside backups).

Any ideas what i should do? Howto put the raid back together, possibly in
live mode, without rebooting in rescue mode and risk long downtime?

Any help would be greatly appreciated as by now the only thing i had to do
was resyncing a disk after usual hd crash.

Best
marc
