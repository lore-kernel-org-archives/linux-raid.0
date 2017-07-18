From: Maarten <maarten@ultratux.net>
Subject: 3-disk fail on raid-6, examining my options...
Date: Tue, 18 Jul 2017 19:20:37 +0200
Message-ID: <07b77b80-4bee-3820-6a0d-3323ef06a3f3@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Argh.. Murphy can be such a troll... :(

Hi all,

While I was in the process of migrating all my raid-6 arrays to raid-1
arrays (with either two or three member disks), I got stung severely.
(Obviously I shouldn't have been so stupid as to write to an array not
yet fully copied, but that is now too late to undo)


  What probably happened:
A six-disk raid-6 array suffered a simultaneous two-disk failure which
went unnoticed for a number of hours, and then inevitably got hit by a
-catastrophic- 3rd disk failure during the following night.


The first two disks that failed have exactly identical event counters
according to mdadm -E <disk device> which leads me to believe that it is
probably the SATA card/controller that failed/oops'ed, not the disks
themselves. But at this point that has not yet been verified.

The third disk, and the array, have a substantially higher event
counter. This makes complete sense, since the array was being actively
_written_ to at the time. (Yes, alas...) *Bangs head against desk*


Now from what I've gathered over the years and from earlier incidents, I
have now 1 (one) chance left to rescue data off this array; by hopefully
cloning the bad 3rd-failed drive with the aid of dd_rescue and
re-assembling --force the fully-degraded array. (Only IF that drive is
still responsive and can be cloned)

My feeling is, the two ``good'' drives with the lower event counter are
now more useful as paperweights than to help restore any data... But I
like to have certainty before I try other ways to restore (or recreate)
data...

Is there any hope?


Here are some snippets from mdadm:

md0 : active raid6 sdh1[10] sdj1[8] sdm1[9] sdb1[3](F) sde1[7](F) sdd1[6](F)
7799470080 blocks super 1.2 level 6, 512k chunk, algorithm 2 [6/3] [U___UU]


mdadm -E /dev/sde1:
    Update Time : Mon Jul 17 15:49:44 2017
       Checksum : fdc7fdd7 - correct
         Events : 58235
    Array State : AAAAAA ('A' == active, '.' == missing)

mdadm -E /dev/sdb1:
    Update Time : Mon Jul 17 15:49:44 2017
       Checksum : cd97800c - correct
         Events : 58235
    Array State : AAAAAA ('A' == active, '.' == missing)

mdadm -E /dev/sdd1:
    Update Time : Tue Jul 18 01:47:33 2017
       Checksum : d00eff1d - correct
         Events : 69129
    Array State : AA..AA ('A' == active, '.' == missing)

mdadm --detail /dev/md0
 Failed Devices : 3
         Events : 69132


Thanks for any insights...

regards,
Maarten
