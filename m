From: Brad Campbell <brad@wasp.net.au>
Subject: Debugging a strange array corruption
Date: Tue, 14 Dec 2010 16:10:07 +0800
Message-ID: <4D07265F.8060109@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

I have a 10 x 1TB drive RAID-6 here. It's been great for ages, but recently I've seen nasty random 
corruption across the entire array that I can not pin down.

The machine also has a number of RAID-1 and a RAID-5 which are all behaving perfectly.

The machine has 16GB of RAM, so all my read tests are done with dd bs=1G count=20 to make sure I'm 
actually hitting the disk somewhere.

The array is partitioned into three approximately equal partitions.

If I do something like -

for i in `seq 3` ; do dd if=/dev/md0p1 bs=1G count=20 | md5sum ; done

- I get three completely different checksums

The filesystems are unmounted and the array is idle.

I've run the same test individually on all 10 disks in the array and they all appear to give 
consistent data. Reading anything from the array gives me mostly correct data with intermittent garbage.

I've tried both a 2.6.36.[12] kernel, and I'm currently running 2.6.37-rc5-git3 with the same odd 
results.

All the disks pass long SMART tests. They all checksum correctly from end to end with repeated 
sequential runs.

No libata errors in the logs.

The drives are all on separate channels. 8 are on a pair of Marvell 88SX7042 controllers and 2 are 
on a SIL3132. This has occurred since I upgraded the mainboard (and kernel at the same time - 
nothing like throwing more variables in the mix) and its effects were subtle enough that I missed 
them until it had successfully rotated out all of my good backups with broken data. Lesson learned.

I'm stumped and I don't even know where to begin. I've never seen something like this happen without 
a bad disk, controller or cable and they are easy to diagnose.

Regards,
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
