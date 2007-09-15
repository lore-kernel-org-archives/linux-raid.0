From: Jordan Russell <jr-list-2007@quo.to>
Subject: MD RAID1 performance very different from non-RAID partition
Date: Sat, 15 Sep 2007 00:28:07 -0500
Message-ID: <46EB6D67.1000802@quo.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(Kernel: 2.6.18, x86_64)

Is it normal for an MD RAID1 partition with 1 active disk to perform
differently from a non-RAID partition?

md0 : active raid1 sda2[0]
      8193024 blocks [2/1] [U_]

I'm building a search engine database onto this partition. All of the
source data is cached into memory already (i.e., only writes should be
hitting the disk).
If I mount the partition as /dev/md0, building the database consistently
takes 18 minutes.
If I stop /dev/md0 and mount the partition as /dev/sda2, building the
database consistently takes 31 minutes.

Why the difference?

The "fast" time seen when the partition is mounted as /dev/md0 actually
creates a serious problem: the kernel apparently flushes dirty pages so
aggressively that other processes attempting to write to the same
partition during the database build become blocked for several
minutes(!) at a time.

When mounted as /dev/sda2, that doesn't happen: other processes writing
to the same partition are blocked for no more than a few seconds at a time.

I don't know if it's relevant, but the results from iostat when writing
large chunks of data to RAID1 partitions seem somewhat curious, as if MD
is telling the I/O layer "all done!" before it's actually finished
writing the data out to the member disks. Note the unrealistically high
kB_wrtn/s numbers on md0 in the following test. (And why does it show
50000 tps?)

# iostat -dk 1 md0 sda

# fgrep MemTotal /proc/meminfo
MemTotal:      2059784 kB
# cat /proc/sys/vm/dirty_ratio
40
# cat /proc/sys/vm/dirty_background_ratio
10
# dd if=/dev/zero of=/testpart/bigfile bs=1M count=400

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              91.00         0.00     46592.00          0      46592
md0           48692.00         0.00    194768.00          0     194768

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              99.00         0.00     50176.00          0      50176
md0               0.00         0.00         0.00          0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              96.00         0.00     49152.00          0      49152
md0               0.00         0.00         0.00          0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              86.00         0.00     44032.00          0      44032
md0               0.00         0.00         0.00          0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              96.00         0.00     48160.00          0      48160
md0           51636.00         0.00    206544.00          0     206544

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              95.05         0.00     48665.35          0      49152
md0               0.00         0.00         0.00          0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              92.00         0.00     46596.00          0      46596
md0               0.00         0.00         0.00          0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              95.96         0.00     48614.14          0      48128
md0               0.00         0.00         0.00          0          0

...

-- 
Jordan Russell
