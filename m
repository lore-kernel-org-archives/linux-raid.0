From: Felix Bellaby <member@bellaby.freeserve.co.uk>
Subject: RAID10 overwrites partition tables
Date: Fri, 26 Nov 2004 18:28:20 +0100 (CET)
Message-ID: <10578812.1101490100216.JavaMail.www@wwinf3001>
Reply-To: member@bellaby.freeserve.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

   	 mdadm --level 10 does not seem to respect disk partition boundaries.

Whilst trying to construct a small RAID10 array on a workstation, I naturally attempted
to set the array up over partitions to leave somewhere for grub to access the kernel.
Using partitions also assists with booting Fedora 3 as it relies on RAID autodetection
and partition labels in its standard initial ram disk.

However, the RAID10 seems to overwrite some of the partition tables.

For example, configuring a RAID10 array over 3 partitions as follows:

       mdadm --create /dev/md0 --level 10 --raid-devices 3 \
               /dev/sda1 /dev/sdb1 /dev/sdc1

seems to overwrite the partition tables for the disks in the
same way as configuring RAID10 over the complete disks:

       mdadm --create /dev/md0 --level 10 --raid-devices 3 \
               /dev/sda /dev/sdb /dev/sdc

A more detailed example:

       echo ',,fd' | sfdisk /dev/sda
       echo ',,fd' | sfdisk /dev/sdb
       echo ',,fd' | sfdisk /dev/sdc

       mdadm --create /dev/md0 --level 10 --raid-devices 3 \
               /dev/sda1 /dev/sdb1 /dev/sdc1

       mke2fs /dev/md0

       sfdisk -d /dev/sda
       sfdisk -d /dev/sdb
       sfdisk -d /dev/sdc

One of the partition tables in the above example will be replaced with
the start of the second chunk of the ext2 fs, just as one would expect
with an array configured over /dev/sda, dev/sdb and /dev/sdc.

The problem appears consistently on my test system (minimal Fedora 3 on
an NForce3 system using the sata_nv.ko device driver). I have had the
same results with a separate, identical system, and when using various
custom 2.6.9 kernels. However, the problems do not appear with RAID5.

The code in raid10.c is probably to blame. A cursory examination suggests
that raid10.c accesses the configured devices using very similar code to
raid1.c (where the problem might go unnoticed) but rather differently from
raid5.c.

Felix


-- 

Whatever you Wanadoo:
http://www.wanadoo.co.uk/time/

This email has been checked for most known viruses - find out more at: http://www.wanadoo.co.uk/help/id/7098.htm
