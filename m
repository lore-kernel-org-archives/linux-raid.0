From: "Jonathan Schmidt" <jon@impact-ltd.ca>
Subject: raidreconf error (bug)
Date: Thu, 15 Sep 2005 13:08:40 -0700
Message-ID: <dgckbo$her$1@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just attempted to add a 5th 80GB disk to my RAID-5 array using raidreconf. 
I previously added a 4th disk 6 months ago using the identical tools with no 
errors or hiccups whatsoever.  Back then, I made a full backup because of 
all the warnings.  This time, I assumed it would work since it did last 
time, and did not backup the data.  You can see where this is going...

Here's some of the relevant info:

raidtab.old:
raiddev /dev/md0
        raid-level      5
        persistent-superblock   1
        chunk-size      32
        nr-raid-disks   4
        device  /dev/hdg1
                raid-disk       0
        device  /dev/hdh1
                raid-disk       1
        device  /dev/hde1
                raid-disk       2
        device  /dev/hdf1
                raid-disk       3

raidtab.new
raiddev /dev/md0
        raid-level      5
        persistent-superblock   1
        chunk-size      32
        nr-raid-disks   5
        device  /dev/hdg1
                raid-disk       0
        device  /dev/hdh1
                raid-disk       1
        device  /dev/hde1
                raid-disk       2
        device  /dev/hdf1
                raid-disk       3
        device  /dev/hdb1
                raid-disk       4

As you can see, the nr-raid-disks was incremented and /dev/hdb1 was added to 
the bottom of the list as raid-disk 4.

The command:  raidreconf -o /etc/raidtab.old -n /etc/raidtab.new -m /dev/md0

This output is reconstructed from memory mostly so there are a few holes.

...
Old raid-disk 0 has 2442206 chunks, 78150592 blocks
Old raid-disk 1 has 2442206 chunks, 78150592 blocks
Old raid-disk 2 has 2442206 chunks, 78150592 blocks
Old raid-disk 3 has 2442128 chunks, 78148096 blocks
New raid-disk 0 has 2442206 chunks, 78150592 blocks
New raid-disk 1 has 2442206 chunks, 78150592 blocks
New raid-disk 2 has 2442206 chunks, 78150592 blocks
New raid-disk 3 has 2442128 chunks, 78148096 blocks
New raid-disk 4 has 2442128 chunks, 78148096 blocks
Using 32 Kbyte blocks to move from 32 Kbyte chunks to 32 Kbyte chunks.
Detected 513804 KB of physical memory in system
A maximum of 2518 outstanding requests is allowed
---------------------------------------------------
I will GROW your old device /dev/md0 of 7326540 blocks
to a new device /dev/md0 of 9768668 blocks
using a block-size of 32 KB
Is this what you want? (yes/no): yes
Converting 7326540 block device to 9768668 block device
Allocated free block map for 5 disks
5 unique disks detected.

... reconfiguration progress to roughly 85-90% complete normally ...

raid5_map_global_to_local: disk 3 block out of range: 2442129 (2442128) 
gblock = ? (can't remember)
Aborted

--------------------------------------------------------------------

Ouch.  Problems -- it looks like raidreconf tried to access beyond the end 
of disk 3 (noting that it has fewer block than the rest of the disks).

(At this point I bought a 400GB hard drive and took a "dd" image of all 5 
80GB raid disks.  This will let me attempt multiple recovery methods.)

Is there any order that raidreconf performs the operation?  Since it got 85% 
done, if it started at the beginning and progressed towards the end, it 
would have properly striped all the actual data and would be in the process 
of striping the free space added by the 5th disk.  IF this is the case, it 
should be possible to recover the operation.  I have tried running:

mdadm --create -c 32 -l 5 -n 5 /dev/hdg1 /dev/hdh1 /dev/hde1 /dev/hdf1 
/dev/hdb1

to recreate the superblocks (which raidreconf never got a chance to do), 
then mounting the resulting 5-disk array.  Reiser detects a 3.6 format 
journal (which is right) but won't mount.  Running reiserfsck spits out 
thousands of errors but actually manages to reconstruct some of the files, 
into the lost+found directory.  Files that are smaller than 32 Kbytes have a 
good success rate at recovery, probably because they fit in one raid chunk. 
Also, many of the larger files and directories have the proper file names, 
even if the data is scrambled.  This says to me that there's hope.  Do I 
have the order of the raid devices correct on the mdadm command line? 
Certainly an incorrect order would cause similar scrambling.

Also, I've tried to reverse raidreconf's actions by typing: raidreconf -o 
/etc/raidtab.new -n /etc/raidtab.old -m /dev/md0

I get this exact result, immediately.  It does not even start 
reconfiguration.

Old raid-disk 0 has 2442206 chunks, 78150592 blocks
Old raid-disk 1 has 2442206 chunks, 78150592 blocks
Old raid-disk 2 has 2442206 chunks, 78150592 blocks
Old raid-disk 3 has 2442128 chunks, 78148096 blocks
Old raid-disk 4 has 2442128 chunks, 78148096 blocks
New raid-disk 0 has 2442206 chunks, 78150592 blocks
New raid-disk 1 has 2442206 chunks, 78150592 blocks
New raid-disk 2 has 2442206 chunks, 78150592 blocks
New raid-disk 3 has 2442128 chunks, 78148096 blocks
Using 32 Kbyte blocks to move from 32 Kbyte chunks to 32 Kbyte chunks.
Detected 513804 KB of physical memory in system
A maximum of 2518 outstanding requests is allowed
---------------------------------------------------
I will SHRINK your old device /dev/md0 of 9768668 blocks
to a new device /dev/md0 of 7326540 blocks
using a block-size of 32 KB
Is this what you want? (yes/no): yes
Converting 9768668 block device to 7326540 block device
Allocated free block map for 5 disks
5 unique disks detected.

raid5_map_global_to_local: disk 3 block out of range: 2442128 (2442128) 
gblock = 9768514
Aborted

This might be an easier way to discover where the bug occurs because it's 
quick and repeatable.

Any help that anyone can provide will be much appreciated.  There is a 
budget allocated for the recovery of this data as well, so if anyone knows 
where I can send something like this, let me know.  I'm located in Canada 
but will ship to USA if needed. 



