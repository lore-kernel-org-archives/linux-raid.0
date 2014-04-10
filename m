From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Growing RAID5 SSD Array
Date: Thu, 10 Apr 2014 03:06:02 -0500
Message-ID: <534650EA.10201@hardwarefreak.com>
References: <53211C9D.8050607@websitemanagers.com.au> <53219D4C.2020207@hardwarefreak.com> <53268B87.4060203@websitemanagers.com.au> <53276C84.5040805@hardwarefreak.com> <5327A462.2060303@websitemanagers.com.au> <53282C6C.4090502@hardwarefreak.com> <5328D5EC.7090303@websitemanagers.com.au> <532A0200.3070000@hardwarefreak.com> <532A5868.8060209@websitemanagers.com.au> <532DE6FC.5010301@hardwarefreak.com> <5331804B.6010708@websitemanagers.com.au> <5331E7AB.9080904@hardwarefreak.com> <53405896.5070902@websitemanagers.com.au> <53441567.3040805@hardwarefreak.com> <5344C51B.5010201@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5344C51B.5010201@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/8/2014 10:57 PM, Adam Goryachev wrote:
> On 09/04/14 01:27, Stan Hoeppner wrote:
>> On 4/5/2014 2:25 PM, Adam Goryachev wrote:
>>> On 26/03/14 07:31, Stan Hoeppner wrote:
>>>> On 3/25/2014 8:10 AM, Adam Goryachev wrote:
...
>>> Would you suggest moving the eth devices to another CPU as well, perhaps
>>> CPU3 ?
>>
>> Spread all the interrupt queues across all cores, starting with CPU3
>> moving backwards and eth0 moving forward, this because IIRC eth0 is your
>> only interface receiving inbound traffic currently, due to a broken
>> balance-alb config.  NICs generally only generate interrupts for inbound
>> packets, so balancing IRQs won't make much difference until you get
>> inbound load balancing working.
> 
> My /proc/interrupts now looks like this:
>   47:      22036          0   78203150          0 IR-PCI-MSI-edge      mpt2sas0-msix0
>   48:       1588          0   78058322          0 IR-PCI-MSI-edge      mpt2sas0-msix1
>   49:        616          0  352803023          0 IR-PCI-MSI-edge      mpt2sas0-msix2
>   50:        382          0   78836976          0 IR-PCI-MSI-edge      mpt2sas0-msix3
>   51:        303          0          0   34032878 IR-PCI-MSI-edge      eth3-TxRx-0
>   52:        120          0          0   49823788 IR-PCI-MSI-edge      eth3-TxRx-1
>   53:        118          0          0   27475141 IR-PCI-MSI-edge      eth3-TxRx-2
>   54:        100          0          0   52690836 IR-PCI-MSI-edge      eth3-TxRx-3
>   55:          2          0          0         13 IR-PCI-MSI-edge      eth3
>   56:    8845363          0          0          0 IR-PCI-MSI-edge      eth0-rx-0
>   57:    7884067          0          0          0 IR-PCI-MSI-edge      eth0-tx-0
>   58:          2          0          0          0 IR-PCI-MSI-edge      eth0
>   59:         26   18534150          0          0 IR-PCI-MSI-edge      eth2-TxRx-0
>   60:         23  292294351          0          0 IR-PCI-MSI-edge      eth2-TxRx-1
>   61:         21   29820261          0          0 IR-PCI-MSI-edge      eth2-TxRx-2
>   62:         21   32405950          0          0 IR-PCI-MSI-edge      eth2-TxRx-3

eth0 is the integrated/management port?  eth2/3 are the two ports of the new 10 GbE?  This should free up all of cpu3 for the RAID5 write thread.  

> I've replaced the 8 x 1G ethernet with the 1 x 10G ethernet (yep, I know, probably not useful, but at least it solved the unbalanced traffic, and removed another potential problem point).

It's overkill, but it does make things much cleaner, simpler to manage.

> So, currently, total IRQ's per core are roughly equal. Given I only have 4 cores, is it still useful to put each IRQ on a different core? Also, most of the IRQ's for the LSI card are all on the same IRQ, so again will it make any difference?

It will make the most difference under heavy RAID write load.  With a light load probably not much.  Given the cost to implement it you can't go wrong here.
 
>>> I'll run a bunch more tests tonight, and get a better idea. For now though:
>>> dd if=/dev/vg0/xptest of=/dev/vg0/testing iflag=direct oflag=direct
>>> bs=1536k count=5k
>>> iostat shows much more solid read and write rates, around 120MB/s peaks,
>>> dd reported 88MB/s, it also shows 0 for rrqm and wrqm, so no more
>>> merging was being done.
>>
>> Moving larger blocks and thus eliminating merges increased throughput a
>> little over 2x.  The absolute data rate is still very poor as something
>> is broken.  Still, doubling throughput with a few command line args is
>> always impressive.

I should have said "eliminating [some of the] merges" here.  There is always merging, see below.

> OK, re-running the above test now (while some other load is active) I get this result from iostat while the copy is running:
> Device:         rrqm/s   wrqm/s     r/s     w/s         rMB/s wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sda            1316.00 11967.80  391.40  791.80    44.96    49.97 164.32     0.83    0.69    0.96    0.56   0.40  47.20
> sdc            1274.00 11918.20  383.00  815.60    44.73    49.81 161.54     0.82    0.67    0.88    0.58   0.39  47.20
> sdd            1288.00 11965.00  388.00  791.00    44.84    49.95 164.65     0.88    0.73    1.05    0.57   0.42  49.28
> sde            1358.00 11972.20  385.00  795.60    45.10    50.00 164.98     0.95    0.79    1.10    0.64   0.44  52.24
> sdf            1304.60 11963.60  393.20  804.80    44.94    50.00 162.30     0.80    0.66    0.93    0.53   0.38  45.84
> sdg            1329.80 11967.00  394.00  802.60    45.03    49.99 162.64     0.80    0.67    0.94    0.53   0.39  46.64
> sdi            1282.60 11937.00  380.80  803.40    44.75    49.84 163.59     0.81    0.67    0.91    0.56   0.40  47.68
> md1               0.00     0.00 4595.00 4693.00   286.00   287.40 126.43     0.00    0.00    0.00    0.00   0.00   0.00
> 
> root@san1:~# dd if=/dev/vg0/xptest of=/dev/vg0/testing iflag=direct oflag=direct bs=1536k count=5k
> 5120+0 records in
> 5120+0 records out
> 8053063680 bytes (8.1 GB) copied, 23.684 s, 340 MB/s
> 
> So, now 340MB/s... but now the merging is being done again. I'm not sure this is going to matter though, see below...

Request merging is always performed.  You just tend to get more merging with small IOs than with large IOs.  Think along the lines of jumbo frames vs standard frames-- more data transferred with less overhead.

>>> The avgrq-sz value is always 128 for the
>>> destination, and almost always 128 for the source during the copy. This
>>> seems to equal 64kB, so I'm not sure why that is if we told dd to use
>>> 1536k ...
>> I'd need to see the actual output to comment intelligently on this.
>> However, do note that application read/write IO size and avgrq-sz
>> reported by iostat are two different things.
>>
>> ...
> See results above...

From 128 to 160, both using 1526 KB block size doing the same copy operation.  I'd say there is other load on the system every time you run a test, and that's causing variable results, possible artificially low results as well.
...
>> Remember:  High throughput requires large IOs in parallel.  High IOPS
>> requires small IOs in parallel.  Bandwidth and IOPS are inversely
>> proportional.
> 
> Yep, I'm working through that learning curve :) I never considered storage to be such a complex topic, and I'm sure I never had to deal with this much before. The last time I sincerely dealt with storage performance was setting up a NNTP news server, where the simple solution was to drop in lots of small (well, compared to current sizes) SCSI drives to allow the nntp server to balance load amongst the different drives. From memory that was all without raid, since if you lost a bunch of newsgroups you just said "too bad" to the users, waited a few days, and everything was fine again :)

The only difference between tuning storage and rocket science is that disk drives don't fly-- until you get really frustrated.

...
>>> I think the parallel part of the workload should be fine in real world
>>> use, since each user and machine will be generating some random load,
>>> which should be delivered in parallel to the stack (LVM/DRBD/MD).
>>> However, in 'real world' use, we don't determine the request size, only
>>> the application or client OS, or perhaps iscsi will determine that.
>>
>> Note that in your previous testing you achieved 200 MB/s iSCSI traffic
>> at the Xen hosts.  Whether using many threads on the client or not,
>> iSCSI over GbE at the server should never be faster than a local LV to
>> LV copy.  Something is misconfigured or you have a bug somewhere.
> 
> Or perhaps we are testing different things. I think the 200MB/s over iSCSI was using fio, with large block sizes, and multiple threads.

Anything over the wire, regardless of thread count and block size, should not be faster than a local single stream operation on the same storage, simply due to TCP latency being at least a hundred times higher than local SATA.  Worth noting, there are many folks on this list who have demonstrated 500 MB/s+ with similar dd streaming but with only a handful of high cap rust drives.  340 MB/s is only about 1/3rd of the minimum I think you should be seeing.  So there's more investigation and optimization to be done.
 
>>> My concern is that while I can get fantastical numbers from specific
>>> tests (such as highly parallel, large block size requests) I don't need
>>> that type of I/O,
>>
>> The previous testing I assisted you with a year ago demonstrated peak
>> hardware read/write throughput of your RAID5 array.  Demonstrating
>> throughput was what you requested, not IOPS.
> 
> Yep, again, my own complete ignorance. Sometimes you just want to see a big number because it looks good, regardless of what it means. At the time I was merely suspicious of a performance issue, and randomly testing things I only partly understood, and then focusing on the items which produced unexpected results. That started as throughput on the SAN.

2.5GB/s is such a large number, and is the parallel FIO read throughput you achieved with 5 SSDs last year.  You should be able to hit 3.5GB/s read throughput with 7 drives and that job file.

318,000 doesn't seem like a big number to some folks these days who are accustomed to quantities in the GB and TB.  But for anyone who has been around storage for a while and understands what "random IOPS" means, this number would make jaws drop just a few years ago.  Before the big storage players started offering SSD based products, a disk based storage system capable of 300K+ random read IOPS would have cost USD $1 million, minimum, and included many FC heads connected to ~2000 disk drives.

>> The broken FIO test you performed, with results down below, demonstrated
>> 320K read IOPS, or 45K IOPS per drive.  This is the inverse test of
>> bandwidth.  Here you also achieved near peak hardware IO rate from the
>> SSDs, which is claimed by Intel at 50K read IOPS.  You have the best of
>> both worlds, max throughput and IOPS.  If you'd not have broken the test
>> your write IOPS would have been correctly demonstrated as well.
>>
>> Playing the broken record again, you simply don't yet understand how to
>> use your benchmarking/testing tools, nor the data, the picture, they are
>> presenting to you.
>>
>>> so my system isn't tuned to my needs.
>> While that statement may be true, the thing(s) not properly tuned are
>> not the SSDs, nor LSI, nor mobo, nor md.  That leaves LVM and DRBD.  And
>> the problems may not be due to tuning but bugs.
> 
> Absolutely, and to be honest, while we have tuned a few of those things I don't think they were significant in the scheme of things. Tuning something that isn't broken might get an extra few percent, but we were always looking to get a significant improvement (like 5x or something).

Some of the tuning you've done did have a big impact on throughput, specifically, testing stripe_cache_size values and settling on 4096.  That alone bumped your sustained measured write throughput from ~1 GB/s to 1.6 GB/s.  And this provided real world benefit.  IIRC before this tuning you were unable to run some daemon in realtime, DRBD or LVM snapshots etc, due to the hit to the storage throughput and resulting low user performance.  After the tuning you were able to reenable it to run realtime due to the extra performance.

Speaking of which, you've increased your data 'spindles' by 50% from 4 to 6, which means your drive level peak write throughput with the parallel IO should now be 2.4 GB/s.  You should run the last FIO job file you used last year that produced the 1.6 GB/s write throughput with stripe_cache_size 4096, for apples to apples 5 drives vs 7 comparison.  Then bump stripe_cache_size to 8192 to see if that helps your sequential write throughput.  Also perform your recent 4KB FIO test at 8192.

>>> After working with linbit (DRBD) I've found out some more useful
>>> information, which puts me right back to the beginning I think, but with
>>> a lot more experience and knowledge.
>>> It seems that DRBD keeps it's own "journal", so every write is written
>>> to the journal, then it's bitmap is marked, then the journal is written
>>> to the data area, then the bitmap updated again, and then start over for
>>> the next write. This means it is doing lots and lots of small writes to
>>> the same areas of the disk ie, 4k blocks.
>>
>> Your 5 SSDs had a combined ~160,000 4KB IOPS write performance.  Your 7
>> SSDs should hit ~240,000 4KB write IOPS when configured properly.  To
>> put this into perspective, an array comprised of 15K SAS drives in RAID0
>> would require 533 and 800 drives respectively to reach the same IOPS
>> performance, 1066 and 1600 drives in RAID10.
>
> OK, so like I always thought, the hardware I have *should* be producing some awesome performance... 

Your server isn't the problem.  The MS Windows infrastructure is.  

> I'd hate to think how someone might connect 1600 15k SAS drives, nor the noise, heat, power draw, etc..

This is small potatoes for large enterprises, sites serving lots of HD video, and of course the HPC labs such as NCSA, ORNL, LLNL, NASA's NAS, LHC, et al with their multiple petabyte Lustre storage.  The 4U 60 drive SAN/DAS/JBOD chassis becoming popular today pack 1800 drives in just three 19" cabinets.  Many HPC clusters are connected to dozens of such cabinets.

...
>>> [global]
>>> filename=/dev/vg0/testing
>>> zero_buffers
>>> numjobs=16
>>> thread
>>> group_reporting
>>> blocksize=4k
>>> ioengine=libaio
>>> iodepth=16
>>> direct=1
>>
>> It's generally a bad idea to mix size and run time.  It makes results
>> non deterministic.  Best to use one or the other.  But you have much
>> bigger problems here...
>>
>>> runtime=60
>>> size=16g
>>
>> 16 jobs * 2 streams (read + write) * 16 GB per stream = 512 GB required
>> for this test.  The size= parm is per job thread, not aggregate.  What
>> was the capacity of /dev/vg0/testing?  Is this a filesystem or raw
>> device?  I'm assuming raw device of capacity well less than 512 GB.
> 
> From running the tests, fio runs one stream (read or write) at a time, not both concurrently. So it does the read test first, and then does the write test.

Correct, that is how fio executes.  But that's not the point of confusion here, which I finally figured it out.  My apologies for not catching this sooner.  After re-re-reading your job file I realized you're specifying "filename=" instead of "directory=".  I'd assumed you always used the latter as I thought this was in my example job files I sent you, and that you stuck with that.   "directory=" gives you numb_jobs*2 files, each of size "size=" by default.  Specifying one file in "filename=" will cause all threads to read/write the same file.  So fio should have been using single a 16 GB file, as you thought, or, apparently in your case 16 GB of a raw device space.  This is correct, yes?  This device has no filesystem, correct?

However, many filesystems tend to achieve poor performance writing to different parts of one file in parallel.  fio does this without locking so it's not as bad as the normal case.  But even so performance is typically less than accessing multiple files in parallel.

Which filesystem is on this LV?  Is it aligned to the RAID geometry?

...
> What I thought that was doing is making 16 requests in parallel, with a total test size of 16G.  Clearly a mistake again.

Yes it was, but this time it was my mistake.

>>>    read : io=74697MB, bw=1244.1MB/s, iops=318691 , runt= 60003msec
>>                ^^^^^^^                      ^^^^^^
>>
>> 318K IOPS is 45K IOPS per drive, all 7 active on reads.  This is
>> awesome, and close to the claimed peak hardware performance of 50K 4KB
>> read IOPS per drive.
>
> Yep, read performance is awesome, and I don't think this was ever an issue... at least, not for a long time (or my memory is corrupt)...

Write performance hadn't been severely lacking either.  It simply needed to be demonstrated and quantified, and tweaked a bit.

>>>      lat (usec) : 2=3.34%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
>>>      lat (usec) : 100=0.01%, 250=3.67%, 500=31.43%, 750=24.55%, 1000=13.33%
>>>      lat (msec) : 2=19.37%, 4=4.25%, 10=0.04%, 20=0.01%, 50=0.01%
>>>      lat (msec) : 100=0.01%, 250=0.01%, 1000=0.01%, 2000=0.01%
>>
>> 76% of read IOPS completed in 1 millisecond or less, 63% in 750
>> microseconds or less, and 31% in 500 microseconds or less.  This is
>> nearly perfect for 7 of these SSDs.
> 
> Inadvertently, I have ended up with 5 x SSDSC2CW480A3 + 2 x SSDSC2BW480A4 in each server. I noticed significantly higher %util reported by iostat on the 2 SSD's compared to the other 5. 

Which is interesting as the A4 is presumably newer than the A3.

> Finally on Monday I moved two of the SSDSC2CW480A3 models from the second server into the primary, (one at a time) and the two SSDSC2BW480A4 into the second server. So then I had 7 x SSDSC2CW480A3 in the primary, and the secondary had 3 of them plus 4 of the other model. iostat on the primary then showed a much more balanced load across all 7 of the SSD's in the primary (with DRBD disconnected).
> BTW, when I say much higher, the 2 SSD's would should 40% while the other 5 would should around 10%, with the two peaking at 100% while the other 5 would peak at 30%...

Swapped out two drives from a 7 drive SSD RAID5?  How long did each rebuild take?

> I haven't been able to find detailed enough specs on the differences between these two models to explain that yet. In any case, the SSDSC2CW480A3 model is no longer available, so I can't order more of them anyway.

Did you check to see if newer firmware is available for these two?
 
... 
> One other explanation for the different sizes might be that the bandwidth was different, but the time was constant (because I specified the time option as well). In any case, the performance difference might easily be due to your suggestion, which was definitely another idea I was having. 

Usually latencies this high with SSDs are due to GC, i.e. lack of trim.  A few microseconds of the latency could be in the IO path, but you're seeing a huge number of IOs at 10ms, which just has to be occurring inside the SSDs.

> I was thinking now that I have more drives, I could go back to the old solution of leaving some un-allocated space on each drive. However to do that I would have needed to reduce the PV ensuring no allocated blocks at the "end" of the MD, then reduce the MD, and finally reduce the partition. Then I still needed to find a method to tell the SSD that the space is now unused (trim). Now I think it isn't so important any more...

That would be option Z for me.

>>> So, a maximum of 237MB/s write. Once DRBD takes that and adds it's
>>> overhead, I'm getting approx 10% of that performance (some of the time,
>>> other times I'm getting even less, but that is probably yet another issue).
>>>
>>> Now, 237MB/s is pretty poor, and when you try and share that between a
>>> dozen VM's, with some of those VM's trying to work on 2+ GB files
>>> (outlook users), then I suspect that is why there are so many issues.
>>> The question is, what can I do to improve this? Should I use RAID5 with
>>> a smaller stripe size? Should I use RAID10 or RAID1+linear? Could the
>>> issue be from LVM? LVM is using 4MB Physical Extents, from reading
>>> though, nobody seems to worry about the PE size related to performance
>>> (only LVM1 had a limit on the number of PE's... which meant a larger LV
>>> required larger PE's).
>> I suspect you'll be rethinking the above after running a proper FIO test
>> for 4KB IOPS.  Try numjobs=8 and size=500m, for an 8 GB test, assuming
>> the test LV is greater than 8 GB in size.
>>
>> ...
> OK, I'll retry with numjobs=16 and size=1G which should require a 32G LV, which should be fine with my 50G LV.

Actually the total is apparently 1 GB.  I must say I really do dislike the raw device target.

> read: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
> ...
> read: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
> write: (g=1): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
> ...
> write: (g=1): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
> 2.0.8
> Starting 32 threads
> Jobs: 2 (f=2): [_________________w_____________w] [100.0% done] [0K/157.9M /s] [0 /40.5K iops] [eta 00m:00s]]
> read: (groupid=0, jobs=16): err= 0: pid=26714
>   read : io=16384MB, bw=1267.4MB/s, iops=324360 , runt= 12931msec
>     slat (usec): min=1 , max=141080 , avg= 7.28, stdev=141.90
>     clat (usec): min=9 , max=207827 , avg=764.34, stdev=962.30
>      lat (usec): min=55 , max=207831 , avg=771.84, stdev=981.10
>     clat percentiles (usec):
>      |  1.00th=[  159],  5.00th=[  215], 10.00th=[  262], 20.00th=[ 342],
>      | 30.00th=[  426], 40.00th=[  524], 50.00th=[  628], 60.00th=[ 740],
>      | 70.00th=[  868], 80.00th=[ 1048], 90.00th=[ 1352], 95.00th=[ 1672],
>      | 99.00th=[ 2672], 99.50th=[ 3632], 99.90th=[ 8896], 99.95th=[13632],
>      | 99.99th=[36608]
>     bw (KB/s)  : min=40608, max=109600, per=6.29%, avg=81566.38, stdev=8098.56
>     lat (usec) : 10=0.01%, 20=0.01%, 50=0.01%, 100=0.02%, 250=8.72%
>     lat (usec) : 500=29.09%, 750=23.21%, 1000=16.65%
>     lat (msec) : 2=19.74%, 4=2.16%, 10=0.33%, 20=0.05%, 50=0.02%
>     lat (msec) : 100=0.01%, 250=0.01%
>   cpu          : usr=41.33%, sys=238.07%, ctx=48328280, majf=0, minf=64230
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=4194304/w=0/d=0, short=r=0/w=0/d=0
> write: (groupid=1, jobs=16): err= 0: pid=27973
>   write: io=16384MB, bw=262686KB/s, iops=65671 , runt= 63868msec
>     slat (usec): min=2 , max=4387.4K, avg=64.75, stdev=9203.16
>     clat (usec): min=13 , max=6500.9K, avg=3692.55, stdev=47966.38
>      lat (usec): min=64 , max=6500.9K, avg=3757.42, stdev=48862.99
>     clat percentiles (usec):
>      |  1.00th=[  410],  5.00th=[  564], 10.00th=[  700], 20.00th=[ 1080],
>      | 30.00th=[ 1432], 40.00th=[ 1688], 50.00th=[ 1880], 60.00th=[ 2064],
>      | 70.00th=[ 2256], 80.00th=[ 2480], 90.00th=[ 2992], 95.00th=[ 3632],
>      | 99.00th=[ 8640], 99.50th=[12736], 99.90th=[577536], 99.95th=[954368],
>      | 99.99th=[2146304]
>     bw (KB/s)  : min=   97, max=56592, per=7.49%, avg=19678.60, stdev=8387.79
>     lat (usec) : 20=0.01%, 100=0.01%, 250=0.08%, 500=2.74%, 750=8.96%
>     lat (usec) : 1000=6.49%
>     lat (msec) : 2=38.00%, 4=40.30%, 10=2.68%, 20=0.36%, 50=0.02%
>     lat (msec) : 100=0.14%, 250=0.06%, 500=0.07%, 750=0.04%, 1000=0.03%
>     lat (msec) : 2000=0.03%, >=2000=0.01%
>   cpu          : usr=10.05%, sys=40.27%, ctx=60488513, majf=0, minf=62068
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=4194304/d=0, short=r=0/w=0/d=0
> 
> Run status group 0 (all jobs):
>    READ: io=16384MB, aggrb=1267.4MB/s, minb=1267.4MB/s, maxb=1267.4MB/s, mint=12931msec, maxt=12931msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=16384MB, aggrb=262685KB/s, minb=262685KB/s, maxb=262685KB/s, mint=63868msec, maxt=63868msec
> 
> So, I don't think that made a lot of difference to the results.

Measured 65K random write IOPS performance is much lower than I'd expect given the advertised rates for SandForce 22xx based SSDs.  However, putting this into perspective...

15K SAS drives peak at 300 random seeks/second.
65K random write IOPS = ((65671/300)*2)= 436 SAS 15K drives using nested RAID10.
A 6ft 40U cabinet containing 18x 2U 24 drive chassis provides 432 drives, 4U for the server.
Practically speaking, it's a full rack of 15K SAS drives.

If you had this sitting next to your server cage providing your storage, would you consider it insufficient, or overkill on the scale of hunting mice with nukes?

>>> BTW, I've also split the domain controller to a win2008R2 server, and
>>> upgraded the file server to win2012R2.
>> I take it you decided this route had fewer potential pitfalls than
>> reassigning the DC share LUN to a new VM with the same Windows host
>> name, exporting/importing the shares, etc?  It'll be interesting to see
>> if this resolves some/all of the problems.  Have my fingers crossed for ya.
> 
> It wasn't clear, but what I meant was:
> 1) Install new 2008R2 server, promote to DC, migrate roles across to it, etc
> 2) Install new 2012R2 server
> 3) export registry with share information and shutdown the old 2003 server
> 4) change name of the new server (to the same as the old server) and join the domain
> 5) attach the existing LUN to the 2012R2 server
> 6) import the registry information

Got it.

> Short answer, it seemed to have a variable result, but I think that was just the usual some days are good and some days are bad, depending on who is doing what, when, and how much the users decide to complain.

How many use a full TS desktop as their "PC"?  Are standalone PC users complaining about performance as well?

>> Please don't feel I'm picking on you WRT your understanding of IO
>> performance, benching, etc.  It is not my intent to belittle you.  It is
>> critical that you better understand Linux block IO, proper testing,
>> correctly interpreting the results.  Once you do you can realize if/when
>> and where you do actually have problems, instead of thinking you have a
>> problem where none exists.
> 
> Absolutely, and I do appreciate the lessons. I apologise for needing so much "hand holding", but hopefully we are almost at the end.
> 
> After some more work with linbit, they logged in, and took a look around, doing some of their own measurements, and the outcome was to add the following three options to the DRBD config file, which improved the DRBD IOPS from around 3000 to 50000.
>         disk-barrier no;
>         disk-flushes no;
>         md-flushes no;
> 
> Essentially DRBD was disabling the SSD write cache by forcing every write to be completed before returning, and this was drastically reducing the IOPS that could be achieved.

The plot thickens.  When you previously mentioned DRBD writes a journal log it didn't click that they'd be doing barriers and flushes.  But this makes perfect sense given the mirror function of DRBD.

> Running the same test against the DRBD device, in a connected state:
> read: (groupid=0, jobs=16): err= 0: pid=4498
>   read : io=16384MB, bw=1238.8MB/s, iops=317125 , runt= 13226msec
>     slat (usec): min=0 , max=997330 , avg=11.16, stdev=992.34
>     clat (usec): min=0 , max=1015.8K, avg=769.38, stdev=7791.99
>      lat (usec): min=0 , max=1018.6K, avg=781.10, stdev=7873.73
>     clat percentiles (usec):
>      |  1.00th=[    0],  5.00th=[    0], 10.00th=[  195], 20.00th=[ 298],
>      | 30.00th=[  370], 40.00th=[  446], 50.00th=[  532], 60.00th=[ 620],
>      | 70.00th=[  732], 80.00th=[  876], 90.00th=[ 1144], 95.00th=[ 1480],
>      | 99.00th=[ 4896], 99.50th=[ 7200], 99.90th=[16512], 99.95th=[21888],
>      | 99.99th=[53504]
>     bw (KB/s)  : min= 5085, max=305504, per=6.35%, avg=80531.22, stdev=29062.40
>     lat (usec) : 2=7.73%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
>     lat (usec) : 100=0.04%, 250=6.78%, 500=32.00%, 750=25.02%, 1000=14.15%
>     lat (msec) : 2=11.28%, 4=1.64%, 10=1.10%, 20=0.20%, 50=0.05%
>     lat (msec) : 100=0.01%, 250=0.01%, 1000=0.01%, 2000=0.01%
>   cpu          : usr=41.05%, sys=253.29%, ctx=49215916, majf=0, minf=65328
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=4194304/w=0/d=0, short=r=0/w=0/d=0
> write: (groupid=1, jobs=16): err= 0: pid=5163
>   write: io=16384MB, bw=138483KB/s, iops=34620 , runt=121150msec
>     slat (usec): min=1 , max=84258 , avg=20.68, stdev=303.42
>     clat (usec): min=179 , max=123372 , avg=7354.94, stdev=3634.96
>      lat (usec): min=187 , max=132967 , avg=7375.81, stdev=3644.96
>     clat percentiles (usec):
>      |  1.00th=[ 3696],  5.00th=[ 4576], 10.00th=[ 5088], 20.00th=[ 5920],
>      | 30.00th=[ 6560], 40.00th=[ 7008], 50.00th=[ 7328], 60.00th=[ 7584],
>      | 70.00th=[ 7840], 80.00th=[ 8160], 90.00th=[ 8640], 95.00th=[ 9280],
>      | 99.00th=[13504], 99.50th=[23168], 99.90th=[67072], 99.95th=[70144],
>      | 99.99th=[75264]
>     bw (KB/s)  : min= 5976, max=12447, per=6.26%, avg=8673.20, stdev=731.62
>     lat (usec) : 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
>     lat (msec) : 2=0.09%, 4=1.76%, 10=94.97%, 20=2.61%, 50=0.29%
>     lat (msec) : 100=0.26%, 250=0.01%
>   cpu          : usr=8.99%, sys=33.90%, ctx=71679376, majf=0, minf=69677
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=4194304/d=0, short=r=0/w=0/d=0
> 
> Run status group 0 (all jobs):
>    READ: io=16384MB, aggrb=1238.8MB/s, minb=1238.8MB/s, maxb=1238.8MB/s, mint=13226msec, maxt=13226msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=16384MB, aggrb=138483KB/s, minb=138483KB/s, maxb=138483KB/s, mint=121150msec, maxt=121150msec
> 
> Disk stats (read/write):
>   drbd17: ios=4194477/4188834, merge=0/0, ticks=2645376/30507320, in_queue=33171672, util=99.81%
> 
> 
> Here is the summary of the first fio above:
>   read : io=16384MB, bw=1267.4MB/s, iops=324360 , runt= 12931msec
>   write: io=16384MB, bw=262686KB/s, iops=65671 , runt= 63868msec
>    READ: io=16384MB, aggrb=1267.4MB/s, minb=1267.4MB/s, maxb=1267.4MB/s, mint=12931msec, maxt=12931msec
>   WRITE: io=16384MB, aggrb=262685KB/s, minb=262685KB/s, maxb=262685KB/s, mint=63868msec, maxt=63868msec

Given that even with the new settings DRBD cuts your random IOPS in half, it would make a lot of sense to move the journal off the array and onto the system SSD, since as you stated it is idle all the time.  XFS allows one to put the journal on a separate device for precisely this reason.  Does DRBD?  If not, request this feature be added.  There's no technical requirement that ties the journal to the device being mirrored.

> So, do you still think there is an issue (from looking the the first fio results above) with getting "only" 65k IOPS write?

Yes.  But I think the bulk of the issue is your benchmark configuration, mainly the tiny sliver of the array you keep hammering with test write IOs.

> One potential clue I did find was hidden in the Intel specs:
> Firstly Intel markets it here:
> http://www.intel.com/content/www/us/en/solid-state-drives/solid-state-drives-520-series.html
> 480GB     SATA 6Gb/s 550 MB/s / 520 MB/s
> SATA 3Gb/s       280 MB/s / 260 MB/s     50,000 IOPS / 50,000 IOPS     9.5mm 2.5-inch SATA

That link doesn't work for me, but the ARK always has the info:
http://ark.intel.com/products/66251/Intel-SSD-520-Series-480GB-2_5in-SATA-6Gbs-25nm-MLC

Their 4KB random write IOPS tests are performed on an "out of box" SSD, meaning all fresh cells.  They only write 8 GB but randomly across the entire LBA range, all 480 GB.  This prevents wear leveling from kicking in.  The yield is 42K write IOPS.

You're achieving 1/4th of that IOPS rate with non trimmed heavily used drives and testing greater than 8 GB.  Recall I suggested you test with only 8 GB or less?  It should actually be much smaller given the LV device size.  Realistically, you should be testing over the entire capacity of all the drives, but that's not possible.  Hitting this small LV causes the wear leveling routine to attack like a rabid dog, remapping erase blocks on the fly and thus dragging down interface performance dramatically due to all of the internal data shuffling going on.  This is the cause of the large number of IOPS requiring 4, 10, and 20ms to complete.

LVM supports TRIM for some destructive operations:
https://wiki.debian.org/SSDOptimization#A.2Fetc.2Flvm.2Flvm.conf_example

You could enable TRIM support and lvremove the 50 GB device.  This action should trim the ~7 GB on each drive, if your kernel version's md RAID5 module supports TRIM pass through--I haven't kept up.  Then create a new LV device.  Should be fully trimmed and fresh.  Ask other for status of RAID5 TRIM pass through and your kernel version.

> However, here: http://www.intel.com/content/dam/www/public/us/en/documents/product-specifications/ssd-530-sata-specification.pdf

This is the 530 series, although it is very similar to your 520s.  

> Table 5 shows the Incompressible Performance:
> 480GB     Random 4k Read 37500 IOPS       Random 4k Write 13000 IOPS

zero_buffers

in your job file causes all writes to be zeros.  This should be allowing maximum compression by the SF-22xx controllers on the SSDs.

> So, now we might be better placed to calculate the "expected" results? 13000 * 6 = 78000, we are getting 65000, which is not very far away.

Unless your fio is broken, bugged, and not zeroing buffers, I can't see compression being a factor in the low benching throughput.  Everything seems to point to garbage collection, i.e. wear leveling.  Note that you're achieving ~45K read IOPS per drive with worn no-TRIM drives, huge data sets compared to Intel's tests, and on a tiny sliver of each SSD.  Intel says 50K on pristine drives.

In almost all cases where SSD write performance is much lower than spec, decreases over time, etc, it is due to lack of TRIM and massive wear leveling kicking in as a result.

> So, for yesterday and today, with the barriers/flushes disabled, things seem to be working well, 

Good to hear.

> I haven't had any user complaints, and that makes me happy :) 

Also good to hear.  But even with 'only' 35K IOPS available w/DRBD running, that's equivalent to 232 SAS 15K drives in RAID 10, which should be a tad bit more than sufficient.  So I'm guessing this may be the normal case of the benchmarks not accurately reflecting reality, your actual workload.

> However, if you still think I should be able to get 200000 IOPS or higher on write, then I'll definitely be interested in investigating further.

You can surely achieve close to it with future fio testing, but the results may not be very informative as we already know the bulk of the performance hit is the result of no TRIM and garbage collection.  Larger stripe_cache_size may help a little, but the lvremove with TRIM should help far more if that 50 GB is the only slice available for testing.  To hit Intel's published write numbers may require secure erasing the drives making them factory fresh, and that's not an option on a production machine.

Cheers,

Stan
