From: "P. Gautschi" <linuxlist@gautschi.net>
Subject: Bad sequential performance of RAID5 with a lot of disk seeks
Date: Tue, 07 Oct 2014 06:44:49 +0200
Message-ID: <54336FC1.6080306@gautschi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've created a RAID5 on 5 identical SATA disks. Doing some performance measurements
with dd I get a disappointing performance.
A dd with bs=1M on a btrfs created on md0 transfers about 110 MB/s. (both read and write)
A dd on md0 has the same write speed but only about 20 MB/s on read.
In all of the tests I hear the disk constantly seeking. This was also the case
during creation of the array.
I also created a RAID4 to make sure that I doesn't get fooled by the stripe layout of RAID5.
Now I get about 110 MB/s for write and 230 MB/s for read on md0. But the constant
seeking is still present for both read and write and during creation of the array.

Why are the disk perform so many seek operations? I think a sequential access on md0 should
cause a sequential access on the individual disk.

I have to add that I did something unusual: I created the RAID4/5 with a chunk size of 4KiB.
The idea of this was that when I'm going to use btrfs with the default nodesize of 16KiB
all node write will fill a full stripe and there won't be any RMW at all. (both fortunate
for performance and integrity in a power loss situation.)
Nevertheless I think a sequential access on the array should cause a sequential access on the
disks for any chunk size if the read/write block size is a exact multiple of
the (numdisks-1)*chunk size.

Is there any explanation for the seeks and how do I get rid of them?

Patrick
