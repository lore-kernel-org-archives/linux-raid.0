From: Chris Allen <chris@cjx.com>
Subject: Multiple raids on one machine?
Date: Sun, 25 Jun 2006 23:37:01 +0100
Message-ID: <449F100D.6030509@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Back to my 12 terabyte fileserver, I have decided to split the storage 
into four partitions
each of 3TB. This way I can choose between XFS and EXT3 later on.

So now, my options are between the following:

1. Single 12TB /dev/md0, partitioned into four 3TB partitions. But how do
I do this? fdisk won't handle it. Can GNU Parted handle partitions this big?

2. Partition the raw disks into four partitions and make 
/dev/md0,md1,md2,md3.
But am I heading for problems here? Is there going to be a big 
performance hit
with four raid5 arrays on the same machine? Am I likely to have dataloss 
problems
if my machine crashes?

Thanks for listening...


