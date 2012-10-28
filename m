From: Erez Zarum <erezzarum@gmail.com>
Subject: Re: RAID and LVM alignment when expanding PVs
Date: Sun, 28 Oct 2012 14:05:41 +0200
Message-ID: <CAEQBofHLEyOzuuL1iHNythUqMPqNKRRZiuzDkco30dYRmp6CAQ@mail.gmail.com>
References: <CAEQBofHr-Fz=9zuR7WviZ4SRouEygOuX=WQRmg___ErMQyrqnw@mail.gmail.com>
	<508C9661.2070505@hardwarefreak.com>
	<CAEQBofFwe6rt6FrQb6hAX+kbd+jFG3K0Pso3zdj4qmx9h+57Dg@mail.gmail.com>
	<508CD203.6000209@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508CD203.6000209@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, i don't dream out loud :), i don't want to waste anyone's time,
especially not those on the mailing list.
To be more accurate, i don't have a lot of small files or directories,
I have about 3 big tables (each one is a file) that have uneven size,
one is small with about 400GB, another one is around 2.5TB and another
one around 3TB.
I can't use a small agcount size like 5 because then i will have the
agsize larger than 1TB.
Each SSD disk is 480GB which then gives me 440GB usable space.
So the minimum agcount i can use is 9, and i already tried that and it
didn't help.
The benchmark i am doing usually predict quite good results when
moving from staging to production, this was just a small test case for
the benchmark, it's running a lot of other test, all of them only used
1 RAID set at a time, for obvious reasons (as i understand) as i don't
use a lot of small files.
On my other tests i have used the inode64, now i have tested inode64
with linear and it didn't help.

I do want to use LVM especially because of the snapshots options, I
came here because i wanted to know in case i grow a mdadm device that
is a PV, what happens to the alignment, this is the same situation i
am in.

As for your last note, i have one server with identical configuration,
3 LSI HBAs with 24 SSDs and it perform well, but i don't intend to
scale this one up.
I chose the MegaRAID because i wanted the option to expand RAID50
without any problems, if i knew it won't be possible i would have
gotten the HBAs instead.

The server has 2 x Intel E5-2670 which yield 32 cores with
Hyper-Threading enabled and i also setup the interrupts correctly so
they will be distributed across the first CPU (which the controller is
attached to) and disabled irqbalance, i can see with mpstat that i
utilize all cores evenly.

XFS + md linear was not suggested on IRC, it was suggested to ask in
here what happens if i grow a raid device (mdadm for that case) which
is a PV, do i lose the alignment?

I will probably disable the writeback cache as i saw i get better
performance without it (also LSI recommends disabling it when using
FastPath).
I am using CentOS 6.3 (2.6.32-279.11.1.el6.x86_64), i know log delay
is enabled by default.

I use a few files as this predict what i have (3 big tables/3 big
files), i don't just benchmark file allocation, i also benchmark
different types of read patterns (random read, random read/write,
sequential read).
My database is mostly read workload (80% read, 20% write).

The biggest concern is when scaling up.

Thanks!


On Sun, Oct 28, 2012 at 8:34 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 10/27/2012 9:55 PM, Erez Zarum wrote:
>> I have already tried using linear mode, performance drops significantly.
>> To show you how big the impact is, with seqrd 64 threads (sysbench) i
>> get about 2.5Gb/s using striped LVM, with linear mode i get around
>> 800MB/s.
>
> Apologies if I seemed hostile, or short tempered, Erez.  We get a lot of
> long winded people on here who "dream out loud" and end up wasting a lot
> time with "what ifs".  I mistook you for such a person.
>
> So, with an XFS over concat, if your benchmark only writes/reads to 1 or
> a few directories you're only going to hit the first few allocation
> groups, which means you're likely only hitting the first RAID set or
> two.  You can fix this by either using far more directories and hitting
> all AGs in the concat, i.e. hitting all RAID sets, or you can manually
> specify "-d agcount=" at mkfs time to reduce the number of allocation
> groups, precisely matching agcount to your arrays, to achieve the same
> result with fewer directories.
>
> For instance, you're using five 4+1 RAID5 arrays.  The max XFS agsize is
> 1TB.  If these are 250GB SSDs or smaller, you would do
>
> $ mkfs.xfs -d agcount=5 /dev/md0
>
> and end up with exactly 1 AG per RAID set, 5 AGs total.  In actuality 5
> AGs is likely too few as it will limit allocation parallelism to a
> degree, though not as much as with rust.  Thus, if your real workload
> creates lots (thousands) of files in parallel then you probably want to
> use 10 AGs total, 2 per array.  Run your benchmark against 10
> directories and you should see something close to that 2.5GB/s figure
> you achieve with LVM striping, possibly more depending on the files and
> access patterns, unless you have a single SFF8088 cable between the
> controller and the expander, in which case 2.5GB/s is pretty much the
> speed limit.
>
>
> Second, benchmarks are synthetic tests for comparing hardware and
> operating systems in apples to apples tests.  They are not application
> workloads and rarely come anywhere close to mimicking a real workload.
> There are few, if any, real world workloads that require 800MB/s
> streaming throughput, let alone 2.5GB/s, to innodb files.  Maybe you
> have one, but I doubt it.
>
> I forgot to mention in my previous reply that you'll want to add
> "inode64" to your mount options.  This changes the allocation behavior
> of XFS in a very positive way, increasing directory metadata and
> allocation performance quite a bit for parallel workloads.  This has
> more positive effect on rust but is still helpful with SSD.
>
>> I don't want to be rude, but please, before saying what i have below
>> is a damn mess, it's after i have spent hours of running benchmarks
>> and getting the correct numbers.
>
> Well, the way you described it made it look so. ;)  To me, and others,
> LVM is simply a mess.  If one absolutely needs to take snapshots one
> must have it.  If not, I say don't use it.  Using XFS with md linear
> yields a cleaner, high performance solution, with easy infinite
> expandability.
>
>> I assume you told me to do this because it's SSD and i will saturate
>> the PCI BUS before i will be able to saturate the disks, this
>> assumption is usually wrong, especially when this LSI Controller is
>> Gen3.
>
> My recommendation had nothing to do with hardware limitations.  But
> since you mentioned this I'll point out that RAID ASICs nearly always
> bottleneck before the PCIe bus, especially when using parity arrays.
> Running parity RAID on the dual core 2208 controllers will top out at
> about 3GB/s with everything optimally configured, assuming SSDs or so
> many rust disks they outrun the ASIC.  You're close to the max ASIC
> throughput with your 2.5GB/s LVM stripe setup.
>
> If you truly want maximum performance from your SSDs, which can likely
> stream 400MB/s+ each, you should be using something like 4x 9207-8i in a
> 32+ slot chassis, with 4 more SSDs, 32 total.  You'd configure 4x 6+1
> mdadm RAID5 arrays (one array per HBA), with 4 spares.  Add the RAID5s
> to a linear array, of course with XFS atop and the proper number of AGs
> for your workload and SSD size.
>
> With 8 sufficiently stout CPU cores (4 cores to handle the 4 md/RAID5
> write threads and 4 for interrupts, the application, etc) on a good high
> bandwidth system board design, proper Linux tuning, msi-x, irqbalance,
> etc, you should be able to get 300MB/s per SSD, or ~7GB/s aggregate,
> more than double that of the, I'm guessing here, 9286-8e you're using.
> Bear in mind that hitting write IO of 7GB/s, with any hardware, will
> require substantial tuning effort.  Joe Landman probably has more
> experience than anyone here with such SSD setups and might be able to
> give you some pointers, should 2.5GB/s be insufficient for your needs. ;)
>
>> I also don't need you to explain this to me as I understand exactly
>> why it's slow, I came here asking a simple question which we can
>> summarize: "If i have PV which is based on mdadm array, i then expand
>> the mdadm array, do i lose the data alignment in LVM?"
>
> I "explained" the XFS + md option because it eliminates this alignment
> confusion entirely, and it's simply a less complex, better solution.
>
>> I always opt to mailing list as the last option and this was also a
>> suggestion i got from the IRC channel.
>
> XFS + md linear was suggested on IRC?  Or something to do with LVM was
> suggested?
>
>>>> The problem i have in this setup is that i couldn't make it work, I
>>>> know i need to align the XFS allocation group with the LV boundaries,
>
> Again, using the setup I mentioned, XFS writeout will be in 4KB blocks
> eliminating possible filesystem stripe misalignment issues.  You can
> still align XFS if you want, but for a workload comprised of 16KB
> writes, it won't gain you much, if anything.  The BBWC will take care of
> coalescing adjacent sectors during writeback scheduling so FS stripe
> alignment isn't a big issue, especially with delaylog coalescing log
> writes.  Speaking of which, are you using kernel 2.6.39 or later?
>
>>>> but i couldn't find a way to do it correctly, during my benchmarks i
>>>> utilized only 1 disk and didn't get that much parallel I/O (regardless
>>>> of threads).
>
> If you were allocating to a single directory or just a few, this would
> tend to explain the lack of parallelism.  XFS allocations to a single
> directory, therefor a single AG, are mostly serialized.  To get
> allocation parallelism, you must allocate to multiple AGs, to multiple
> directories.  This AG based allocation parallelism is one of XFS'
> greatest strengths, if one's workload does a lot of parallel allocation.
>
> Speaking of which, you seem to be benchmarking file creation.  Most
> database workloads are append heavy, not allocation heavy.  Can you
> briefly describe your workload's file access patterns?  How many db
> files you'll have, and which ones will be written to often?  Having 20+
> SSDs may not help your application much if most of the write IO is to
> only a handful of files.
>
> --
> Stan
>
