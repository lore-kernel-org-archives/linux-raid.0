From: Doug Dumitru <doug@easyco.com>
Subject: Re: RAID5 Performance
Date: Tue, 26 Jul 2016 22:36:31 -0700
Message-ID: <CAFx4rwR0+wR_0GXh3Y7j1hZyv0_Gy7b4OD-D2+bfxV9MRp+b3Q@mail.gmail.com>
References: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 26, 2016 at 7:24 PM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
> Hi all,
>
> I know, age old question, but I have the chance to change things up a bit,
> and I wanted to collect some thoughts/ideas.
>
> Currently I am using 8 x 480GB Intel SSD in a RAID5, then LVM on top, DRBD
> on top, and finally iSCSI on top (and then used as VM raw disks for mostly
> windows VM's).
>
> My current array looks like this:
>
> /dev/md1:
>         Version : 1.2
>   Creation Time : Wed Aug 22 00:47:03 2012
>      Raid Level : raid5
>      Array Size : 3281935552 (3129.90 GiB 3360.70 GB)
>   Used Dev Size : 468847936 (447.13 GiB 480.10 GB)
>    Raid Devices : 8
>   Total Devices : 8
>     Persistence : Superblock is persistent
>
>     Update Time : Wed Jul 27 11:32:00 2016
>           State : active
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>            Name : san1:1  (local to host san1)
>            UUID : 707957c0:b7195438:06da5bc4:485d301c
>          Events : 2185221
>
>     Number   Major   Minor   RaidDevice State
>        7       8       65        0      active sync   /dev/sde1
>       13       8        1        1      active sync   /dev/sda1
>        8       8       81        2      active sync   /dev/sdf1
>        5       8      113        3      active sync   /dev/sdh1
>        9       8       97        4      active sync   /dev/sdg1
>       12       8       17        5      active sync   /dev/sdb1
>       10       8       49        6      active sync   /dev/sdd1
>       11       8       33        7      active sync   /dev/sdc1
>
> I've configured the following non-standard options:
>
> echo 4096 > /sys/block/md1/md/stripe_cache_size
>
> The following apply to all SSD's installed:
> echo noop > $disk/queue/scheduler
> echo 128 > ${disk}/queue/nr_requests
>
> What I can measure (at peak periods) with iostat:
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s wMB/s avgrq-sz
> avgqu-sz   await r_await w_await  svctm  %util
> sdi               0.00     0.00    0.00    0.00     0.00 0.00     0.00
> 0.00    0.00    0.00    0.00   0.00   0.00
> sda              78.00    59.00   79.00   86.00     0.74 0.52    15.55
> 0.02    0.15    0.20    0.09   0.15   2.40
> sdg              35.00    48.00   68.00   79.00     0.52 0.44    13.39
> 0.02    0.14    0.24    0.05   0.11   1.60
> sdf              46.00    65.00   86.00   98.00     0.76 0.58    14.96
> 0.03    0.17    0.09    0.24   0.09   1.60
> sdh              97.00    45.00   70.00  141.00     0.66 0.68    12.96
> 0.08    0.36    0.29    0.40   0.34   7.20
> sde             101.00    75.00   87.00   94.00     0.79 0.61    15.76
> 0.08    0.42    0.32    0.51   0.29   5.20
> sdb              85.00    54.00   94.00  102.00     0.84 0.56    14.62
> 0.01    0.04    0.09    0.00   0.04   0.80
> sdc              85.00    74.00   98.00  106.00     0.79 0.66    14.53
> 0.01    0.06    0.04    0.08   0.04   0.80
> sdd             230.00   199.00  266.00  353.00     2.19 2.11    14.24
> 0.18    0.28    0.23    0.32   0.16   9.60
> drbd0             0.00     0.00    0.00    2.00     0.00 0.00     4.50
> 0.08   38.00    0.00   38.00  20.00   4.00
> drbd12            0.00     0.00    1.00    1.00     0.00 0.00     7.50
> 0.03   14.00    4.00   24.00  14.00   2.80
> drbd1             0.00     0.00    0.00    2.00     0.00 0.03    32.00
> 0.09   44.00    0.00   44.00  22.00   4.40
> drbd9             0.00     0.00    2.00    0.00     0.01 0.00     8.00
> 0.00    0.00    0.00    0.00   0.00   0.00
> drbd2             0.00     0.00    0.00    0.00     0.00 0.00     0.00
> 0.00    0.00    0.00    0.00   0.00   0.00
> drbd11            0.00     0.00    0.00    0.00     0.00 0.00     0.00
> 0.00    0.00    0.00    0.00   0.00   0.00
> drbd3             0.00     0.00    4.00  197.00     0.02 1.01    10.47
> 7.92   41.03    0.00   41.87   4.98 100.00
> drbd4             0.00     0.00    0.00    0.00     0.00 0.00     0.00
> 0.00    0.00    0.00    0.00   0.00   0.00
> drbd17            0.00     0.00    1.00    0.00     0.00 0.00     8.00
> 0.00    0.00    0.00    0.00   0.00   0.00
> drbd5             0.00     0.00    0.00    7.00     0.00 0.03     8.00
> 0.22   30.29    0.00   30.29  28.57  20.00
> drbd19            0.00     0.00    0.00    0.00     0.00 0.00     0.00
> 0.00    0.00    0.00    0.00   0.00   0.00
> drbd6             0.00     0.00    2.00    0.00     0.01 0.00     8.00
> 0.00    0.00    0.00    0.00   0.00   0.00
> drbd7             0.00     0.00    0.00    0.00     0.00 0.00     0.00
> 0.00    0.00    0.00    0.00   0.00   0.00
> drbd8             0.00     0.00    0.00    0.00     0.00 0.00     0.00
> 0.00    0.00    0.00    0.00   0.00   0.00
> drbd13            0.00     0.00   90.00   44.00     1.74 0.38    32.35
> 1.72   13.46    0.40   40.18   4.27  57.20
> drbd15            0.00     0.00    2.00   33.00     0.02 0.29    17.86
> 1.40   40.91    0.00   43.39  28.34  99.20
> drbd18            0.00     0.00    1.00    3.00     0.00 0.03    16.00
> 0.08   21.00    0.00   28.00  21.00   8.40
> drbd14            0.00     0.00    0.00    0.00     0.00 0.00     0.00
> 0.00    0.00    0.00    0.00   0.00   0.00
> drbd10            0.00     0.00    0.00    0.00     0.00 0.00     0.00
> 0.00    0.00    0.00    0.00   0.00   0.00
>
> As you can see, the DRBD devices are busy, and slowing down the VM's,
> looking at the drives on the second server we can see why:
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s wMB/s avgrq-sz
> avgqu-sz   await r_await w_await  svctm  %util
> sdf              67.00    76.00   64.00  113.00     0.52 0.62    13.17
> 0.26    1.47    0.06    2.27   1.45  25.60
> sdg              39.00    61.00   50.00  114.00     0.35 0.56    11.38
> 0.45    2.76    0.08    3.93   2.71  44.40
> sdd              49.00    67.00   50.00  109.00     0.39 0.57    12.40
> 0.75    4.73    0.00    6.90   4.70  74.80
> sdh              55.00    54.00   52.00  104.00     0.42 0.51    12.12
> 0.81    5.21    0.23    7.69   5.13  80.00
> sde              67.00    67.00   75.00  129.00     0.56 0.65    12.13
> 0.94    4.59    0.69    6.85   4.24  86.40
> sda              64.00    76.00   58.00  109.00     0.48 0.61    13.29
> 0.84    5.03    0.21    7.60   4.89  81.60
> sdb              35.00    72.00   57.00  104.00     0.36 0.57    11.84
> 0.69    4.27    0.14    6.54   4.22  68.00
> sdc             118.00   144.00  228.00  269.00     1.39 1.50    11.92
> 1.21    2.43    1.88    2.90   1.50  74.40
> md1               0.00     0.00    0.00  260.00     0.00 1.70    13.38
> 0.00    0.00    0.00    0.00   0.00   0.00
>
> I've confirmed that the problem is that we have mixed two models of SSD (520
> series and 530 series), and that the 530 series drives perform significantly
> worse (under load) in comparison. Above, the two 520 series are sdf and sdg
> while the other drives are 530 series. So, we will be replacing all of the
> drives across both systems with 545s series 1000GB SSD's (which I've
> confirmed will operate same or better than the 520 series, sdc on the first
> machine above is one of these already).
>
> Over the years, I've learned a lot about RAID and optimisation, originally I
> configured things to optimise for super fast streaming reads and streaming
> writes, but in practice, the actual work-load is small random read/write,
> with the writes causing the biggest load.
>
> Looking at this:
> http://serverfault.com/questions/384273/optimizing-raid-5-for-backuppc-use-small-random-reads
>>
>>
>>  *
>>
>>     Enhance the queue depth. Standard kernel queue depth is OK for old
>>     single drives with small caches, but not for modern drives or RAID
>>     arrays:
>>
>>     echo 512 > /sys/block/sda/queue/nr_requests
>>
> So my question is should I increase the configured nr_requests above the
> current 128?

With your workload, it probably won't matter too much.  Really high
queue depths are great on paper, but hard to actually see.

>
> If the chunk size is 64k, and there are 8 drives in total, then the stripe
> size is currently 64k*7 = 448k, is this too big? My reading of the mdadm man
> page suggests the minimum chunk size is 4k ("In any case it must be a
> multiple of 4KB"). If I set the chunk size to 4k, then the stripe size
> becomes 28k, which means for a random 4k write, we only need to write 28k
> instead of 448k ?

This is not how a random write works.  If you are running raid-5
before the 4.4 kernel, you get the "old" read/modify/write algorithm.
If you write 4K, the system will read 4K from (n-2) drives, add in
your 4K to compute parity, and write 2 drives.  This is n-2 reads + 2
writes.  With the "new" logic in 4.4, you read the old contents of the
4K plus parity, and re-write the 4k plus parity, so there are 2 reads
and 2 writes.  With big arrays, the "new" logic can help quite a bit,
but the chatter rate is still high.  Note that the new logic is only
raid-5.  raid-6 cannot use the new logic and has to read the stripe
from every drive.

The stripe size impacts when the system does can avoid doing a
read/modify/write.  If you write a full stripe [ 64K * (n-1) ], and
the write is exactly on a stripe boundary, and you get lucky and the
background thread does not wake up at just the wrong time, you will do
the write with zero reads.  I personally run with very small chunks,
but I have code that always writes perfect stripe writes and stock
file systems don't act that way.

DRBD can saturate GigE without any problem with random 4K writes.  I
have a pair of systems here that pushes 110 MB/sec at 4K or 28,000
IOPS.  The target arrays needs to keep up, but that is another story.
My testing with DRBD is that it starts to peter out at 10Gig, so if
you want more bandwidth you need some other approach.  Some vendors
use SRP over Infiniband with software raid-1 as a mirror.  iSCSI with
iSER should give you similar results with RDMA capable ethernet.
Linbit (the people who write DRBD) have a non GPL extension to DRBD
that uses RDMA so you can get more bandwidth that way as well.

> The drives report a sector size of 512k, which I guess means the smallest
> meaningful write that the drive can do is 512k, so should I increase the
> chunk size to 512k to match? Or does that make it even worse?
> Finally, the drive reports Host_Writes_32MiB in SMART, does that mean that
> the drive needs to replace a entire 32MB chunk in order to overwrite a
> sector? I'm guessing a chunk size of 32M is just crazy though...

This is probably not true.  If the drive really had to update 512K at
a time, then 4K writes would be 128x wear amplification.  SSDs can be
bad, but usually not that bad.

>
> Is there a better way to actually measure the different sizes and quantity
> of read/writes being issued, so that I can make a more accurate decision on
> chunk size/stripe size/etc... iostat seems to show an average numbers, but
> not the number of 1k read/write, 4k read/write, 16k read/write etc...

The problem is that the FTL of the SSDs are a black box and as the
array gets bigger, the slowest drive dictates the array performance.
This is why the "big vendors" all map SSDs in the host and avoid or
minimize writing randomly.  I know of one vendor install that has 4000
VDI seats (using ESXI as compute hosts) from a single HA pair of 24
SSD shelves.  The connection to ESXI is FC and the hosts are HA with
an IB/SRP raid-1 link between them.  Unfortunately, you need 500K+
random write IOPS to pull this off, which I think is impossible with
stock parity raid, and very hard with raid-10.

>
> My suspicion is that the actual load is made up of rather small random
> read/write, because that is the scenario that produced the worst performance
> results when I was initially setting this up, and seems to be what we are
> getting in practice.
>
> The last option is, what if I moved to RAID10? Would that provide a
> significant performance boost (completely removes the need to worry about
> chunk/stripe size because we always just write the exact data we want, no
> need to read/compute/write)?

RAID-10 will be faster, but you pay for this with capacity.  It is
also a double-edged sword as SSDs themselves run faster if you leave
more free space on them, so RAID-10 absolutely might not be a lot
faster than RAID-5 with some space left over.  Also remember that free
space on the SSDs only counts if it is actually unallocated.  So you
need to trim the SSDs or start with a secure erased drive and then
never use the full capacity.  It is best to leave an empty partition
that is untouched.

> OR, is that read/compute overhead negligible since I'm using SSD and read
> performance is so quick?

The reads, especially with the pre 4.4 code or with raid-6 definitely
take their toll.  Most SSDs are also not quite symmetrical in terms of
performance.  If your SSD does 50K read IOPS and 50K write IOPS, it
will probably not do 25K reads and 25K writes concurrently, but
instead stop somewhere around 18K.  But your mileage may vary.  If you
have 8 drives that do 20 read/write symmetric, with new raid-5, each
4K write is 2 reads and 2 writes.  8 drives will give you 8*20K = 160K
reads and writes or 320K total OPS.  Each 4K write takes 4 OPS, so
your data rate ends up maxing out at 80K IOPS.  With the old raid-5
logic, you end up with 6 reads plus two writes per "OP", so you tend
to max out around 320K/(6+2) = 40K IOPS.  With more than 8 drives,
these computations tend to fall apart, so 24 SSD arrays are not 3x
faster than 8 SSD arrays, at least with stock code.

You also need to consider what raid does to the SSD FTL.  As you
chatter a drive, its wear goes up and its performance goes down.
Different SSD models can vary wildly, but again the rule of thumb is
keep as much free space as possible on the drives.  raid-5 or
mirroring is also 2:1 write amplification (ie, you are writing two
drives) and raid-6 is 3:1, on top of whatever the FTL write
amplification is at the time.

>
> For completeness, PV information:
>   PV Name               /dev/md1
>   VG Name               vg0
>   PV Size               3.06 TiB / not usable 2.94 MiB
>   Allocatable           yes
>   PE Size               4.00 MiB
>   Total PE              801253
>   Free PE               33281
>   Allocated PE          767972
>   PV UUID c0PIEb-tUka-zBk3-lcGM-H89s-ayde-hcMUBZ
>
> Any advice or assistance would be greatly appreciated.
>
> Regards,
> Adam
> --
> Adam Goryachev Website Managers www.websitemanagers.com.au
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Doug Dumitru
WileFire Storage.  http://www.wildfire-storage.com
