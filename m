From: Eric Drew Hollins <gte275e@mail.gatech.edu>
Subject: Software RAID1 problem (bad superblock?)
Date: Tue, 28 Jan 2003 10:39:23 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.SOL.4.33.0301281038380.24659-100000@acmez.gatech.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK, first off I have a Debian 3.0 testing box running with kernel 2.4.20.
I have RAID1 working through software.  I have created a /dev/md0 device
from the /dev/hde1 and /dev/hdg1 partitions which are identically Maxtor
60GB hard drives with maxed out partitions that are connected to a Promise
UDMA133 controller.

So, I created the RAID1 device and it synced up correctly.  I also
changed the partition types to 0xfd (Linux auto RAID).  However, when
I reboot the computer, I get this error:

/dev/md0: THe filesystem size (according to the superblock) is 14658328
blocks.  THe physical size of the device is 14658304 blocks.  Either the
superblock or the partition table is likely to be corrupt!

I ran fsck manually and it didn't correct the problem.  I have created
this device twice now and I keep getting the same errors.  Does anyone
have any clue as to what is going on and how I can fix it.

BTW, I followed the Software RAID HOWTO when creating these devices if
that helps at all.  THanks for the help.



**** Eric Drew Hollins ****
**** Georgia Institute of Technology ****
**** 336198 GT Station, Atlanta, GA  30332 ****
**** W: http://jastermereel.org ****
**** C: 404.312.0685 ****



