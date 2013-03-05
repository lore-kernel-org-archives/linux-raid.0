From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance -  5x SSD RAID5 - effects of stripe cache sizing
Date: Tue, 05 Mar 2013 03:30:20 -0600
Message-ID: <5135BB2C.5030400@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com> <c886b8ac-9786-4e7d-b6f1-b6fb5d801c85@email.android.com> <5134917F
 .8060903@hardwarefreak.com> <5134CB39.8050000@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5134CB39.8050000@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/4/2013 10:26 AM, Adam Goryachev wrote:

>> Whatever value you choose, make it permanent by adding this entry to
>> root's crontab:
>>
>> @reboot		/bin/echo 32768 > /sys/block/md0/md/stripe_cache_size
> 
> Already added to /etc/rc.local along with the config to set the deadline
> scheduler for each of the RAID drives.

You should be using noop for SSD, not deadline.  noop may improve your
FIO throughput, nad real workload, even further.

Also, did you verify with a reboot that stripe_cache_size is actually
being set correctly at startup?  If it's not working as assumed you'll
be losing several hundred MB/s of write throughput at the next reboot.
Something this critical should always be tested and verified.

> stripe_cache_size = 4096
>>    READ: io=131072MB, aggrb=2504MB/s, minb=2564MB/s, maxb=2564MB/s, mint=52348msec, maxt=52348msec
>>   WRITE: io=131072MB, aggrb=1590MB/s, minb=1628MB/s, maxb=1628MB/s, mint=82455msec, maxt=82455msec

Wow, we're up to 1.6 GB/s data throughput, 2 GB/s total md device
throughput.  That's 407MB/s per SSD.  This is much more inline with what
one would expect from a RAID5 using 5 large, fast SandForce SSDs.  This
is 80% of the single drive streaming write throughput of this SSD model,
as tested by Anandtech, Tom's, and others.

I'm a bit surprised we're achieving 2 GB/s parity write throughput with
the single threaded RAID5 driver on one core.  Those 3.3GHz Ive Bridge
cores are stouter than I thought.  Disabling HT probably helped a bit
here.  I'm anxious to see the top output file for this run (if you made
one--you should for each and every FIO run).  Surely we're close to
peaking the core here.

> stripe_cache_size = 8192
>>    READ: io=131072MB, aggrb=2487MB/s, minb=2547MB/s, maxb=2547MB/s, mint=52697msec, maxt=52697msec
>>   WRITE: io=131072MB, aggrb=1521MB/s, minb=1557MB/s, maxb=1557MB/s, mint=86188msec, maxt=86188msec

Interesting.  4096/8192 are both higher by ~300MB/s compared to the
previous 1292MB/s you posted for 8192.  Some other workload must have
been active during the previous run, or something else has changed.

> stripe_cache_size = 16384
>>    READ: io=131072MB, aggrb=2494MB/s, minb=2554MB/s, maxb=2554MB/s, mint=52556msec, maxt=52556msec
>>   WRITE: io=131072MB, aggrb=1368MB/s, minb=1401MB/s, maxb=1401MB/s, mint=95779msec, maxt=95779msec
> 
> stripe_cache_size = 32768
>>    READ: io=131072MB, aggrb=2489MB/s, minb=2549MB/s, maxb=2549MB/s, mint=52661msec, maxt=52661msec
>>   WRITE: io=131072MB, aggrb=1138MB/s, minb=1165MB/s, maxb=1165MB/s, mint=115209msec, maxt=115209msec

This is why you test, and test, and test when tuning for performance.
4096 seems to be your sweet spot.

> (let me know if you want the full fio output....)

No, the summary is fine.  What's more more valuable to have the top
output file for each run so I can see what's going on.  At 2 GB/s of
throughput your interrupt rate should be pretty high, and I'd like to
see the IRQ spread across the cores, as well as the RAID5 thread load,
among other things.  I haven't yet looked at the file you sent, but I'm
guessing it doesn't include this 1.6GB/s run.  I'm really interested in
seeing that one, and the ones for 16384 and 32768.  WRT the latter two,
I'm curious whether the much larger tables are causing excessive CPU
burn, which may in turn be what lowers throughput.

> This seems to show that DRBD did not slow things down at all... I don't

I noticed.

> remember exactly when I did the previous fio tests with drbd connected,
> but perhaps I've made changes to the drbd config since then and/or
> upgraded from the debian stable drbd to 8.3.15

Maybe it wasn't actively syncing when you made these FIO runs.

> Let's re-run the above tests with DRBD stopped:
...
> stripe_cache_size = 4096
>>    READ: io=131072MB, aggrb=2498MB/s, minb=2558MB/s, maxb=2558MB/s, mint=52465msec, maxt=52465msec
>>   WRITE: io=131072MB, aggrb=1596MB/s, minb=1634MB/s, maxb=1634MB/s, mint=82126msec, maxt=82126msec
> 
> stripe_cache_size = 8192
>>    READ: io=131072MB, aggrb=2498MB/s, minb=2558MB/s, maxb=2558MB/s, mint=52469msec, maxt=52469msec
>>   WRITE: io=131072MB, aggrb=1514MB/s, minb=1550MB/s, maxb=1550MB/s, mint=86565msec, maxt=86565msec
...

Numbers are identical.  Either BRBD wasn't actually copying anything
during the previous FIO run, its nice level changed, its
configuration/behavior changed with the new version, or something.
Whatever the reason, it appears to be putting no load on the array.

> So, it looks like the ideal value is actually smaller (4096) although
> there is not much difference between 8192 and 4096. It seems strange
> that a larger cache size will actually reduce performance... I'll change

It's not strange at all, but expected.  As a table gets larger it takes
more CPU cycles to manage it and more memory bandwidth; your cache miss
rate increases, etc.  At a certain point this overhead becomes
detrimental instead of beneficial.  In your case the size of the cache
table outweighs the overhead and yields increased performance up to 80MB
table size.  At 160MB and above the size of the table creates more
overhead than performance benefit.

This is what system testing/tuning is all about.

> to 4096 for the time being, unless you think "real world" performance
> might be better with 8192?

These FIO runs are hitting your IO subsystem much harder than your real
workloads every will.  Stick with 4096.

> Here are the results of re-running fio using the previous config (with
> drbd connected with the stripe_cache_size = 8192):
>>    READ: io=4096MB, aggrb=2244MB/s, minb=2298MB/s, maxb=2298MB/s, mint=1825msec, maxt=1825msec
>>   WRITE: io=4096MB, aggrb=494903KB/s, minb=506780KB/s, maxb=506780KB/s, mint=8475msec, maxt=8475msec
> 
> Perhaps the old fio test just isn't as well suited to the way drbd
> handles things. Though the issue would be what sort of data the real
> users are doing, because if that matches the old fio test or the new fio
> test, it makes a big difference.

The significantly lower throughput of the "old" FIO job has *nothing* to
do with DRBD.  It has everything to do with the parameters of the job
file.  I thought I explained the differences previously.  If not, here
you go:

1.  My FIO job has 16 workers submitting IO in parallel
    The "old" job has a single worker submitting serially
    -- both are using AIO

2.  My FIO job uses zeroed buffers, allowing the SSDs to compress data
    The old job uses randomized data, thus SSD compression is lower

3.  My FIO job does 256KB IOs, each one filling a RAID stripe
    The old job does 64KB IOs, each one filling one chunk

4.  My FIO job does random IOs, spreading the writes over the volume
    The old job does serial IOs
    -- the SandForce controllers have 8 channels and can write to all 8
       in parallel.  Writing randomly creates more opportunity for the
       controller to write multiple channels concurrently

My FIO job simulates a large multiuser heavy concurrent IO workload.  It
creates 16 threads, 4 running on each core.  In parallel, they submit a
massive amount of random, stripe width writes, containing uniform data,
asynchronously, to the block device, here the md/RAID5 device.  Doing
this ensures the IO pipeline is completely full all the time, with zero
delays between submissions.

The "old" FIO job creates a single thread which submits chunk size
overlapping writes asynchronously via the io_submit() system call
(libaio).  Contrary to apparently popular belief, this does not allow
one to send a continuous stream of overlapping writes from a single
thread with no time slice gaps between the system calls.

My FIO job threads use io_submit() as well, but there are 16 threads
submitting in parallel, leaving no time gaps between IO submissions,
with massive truly overlapping IOs.  This parallel job could be run with
any number of FIO engines with the same results.  I stuck with AIO for
direct comparison as we're doing here.

Because it is sending so many more IOs per unit time than the single
threaded job, the larger md stripe cache is of great benefit.  The
single threaded job isn't submitting sufficient IOs per unit for the
larger stripe cache to make a difference.

The takeaway here is not that my FIO job makes the SSD RAID faster.  It
simply pushes a sufficient amount of IO to demonstrate the intrinsic
high throughput the array is capable of.  For those fond of car
analogies:  the old FIO test is barely pushing on the throttle;  my FIO
test is hammering the pedal to the floor.  Same car, same speed
potential, just different amounts of load applied to the pedal.

> So, it looks like it is the stripe_cache_size that is affecting
> performance, and that DRBD makes no difference whether it is connected
> or not. Possibly removing it completely would increase performance
> somewhat, but since I actually do need it, and that is somewhat
> destructive, I won't try that :)

I'd do more investigating of this.  DRBD can't put zero load on the
array if it's doing work.  Given it's a read only workload, it's
possible the increased stripe cache is allowing full throttle writes
while doing 100MB/s of reads, without writes being impacted.  You'll
need to look deeper into the md statistics and/or monitor iostat, etc,
during runs with DRBD active and actually moving data.

> Will stick with 4096 for the moment based on the above results.

That's my recommendation.

>> FIO runs on Windows:  http://www.bluestop.org/fio/
> 
> Will check into that, it will be the ultimate end-to-end test.... Also,

Yes, it will.  As long as you're running at least 16-32 threads per TS
client to overcome TCP/iSCSI over GbE latency, and the lack of AIO on
Windows.  And you can't simply reuse the same job file.  The docs tell
you which engine, and other settings, to use for Windows.

> Hmmm, good point, I realised I could try and upgrade to the x64 windows
> 2003, but I think I'd prefer to just move up to 2008 x64 (or 2012)...
> For now, I'll just keep using my hacky 4GB RAM drive for the pagefile...

Or violate BCP and run two TS instances per Xen, or even four, with the
appropriate number of users per each.  KSM will consolidate all the
Windows and user application read only files (DLLs, exes, etc), yielding
much more free real memory than with a single Windows TS instance.
AFAIK Windows has no memory merging so you can't over commit memory
other than with the page file, which is horribly less efficient than KSM.

> I meant I hadn't crossed off as many items from my list of things to
> do... Not that I hadn't improved performance significantly :)

I know, was just poking you in the ribs. ;)

>> To find out how much of the 732MB/s write throughput increase is due to
>> buffering 512 stripes instead of 16, simply change it back to 256,
>> re-run my FIO job file, and subtract the write result from 1292MB/s.
> 
> So, running your FIO job file with the original 256 give a write speed
> of 950MB/s and the previous FIO file gives 509MB/s. So it would seem the
> increase in stripe_cache_size from 256 to 4096 give an increase in your
> FIO job from 950MB/s to 1634MB/s which is a significant speed boost. I

72 percent increase with this synthetic workload, by simply increasing
the stripe cache.  Not bad eh?  This job doesn't present an accurate
picture of real world performance though, as most synthetic tests don't.

Get DRBD a hump'n and your LVM snapshot(s) in place, all the normal
server side load, then fire up the 32 thread FIO test on each TS VM to
simulate users (I could probably knock out this job file if you like).
Then monitor the array throughput with iostat or similar.  This would be
about as close to peak real world load as you can get.

> must wonder why we have a default of 256 when this can make such a
> significant performance improvement?  A value of 4096 with a 5 drive raid
> array is only 80MB of cache, I suspect very few users with a 5 drive
> RAID array would be concerned about losing 80MB of RAM, and a 2 drive
> RAID array would only use 32MB ...

The stripe cache has nothing to do with device count, but hardware
throughput.  Did you happen to notice what occurred when you increased
cache size past your 4096 sweet spot to 32768?  Throughput dropped by
~500MB/s, almost 1/3rd.  Likewise, for the slow rust array whose sweet
spot is 512, making the default 4096 will decrease his throughput, and
eat 80MB RAM for nothing.  Defaults are chosen to work best with the
lowest common denominator hardware, not the Ferrari.

-- 
Stan

