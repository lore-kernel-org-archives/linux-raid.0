From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID and LVM alignment when expanding PVs
Date: Sun, 28 Oct 2012 01:34:43 -0500
Message-ID: <508CD203.6000209@hardwarefreak.com>
References: <CAEQBofHr-Fz=9zuR7WviZ4SRouEygOuX=WQRmg___ErMQyrqnw@mail.gmail.com> <508C9661.2070505@hardwarefreak.com> <CAEQBofFwe6rt6FrQb6hAX+kbd+jFG3K0Pso3zdj4qmx9h+57Dg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEQBofFwe6rt6FrQb6hAX+kbd+jFG3K0Pso3zdj4qmx9h+57Dg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Erez Zarum <erezzarum@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/27/2012 9:55 PM, Erez Zarum wrote:
> I have already tried using linear mode, performance drops significantly.
> To show you how big the impact is, with seqrd 64 threads (sysbench) i
> get about 2.5Gb/s using striped LVM, with linear mode i get around
> 800MB/s.

Apologies if I seemed hostile, or short tempered, Erez.  We get a lot of
long winded people on here who "dream out loud" and end up wasting a lot
time with "what ifs".  I mistook you for such a person.

So, with an XFS over concat, if your benchmark only writes/reads to 1 or
a few directories you're only going to hit the first few allocation
groups, which means you're likely only hitting the first RAID set or
two.  You can fix this by either using far more directories and hitting
all AGs in the concat, i.e. hitting all RAID sets, or you can manually
specify "-d agcount=" at mkfs time to reduce the number of allocation
groups, precisely matching agcount to your arrays, to achieve the same
result with fewer directories.

For instance, you're using five 4+1 RAID5 arrays.  The max XFS agsize is
1TB.  If these are 250GB SSDs or smaller, you would do

$ mkfs.xfs -d agcount=5 /dev/md0

and end up with exactly 1 AG per RAID set, 5 AGs total.  In actuality 5
AGs is likely too few as it will limit allocation parallelism to a
degree, though not as much as with rust.  Thus, if your real workload
creates lots (thousands) of files in parallel then you probably want to
use 10 AGs total, 2 per array.  Run your benchmark against 10
directories and you should see something close to that 2.5GB/s figure
you achieve with LVM striping, possibly more depending on the files and
access patterns, unless you have a single SFF8088 cable between the
controller and the expander, in which case 2.5GB/s is pretty much the
speed limit.


Second, benchmarks are synthetic tests for comparing hardware and
operating systems in apples to apples tests.  They are not application
workloads and rarely come anywhere close to mimicking a real workload.
There are few, if any, real world workloads that require 800MB/s
streaming throughput, let alone 2.5GB/s, to innodb files.  Maybe you
have one, but I doubt it.

I forgot to mention in my previous reply that you'll want to add
"inode64" to your mount options.  This changes the allocation behavior
of XFS in a very positive way, increasing directory metadata and
allocation performance quite a bit for parallel workloads.  This has
more positive effect on rust but is still helpful with SSD.

> I don't want to be rude, but please, before saying what i have below
> is a damn mess, it's after i have spent hours of running benchmarks
> and getting the correct numbers.

Well, the way you described it made it look so. ;)  To me, and others,
LVM is simply a mess.  If one absolutely needs to take snapshots one
must have it.  If not, I say don't use it.  Using XFS with md linear
yields a cleaner, high performance solution, with easy infinite
expandability.

> I assume you told me to do this because it's SSD and i will saturate
> the PCI BUS before i will be able to saturate the disks, this
> assumption is usually wrong, especially when this LSI Controller is
> Gen3.

My recommendation had nothing to do with hardware limitations.  But
since you mentioned this I'll point out that RAID ASICs nearly always
bottleneck before the PCIe bus, especially when using parity arrays.
Running parity RAID on the dual core 2208 controllers will top out at
about 3GB/s with everything optimally configured, assuming SSDs or so
many rust disks they outrun the ASIC.  You're close to the max ASIC
throughput with your 2.5GB/s LVM stripe setup.

If you truly want maximum performance from your SSDs, which can likely
stream 400MB/s+ each, you should be using something like 4x 9207-8i in a
32+ slot chassis, with 4 more SSDs, 32 total.  You'd configure 4x 6+1
mdadm RAID5 arrays (one array per HBA), with 4 spares.  Add the RAID5s
to a linear array, of course with XFS atop and the proper number of AGs
for your workload and SSD size.

With 8 sufficiently stout CPU cores (4 cores to handle the 4 md/RAID5
write threads and 4 for interrupts, the application, etc) on a good high
bandwidth system board design, proper Linux tuning, msi-x, irqbalance,
etc, you should be able to get 300MB/s per SSD, or ~7GB/s aggregate,
more than double that of the, I'm guessing here, 9286-8e you're using.
Bear in mind that hitting write IO of 7GB/s, with any hardware, will
require substantial tuning effort.  Joe Landman probably has more
experience than anyone here with such SSD setups and might be able to
give you some pointers, should 2.5GB/s be insufficient for your needs. ;)

> I also don't need you to explain this to me as I understand exactly
> why it's slow, I came here asking a simple question which we can
> summarize: "If i have PV which is based on mdadm array, i then expand
> the mdadm array, do i lose the data alignment in LVM?"

I "explained" the XFS + md option because it eliminates this alignment
confusion entirely, and it's simply a less complex, better solution.

> I always opt to mailing list as the last option and this was also a
> suggestion i got from the IRC channel.

XFS + md linear was suggested on IRC?  Or something to do with LVM was
suggested?

>>> The problem i have in this setup is that i couldn't make it work, I
>>> know i need to align the XFS allocation group with the LV boundaries,

Again, using the setup I mentioned, XFS writeout will be in 4KB blocks
eliminating possible filesystem stripe misalignment issues.  You can
still align XFS if you want, but for a workload comprised of 16KB
writes, it won't gain you much, if anything.  The BBWC will take care of
coalescing adjacent sectors during writeback scheduling so FS stripe
alignment isn't a big issue, especially with delaylog coalescing log
writes.  Speaking of which, are you using kernel 2.6.39 or later?

>>> but i couldn't find a way to do it correctly, during my benchmarks i
>>> utilized only 1 disk and didn't get that much parallel I/O (regardless
>>> of threads).

If you were allocating to a single directory or just a few, this would
tend to explain the lack of parallelism.  XFS allocations to a single
directory, therefor a single AG, are mostly serialized.  To get
allocation parallelism, you must allocate to multiple AGs, to multiple
directories.  This AG based allocation parallelism is one of XFS'
greatest strengths, if one's workload does a lot of parallel allocation.

Speaking of which, you seem to be benchmarking file creation.  Most
database workloads are append heavy, not allocation heavy.  Can you
briefly describe your workload's file access patterns?  How many db
files you'll have, and which ones will be written to often?  Having 20+
SSDs may not help your application much if most of the write IO is to
only a handful of files.

-- 
Stan

