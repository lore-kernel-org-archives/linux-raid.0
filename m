From: Michel <michel@ket.kth.se>
Subject: Performance difference between two raid0 arrays on same drives?
Date: Fri, 11 Jul 2003 18:13:26 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200307111813.26177.michel@ket.kth.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I have set two raid0 arrays on two hardrives, using 2x2 partitions. I did a 
benchmark of the resulting arrays and one is much slower than the other one. 
I used bonnie++ and hdparm for the tests. It showed that /dev/md0 is 30% 
slower than /dev/md1. 
/dev/md1 is really close to twice the performance of a single drive.
I set the arrays with the same parameters. md0 is built from 2x 5 Gb while md1 
is built from 2x2 Gb. The harddrives have the same partition table. md0 is 
the closest to the begining of the drives.
The filessystem is Reiserfs on both arrays.
Everything works well, except i am curious about such a difference in 
performances, since the arrays share the same hardware. 
I am new to linux raid, i do not know if this is normal or weird.
Thanks for any help!

/etc/raidtab:
raiddev /dev/md0
	raid-level 0
	nr-raid-disks 2
	persistent-superblock 1
	chunk-size 32
	device /dev/hde3
	raid-disk 0
	device /dev/hdg3
	raid-disk 1

raiddev /dev/md1
	raid-level 0
	nr-raid-disks 2
	persistent-superblock 1
	chunk-size 32
	device /dev/hde5
	raid-disk 0
	device /dev/hdg5
	raid-disk 1

