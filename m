From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID and LVM alignment when expanding PVs
Date: Mon, 29 Oct 2012 05:24:17 -0500
Message-ID: <508E5951.7030809@hardwarefreak.com>
References: <CAEQBofHr-Fz=9zuR7WviZ4SRouEygOuX=WQRmg___ErMQyrqnw@mail.gmail.com> <508C9661.2070505@hardwarefreak.com> <CAEQBofFwe6rt6FrQb6hAX+kbd+jFG3K0Pso3zdj4qmx9h+57Dg@mail.gmail.com> <508CD203.6000209@hardwarefreak.com> <CAEQBofHLEyOzuuL1iHNythUqMPqNKRRZiuzDkco30dYRmp6CAQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEQBofHLEyOzuuL1iHNythUqMPqNKRRZiuzDkco30dYRmp6CAQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Erez Zarum <erezzarum@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/28/2012 7:05 AM, Erez Zarum wrote:
> Well, i don't dream out loud :), i don't want to waste anyone's time,
> especially not those on the mailing list.

Don't worry about that.  People read posts they find interesting and
skip the rest, just as I've skipped all the "3TB drive failure rate" posts.

> To be more accurate, i don't have a lot of small files or directories,
> I have about 3 big tables (each one is a file) that have uneven size,
> one is small with about 400GB, another one is around 2.5TB and another
> one around 3TB.

Those are awfully large tables.  What kind of data are you storing in
these tables?  Are the reads transactional in nature, i.e. random, or
are you doing mostly table walking queries as in data mining, where
reads are mostly sequential down the table?  I ask because the answer
will directly impact the way you'll want to layout your storage for
optimal performance, or whether you can even optimize the layout for
your workload at all.

> I can't use a small agcount size like 5 because then i will have the
> agsize larger than 1TB.

I was basing my example on 250GB drives.

> Each SSD disk is 480GB which then gives me 440GB usable space.
> So the minimum agcount i can use is 9, and i already tried that and it
> didn't help.

For a transactional database application with files of the size you've
stated, Allocation Groups yield no advantage because your workload has
no allocation, and you have far fewer files than AGs so you can't
manually layout the data across many AGs to increase parallelism.  Thus
XFS offers you no inherent parallelism for this workload beyond that of
the read/write pattern of the application.

Additionally, and this is an important point, XFS stripe alignment
applies only to metadata journal writes and allocation.  Your database
workload has zero allocation and thus zero metadata operations.  Thus
you're not writing to the journal log and you're not writing to the
directory trees.  It's all read, modify-in-place, and/or append.  So
don't align the XFS.  This also eliminates any issues with md/LVM stripe
alignment.  Though this shouldn't be an issue anyway after you read what
I have to say below.

The reason you saw better benchmark performance with the striped LVM
setup vs the concatenated setup is simply due to the fact your 3TB files
were spread across all RAID devices by the striping, whereas the concat
limited file placement to only a couple of RAID devices.  This makes the
benchy numbers look good for striping though it likely won't add
performance to your actual workload.  That said...

If you truly *need* the IOPS of so many SSDs, and your application
access pattern is sufficiently not random to actually hit all the SSDs
in parallel, then your only option is to stripe them.  Given this, you
need to reconsider your chosen storage layout.

The BCP of 4+1/6+2 RAID5/6 arrays assumes mechanical storage with high
capacity and low transfer rate, thus high rebuild times, and the
probability of another member device failure during the rebuild window.
 This BCP does not apply to SSDs.  Consider the following.

Start over from scratch with the LSI configuration.  You have 28 SSDs.
IIRC the maximum drives per drive group is 32.  So you should be able to
create a 24 drive RAID6 array, leaving 4 spares.  This yields 22 data
drives, 2 more than your current 20, and an additional hot spare.
Configure a 16KB strip size, as you stated the IO size of your
application was 16KB.  This ensures that every db write goes to a
different SSD in the array.  This layout is as good as it gets for small
random IO.  And even though you have a 20% write load, using this super
small strip decreases the complexity of the parity calculation for each
stripe during RMW, decreasing the load on the ASIC, thus decreasing
random IO latency, and increasing random IO throughput.  This may
decrease your benchmark numbers, especially your sequential read/write
tests.  But it should provide maximum performance for your actual mysql
workload.

Create your PVs and LVs.  Again, no need for alignment anywhere.  Format
with mkfs.xfs defaults.  Do NOT mount with inode64 because you have only
3 files in the XFS.  inode64 puts inodes and files in the same AG and is
designed for filesystems with up to millions of files.  inode32, the
default allocator, is a much better fit.

And, when 10TB is no longer sufficient, add another LSI card and 28 SSDs
and the same RAID6 setup, and expand your PV over the new space and grow
the XFS.  No stripe alignment to worry about.

> The benchmark i am doing usually predict quite good results when
> moving from staging to production, this was just a small test case for
> the benchmark, it's running a lot of other test, all of them only used
> 1 RAID set at a time, for obvious reasons (as i understand) as i don't
> use a lot of small files.
> On my other tests i have used the inode64, now i have tested inode64
> with linear and it didn't help.

Yep.  Now that I know your workload and explained above, you now
understand why inode64 gained you nothing.

> I do want to use LVM especially because of the snapshots options, I
> came here because i wanted to know in case i grow a mdadm device that
> is a PV, what happens to the alignment, this is the same situation i
> am in.

And now you know you should not do any alignment anywhere, and don't
need to bother with md or LVM striping or concatenation.  Just lay a
regular PV and LV over the 10.5TB disk device.

> As for your last note, i have one server with identical configuration,
> 3 LSI HBAs with 24 SSDs and it perform well, but i don't intend to
> scale this one up.
> I chose the MegaRAID because i wanted the option to expand RAID50
> without any problems, if i knew it won't be possible i would have
> gotten the HBAs instead.

The only thing RAID50 will likely gain you over the 24 wide RAID6 is
fewer drives involved during a rebuild.  With SSDs this is a bit
irrelevant.  And of course the RAID6 gives you 2 more data drives of
performance and 1 more spare, as in the 5x RAID5 case.  The only thing
I'm unsure of whether both ASIC cores come into play with a single
array.  If not I'd go with a 2x12 drive RAID60, over a 5x5 drive RAID5,
to get both cores into action.  No matter what you do with array
type/drive count, use the 16KB strip size.  Whether your synthetic tests
like it or not, if your app really does do 16KB IOs, it will gie the
best performance in production.

> The server has 2 x Intel E5-2670 which yield 32 cores with

16 cores with HT isn't the same as 32 cores.  But with a parallel
database, HT should definitely improve performance.

> Hyper-Threading enabled and i also setup the interrupts correctly so
> they will be distributed across the first CPU (which the controller is
> attached to) and disabled irqbalance, i can see with mpstat that i
> utilize all cores evenly.
>
> XFS + md linear was not suggested on IRC, it was suggested to ask in
> here what happens if i grow a raid device (mdadm for that case) which
> is a PV, do i lose the alignment?

As I said it doesn't matter.  Your workload does no allocation, and only
does small random writes, which are unaligned by their nature.
Alignment has no effect on reads, only writes.  So, doing any kind of
alignment with your workload has no upside.

> I will probably disable the writeback cache as i saw i get better
> performance without it (also LSI recommends disabling it when using
> FastPath).

Are you running with the disk caches enabled?  Do these SSDs have power
fail capacitors?  If yes and no that's unsafe.  So disable the drive
caches and then re-test write-through vs write-back.

> I am using CentOS 6.3 (2.6.32-279.11.1.el6.x86_64), i know log delay
> is enabled by default.

With your workload it makes no difference.

> I use a few files as this predict what i have (3 big tables/3 big
> files), i don't just benchmark file allocation, i also benchmark
> different types of read patterns (random read, random read/write,
> sequential read).
> My database is mostly read workload (80% read, 20% write).
> 
> The biggest concern is when scaling up.

Scaling up in IOPS or capacity?  If the former, the controller will be
the bottleneck, not the quantity of SSDs.  BTW, you didn't mention which
controller you have in this system.  Is it indeed the 9286-8e?  Which
JBOD chassis and SSDs are you using?

I still can't imagine a random IO database workload that needs 20+ SSDs
worth of IOPS.  Tell me more about what you're doing, off list if
necessary.  I find this project of yours very intriguing.

> Thanks!

Well, I don't know if I've given you anything worth thanking me for.  If
you test some of my suggestions and they don't yield positive results,
you may want to curse me instead. ;)

-- 
Stan


> On Sun, Oct 28, 2012 at 8:34 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 10/27/2012 9:55 PM, Erez Zarum wrote:
>>> I have already tried using linear mode, performance drops significantly.
>>> To show you how big the impact is, with seqrd 64 threads (sysbench) i
>>> get about 2.5Gb/s using striped LVM, with linear mode i get around
>>> 800MB/s.
>>
>> Apologies if I seemed hostile, or short tempered, Erez.  We get a lot of
>> long winded people on here who "dream out loud" and end up wasting a lot
>> time with "what ifs".  I mistook you for such a person.
>>
>> So, with an XFS over concat, if your benchmark only writes/reads to 1 or
>> a few directories you're only going to hit the first few allocation
>> groups, which means you're likely only hitting the first RAID set or
>> two.  You can fix this by either using far more directories and hitting
>> all AGs in the concat, i.e. hitting all RAID sets, or you can manually
>> specify "-d agcount=" at mkfs time to reduce the number of allocation
>> groups, precisely matching agcount to your arrays, to achieve the same
>> result with fewer directories.
>>
>> For instance, you're using five 4+1 RAID5 arrays.  The max XFS agsize is
>> 1TB.  If these are 250GB SSDs or smaller, you would do
>>
>> $ mkfs.xfs -d agcount=5 /dev/md0
>>
>> and end up with exactly 1 AG per RAID set, 5 AGs total.  In actuality 5
>> AGs is likely too few as it will limit allocation parallelism to a
>> degree, though not as much as with rust.  Thus, if your real workload
>> creates lots (thousands) of files in parallel then you probably want to
>> use 10 AGs total, 2 per array.  Run your benchmark against 10
>> directories and you should see something close to that 2.5GB/s figure
>> you achieve with LVM striping, possibly more depending on the files and
>> access patterns, unless you have a single SFF8088 cable between the
>> controller and the expander, in which case 2.5GB/s is pretty much the
>> speed limit.
>>
>>
>> Second, benchmarks are synthetic tests for comparing hardware and
>> operating systems in apples to apples tests.  They are not application
>> workloads and rarely come anywhere close to mimicking a real workload.
>> There are few, if any, real world workloads that require 800MB/s
>> streaming throughput, let alone 2.5GB/s, to innodb files.  Maybe you
>> have one, but I doubt it.
>>
>> I forgot to mention in my previous reply that you'll want to add
>> "inode64" to your mount options.  This changes the allocation behavior
>> of XFS in a very positive way, increasing directory metadata and
>> allocation performance quite a bit for parallel workloads.  This has
>> more positive effect on rust but is still helpful with SSD.
>>
>>> I don't want to be rude, but please, before saying what i have below
>>> is a damn mess, it's after i have spent hours of running benchmarks
>>> and getting the correct numbers.
>>
>> Well, the way you described it made it look so. ;)  To me, and others,
>> LVM is simply a mess.  If one absolutely needs to take snapshots one
>> must have it.  If not, I say don't use it.  Using XFS with md linear
>> yields a cleaner, high performance solution, with easy infinite
>> expandability.
>>
>>> I assume you told me to do this because it's SSD and i will saturate
>>> the PCI BUS before i will be able to saturate the disks, this
>>> assumption is usually wrong, especially when this LSI Controller is
>>> Gen3.
>>
>> My recommendation had nothing to do with hardware limitations.  But
>> since you mentioned this I'll point out that RAID ASICs nearly always
>> bottleneck before the PCIe bus, especially when using parity arrays.
>> Running parity RAID on the dual core 2208 controllers will top out at
>> about 3GB/s with everything optimally configured, assuming SSDs or so
>> many rust disks they outrun the ASIC.  You're close to the max ASIC
>> throughput with your 2.5GB/s LVM stripe setup.
>>
>> If you truly want maximum performance from your SSDs, which can likely
>> stream 400MB/s+ each, you should be using something like 4x 9207-8i in a
>> 32+ slot chassis, with 4 more SSDs, 32 total.  You'd configure 4x 6+1
>> mdadm RAID5 arrays (one array per HBA), with 4 spares.  Add the RAID5s
>> to a linear array, of course with XFS atop and the proper number of AGs
>> for your workload and SSD size.
>>
>> With 8 sufficiently stout CPU cores (4 cores to handle the 4 md/RAID5
>> write threads and 4 for interrupts, the application, etc) on a good high
>> bandwidth system board design, proper Linux tuning, msi-x, irqbalance,
>> etc, you should be able to get 300MB/s per SSD, or ~7GB/s aggregate,
>> more than double that of the, I'm guessing here, 9286-8e you're using.
>> Bear in mind that hitting write IO of 7GB/s, with any hardware, will
>> require substantial tuning effort.  Joe Landman probably has more
>> experience than anyone here with such SSD setups and might be able to
>> give you some pointers, should 2.5GB/s be insufficient for your needs. ;)
>>
>>> I also don't need you to explain this to me as I understand exactly
>>> why it's slow, I came here asking a simple question which we can
>>> summarize: "If i have PV which is based on mdadm array, i then expand
>>> the mdadm array, do i lose the data alignment in LVM?"
>>
>> I "explained" the XFS + md option because it eliminates this alignment
>> confusion entirely, and it's simply a less complex, better solution.
>>
>>> I always opt to mailing list as the last option and this was also a
>>> suggestion i got from the IRC channel.
>>
>> XFS + md linear was suggested on IRC?  Or something to do with LVM was
>> suggested?
>>
>>>>> The problem i have in this setup is that i couldn't make it work, I
>>>>> know i need to align the XFS allocation group with the LV boundaries,
>>
>> Again, using the setup I mentioned, XFS writeout will be in 4KB blocks
>> eliminating possible filesystem stripe misalignment issues.  You can
>> still align XFS if you want, but for a workload comprised of 16KB
>> writes, it won't gain you much, if anything.  The BBWC will take care of
>> coalescing adjacent sectors during writeback scheduling so FS stripe
>> alignment isn't a big issue, especially with delaylog coalescing log
>> writes.  Speaking of which, are you using kernel 2.6.39 or later?
>>
>>>>> but i couldn't find a way to do it correctly, during my benchmarks i
>>>>> utilized only 1 disk and didn't get that much parallel I/O (regardless
>>>>> of threads).
>>
>> If you were allocating to a single directory or just a few, this would
>> tend to explain the lack of parallelism.  XFS allocations to a single
>> directory, therefor a single AG, are mostly serialized.  To get
>> allocation parallelism, you must allocate to multiple AGs, to multiple
>> directories.  This AG based allocation parallelism is one of XFS'
>> greatest strengths, if one's workload does a lot of parallel allocation.
>>
>> Speaking of which, you seem to be benchmarking file creation.  Most
>> database workloads are append heavy, not allocation heavy.  Can you
>> briefly describe your workload's file access patterns?  How many db
>> files you'll have, and which ones will be written to often?  Having 20+
>> SSDs may not help your application much if most of the write IO is to
>> only a handful of files.
>>
>> --
>> Stan
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

