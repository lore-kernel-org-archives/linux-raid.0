From: "Jon Robertson" <jonrobertson@sbcglobal.net>
Subject: Gentoo - New to Linux need help with RAID-1 Mirroring
Date: Thu, 6 Feb 2003 16:24:48 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <b1un4u$9g6$1@main.gmane.org>
Reply-To: "Jon Robertson" <jonrobertson@sbcglobal.net>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks to whoever reads this in advance....

Background:  I've installed Gentoo's latest release on a P4 1.8 Ghz machine.
I installed per the directions on gentoo's site.  I installed everything on
one IDE drive (120gb)  and also installed Webmin, samba, apache, and will
soon install netfilter.

My goal is to install a 2nd IDE drive same size, etc. on the second ide
controller channel.  Obviously the goal is to have a back up in case drive 1
fails.  My first drive has been partitioned as /hda1 /hda2 and /hda3 with
/hda3 having most of the software on it, etc.  I do have a couple questions
that don't seem obvious to me after all the materials that I've searched
including the famous Oestergaard installation instructions.

Question1:  do i want to mirror a swap drive?

Question 2: Is this the correct syntax below? (open to constructive
feedback!) to mirorr the entire drive?  If the answer to #1 is no...then
would I need to /md devices?  in which the second example would be the
correct one?  (/hda2 is the swap drive)

option 1



/etc/raidtab

            raiddev                     /md0

            raid-level                  1

            nr-raid-disks             2

            chunk-size               4 (chunk-size is a place holder and not
used in Raid-1)



            device                       /dev/hda

            raid-disk                  0



            device                      /dev/hdb

            raid-disk                  1







option 2



/etc/raidtab

            raiddev                     /md0

            raid-level                  1

            nr-raid-disks             2

            chunk-size               4 (chunk-size is a place holder and not
used in Raid-1)



            device                       /dev/hda 1

            raid-disk                  0



            device                      /dev/hdb1

            raid-disk                  1



            raiddev                     /md1

            raid-level                  1

            nr-raid-disks             2

            chunk-size               4 (chunk-size is a place holder and not
used in Raid-1)



            device                       /dev/hda3

            raid-disk                  0



            device                      /dev/hdb3

            raid-disk                  1



Question 3:  In terms of the order of instructions, would this be correct?



1. install the second drive,

2. re-boot

3. use fdisk to create the partitions on the 2nd ide drive (identical to the
ones on drive 1)

3. create the array with the raidtab file

4. at this point, doesn't synchronization occur?



Ok. I think I better quit while I'm ahead....I am thoroughly confusing
myself......I just want to make sure that I follow the directions in the
right order....



thanks everyone..



JR



