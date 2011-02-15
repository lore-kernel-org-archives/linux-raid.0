From: Gavin Flower <gavinflower@yahoo.com>
Subject: physical size of the device inconsistent with superblock, after RAID problems
Date: Mon, 14 Feb 2011 19:14:34 -0800 (PST)
Message-ID: <1581.38921.qm@web65110.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: ext3-users@redhat.com
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I would appreciate advice recovering from the following situation, after an aborted mdadm resizing operation and subsequent recovery actions:

/dev/md1: The filing system size (according to the superblock) is 76799952 blocks
The physical size of the device is 76799616
Either the superblock or the partition table is likely to be corrupt!

/dev/md1: UNEXPECTED INCONSISTENCY: RUN fsck manually
(i.e. without -a or -p options)


fsck.ext4 -f -n /dev/md1 output:

e2fsck 1.41.12 (17-May-2010)
The filesystem size (according to the superblock) is 76799952 blocks
The physical size of the device is 76799616 blocks
Either the superblock or the partition table is likely to be corrupt!
Abort? no

Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -9626 -(9728--9752) +(405344--405369)
Fix? no

/dev/md1: ********** WARNING: Filesystem still has errors **********

/dev/md1: 1693644/19202048 files (0.3% non-contiguous), 54273929/76799952 blocks


Note that original size, according mdadm, was not a multiple of 512KB, so I reshaped it to be the largest multiple or 512KB less than the original size using the -size option of mdadm.  So my second attempt to reshape, using the 512 chunk size, started okay.  The previous chunk size was 64KB.

Note I am using Fedora 14, up-to-date as of Friday February 11th, and that there are 5X500KB drives, with 3 RAID-6 arrays:
/dev/md0 swap
/dev/md1 mostly user data (the problematic one)
/dev/md2 distribution & O/S files
plus /boot on a non-RAID ext4 partition

Sequence of events:
Reshaped /dev/md1 using mdadm, without first reducing size of the ext4 filesystem.

The process of reshaping /dev/md1 was about 20% through when I killed it.

System appeared okay.

I rebooted a few minute later, but shortly after I selected the kernel, it stopped, and I dropped into a shell.

With the help of Neil Brown, I made some progress and /dev/md1 reshaping appeared to have completed without error.

However, on the next reboot I got the INCONSISTENCY message.

Will it be safe to simply accept fsck's offer to fix, or are there other things I should do?


Thanks,
Gavin 

--
All Adults share the Responsibility
to help Raise Today's Children,
for they are Tomorrow's Society!


      
