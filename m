From: Philip Molter <philip@datafoundry.com>
Subject: RAID1 disk failure causes hung mount
Date: Mon, 01 Sep 2008 13:32:10 -0500
Message-ID: <48BC352A.5010701@datafoundry.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

We're running a modified version of the FC4 2.6.17 kernel (2.6.17.4).  I 
realize this is an old kernel.  For internal reasons, we cannot update 
to a newer version of the kernel at this time.

We have a 3ware 9550SXU card with 12 drives in JBOD mode.  These 12 
drives are mirrored in 6 RAID1 pairs, then striped together in one big 
RAID0 stripe.  When we have a disk error with one of the drives in a 
RAID1 pair, the entire RAID0 mount locks up.  We can still cd to the 
mount and read from it, but if we try to write anything to the mount, 
the process hangs in an unkillable state.

This recently happened.  Here are the log messages from the disk failure:

sd 0:0:9:0: SCSI error: return code = 0x8000004
sdj: Current: sense key: Medium Error
     Additional sense: Unrecovered read error
end_request: I/O error, dev sdj, sector 10964975
raid1: sdj1: rescheduling sector 10964912
3w-9xxx: scsi0: ERROR: (0x03:0x0202): Drive ECC error:port=9.
sd 0:0:9:0: SCSI error: return code = 0x8000004
sdj: Current: sense key: Medium Error
     Additional sense: Unrecovered read error
end_request: I/O error, dev sdj, sector 10964975
raid1: sdd1: redirecting sector 10964912 to another mirror

When this happened, /dev/sdj1 did not fail out of its RAID.  It also did 
not lock the system.  Later:

sd 0:0:9:0: SCSI error: return code = 0x8000004
sdj: Current: sense key: Medium Error
     Additional sense: Unrecovered read error
end_request: I/O error, dev sdj, sector 16744439
raid1: sdj1: rescheduling sector 16744376

When this happened, /dev/sdj1 did not fail out of its RAID, but it did 
lock writes to the big RAID0 stripe.  I manually failed /dev/sdj1 out of 
the RAID and /proc/mdstat did report it as failed out at that point.  It 
did not cause writes to begin being processed.  I tried to manually 
remove /dev/sdj1 from the RAID and mdadm reported that the device was 
busy.  A hard power-cycle was required to restore functionality to the 
system.  This is consistent with these kinds of errors.

I have looked through the patches related to RAID1 and lockups.  The 
patches from January/March 2008 related to RAID1 deadlocks have not 
seemed to help (I didn't really expect them to as 2.6.17.4 predates 
bitmap code, no?).

I'd like to be able to get more debug during cases like this, but I'm 
not sure what to gather or how to gather it.  If anyone has any 
suggestions, I'd appreciate hearing them.  If any of the md devs have 
any suggestions for patches to look at that specifically address this 
behavior, I'd by very grateful for that advice.  As it is, I've been 
combing over git commits with very little success.

Thanks in advance for any assistance, knowledge, or suggestions anyone has.

Philip
