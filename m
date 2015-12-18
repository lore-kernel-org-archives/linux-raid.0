From: Marc Smith <marc.smith@mcc.edu>
Subject: RAID10 Write Performance
Date: Fri, 18 Dec 2015 13:43:02 -0500
Message-ID: <CAHkw+LdtZY=d6kCtaTe5Uu8nNXOgF+yCAjJeHWJ2TrVAuNoDeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm testing a (24) slot SSD array (Supermicro) with MD RAID. The setup
consists of the Supermicro chassis, (24) Pliant LB406M SAS SSD drives,
(3) Avago/LSI SAS3008 SAS HBAs, and (2) Intel Xeon E5-2660 2.60GHz
processors.

The (24) SSDs are directly connected (pass-through back-plane) to the
(3) SAS HBAs (eight drives per HBA) with no SAS expanders.

I'm planning to use RAID10 for this system. I started by playing with
some performance configurations, I'm specifically looking at random IO
performance.

The test commands I've been using with fio are the following:
4K 100% random, 100% READ: fio --bs=4k --direct=1 --rw=randread
--ioengine=libaio --iodepth=16 --numjobs=16 --name=/dev/md0
--runtime=60
4K 100% random, 100% WRITE: fio --bs=4k --direct=1 --rw=randwrite
--ioengine=libaio --iodepth=16 --numjobs=16 --name=/dev/md0
--runtime=60

As a benchmark, I initially tested all twenty-four drives using RAID0;
using a 8K chunk size and here are the numbers I got:
4K random read: 645,233 IOPS
4K random write: 309,879 IOPS

Not too shabby... obviously these are just for bench-marking, the plan
is to use RAID10 for production.

So, I won't go into the specifics of all the tests, but I've tried
quite a few different RAID10 configurations: Nested RAID 10 (1+0) -
RAID 0 (stripe) built with RAID 1 (mirror) arrays, Nested RAID 10
(0+1) - RAID 1 (mirror) built with RAID 0 (stripe) arrays, and
"Complex" RAID 10 - Near Layout / 2.

All of these yield very similar results using (12) of the disks spread
across the (3) HBAs. As an example:
Nested RAID 10 (0+1) - RAID 1 (mirror) built with RAID 0 (stripe) arrays
For the (2) stripe sets (2 disks per HBA, 6 total per set):
mdadm --create --verbose /dev/md0 --level=stripe --raid-devices=6
--chunk=64K /dev/sda1 /dev/sdb1 /dev/sdi1 /dev/sdj1 /dev/sdq1
/dev/sdr1
mdadm --create --verbose /dev/md1 --level=stripe --raid-devices=6
--chunk=64K /dev/sdc1 /dev/sdd1 /dev/sdk1 /dev/sdl1 /dev/sds1
/dev/sdt1
For the (1) mirror set (consisting of the 2 stripe sets):
mdadm --create --verbose /dev/md2 --level=mirror --raid-devices=2
/dev/md0 /dev/md1

Running the random 4K performance tests described above yields the
following results for the RAID10 array:
4K random read: 276,967 IOPS
4K random write: 643 IOPS


The read numbers seem in-line with what I expected, but the writes are
absolutely dismal. I expect them not be where the read numbers are,
but this is really, really low! I gotta have something configured
incorrectly, right?

I've experimented with different chunk sizes, and haven't gotten much
of a change in the write numbers. Again, I've tried several different
variations of a "RAID10" configuration (nested 1+0, nested 0+1,
complex using near/2) and all yield very similar results: Good read
performance, extremely poor write performance.

Even the throughput when doing a sequential test with the writes is
not where I'd expect it to be, so something definitely seems to be up
when mixing RAID levels 0 and 1. I didn't explore all the extremes of
the chunk sizes, so perhaps its as simple as that? I haven't tested
the "far" and "offset" layouts of RAID10 yet, but I'm not hopeful its
going to be any different.


Here is what I'm using:
Linux 3.14.57 (vanilla)
mdadm - v3.3.2 - 21st August 2014
fio-2.0.13


Any ideas or suggestions would be greatly appreciated. Just as a
simple test, I created a RAID5 volume using (4) of the SSDs and ran
the same random IO performance tests:
4K random read: 169,026 IOPS
4K random write: 12,682 IOPS

Not sure with the default RAID5 mdadm creation command that we get any
write cache, but we're getting ~ 12K IOPS with RAID5. Not great, but
when compared to the 643 IOPS with RAID10...


Thanks in advance!


--Marc
