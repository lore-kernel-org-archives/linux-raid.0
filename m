From: Chris Allen <chris@cjx.com>
Subject: Large single raid and XFS or two small ones and EXT3?
Date: Thu, 22 Jun 2006 20:11:56 +0100
Message-ID: <449AEB7C.6040108@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear All,

I have a Linux storage server containing 16x750GB drives - so 12TB raw 
space.

If I make them into a single RAID5 array, then it appears my only
choice for a filesystem is XFS - as  EXT3 won't really handle partitions
over 8TB.

Alternatively, I could split each drive into 2 partitions and have 2 RAID5
arrays, then put an EXT3 on each one.

Can anybody advise the pros and cons of these two approaches with
regard to stability, reliability and performance? The store is to be used
for files which will have an even split of:

33% approx 2MB in size
33% approx 50KB in size
33% approx 2KB in size


Also:

- I am running a 2.6.15-1 stock FC5 kernel. Would there be any RAID 
benefits in
me upgrading to the latest 2.6.16 kernel? (don't want to do this unless 
there is
very good reason to)


- I am running mdadm 2.3.1. Would there be any benefits for me in 
upgrading to
mdadm v2.5?

- I have read good things about bitmaps. Are these production ready? Any 
advice/caveats?

Many thanks for reading,

Chris Allen.
