From: bugzilla@watkins-home.com
Subject: 14 disks for RAID 5 question
Date: Thu, 13 Nov 2003 15:01:16 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200311132001.hADK1GE32158@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am setting up an array with 14 disks.
Should I create one 14 disk RAID 5 array?
Or two 7 disk RAID 5 arrays, and then RAID 0 them together?
I know I would have less overall space with 2 RAID 5 arrays.  This is not
an issue.

I guess the real question is: does RAID five have a sweet spot related to
the number of disks?

Is there chunk size sweet spot?  Does it very with number of disks?

System: P3-500 (2 processors)
	512 Meg ram
	3 SCSI cards for disks.
		1 internal LVD (80 meg/second)
			2 disks (for OS) mirrored
			1 disk for spare
		1 external LVD (80 meg per second)
			7 disks
		1 external ultra-wide (40 meg per second)
			7 disks

All disks are 18 Gig.
Will be using RedHat 9
I plan to alternate the disks on each SCSI bus.  So the array would
use disk in an order simular to this: a0, b0, a1, b1, a2, b2, ...
This should help balance the load on the 2 SCSI buses.

I could not find any performance info related to this subject.
Also, could not find much about chunk size.

I did a simple dd test of these disks using a block size
of 16, 32, 64, 128, 256, 512 and 1024K.  16 and 32K were best for overall
speed and CPU usage.  It got worse as the block size increased.  I work with
HP-UX systems alot.  On HP systems, as block size increases CPU load decreases.
But HP-UX has raw (character) devices.  My dd test was with RedHat 8.0.

Thanks for any info,

Guy
