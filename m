From: Maurice Hilarius <maurice@harddata.com>
Subject: deliberately degrading RAID1 to a single disk, then back again
Date: Tue, 26 Jun 2007 12:01:15 -0600
Message-ID: <4681546B.4030709@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Linux, Raid lista" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good day all.

Scenario:
Pair of identical disks.
partitions:
Disk 0:
/boot - NON-RAIDed
swap
/  - rest of disk

Disk 01
/boot1 - placeholder to take same space as /boot on disk0 - NON-RAIDed
swap
/  - rest of disk

I created RAID1 over / on both disks, made /dev/md0

From time to time I want to "degrade" back to only single disk, and turn
off RAID as the overhead has some cost
From time to time I want to restore to RAID1 function, and re-synch the
pair to current.

Yes, this is a backup scenario..

Are there any Recommendations ( with mdadm syntax)  please?





-- 

-- 

Regards,
	Maurice
09 F9 11 02 9D 74 E3 5B D8 41 56 C5 63 56 88 C0

1001 11111001 00010001 00000010 10011101 01110100 11100011 01011011 11011000 01000001 01010110 11000101 01100011 01010110 10001000 11000000

10 base 13,256,278,887,989,457,651,018,865,901,401,704,640 


