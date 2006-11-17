From: "Roger Lucas" <roger@planbit.co.uk>
Subject: Problem with RAID-1, inconsistent data returned if disks get out of sync
Date: Fri, 17 Nov 2006 14:35:48 -0000
Message-ID: <20061117143358.DAD2212EE5@bluewhale.planbit.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am running the 2.6.16.20 kernel what is otherwise a Debian Sarge system.  I have two identical SATA hard drives in the system.
Both have an identical boot partion at the start of the disks (/dev/sda1, /dev/sda2) and the remainder of the disks is used as
RAID-1 on which I have LVM for my root partition and some other partitions.

dromedary:~# uname -a
Linux dromedary 2.6.16.20.rwl2 #1 Wed Jul 26 12:52:43 BST 2006 i686 GNU/Linux
dromedary:~# lvm version
  LVM version:     2.02.14 (2006-11-10)
  Library version: 1.02.12 (2006-10-13)
  Driver version:  4.5.0
dromedary:~# mdadm --version
mdadm - v2.5.5 - 23 October 2006
dromedary:~#

As part of my backup process, I snapshot the data LV and make a copy of the snapshot to another machine's disk.  I take an SHA1
checksum of the snapshot so that I can verify its accuracy.

During this process, the results of the SHA1 checksum of the shapshot was changing between two values.  I tracked this down to a
single bit in the 10GB image which was returning 1/0, apparently randomly.

Checking the "/proc/mdstat" suggested that the RAID array was intact as did a more detailed check using "mdadm --detail /dev/md0",
so I spent a long time digging through the LVM configuration to try to find the problem.

After much digging, I found that by running the RAID-1 array in degraded mode with one disk, the erratic behaviour stopped and I got
a consistent value returned.  When I rebooted the system with just the other disk, so again running the RAID-1 array in degraded
mode, the erratic behaviour stopped but I got the other value returned.  This indicated that the problem was that the RAID array had
inconsistent data on its disks and was returning either disk's value when a read request was made, probably whichever got returned
first...

I have since rebuilt the RAID array by marking one of the disk as faulty then adding it as a spare again, thus causing the array to
rebuild.  The erratic behaviour has now stopped and everything is working properly again.

This confused me, as I was (prehaps wrongly) expecting that a RAID-1 array would detect not just hard disk errors but also soft disk
errors where the array returned inconsistent data from the two disks.

After more digging, I have found that it is considered "good practice" to regularly ask the array to check itself using the "echo
check > /sys/block/md0/md/sync_action" and then check the "/proc/mdstat" and "/sys/block/mdX/md/mismatch_cnt" files to determine the
results.

Is it in any way possible to make the array check both disks in the RAID-1 array when any data is read so that the returned data is
verified "live" and then automatically raise a warning somehow?  I appreciate that this would cause a reduction in performance, but
I am willing to have that in exchange for increased robustness and immediate notification of a disk problem.  

Thanks,

Roger


