From: "Graham Mitchell" <gmitch@woodlea.com>
Subject: device and partition alignment
Date: Sat, 5 Jun 2010 16:51:22 -0400
Message-ID: <000b01cb04f0$dbcf7720$936e6560$@woodlea.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've spent the last couple of days doing some googling, and my goodle-fu
seems to have deserted me at the moment.

I'm looking for some guides and/or words of wisdom on how to partition disks
with optimal alignment for RAID devices, and also the same for laying file
systems on those devices. I've just (re)created a 15 drive RAID 6 array, and
I've partitioned the disk, and I'm building the array on partition 1, which
I see starts at block 63 - I am guessing that this is non-optimal? Is there
a magic formula that can be used to work out what the optimal starting block
on the disk should be, so that we can avoid (or at least reduce) the
read/modify/write penalty on the physical drives?

Is there also a magic formula for doing the same for file systems laid down
on a RAID device? I guess that this would depend on the type of superblock
used, since there seems to be different locations (start, end, start +4k)
for it. 

I've read thru the manual pages (shocking I know), and I can't see anything
mentioned in there, and there's certainly no --optimal-alignment option
there (any chance for next version - lol).

Can someone point me in the direction of some reading about this please?

Thanks.


Graham

