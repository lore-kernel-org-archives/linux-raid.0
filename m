From: Bob Glamm <glamm@a-s-i.com>
Subject: RAID migration from 2.4 -> 2.6
Date: Thu, 12 Aug 2004 10:29:39 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040812152939.GD5326@romulus.a-s-i.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At the moment I'm stumped, so I wonder if someone might be able
to give me a hand.

First, my RAID setup: I have a pair of Adaptec 7899 controllers
with five 9GB SCSI disks on each.  The first disks on each controller
are allocated in a RAID 1 configuration for boot, swap, /usr, etc.,
while the next three disks on each controller are allocated in
a RAID 5 configuration to our running services and data.  The last
disk on each controller is designated as a spare disk for each RAID.

These RAIDs work well with 2.4.  I've got them configured
for autodetect, so the system brings them up at startup in 2.4.

Now I'm trying to migrate to 2.6.7, and autodetection basically
ignores all my SCSI disks.  I get three lines:

  Autodetecting RAID arrays:
    ..  autodetecting
  Done.

when I try to boot 2.6.7.  (Additional note: all SCSI controllers
and disks are discovered just fine, although I am using the new
Adaptec driver in 2.6.)

In the course of googling/reading to fix this problem, I've
come up with several possibilities:

  1) My 2.4 setup uses devfs.  (Don't ask why, it just does.)
     Naturally, I'm ok moving to udev in 2.6; I had a brief thought
     that perhaps the long devfs pathnames were somehow encoded
     into the persistent superblock of each RAID array, but I
     don't think that's the case - I think the major/minor numbers
     of the disk partitions are stored directly.  (Someone
     correct me if I'm wrong?)

  2) After taking a look at
       http://cgi.cse.unsw.edu.au/~neilb/SoftRaid/01084411399
     I'm not even sure if 2.6 will do autodetection of my 2.4 RAID
     arrays?  Or is this only for RAID arrays created under 2.6?

  3) (related to 2) my 2.4 setup does not uses initrd at all.  The boot
     process basically consists of the boot loader loading the kernel
     and the kernel running /sbin/init.  I rely on the kernel autodetection
     assembling the RAID arrays before init is ever run (as / is on
     /dev/md10).

Any suggestions here?  I'd rather not have to backup filesystems and
start from scratch to get my RAID arrays going.

Thanks,
-Bob
