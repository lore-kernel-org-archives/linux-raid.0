From: "Sean Kormilo" <skormilo@nortelnetworks.com>
Subject: Expanding size of existing raid1 md device
Date: 24 Apr 2003 14:48:03 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1051210082.2852.65.camel@pcary03q.ca.nortel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I'm wondering if there is any way to do the following...

Assume I've got a system with 2 18GB disks. Each disk has 2 partitons
which are then setup as mirrored md devices.
/dev/md0 uses small 100MB partitions on each drive
/dev/md1 uses the rest of each disk (ie: ~17.9GB)

I'd like to be able to upgrade the system to use 36GB disks, such that
the /dev/md1 partition expands to take up the rest of the additional
space provided by the 36GB disk.

So, the process might look something like:
- fail and remove the partition for both md arrays
- remove 1 of the 18GB disks
- insert new 36GB disk
- partition 36GB disk with 100MB partition for /dev/md0
- partition 36GB disk with 35.9GB partition for /dev/md1
- hotadd the 36GB disk partitions so that it syncs with 18GB disk
- wait for sync to complete
- fail and remove the partitions on both md arrays on the 18GB disk
- remove the 18GB disk
- insert new 36GB disk
- partition 36GB disk with 100MB partition for /dev/md0
- partition 36GB disk with 35.9GB partition for /dev/md1
- hotadd the 36GB disk partitions so that it syncs with the other 36GB
disk

Having tried this, it works except that /dev/md1 does not make use of
the additional space provided by the 36GB disks even though the
partitions on both disks are larger. It appears to me that it is using
the value from the superblock when the array was created (which makes
sense).

Is there some way to force the md driver to expand to use the maximum
size available based on the disks/partitions in the array? Perhaps from
mdadm? Or is some kind of patch to the kernel required to make this
work? If so, any pointers as to where I'd look?

Thanks!

Sean.




-- 

Sean C. Kormilo, STORM Software Architect, Nortel Networks
              email: skormilo@nortelnetworks.com
  

