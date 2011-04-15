From: Michael Sallaway <michael@sallaway.com>
Subject: device mapper, snapshots, and merging
Date: Fri, 15 Apr 2011 15:07:40 +1000
Message-ID: <4DA7D29C.4030606@sallaway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi linux-raid,

I'm not sure if this is the best forum to ask, but I figured it's a 
result of a RAID issue, and people here have probably tried something 
similar in the past. :-)

I had array integrity issues in the last few days, and I'm in the 
process of fixing it all up. I'm using LVM to allocate the array (a 
12-drive RAID-6).

To test the recovery efforts to ensure nothing too crazy will happen, 
I've made device-mapper copy-on-write snapshots of the filesystems that 
I'm running fsck over. Most of the filesystems are fine, and if I have 
problems I check if it will be OK before re-running the fsck again on 
the underlying (real) device. However, the largest volume has taken 24 
hours so far in the fsck (and I'm expecting probably 48, at this rate), 
so I don't want to have to rerun it all over again on the underlying device.

So, my question is, how do I merge that back to the underlying device 
from the snapshot?

I've been reading the kernel documentation 
(http://www.kernel.org/doc/Documentation/device-mapper/snapshot.txt), 
and I see the 'snapshot-merge' target, but I'm not 100% clear on what I 
should do with it. At the moment, my table definition for the COW 
snapshot is:

0 25868894208 snapshot /dev/vg_data/data /dev/loop2 p 64

(where /dev/loop2 is the zero'd file that I'm using as a COW buffer).  
If I understand it correctly, do I stop the device-mapper device 
(`dmsetup remove cow-data`), and then change the table entry to:

0 25868894208 snapshot-merge /dev/vg_data/data /dev/loop2 p 64

then create the device again (`dmsetup create cow-data <table-file>`)?  
If so, how do I know when all the changes get merged? when do I stop the 
COW device, and resume using the real device?

Thanks in advance for any pointers anyone can give. I appreciate the 
help, and if I'm in the wrong list, please let me know the best place to 
ask. :-)

Cheers,
Michael
