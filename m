From: "Jon Robertson" <jonrobertson@sbcglobal.net>
Subject: Using 1 UDE and 3 SCSI's for Raid-5
Date: Fri, 21 Mar 2003 11:03:09 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <b5fgeb$u15$1@main.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I know what you're thinking, but that's not exactly what I'm trying to
do....

Scenario: I have one IDE (120GB) that has 3 partitions on the drive(/hda1,
/hda2, and /hda3) where /hda1 is /boot, /hda2 is /swap and /hda3 is /....the
server is only being used for SAMBA administration with a bunch of file
shares on it, no Apache, QMail, etc....just plain old Samba.  Right now the
server does not have any 'real' data on it, just user accounts and the
shares have been created however.

I have installed (3) 36GB SCSI drives with a controller card, etc.  that I
want to use as a safeguard for the SAMBA file shares mentioned above.  A
friend of mine told me the goal would be to partition each SCSI drive the
same way I did the IDE drive.  The second goal would be to rsynch changes
from /hda1 to /sda1 and from /hda2 to /sda2 and from /hda3 to
/sda3......this way, if the IDE goes down, then the boot image is on the
raid device and can boot up like 'nothing happened'

Question #1: Is this the proper method for allowing the raid device to boot
up in case of IDE failure?
Question #2: do you recommend raid'ing the swap space?  I've heard mixed
reviews.
Question #3: how many md devices do I set up?  One for /hda1 to /sda1, sdb1,
sdc1  and another md device for the /hda3 to /sda3, sdb3, sdc3? assuming no
on the swap space.
Question #4: based on that, does this look like a reasonable mkraid file?
this assumes 3 md devices.

 /etc/raidtab
   raiddev                       /dev/md0
   raid-level                    5
   chunk-size                    64
   persistent-superblock         1
   parity-algorithm              left-symmetric
   nr-raid-disks                 3
   device                        /dev/sda1
   raid-disk                     0
   device                        /dev/sdb1
   raid-disk                     1
   device                        /dev/sdc1
   raid-disk                     2

   raiddev                       /dev/md1
   raid-level                    5
   chunk-size                    64
   persistent-superblock         1
   parity-algorithm              left-symmetric
   nr-raid-disks                 3
   device                        /dev/sda2
   raid-disk                     0
   device                        /dev/sdb2
   raid-disk                     1
   device                        /dev/sdc2
   raid-disk                     2

   raiddev                       /dev/md2
   raid-level                    5
   chunk-size                    64
   persistent-superblock         1
   parity-algorithm              left-symmetric
   nr-raid-disks                 3
   device                        /dev/sda3
   raid-disk                     0
   device                        /dev/sdb3
   raid-disk                     1
   device                        /dev/sdc3
   raid-disk                     2

Question 5: What would the next steps be?  would I then run the mkraid
commands, one for each md device?

Thanks for your help.
jr



