From: "Scott D'Vileskis" <sdvileskis@gmail.com>
Subject: Replace RAID devices without resorting to degraded mode?
Date: Tue, 11 Mar 2014 13:36:11 -0400
Message-ID: <CAK_KU4ZfsCOyZxgkxLC7AFOJ2XEvcHi-Gr7itv4q_pPOQbaAYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello--
I have been using Linux RAID for about the last 12 years or so and
have endured dozens of RAID migrations, swapping of disks, growing &
shrinking arrays, transforming partitions, etc. I consider myself
pretty well versed in RAID0/1/5, and more recently RAID6.

I would like to grow my RAID5 array to fill larger devices (larger
partitions, actually). In the past, the typical method of replacing
all the disks/partitions with larger ones is to:
1) Add a larger drive/partition as a hot spare
2) Fail a disk
3) Wait for the rebuild/resync
4) Repeat for each disk in the array
5) After all drives/partitions replaced and resynced, Grow the device
and wait for a resync of the new space.
6) Resize the filesystem
While this typically works flawlessly, it does require the array to be
operated in degraded mode for the entire operation, which many would
consider risky.

Does Linux MD RAID support a method of hot replacing a disk WITHOUT
having to resort to degraded mode?

Scenario: I have 6 reliable, perfectly functioning Samsung 2TB drives,
all recently passed SMART tests, zero reallocated sectors, etc.
--One drive is a spare
--Five drives are each partitioned into 500G and 1500G. The five 1500G
partitions make up a RAID5. The 500G partitions were used in a
different RAID array; I am abandoning the 500G partitions and
reclaiming the space, but I want to transform RAID5 to use all the
space on each drive. (And then probably convert to a RAID6)

IF-- the 1500G partitions were at the beginning of the drive, I could
simply (and I believe I have done this in the past):
1) Stop the RAID array
2) Delete both partitions, create a single partition with the same
offset (On a 4K sector boundary for those picky about the details)
3) Restart the array to check for errors/mistakes (It should come up clean)
4) Repeat steps 1-3 for additional drives
5) Grow the array (Resync starts at the *new space)
6) Resize the filesystem

However, in my situation, my RAID5 partitions start in the middle of
the drive, complicating that slightly... Fortunately, I have a spare
drive or two to assist.
Would the following off-line scenario work?
1) Stop RAID array
2) Clone one of the RAID devices to a larger disk (Using dd)
3) Remove the old RAID device from the system
4) Restart the RAID array in readonly mode (to test that the clone was
successful without marking the array as dirty, otherwise, revert to
the removed disk)
5) Optional: Restart the RAID array in readwrite mode to confirm
6) Repeat 1-5 for each additional disk
7) Grow the array (Resync starts at the new space)
8) Grow the filesystem

Thanks!
