From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: raid1 boot regression in 2.6.37 [bisected]
Date: Fri, 25 Mar 2011 19:55:34 +0100
Message-ID: <4D8CE526.3050204@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-raid.ids

Hello,

I've just updated from kernel 2.6.34.7 to kernel 2.6.37.5 and one
HP Proliant DL320 G3 box with a raid1 software RAID stopped booting.
(also two other non-HP boxes).

We run this script at boot time via dracut:
----------------------------------
#!/bin/sh
. /lib/dracut-lib.sh

info "Telling kernel to auto-detect RAID arrays"
/sbin/initqueue --settled --name kerneldetectraid /sbin/mdadm --auto-detect
----------------------------------

With the "bad" commit in place, the kernel doesn't output
any md message at all. I've bisected it down to this commit:

e804ac780e2f01cb3b914daca2fd4780d1743db1 is the first bad commit
commit e804ac780e2f01cb3b914daca2fd4780d1743db1
Author: Tejun Heo <tj@kernel.org>
Date:   Fri Oct 15 15:36:08 2010 +0200

    md: fix and update workqueue usage

    Workqueue usage in md has two problems.

    * Flush can be used during or depended upon by memory reclaim, but md
      uses the system workqueue for flush_work which may lead to deadlock.

    * md depends on flush_scheduled_work() to achieve exclusion against
      completion of removal of previous instances.  flush_scheduled_work()
      may incur unexpected amount of delay and is scheduled to be removed.

    This patch adds two workqueues to md - md_wq and md_misc_wq.  The
    former is guaranteed to make forward progress under memory pressure
    and serves flush_work.  The latter serves as the flush domain for
    other works.

    Signed-off-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: NeilBrown <neilb@suse.de>

:040000 040000 f6b6a34a71864263ed253866c5f8abe7f766ac6b 
dc2eff4a91825142b7c88cf54751fc7acdf1a6d2 M      drivers

I manually verified that the commit before it 
(57dab0bdf689d42972975ec646d862b0900a4bf3) works
and the "bad" commit prevents the box from booting.


Some more info:

# mdadm --version
mdadm - v2.6.9 - 10th March 2009

# mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Wed May 27 17:52:40 2009
     Raid Level : raid1
     Array Size : 2562240 (2.44 GiB 2.62 GB)
  Used Dev Size : 2562240 (2.44 GiB 2.62 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Mar 25 17:11:33 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 0ee8da2c:5803478b:e399b924:6520c535
         Events : 0.160

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1



Any idea what might go wrong? May be building a kernel
with lock debugging on Monday might help. I think I also
tried kernel 2.6.38 though I'll very on Monday, too.


Have a nice weekend,
Thomas

PS: Sorry Tejun for the HTML crap in my first mail.
