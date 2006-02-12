From: it <itech@kfa.org>
Subject: block level vs. file level
Date: Sun, 12 Feb 2006 11:31:07 -0800
Message-ID: <43EF8CFB.5080403@kfa.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

There seem to be two ways of doing software RAID, and I have had trouble 
finding information on this.

First, the raid is done with partitions, for example /dev/sda1 and 
/dev/sdb1 are partitioned as Linux type and the mirroring is done then 
between the two partitions. The writing takes place on a filesystem 
level, and the partition table is not actually mirrored, because it's 
not on /dev/sda1 or /dev/sdb1.

The hardware raid does the mirroring on the block level, so it's 
actually /dev/sda mirroring /dev/sdb - the whole drive, and not 
partitions. There is a way to set this up on software raid. It takes 
more configuration tweaking, but the mirroring then includes the 
partition table as well. This way, if a drive fails, one can replace it 
without pre-partitioning it.

This also raises another point, which is relevant for both cases - same 
exact models of hard disks have different number of cylinders, so if a 
RAID partition is created on a larger drive it cannot be mirrored to a 
smaller drive.

Does anyone have any experience with this?

A.
