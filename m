From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Growing RAID5 SSD Array
Date: Wed, 09 Apr 2014 13:57:15 +1000
Message-ID: <5344C51B.5010201@websitemanagers.com.au>
References: <53211C9D.8050607@websitemanagers.com.au> <53219D4C.2020207@hardwarefreak.com> <53268B87.4060203@websitemanagers.com.au> <53276C84.5040805@hardwarefreak.com> <5327A462.2060303@websitemanagers.com.au> <53282C6C.4090502@hardwarefreak.com> <5328D5EC.7090303@websitemanagers.com.au> <532A0200.3070000@hardwarefreak.com> <532A5868.8060209@websitemanagers.com.au> <532DE6FC.5010301@hardwarefreak.com> <5331804B.6010708@websitemanagers.com.au> <5331E7AB.9080904@hardwarefreak.com> <53405896.5070902@websitemanagers.com.au> <53441567.3040805@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53441567.3040805@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/04/14 01:27, Stan Hoeppner wrote:
> On 4/5/2014 2:25 PM, Adam Goryachev wrote:
>> On 26/03/14 07:31, Stan Hoeppner wrote:
>>> On 3/25/2014 8:10 AM, Adam Goryachev wrote:
> ...
> ...
>> OK, I'm going to add the following to the /etc/rc.local:
>> for irq in `cat /proc/interrupts |grep mpt2sas| awk -F: '{ print $1}'`
>> do
>>          echo 4 > /proc/irq/${irq}/smp_affinity
>> done
>>
>> That will move the LSI card interrupt processing to CPU2 like this:
>>    57:  143806142       7246      41052          0 IR-PCI-MSI-edge
>> mpt2sas0-msix0
>>    58:   14381650          0      22952          0 IR-PCI-MSI-edge
>> mpt2sas0-msix1
>>    59:    6733526          0     144387          0 IR-PCI-MSI-edge
>> mpt2sas0-msix2
>>    60:    3342802          0      32053          0 IR-PCI-MSI-edge
>> mpt2sas0-msix3
>>
>> You can see I briefly moved one to CPU1 as well.
> Most of your block IO interrupts are read traffic.  md/RAID5 reads are
> fully threaded, unlike writes, and can be serviced by any core.  Assign
> each LSI interrupt queue to a different core.
>
>> Would you suggest moving the eth devices to another CPU as well, perhaps
>> CPU3 ?
> Spread all the interrupt queues across all cores, starting with CPU3
> moving backwards and eth0 moving forward, this because IIRC eth0 is your
> only interface receiving inbound traffic currently, due to a broken
> balance-alb config.  NICs generally only generate interrupts for inbound
> packets, so balancing IRQs won't make much difference until you get
> inbound load balancing working.
>
> ...

My /proc/interrupts now looks like this:
   47:      22036          0   78203150          0 IR-PCI-MSI-edge      
mpt2sas0-msix0
   48:       1588          0   78058322          0 IR-PCI-MSI-edge      
mpt2sas0-msix1
   49:        616          0  352803023          0 IR-PCI-MSI-edge      
mpt2sas0-msix2
   50:        382          0   78836976          0 IR-PCI-MSI-edge      
mpt2sas0-msix3
   51:        303          0          0   34032878 IR-PCI-MSI-edge      
eth3-TxRx-0
   52:        120          0          0   49823788 IR-PCI-MSI-edge      
eth3-TxRx-1
   53:        118          0          0   27475141 IR-PCI-MSI-edge      
eth3-TxRx-2
   54:        100          0          0   52690836 IR-PCI-MSI-edge      
eth3-TxRx-3
   55:          2          0          0         13 IR-PCI-MSI-edge      eth3
   56:    8845363          0          0          0 IR-PCI-MSI-edge      
eth0-rx-0
   57:    7884067          0          0          0 IR-PCI-MSI-edge      
eth0-tx-0
   58:          2          0          0          0 IR-PCI-MSI-edge      eth0
   59:         26   18534150          0          0 IR-PCI-MSI-edge      
eth2-TxRx-0
   60:         23  292294351          0          0 IR-PCI-MSI-edge      
eth2-TxRx-1
   61:         21   29820261          0          0 IR-PCI-MSI-edge      
eth2-TxRx-2
   62:         21   32405950          0          0 IR-PCI-MSI-edge      
eth2-TxRx-3


I've replaced the 8 x 1G ethernet with the 1 x 10G ethernet (yep, I 
know, probably not useful, but at least it solved the unbalanced 
traffic, and removed another potential problem point).
So, currently, total IRQ's per core are roughly equal. Given I only have 
4 cores, is it still useful to put each IRQ on a different core? Also, 
most of the IRQ's for the LSI card are all on the same IRQ, so again 
will it make any difference?

>> I'll run a bunch more tests tonight, and get a better idea. For now though:
>> dd if=/dev/vg0/xptest of=/dev/vg0/testing iflag=direct oflag=direct
>> bs=1536k count=5k
>> iostat shows much more solid read and write rates, around 120MB/s peaks,
>> dd reported 88MB/s, it also shows 0 for rrqm and wrqm, so no more
>> merging was being done.
> Moving larger blocks and thus eliminating merges increased throughput a
> little over 2x.  The absolute data rate is still very poor as something
> is broken.  Still, doubling throughput with a few command line args is
> always impressive.

OK, re-running the above test now (while some other load is active) I 
get this result from iostat while the copy is running:
Device:         rrqm/s   wrqm/s     r/s     w/s         rMB/s wMB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda            1316.00 11967.80  391.40  791.80    44.96    49.97 
164.32     0.83    0.69    0.96    0.56   0.40  47.20
sdc            1274.00 11918.20  383.00  815.60    44.73    49.81 
161.54     0.82    0.67    0.88    0.58   0.39  47.20
sdd            1288.00 11965.00  388.00  791.00    44.84    49.95 
164.65     0.88    0.73    1.05    0.57   0.42  49.28
sde            1358.00 11972.20  385.00  795.60    45.10    50.00 
164.98     0.95    0.79    1.10    0.64   0.44  52.24
sdf            1304.60 11963.60  393.20  804.80    44.94    50.00 
162.30     0.80    0.66    0.93    0.53   0.38  45.84
sdg            1329.80 11967.00  394.00  802.60    45.03    49.99 
162.64     0.80    0.67    0.94    0.53   0.39  46.64
sdi            1282.60 11937.00  380.80  803.40    44.75    49.84 
163.59     0.81    0.67    0.91    0.56   0.40  47.68
md1               0.00     0.00 4595.00 4693.00   286.00   287.40 
126.43     0.00    0.00    0.00    0.00   0.00   0.00

root@san1:~# dd if=/dev/vg0/xptest of=/dev/vg0/testing iflag=direct 
oflag=direct bs=1536k count=5k
5120+0 records in
5120+0 records out
8053063680 bytes (8.1 GB) copied, 23.684 s, 340 MB/s

So, now 340MB/s... but now the merging is being done again. I'm not sure 
this is going to matter though, see below...

>> The avgrq-sz value is always 128 for the
>> destination, and almost always 128 for the source during the copy. This
>> seems to equal 64kB, so I'm not sure why that is if we told dd to use
>> 1536k ...
> I'd need to see the actual output to comment intelligently on this.
> However, do note that application read/write IO size and avgrq-sz
> reported by iostat are two different things.
>
> ...
See results above...

>> So it looks like CPU0 is less busy, with more work being done on CPU2
>> (the interrupts for the LSI SATA controller)
> The md write thread is typically scheduled on the processor (core) which
> is servicing interrupts for the thread.  The %sy you're seeing on CPU2
> is not interrupt processing but the RAID5 write thread execution.
>
>> If I increase bs=6M then dd reports 130MB/s ...
> You can continue increasing the dd block size and gain small increases
> in throughput incrementally until you hit the wall.  But again,
> something is broken somewhere for single thread throughput to be this low.
>
> ...
>>> According to your iostat output above, drbd2 was indeed still
>>> engaged.  And eating over 59.6% and 91.6% of a core.
>> Nope, definitely not connected, however, it is still part of the IO
>> path, because the LV sits on drbd. So it isn't talking to it's partner,
>> but it still does it's own "work" in between LVM and MD.
>>
>>>> So, I know dd isn't the ideal performance testing tool or metric, but
>>>> I'd really like to know why I can't get more than 40MB/s. There is no
>>>> networking, no iscsi, just a fairly simple raid5, drbd, and lvm.
> There is nothing simple at all about a storage architecture involving
> layered lvm, drbd, and md RAID.  This may be a "popular" configuration,
> but popular does not equal "simple".

Sorry, I meant "simple raid5", drbd and lvm or (simple raid5), drbd and 
lvm.... :)

>>> You can get much more than 40MB/s, but you must know your tools, and
>>> gain a better understanding of the Linux IO subsystem.
>> Apologies, it was a second late night in a row, and I wasn't doing very
>> well, I should have remembered my previous lessons about this!
> Remember:  High throughput requires large IOs in parallel.  High IOPS
> requires small IOs in parallel.  Bandwidth and IOPS are inversely
> proportional.
>

Yep, I'm working through that learning curve :) I never considered 
storage to be such a complex topic, and I'm sure I never had to deal 
with this much before. The last time I sincerely dealt with storage 
performance was setting up a NNTP news server, where the simple solution 
was to drop in lots of small (well, compared to current sizes) SCSI 
drives to allow the nntp server to balance load amongst the different 
drives. From memory that was all without raid, since if you lost a bunch 
of newsgroups you just said "too bad" to the users, waited a few days, 
and everything was fine again :)

>> OK, so thinking this through... We should expect really poor performance
>> if we are not using O_DIRECT, and not doing large requests in parallel.
> You should never expect poor performance with a single thread, but not
> full hardware potential of the SSDs either.  Something odd is going on
> in your current setup if a dd copy with large block size and O_DIRECT
> can only hit 130 MB/s to an array of 7 of these SandForce based Intel
> SSDs.  You should be able to hit a few hundred MB/s with a simultaneous
> read and write stream from one LV to another.  Something is plugging a
> big finger into the ends of your fat IO pipe when single streaming.
> Determining what this finger is will require some investigation.

I think we might have part of the answer... see below...

>
>> I think the parallel part of the workload should be fine in real world
>> use, since each user and machine will be generating some random load,
>> which should be delivered in parallel to the stack (LVM/DRBD/MD).
>> However, in 'real world' use, we don't determine the request size, only
>> the application or client OS, or perhaps iscsi will determine that.
> Note that in your previous testing you achieved 200 MB/s iSCSI traffic
> at the Xen hosts.  Whether using many threads on the client or not,
> iSCSI over GbE at the server should never be faster than a local LV to
> LV copy.  Something is misconfigured or you have a bug somewhere.

Or perhaps we are testing different things. I think the 200MB/s over 
iSCSI was using fio, with large block sizes, and multiple threads.

>
>> My concern is that while I can get fantastical numbers from specific
>> tests (such as highly parallel, large block size requests) I don't need
>> that type of I/O,
> The previous testing I assisted you with a year ago demonstrated peak
> hardware read/write throughput of your RAID5 array.  Demonstrating
> throughput was what you requested, not IOPS.

Yep, again, my own complete ignorance. Sometimes you just want to see a 
big number because it looks good, regardless of what it means. At the 
time I was merely suspicious of a performance issue, and randomly 
testing things I only partly understood, and then focusing on the items 
which produced unexpected results. That started as throughput on the SAN.

> The broken FIO test you performed, with results down below, demonstrated
> 320K read IOPS, or 45K IOPS per drive.  This is the inverse test of
> bandwidth.  Here you also achieved near peak hardware IO rate from the
> SSDs, which is claimed by Intel at 50K read IOPS.  You have the best of
> both worlds, max throughput and IOPS.  If you'd not have broken the test
> your write IOPS would have been correctly demonstrated as well.
>
> Playing the broken record again, you simply don't yet understand how to
> use your benchmarking/testing tools, nor the data, the picture, they are
> presenting to you.
>
>> so my system isn't tuned to my needs.
> While that statement may be true, the thing(s) not properly tuned are
> not the SSDs, nor LSI, nor mobo, nor md.  That leaves LVM and DRBD.  And
> the problems may not be due to tuning but bugs.

Absolutely, and to be honest, while we have tuned a few of those things 
I don't think they were significant in the scheme of things. Tuning 
something that isn't broken might get an extra few percent, but we were 
always looking to get a significant improvement (like 5x or something).

>> After working with linbit (DRBD) I've found out some more useful
>> information, which puts me right back to the beginning I think, but with
>> a lot more experience and knowledge.
>> It seems that DRBD keeps it's own "journal", so every write is written
>> to the journal, then it's bitmap is marked, then the journal is written
>> to the data area, then the bitmap updated again, and then start over for
>> the next write. This means it is doing lots and lots of small writes to
>> the same areas of the disk ie, 4k blocks.
> Your 5 SSDs had a combined ~160,000 4KB IOPS write performance.  Your 7
> SSDs should hit ~240,000 4KB write IOPS when configured properly.  To
> put this into perspective, an array comprised of 15K SAS drives in RAID0
> would require 533 and 800 drives respectively to reach the same IOPS
> performance, 1066 and 1600 drives in RAID10.
OK, so like I always thought, the hardware I have *should* be producing 
some awesome performance... I'd hate to think how someone might connect 
1600 15k SAS drives, nor the noise, heat, power draw, etc..

> With that comparison in mind, surely it's clear that your original DRBD
> journal throughput was not creating a bottleneck of any kind at the SSDs.
See below...

>> Anyway, I was advised to re-organise the stack from:
>> RAID5 -> DRBD -> LVM -> iSCSI
>> To:
>> RAID5 -> LVM -> DRBD -> iSCSI
>> This means each DRBD device is smaller, and so the "working set" is
>> smaller, and should be more efficient.
> Makes sense.  But I saw nothing previously to suggest DRBD CPU or memory
> consumption was a problem, nor write IOPS.
>
>> So, now I am easily able to do
>> tests completely excluding drbd by targeting the LV itself. Which means
>> just RAID5 + LVM layers to worry about.
> Recall what I said previously about knowing your tools?
>
> ...
>> [global]
>> filename=/dev/vg0/testing
>> zero_buffers
>> numjobs=16
>> thread
>> group_reporting
>> blocksize=4k
>> ioengine=libaio
>> iodepth=16
>> direct=1
> It's generally a bad idea to mix size and run time.  It makes results
> non deterministic.  Best to use one or the other.  But you have much
> bigger problems here...
>
>> runtime=60
>> size=16g
> 16 jobs * 2 streams (read + write) * 16 GB per stream = 512 GB required
> for this test.  The size= parm is per job thread, not aggregate.  What
> was the capacity of /dev/vg0/testing?  Is this a filesystem or raw
> device?  I'm assuming raw device of capacity well less than 512 GB.

 From running the tests, fio runs one stream (read or write) at a time, 
not both concurrently. So it does the read test first, and then does the 
write test.
   testing       vg0  -wi-ao-- 50.00g
The LV was 50G.... somewhat smaller than the 512GB required then....
What I thought that was doing is making 16 requests in parallel, with a 
total test size of 16G.  Clearly a mistake again.

>>    read : io=74697MB, bw=1244.1MB/s, iops=318691 , runt= 60003msec
>                ^^^^^^^                      ^^^^^^
>
> 318K IOPS is 45K IOPS per drive, all 7 active on reads.  This is
> awesome, and close to the claimed peak hardware performance of 50K 4KB
> read IOPS per drive.
Yep, read performance is awesome, and I don't think this was ever an 
issue... at least, not for a long time (or my memory is corrupt)...

>>      lat (usec) : 2=3.34%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
>>      lat (usec) : 100=0.01%, 250=3.67%, 500=31.43%, 750=24.55%, 1000=13.33%
>>      lat (msec) : 2=19.37%, 4=4.25%, 10=0.04%, 20=0.01%, 50=0.01%
>>      lat (msec) : 100=0.01%, 250=0.01%, 1000=0.01%, 2000=0.01%
> 76% of read IOPS completed in 1 millisecond or less, 63% in 750
> microseconds or less, and 31% in 500 microseconds or less.  This is
> nearly perfect for 7 of these SSDs.

Inadvertently, I have ended up with 5 x SSDSC2CW480A3 + 2 x 
SSDSC2BW480A4 in each server. I noticed significantly higher %util 
reported by iostat on the 2 SSD's compared to the other 5. Finally on 
Monday I moved two of the SSDSC2CW480A3 models from the second server 
into the primary, (one at a time) and the two SSDSC2BW480A4 into the 
second server. So then I had 7 x SSDSC2CW480A3 in the primary, and the 
secondary had 3 of them plus 4 of the other model. iostat on the primary 
then showed a much more balanced load across all 7 of the SSD's in the 
primary (with DRBD disconnected).
BTW, when I say much higher, the 2 SSD's would should 40% while the 
other 5 would should around 10%, with the two peaking at 100% while the 
other 5 would peak at 30%...

I haven't been able to find detailed enough specs on the differences 
between these two models to explain that yet. In any case, the 
SSDSC2CW480A3 model is no longer available, so I can't order more of 
them anyway.

>>    write: io=13885MB, bw=236914KB/s, iops=59228 , runt= 60016msec
>                ^^^^^^^                      ^^^^^
> The write IOPS is roughly 10K per drive counting 6 drives no parity.
> This result should be 200K-240K IOPS, 40K IPOS per drive, for these
> SandForce based SSDs.  Why is it so horribly low?  The latencies yield a
> clue.
>
>>      lat (usec) : 250=0.01%, 500=1.25%, 750=8.72%, 1000=10.13%
>>      lat (msec) : 2=23.87%, 4=24.78%, 10=24.87%, 20=5.85%, 50=0.39%
>>      lat (msec) : 100=0.11%, 250=0.01%, 750=0.01%, 2000=0.01%, >=2000=0.01%
> 80% of write IOPS required more than 2 milliseconds to complete, 56%
> required more than 4ms, 31% required over 10ms, and 6.35% required over
> 20ms.  This is roughly equivalent to 15K SAS performance.  What tends to
> make SSD write latency so high?  Erase block rewrite, garbage
> collection.  Why are we experiencing this during the test?  Let's see...
>
> Your read test was 75 GB and your write test was 14 GB.  These should
> always be equal values when the size= parameter is specified.  Using
> file based IO, FIO will normally create one read and one write file per
> job thread of size "size=", and should throw and error and exit if the
> filesystem space is not sufficient.
>
> When performing IO to a raw block device  I don't know what the FIO
> behavior is as the raw device scenario isn't documented and I've never
> traced it.  Given your latency results it's clear that your SSD were
> performing heavyweight garbage collection during the write test.  This
> would tend to suggest that the test device was significantly smaller
> than the 512 GB required, and thus the erase blocks were simply
> rewritten many times over.  This scenario would tend to explain the
> latencies reported.

One other explanation for the different sizes might be that the 
bandwidth was different, but the time was constant (because I specified 
the time option as well). In any case, the performance difference might 
easily be due to your suggestion, which was definitely another idea I 
was having. I was thinking now that I have more drives, I could go back 
to the old solution of leaving some un-allocated space on each drive. 
However to do that I would have needed to reduce the PV ensuring no 
allocated blocks at the "end" of the MD, then reduce the MD, and finally 
reduce the partition. Then I still needed to find a method to tell the 
SSD that the space is now unused (trim). Now I think it isn't so 
important any more...

>> So, a maximum of 237MB/s write. Once DRBD takes that and adds it's
>> overhead, I'm getting approx 10% of that performance (some of the time,
>> other times I'm getting even less, but that is probably yet another issue).
>>
>> Now, 237MB/s is pretty poor, and when you try and share that between a
>> dozen VM's, with some of those VM's trying to work on 2+ GB files
>> (outlook users), then I suspect that is why there are so many issues.
>> The question is, what can I do to improve this? Should I use RAID5 with
>> a smaller stripe size? Should I use RAID10 or RAID1+linear? Could the
>> issue be from LVM? LVM is using 4MB Physical Extents, from reading
>> though, nobody seems to worry about the PE size related to performance
>> (only LVM1 had a limit on the number of PE's... which meant a larger LV
>> required larger PE's).
> I suspect you'll be rethinking the above after running a proper FIO test
> for 4KB IOPS.  Try numjobs=8 and size=500m, for an 8 GB test, assuming
> the test LV is greater than 8 GB in size.
>
> ...
OK, I'll retry with numjobs=16 and size=1G which should require a 32G 
LV, which should be fine with my 50G LV.
read: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
...
read: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
write: (g=1): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
...
write: (g=1): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=16
2.0.8
Starting 32 threads
Jobs: 2 (f=2): [_________________w_____________w] [100.0% done] 
[0K/157.9M /s] [0 /40.5K iops] [eta 00m:00s]]
read: (groupid=0, jobs=16): err= 0: pid=26714
   read : io=16384MB, bw=1267.4MB/s, iops=324360 , runt= 12931msec
     slat (usec): min=1 , max=141080 , avg= 7.28, stdev=141.90
     clat (usec): min=9 , max=207827 , avg=764.34, stdev=962.30
      lat (usec): min=55 , max=207831 , avg=771.84, stdev=981.10
     clat percentiles (usec):
      |  1.00th=[  159],  5.00th=[  215], 10.00th=[  262], 20.00th=[ 342],
      | 30.00th=[  426], 40.00th=[  524], 50.00th=[  628], 60.00th=[ 740],
      | 70.00th=[  868], 80.00th=[ 1048], 90.00th=[ 1352], 95.00th=[ 1672],
      | 99.00th=[ 2672], 99.50th=[ 3632], 99.90th=[ 8896], 99.95th=[13632],
      | 99.99th=[36608]
     bw (KB/s)  : min=40608, max=109600, per=6.29%, avg=81566.38, 
stdev=8098.56
     lat (usec) : 10=0.01%, 20=0.01%, 50=0.01%, 100=0.02%, 250=8.72%
     lat (usec) : 500=29.09%, 750=23.21%, 1000=16.65%
     lat (msec) : 2=19.74%, 4=2.16%, 10=0.33%, 20=0.05%, 50=0.02%
     lat (msec) : 100=0.01%, 250=0.01%
   cpu          : usr=41.33%, sys=238.07%, ctx=48328280, majf=0, minf=64230
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=4194304/w=0/d=0, short=r=0/w=0/d=0
write: (groupid=1, jobs=16): err= 0: pid=27973
   write: io=16384MB, bw=262686KB/s, iops=65671 , runt= 63868msec
     slat (usec): min=2 , max=4387.4K, avg=64.75, stdev=9203.16
     clat (usec): min=13 , max=6500.9K, avg=3692.55, stdev=47966.38
      lat (usec): min=64 , max=6500.9K, avg=3757.42, stdev=48862.99
     clat percentiles (usec):
      |  1.00th=[  410],  5.00th=[  564], 10.00th=[  700], 20.00th=[ 1080],
      | 30.00th=[ 1432], 40.00th=[ 1688], 50.00th=[ 1880], 60.00th=[ 2064],
      | 70.00th=[ 2256], 80.00th=[ 2480], 90.00th=[ 2992], 95.00th=[ 3632],
      | 99.00th=[ 8640], 99.50th=[12736], 99.90th=[577536], 
99.95th=[954368],
      | 99.99th=[2146304]
     bw (KB/s)  : min=   97, max=56592, per=7.49%, avg=19678.60, 
stdev=8387.79
     lat (usec) : 20=0.01%, 100=0.01%, 250=0.08%, 500=2.74%, 750=8.96%
     lat (usec) : 1000=6.49%
     lat (msec) : 2=38.00%, 4=40.30%, 10=2.68%, 20=0.36%, 50=0.02%
     lat (msec) : 100=0.14%, 250=0.06%, 500=0.07%, 750=0.04%, 1000=0.03%
     lat (msec) : 2000=0.03%, >=2000=0.01%
   cpu          : usr=10.05%, sys=40.27%, ctx=60488513, majf=0, minf=62068
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=0/w=4194304/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
    READ: io=16384MB, aggrb=1267.4MB/s, minb=1267.4MB/s, 
maxb=1267.4MB/s, mint=12931msec, maxt=12931msec

Run status group 1 (all jobs):
   WRITE: io=16384MB, aggrb=262685KB/s, minb=262685KB/s, 
maxb=262685KB/s, mint=63868msec, maxt=63868msec

So, I don't think that made a lot of difference to the results.

>> BTW, I've also split the domain controller to a win2008R2 server, and
>> upgraded the file server to win2012R2.
> I take it you decided this route had fewer potential pitfalls than
> reassigning the DC share LUN to a new VM with the same Windows host
> name, exporting/importing the shares, etc?  It'll be interesting to see
> if this resolves some/all of the problems.  Have my fingers crossed for ya.

It wasn't clear, but what I meant was:
1) Install new 2008R2 server, promote to DC, migrate roles across to it, etc
2) Install new 2012R2 server
3) export registry with share information and shutdown the old 2003 server
4) change name of the new server (to the same as the old server) and 
join the domain
5) attach the existing LUN to the 2012R2 server
6) import the registry information

Short answer, it seemed to have a variable result, but I think that was 
just the usual some days are good and some days are bad, depending on 
who is doing what, when, and how much the users decide to complain.

> Please don't feel I'm picking on you WRT your understanding of IO
> performance, benching, etc.  It is not my intent to belittle you.  It is
> critical that you better understand Linux block IO, proper testing,
> correctly interpreting the results.  Once you do you can realize if/when
> and where you do actually have problems, instead of thinking you have a
> problem where none exists.

Absolutely, and I do appreciate the lessons. I apologise for needing so 
much "hand holding", but hopefully we are almost at the end.

After some more work with linbit, they logged in, and took a look 
around, doing some of their own measurements, and the outcome was to add 
the following three options to the DRBD config file, which improved the 
DRBD IOPS from around 3000 to 50000.
         disk-barrier no;
         disk-flushes no;
         md-flushes no;

Essentially DRBD was disabling the SSD write cache by forcing every 
write to be completed before returning, and this was drastically 
reducing the IOPS that could be achieved.

Running the same test against the DRBD device, in a connected state:
read: (groupid=0, jobs=16): err= 0: pid=4498
   read : io=16384MB, bw=1238.8MB/s, iops=317125 , runt= 13226msec
     slat (usec): min=0 , max=997330 , avg=11.16, stdev=992.34
     clat (usec): min=0 , max=1015.8K, avg=769.38, stdev=7791.99
      lat (usec): min=0 , max=1018.6K, avg=781.10, stdev=7873.73
     clat percentiles (usec):
      |  1.00th=[    0],  5.00th=[    0], 10.00th=[  195], 20.00th=[ 298],
      | 30.00th=[  370], 40.00th=[  446], 50.00th=[  532], 60.00th=[ 620],
      | 70.00th=[  732], 80.00th=[  876], 90.00th=[ 1144], 95.00th=[ 1480],
      | 99.00th=[ 4896], 99.50th=[ 7200], 99.90th=[16512], 99.95th=[21888],
      | 99.99th=[53504]
     bw (KB/s)  : min= 5085, max=305504, per=6.35%, avg=80531.22, 
stdev=29062.40
     lat (usec) : 2=7.73%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
     lat (usec) : 100=0.04%, 250=6.78%, 500=32.00%, 750=25.02%, 1000=14.15%
     lat (msec) : 2=11.28%, 4=1.64%, 10=1.10%, 20=0.20%, 50=0.05%
     lat (msec) : 100=0.01%, 250=0.01%, 1000=0.01%, 2000=0.01%
   cpu          : usr=41.05%, sys=253.29%, ctx=49215916, majf=0, minf=65328
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=4194304/w=0/d=0, short=r=0/w=0/d=0
write: (groupid=1, jobs=16): err= 0: pid=5163
   write: io=16384MB, bw=138483KB/s, iops=34620 , runt=121150msec
     slat (usec): min=1 , max=84258 , avg=20.68, stdev=303.42
     clat (usec): min=179 , max=123372 , avg=7354.94, stdev=3634.96
      lat (usec): min=187 , max=132967 , avg=7375.81, stdev=3644.96
     clat percentiles (usec):
      |  1.00th=[ 3696],  5.00th=[ 4576], 10.00th=[ 5088], 20.00th=[ 5920],
      | 30.00th=[ 6560], 40.00th=[ 7008], 50.00th=[ 7328], 60.00th=[ 7584],
      | 70.00th=[ 7840], 80.00th=[ 8160], 90.00th=[ 8640], 95.00th=[ 9280],
      | 99.00th=[13504], 99.50th=[23168], 99.90th=[67072], 99.95th=[70144],
      | 99.99th=[75264]
     bw (KB/s)  : min= 5976, max=12447, per=6.26%, avg=8673.20, stdev=731.62
     lat (usec) : 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
     lat (msec) : 2=0.09%, 4=1.76%, 10=94.97%, 20=2.61%, 50=0.29%
     lat (msec) : 100=0.26%, 250=0.01%
   cpu          : usr=8.99%, sys=33.90%, ctx=71679376, majf=0, minf=69677
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=0/w=4194304/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
    READ: io=16384MB, aggrb=1238.8MB/s, minb=1238.8MB/s, 
maxb=1238.8MB/s, mint=13226msec, maxt=13226msec

Run status group 1 (all jobs):
   WRITE: io=16384MB, aggrb=138483KB/s, minb=138483KB/s, 
maxb=138483KB/s, mint=121150msec, maxt=121150msec

Disk stats (read/write):
   drbd17: ios=4194477/4188834, merge=0/0, ticks=2645376/30507320, 
in_queue=33171672, util=99.81%


Here is the summary of the first fio above:
   read : io=16384MB, bw=1267.4MB/s, iops=324360 , runt= 12931msec
   write: io=16384MB, bw=262686KB/s, iops=65671 , runt= 63868msec
    READ: io=16384MB, aggrb=1267.4MB/s, minb=1267.4MB/s, 
maxb=1267.4MB/s, mint=12931msec, maxt=12931msec
   WRITE: io=16384MB, aggrb=262685KB/s, minb=262685KB/s, 
maxb=262685KB/s, mint=63868msec, maxt=63868msec

So, do you still think there is an issue (from looking the the first fio 
results above) with getting "only" 65k IOPS write?
One potential clue I did find was hidden in the Intel specs:
Firstly Intel markets it here:
http://www.intel.com/content/www/us/en/solid-state-drives/solid-state-drives-520-series.html
480GB 	SATA 6Gb/s 550 MB/s / 520 MB/s
SATA 3Gb/s       280 MB/s / 260 MB/s 	50,000 IOPS / 50,000 IOPS 	9.5mm 
2.5-inch SATA


However, here: 
http://www.intel.com/content/dam/www/public/us/en/documents/product-specifications/ssd-530-sata-specification.pdf

Table 5 shows the Incompressible Performance:
480GB     Random 4k Read 37500 IOPS       Random 4k Write 13000 IOPS

So, now we might be better placed to calculate the "expected" results? 
13000 * 6 = 78000, we are getting 65000, which is not very far away.

So, for yesterday and today, with the barriers/flushes disabled, things 
seem to be working well, I haven't had any user complaints, and that 
makes me happy :) However, if you still think I should be able to get 
200000 IOPS or higher on write, then I'll definitely be interested in 
investigating further.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
