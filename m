From: Michael Tokarev <mjt@tls.msk.ru>
Subject: interesting failure scenario
Date: Mon, 04 Apr 2005 01:59:09 +0400
Message-ID: <4250672D.6080403@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I just come across an interesting situation, here's the
scenario.

0. Have a RAID1 array composed of two components, d1 and d2.
   The array was running, clean, event counter was 10.
1. d1 failed (eg, hotplug-removed).
2. on d2's superblock we now have event=11, and d1 is marked
    as failed.
3. the array is running in degraded mode. Some writes happened.
4. stop the array => d2 event counter = 12, clean.
5. hotplug-remove d2, hotplug-add d1.
6. start the array.  Now it is started off from d1, which is
   clean with event count = 10.  Since d2 is unaccessible, it
   is marked as faulty in d1's superblock.  The whole operation
   changes event count to 11.
7. do some writes to the array which is running on degraded
   mode (writing to d1).
8. Stop the array.  Event count on d1 is set to 12.
9. Hotplug-add d2 back.

Now we have an interesting situation.  Both superblocks in d1
and d2 are identical, event counts are the same, both are clean.
Things wich are different:
   utime - on d1 it is "more recent" (provided we haven't touched
     the system clock ofcourse)
   on d1, d2 is marked as faulty
   on d2, d1 is marked as faulty.

Neither of the conditions are checked by mdadm.

So, mdadm just starts a clean RAID1 array composed of two drives
with different data on them.  And noone noticies this fact (fsck
which is reading from one disk goes ok), until some time later when
some app reports data corruption (reading from another disk); you
go check what's going on, notice there's no data corruption (reading
from 1st disk), suspects memory and.. it's quite a long list of
possible bad stuff which can go on here... ;)

The above scenario is just a theory, but the theory with some quite
non-null probability.  Instead of hotplugging the disks, one can do
a reboot having flaky ide/scsi cables or whatnot, so that disks will
be detected on/off randomly...

Probably it is a good idea to test utime too, in additional to event
counters, in mdadm's Assemble.c (as comments says but code disagrees).
Maybe list of faulty components in every superblock too.  And refuse
to assemble the array if an inconsistency like this is detected
(unelss --force is specified)...  But the logic becomes quite..
problematic...

/mjt
