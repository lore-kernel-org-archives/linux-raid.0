From: Joel Lilienkamp <joel.lilienkamp@earthlink.net>
Subject: resync performance drop after I/O in RAID 5
Date: 27 May 2004 13:16:30 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1085685390.19703.47.camel@w-jlilienk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We are observing a strange performance drop on resync after an I/O is
performed to a RAID5 device.  This is using the RAID5 / md support in
Linux 2.4.20.  It is observable on at least two different disk
controllers, so it doesn't appear to be a specific hardware limitation.

To reproduce:

(1) Create a RAID5 device, say /dev/md5, from four partitions on
different disks, chunk-size = 256.
(2) Observe resync performance vi 'cat /proc/mdstat'.  We are seeing
around 30MB/Sec on one controller, and 50+MB/sec on another.
(3) Do a small read from the RAID device, such as 'dd if=/dev/md5
of=/dev/null bs=1024 count=1'.
(4) Re-observe resync performance vi 'cat /proc/mdstat'.  After the I/O,
we are seeing resync drop by about 60%, to 11-12MB/Sec on one
controller, and 15MB/sec on the other.

The performance never recovers to the previous higher level, short of a
reboot (which starts resync from the beginning) or recontructing the
device.  I/O to the individual sub-partitions does not impact this.  We
do not observe similar issues with RAID1.

I ahve scoured the various lists and postings to find anything about
this, but I haven't located anything.

Thanks very much for any help that can be offered.

Joel Lilienkamp




