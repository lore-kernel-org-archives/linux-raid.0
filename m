From: bugzilla@watkins-home.com
Subject: Can't start raid 5 when device names have changed
Date: Thu, 9 Jan 2003 22:35:16 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200301100335.h0A3ZHt02424@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is reported on http://bugzilla.redhat.com/bugzilla as bug # 81258

Description of problem:
I have a raid 5 with 4 disks.  sda1, sda2, sda3, sda4
I have added 2 disks to my system.
The new disks are sdb and sdd.  At first they did not have a valid partion 
table.  I got this error on both disks:
md: could not lock sdb1, zero-size? Marking faulty.
md: could not import sdb1, trying to run array nevertheless.
 [events: 00000004]
md: could not lock sdd1, zero-size? Marking faulty.
md: could not import sdd1, trying to run array nevertheless.

That should not be a problem because the raid 5 disks are now sda1, sdc1, sde1 
and sdf1.

I did change raidtab before I shutdown to add the new disks.  The system seems 
to ignore raidtab for existing arrays.  Must only use the file when you use 
mkraid.

I have since partitioned the 2 disks sdb and sdd with type fd.
raidstart still fails.

I have created a raid 1 array on the 2 disks sdb and sdd.  I did not need to 
use the force option with mkraid.

The OS is on 2 IDE disks (hda and hdb).

/dev/md0 is swap
/dev/md1 is /
/dev/md2 is /boot
/dev/md3 is the problem array.
/dev/md4 is the array on the 2 new disks.
Here is a copy of my raidtab file:
raiddev             /dev/md1
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hda2
    raid-disk     0
    device          /dev/hdb3
    raid-disk     1

raiddev             /dev/md2
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hda1
    raid-disk     0
    device          /dev/hdb1
    raid-disk     1

raiddev             /dev/md0
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hda3
    raid-disk     0
    device          /dev/hdb2
    raid-disk     1

raiddev             /dev/md3
raid-level                  5
parity-algorithm            left-symmetric
nr-raid-disks               4
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/sda1
    raid-disk     0
    device          /dev/sdc1
    raid-disk     1
    device          /dev/sde1
    raid-disk     2
    device          /dev/sdf1
    raid-disk     3

raiddev             /dev/md4
raid-level                  1
#parity-algorithm            left-symmetric
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/sdb1
    raid-disk     0
    device          /dev/sdd1
    raid-disk     1

I did remove the 2 new disks.  Then my device names were back to normal.  The 
array /dev/md3 did come up after a re-boot.  /dev/md4 did not (as expected, 
the drives had no power)!

Please help!  I can resolve the problem by addressing the new disks so they 
will be sde and sdf.  But this seems like it could be a major problem for 
others in the future.  You should be able to add disks to a system without 
such problems.

I will keep the disks configured like this for a while.  If someone wants me 
to try something I will.  If I lose data I don't care.  I have 2 or more 
backups.

Thanks.

 


------- Additional Comment #1 From Mr Watkins on 2003-01-09 22:20 -------  

I will be trashing the array soon.  I will re-create it with 7 disks.  If 
anyone wants to debug this issue, they need to start within the next few 
days.  I may play first, add a hot spare, fail a drive, raidhotadd.  Stuff 
like that.  I want to determine if this stuff is top notch, or not.
