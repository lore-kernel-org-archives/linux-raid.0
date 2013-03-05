From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance -  5x SSD RAID5 - effects of stripe cache sizing
Date: Wed, 06 Mar 2013 02:53:29 +1100
Message-ID: <513614F9.1050808@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au> <51272808.7070302@hardwarefreak.com> <512A79D3.9020502@hardwarefreak.com> <5130D206.4090302@websitemanagers.com.au> <5131C338.8010402@hardwarefreak.com> <c886b8ac-9786-4e7d-b6f1-b6fb5d801c85@email.android.com> <5134917F
 .8060903@hardwarefreak.com> <5134CB39.8050000@websitemanagers.com.au> <5135BB2C.5030400@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5135BB2C.5030400@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/03/13 20:30, Stan Hoeppner wrote:
> On 3/4/2013 10:26 AM, Adam Goryachev wrote:
> 
>>> Whatever value you choose, make it permanent by adding this entry to
>>> root's crontab:
>>>
>>> @reboot		/bin/echo 32768 > /sys/block/md0/md/stripe_cache_size
>>
>> Already added to /etc/rc.local along with the config to set the deadline
>> scheduler for each of the RAID drives.
> 
> You should be using noop for SSD, not deadline.  noop may improve your
> FIO throughput, nad real workload, even further.

OK, done now...

> Also, did you verify with a reboot that stripe_cache_size is actually
> being set correctly at startup?  If it's not working as assumed you'll
> be losing several hundred MB/s of write throughput at the next reboot.
> Something this critical should always be tested and verified.

Will do, thanks for the nudge...

>> stripe_cache_size = 4096
>>>    READ: io=131072MB, aggrb=2504MB/s, minb=2564MB/s, maxb=2564MB/s, mint=52348msec, maxt=52348msec
>>>   WRITE: io=131072MB, aggrb=1590MB/s, minb=1628MB/s, maxb=1628MB/s, mint=82455msec, maxt=82455msec
> 
> Wow, we're up to 1.6 GB/s data throughput, 2 GB/s total md device
> throughput.  That's 407MB/s per SSD.  This is much more inline with what
> one would expect from a RAID5 using 5 large, fast SandForce SSDs.  This
> is 80% of the single drive streaming write throughput of this SSD model,
> as tested by Anandtech, Tom's, and others.
> 
> I'm a bit surprised we're achieving 2 GB/s parity write throughput with
> the single threaded RAID5 driver on one core.  Those 3.3GHz Ive Bridge
> cores are stouter than I thought.  Disabling HT probably helped a bit
> here.  I'm anxious to see the top output file for this run (if you made
> one--you should for each and every FIO run).  Surely we're close to
> peaking the core here.

I'll run some more tests on the box soon, and make sure to collect the
top outputs for each run. Will email the lot when done. (See below why
there will be some delay).

>> stripe_cache_size = 8192
>>>    READ: io=131072MB, aggrb=2487MB/s, minb=2547MB/s, maxb=2547MB/s, mint=52697msec, maxt=52697msec
>>>   WRITE: io=131072MB, aggrb=1521MB/s, minb=1557MB/s, maxb=1557MB/s, mint=86188msec, maxt=86188msec
> 
> Interesting.  4096/8192 are both higher by ~300MB/s compared to the
> previous 1292MB/s you posted for 8192.  Some other workload must have
> been active during the previous run, or something else has changed.

Every run I took in this email was actually done twice, and I used the
larger result in the email (since we are trying to compare max
performance). However, I'm pretty sure the two runs were very similar in
results (less than 6MB/s difference).... I thought that maybe I should
have averaged the results, or run more tests, but really, I'm not that
seriously benchmarking to sell the stuff, I just need to know which one
worked best...

>> stripe_cache_size = 16384
>>>    READ: io=131072MB, aggrb=2494MB/s, minb=2554MB/s, maxb=2554MB/s, mint=52556msec, maxt=52556msec
>>>   WRITE: io=131072MB, aggrb=1368MB/s, minb=1401MB/s, maxb=1401MB/s, mint=95779msec, maxt=95779msec
>>
>> stripe_cache_size = 32768
>>>    READ: io=131072MB, aggrb=2489MB/s, minb=2549MB/s, maxb=2549MB/s, mint=52661msec, maxt=52661msec
>>>   WRITE: io=131072MB, aggrb=1138MB/s, minb=1165MB/s, maxb=1165MB/s, mint=115209msec, maxt=115209msec
> 
> This is why you test, and test, and test when tuning for performance.
> 4096 seems to be your sweet spot.

Yep, I ran those tests a lot more times (4096, 8192 and 16384) to try
and see if it was an anomaly, or some other strange effect...

>> (let me know if you want the full fio output....)
> 
> No, the summary is fine.  What's more more valuable to have the top
> output file for each run so I can see what's going on.  At 2 GB/s of
> throughput your interrupt rate should be pretty high, and I'd like to
> see the IRQ spread across the cores, as well as the RAID5 thread load,
> among other things.  I haven't yet looked at the file you sent, but I'm
> guessing it doesn't include this 1.6GB/s run.  I'm really interested in
> seeing that one, and the ones for 16384 and 32768.  WRT the latter two,
> I'm curious whether the much larger tables are causing excessive CPU
> burn, which may in turn be what lowers throughput.

OK, will prepare and send soon...

>> This seems to show that DRBD did not slow things down at all... I don't
> 
> I noticed.
> 
>> remember exactly when I did the previous fio tests with drbd connected,
>> but perhaps I've made changes to the drbd config since then and/or
>> upgraded from the debian stable drbd to 8.3.15
> Maybe it wasn't actively syncing when you made these FIO runs.

It was "in sync" prior to running the tests, and remained in sync during
the tests... However, with the newer 8.3.15 I've adjusted the config so
that if the secondary falls behind, it will drop out of sync, and catch
up when it can. There is no way the secondary can be writing at
1.6GB/sec over a 1Gbps ethernet, to a 4 x 2TB RAID10 HDD's....

>> Let's re-run the above tests with DRBD stopped:
> ...
>> stripe_cache_size = 4096
>>>    READ: io=131072MB, aggrb=2498MB/s, minb=2558MB/s, maxb=2558MB/s, mint=52465msec, maxt=52465msec
>>>   WRITE: io=131072MB, aggrb=1596MB/s, minb=1634MB/s, maxb=1634MB/s, mint=82126msec, maxt=82126msec
>>
>> stripe_cache_size = 8192
>>>    READ: io=131072MB, aggrb=2498MB/s, minb=2558MB/s, maxb=2558MB/s, mint=52469msec, maxt=52469msec
>>>   WRITE: io=131072MB, aggrb=1514MB/s, minb=1550MB/s, maxb=1550MB/s, mint=86565msec, maxt=86565msec
> ...
> 
> Numbers are identical.  Either BRBD wasn't actually copying anything
> during the previous FIO run, its nice level changed, its
> configuration/behavior changed with the new version, or something.
> Whatever the reason, it appears to be putting no load on the array.

Very surprising indeed... I'll still keep DRBD disconnected during the
day until I get a better handle on what is going on here.... I would
have expected *some* impact....

>> So, it looks like the ideal value is actually smaller (4096) although
>> there is not much difference between 8192 and 4096. It seems strange
>> that a larger cache size will actually reduce performance... I'll change
> 
> It's not strange at all, but expected.  As a table gets larger it takes
> more CPU cycles to manage it and more memory bandwidth; your cache miss
> rate increases, etc.  At a certain point this overhead becomes
> detrimental instead of beneficial.  In your case the size of the cache
> table outweighs the overhead and yields increased performance up to 80MB
> table size.  At 160MB and above the size of the table creates more
> overhead than performance benefit.
> 
> This is what system testing/tuning is all about.

Of course, I suppose I assumed cache table management had zero cost
(CPU/memory bandwidth) but at these speeds, it would be quite a big
factor...

>> to 4096 for the time being, unless you think "real world" performance
>> might be better with 8192?
> 
> These FIO runs are hitting your IO subsystem much harder than your real
> workloads every will.  Stick with 4096.

Very true... At 1.6GB/s that is equivalent (approx) to 8 x 1Gbps
ethernet, which is the maximum that all the machines can push at the
same time... and that is only write performance, read performance is
even higher.

>> Here are the results of re-running fio using the previous config (with
>> drbd connected with the stripe_cache_size = 8192):
>>>    READ: io=4096MB, aggrb=2244MB/s, minb=2298MB/s, maxb=2298MB/s, mint=1825msec, maxt=1825msec
>>>   WRITE: io=4096MB, aggrb=494903KB/s, minb=506780KB/s, maxb=506780KB/s, mint=8475msec, maxt=8475msec
>>
>> Perhaps the old fio test just isn't as well suited to the way drbd
>> handles things. Though the issue would be what sort of data the real
>> users are doing, because if that matches the old fio test or the new fio
>> test, it makes a big difference.
> 
> The significantly lower throughput of the "old" FIO job has *nothing* to
> do with DRBD.  It has everything to do with the parameters of the job
> file.  I thought I explained the differences previously.  If not, here
> you go:

Thanks :)

>> So, it looks like it is the stripe_cache_size that is affecting
>> performance, and that DRBD makes no difference whether it is connected
>> or not. Possibly removing it completely would increase performance
>> somewhat, but since I actually do need it, and that is somewhat
>> destructive, I won't try that :)
> 
> I'd do more investigating of this.  DRBD can't put zero load on the
> array if it's doing work.  Given it's a read only workload, it's
> possible the increased stripe cache is allowing full throttle writes
> while doing 100MB/s of reads, without writes being impacted.  You'll
> need to look deeper into the md statistics and/or monitor iostat, etc,
> during runs with DRBD active and actually moving data.

Yes, will check this out more carefully before I will re-enable DRBD
during the day....

>>> FIO runs on Windows:  http://www.bluestop.org/fio/
>>
>> Will check into that, it will be the ultimate end-to-end test.... Also,
> 
> Yes, it will.  As long as you're running at least 16-32 threads per TS
> client to overcome TCP/iSCSI over GbE latency, and the lack of AIO on
> Windows.  And you can't simply reuse the same job file.  The docs tell
> you which engine, and other settings, to use for Windows.

Well, I used mostly the same fio file... just changed the engine, and
size of the test down to 1GB (so the test would finish more quickly)

>> Hmmm, good point, I realised I could try and upgrade to the x64 windows
>> 2003, but I think I'd prefer to just move up to 2008 x64 (or 2012)...
>> For now, I'll just keep using my hacky 4GB RAM drive for the pagefile...
> 
> Or violate BCP and run two TS instances per Xen, or even four, with the
> appropriate number of users per each.  KSM will consolidate all the
> Windows and user application read only files (DLLs, exes, etc), yielding
> much more free real memory than with a single Windows TS instance.
> AFAIK Windows has no memory merging so you can't over commit memory
> other than with the page file, which is horribly less efficient than KSM.

BCP = Best Computing Practise ?
KSM = Kernel SamePage Merging ? (Had to ask wikipedia for this one)...

I'm not sure xen supports this currently.... However, in addition to
either saving RAM / spending more CPU managing this, there is also the
licensing consideration of purchasing more windows server licenses.
Overall, probably better spend on newer versions/upgrading...

>> I meant I hadn't crossed off as many items from my list of things to
>> do... Not that I hadn't improved performance significantly :)
> I know, was just poking you in the ribs. ;)

Ouch :)

>>> To find out how much of the 732MB/s write throughput increase is due to
>>> buffering 512 stripes instead of 16, simply change it back to 256,
>>> re-run my FIO job file, and subtract the write result from 1292MB/s.
>>
>> So, running your FIO job file with the original 256 give a write speed
>> of 950MB/s and the previous FIO file gives 509MB/s. So it would seem the
>> increase in stripe_cache_size from 256 to 4096 give an increase in your
>> FIO job from 950MB/s to 1634MB/s which is a significant speed boost. I
> 
> 72 percent increase with this synthetic workload, by simply increasing
> the stripe cache.  Not bad eh?  This job doesn't present an accurate
> picture of real world performance though, as most synthetic tests don't.
> 
> Get DRBD a hump'n and your LVM snapshot(s) in place, all the normal
> server side load, then fire up the 32 thread FIO test on each TS VM to
> simulate users (I could probably knock out this job file if you like).
> Then monitor the array throughput with iostat or similar.  This would be
> about as close to peak real world load as you can get.

Interestingly I noted that fio can run in server/client mode, so in
theory I should be able to run a central job to instruct all the other
machines to start testing at the same time.... I'll work on this soon...

>> must wonder why we have a default of 256 when this can make such a
>> significant performance improvement?  A value of 4096 with a 5 drive raid
>> array is only 80MB of cache, I suspect very few users with a 5 drive
>> RAID array would be concerned about losing 80MB of RAM, and a 2 drive
>> RAID array would only use 32MB ...
> 
> The stripe cache has nothing to do with device count, but hardware
> throughput.  Did you happen to notice what occurred when you increased
> cache size past your 4096 sweet spot to 32768?  Throughput dropped by
> ~500MB/s, almost 1/3rd.  Likewise, for the slow rust array whose sweet
> spot is 512, making the default 4096 will decrease his throughput, and
> eat 80MB RAM for nothing.  Defaults are chosen to work best with the
> lowest common denominator hardware, not the Ferrari.

Oh yeah, I forgot about HDD's :) However, I would have thought the cache
would be even more effective when the CPU/memory is so much faster than
the storage medium.... Oh well, that is somebody else's performance
testing/tuning job to work out, I've got enough on my plate right now :)


Thanks to the tip about running fio on windows, I think I've now come
full circle.... Today I had numerous complaints from users that their
outlook froze/etc, and some cases were the TS couldn't copy a file from
the DC to it's local C: (iSCSI). The cause was the DC was logging events
with event ID 2020 which is "The server was unable to allocate from the
system paged pool because the pool was empty". Supposedly the solution
to this is tuning two random numbers in the registry, not much is said
what the consequences of this are, nor about how to calculate the
correct value. However, I think I've worked it out... first, let's look
at the fio results.

Running fio on one of the TS (win2003) against it's local C: (xen ->
iSCSI -> etc) gives this result:
> READ: io=16384MB, aggrb=239547KB/s, minb=239547KB/s, maxb=239547KB/s, mint=70037msec, maxt=0msec
> WRITE: io=16384MB, aggrb=53669KB/s, minb=53669KB/s, maxb=53669KB/s, mint=312601msec, maxt=0msec

To me, the read performance is as good as it can get (239MB/s looks like
2 x 1Gbps ethernet performance)...
The write performance might be a touch slow, but 53MB/s should be more
than enough to keep the users happy. I can come back to this later,
would be nice to see this closer to 200MB/s...

Running the same fio test on the same TS (win2003) against a SMB share
from the DC (SMB -> Win2000 -> Xen -> iSCSI -> etc)
> READ: io=16384MB, aggrb=14818KB/s, minb=14818KB/s, maxb=14818KB/s, mint=1132181msec, maxt=0msec
> WRITE: io=16384MB, aggrb=8039KB/s, minb=8039KB/s, maxb=8039KB/s, mint=2086815msec, maxt=0msec

This is pretty shockingly slow, and seems to clearly indicate why the
users are so upset... 14MB/s read and 8MB/s write, it's a wonder they
haven't formed a mob and lynched me yet!

However, the truly useful information is that during the read portion of
the test, the DC has a CPU load of 100% (no variation, just pegged at
100%), during the write portion, it fluctuates between 80% to 100%.

This could also indicate why the pool was empty, if the CPU is so busy,
it doesn't have time to clean the pool, and so it runs out... One of the
registry entries was to start cleaning the pool sooner (default 80%
suggested to reduce down to 60% or even 40%).

So, I tried again to re-configure windows to support multiprocessor, but
that was another clear failure. (You can change the value/driver in
windows easily, but on reboot it fails to find the HDD, so BSoD or
usually just hangs). Supposedly this can be changed with a "install on
top", but I'll need to take a copy and test that out remotely.
Especially being the DC I am not very comfortable with that.

Next option is to take another shot at upgrade to Win2003, which should
solve the multiprocessor issue, as well as provide much better support
for virtualisation. Though again, it's a major upgrade and could just
introduce a whole bunch of other problems....

Anyway, I've tried to tune a few basic things:
Remove some old devices from Device Manager on the DC
Uninstall some applications/drivers
Disable old unused services (backup software)
Extended the data drive from 279GB to 300GB (it was 90% full, now 84% full)
Adjusted registry entry to try and allocate additional memory to the pool
Increased xen memory allocation for the DC VM from 4096MB to 4200MB. I
suspect xen was keeping some of this memory for it's own overhead, and I
want the VM to get a full 4GB.

I just need to restart the san, to check it is picking up the right
settings on boot, and then put everything back online, and I'm done for
another night....

I'll come back to the benchmarking as soon as I get this DC CPU issue
resolved.

Thanks,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
