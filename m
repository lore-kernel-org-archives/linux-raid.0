From: Maurice Hilarius <maurice@harddata.com>
Subject: MD devices renaming or re-ordering question
Date: Thu, 13 Sep 2007 12:43:51 -0600
Message-ID: <46E984E7.1080903@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi to all.

I wonder if somebody would care to help me to solve a problem?

I have some servers.
They are running CentOS5
This OS has a limitation where the maximum filesystem size is 8TB.

Each server curr3ently has a  AMCC/3WARE 16 port SATA controllers. Total
of 16 ports / drives
I am using 750GB drives.

I am exporting the drives as single, NOT as hardware RAID
That is due to the filesystem and controller limitations, among other
reasons.

Each server currently has 16 disks attached to the one controller

I want to add a 2nd controller, and, for now, 4 more disks on it.

I want to have the boot disk as a plain disk, as presently configured as
sda1,2,3

The remaining 15 disks are configured as :
sdb1 through sde1 as md0 ( 4 devices/partitions)
sdf1 through sdp1 as md1 (10 devices/partitions)
I want to add a 2nd controller, and 4 more drives, to the md0 device.

But, I do not want md0 to be "split" across the 2 controllers this way.
I prefer to do the split on md1

Other than starting from scratch, the best solution would be to add the
disks to md0, then to "magically" turn md0 into md1, and md1 into md0

So, the question:
How does one make md1 into md0, and vice versa?
Without losing the data on these md's ?

Thanks in advance for any suggestions.



-- 
Regards, Maurice


/09 F9 11 02 9D 74 E3 5B D8 41 56 C5 63 56 88 C0/

/1001 11111001 00010001 00000010 10011101 01110100 11100011 01011011
11011000 01000001 01010110 11000101 01100011 01010110 10001000 11000000/

/10 base 13,256,278,887,989,457,651,018,865,901,401,704,640/
