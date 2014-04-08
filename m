From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Growing RAID5 SSD Array
Date: Tue, 08 Apr 2014 10:27:35 -0500
Message-ID: <53441567.3040805@hardwarefreak.com>
References: <53211C9D.8050607@websitemanagers.com.au> <53219D4C.2020207@hardwarefreak.com> <53268B87.4060203@websitemanagers.com.au> <53276C84.5040805@hardwarefreak.com> <5327A462.2060303@websitemanagers.com.au> <53282C6C.4090502@hardwarefreak.com> <5328D5EC.7090303@websitemanagers.com.au> <532A0200.3070000@hardwarefreak.com> <532A5868.8060209@websitemanagers.com.au> <532DE6FC.5010301@hardwarefreak.com> <5331804B.6010708@websitemanagers.com.au> <5331E7AB.9080904@hardwarefreak.com> <53405896.5070902@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53405896.5070902@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/5/2014 2:25 PM, Adam Goryachev wrote:
> On 26/03/14 07:31, Stan Hoeppner wrote:
>> On 3/25/2014 8:10 AM, Adam Goryachev wrote:
...
...
> OK, I'm going to add the following to the /etc/rc.local:
> for irq in `cat /proc/interrupts |grep mpt2sas| awk -F: '{ print $1}'`
> do
>         echo 4 > /proc/irq/${irq}/smp_affinity
> done
> 
> That will move the LSI card interrupt processing to CPU2 like this:
>   57:  143806142       7246      41052          0 IR-PCI-MSI-edge     
> mpt2sas0-msix0
>   58:   14381650          0      22952          0 IR-PCI-MSI-edge     
> mpt2sas0-msix1
>   59:    6733526          0     144387          0 IR-PCI-MSI-edge     
> mpt2sas0-msix2
>   60:    3342802          0      32053          0 IR-PCI-MSI-edge     
> mpt2sas0-msix3
> 
> You can see I briefly moved one to CPU1 as well.

Most of your block IO interrupts are read traffic.  md/RAID5 reads are
fully threaded, unlike writes, and can be serviced by any core.  Assign
each LSI interrupt queue to a different core.

> Would you suggest moving the eth devices to another CPU as well, perhaps
> CPU3 ?

Spread all the interrupt queues across all cores, starting with CPU3
moving backwards and eth0 moving forward, this because IIRC eth0 is your
only interface receiving inbound traffic currently, due to a broken
balance-alb config.  NICs generally only generate interrupts for inbound
packets, so balancing IRQs won't make much difference until you get
inbound load balancing working.

...
> I'll run a bunch more tests tonight, and get a better idea. For now though:
> dd if=/dev/vg0/xptest of=/dev/vg0/testing iflag=direct oflag=direct
> bs=1536k count=5k
> iostat shows much more solid read and write rates, around 120MB/s peaks,
> dd reported 88MB/s, it also shows 0 for rrqm and wrqm, so no more
> merging was being done. 

Moving larger blocks and thus eliminating merges increased throughput a
little over 2x.  The absolute data rate is still very poor as something
is broken.  Still, doubling throughput with a few command line args is
always impressive.

> The avgrq-sz value is always 128 for the
> destination, and almost always 128 for the source during the copy. This
> seems to equal 64kB, so I'm not sure why that is if we told dd to use
> 1536k ...

I'd need to see the actual output to comment intelligently on this.
However, do note that application read/write IO size and avgrq-sz
reported by iostat are two different things.

...
> So it looks like CPU0 is less busy, with more work being done on CPU2
> (the interrupts for the LSI SATA controller)

The md write thread is typically scheduled on the processor (core) which
is servicing interrupts for the thread.  The %sy you're seeing on CPU2
is not interrupt processing but the RAID5 write thread execution.

> If I increase bs=6M then dd reports 130MB/s ...

You can continue increasing the dd block size and gain small increases
in throughput incrementally until you hit the wall.  But again,
something is broken somewhere for single thread throughput to be this low.

...
>> According to your iostat output above, drbd2 was indeed still
>> engaged.  And eating over 59.6% and 91.6% of a core.
>
> Nope, definitely not connected, however, it is still part of the IO
> path, because the LV sits on drbd. So it isn't talking to it's partner,
> but it still does it's own "work" in between LVM and MD.
> 
>>> So, I know dd isn't the ideal performance testing tool or metric, but
>>> I'd really like to know why I can't get more than 40MB/s. There is no
>>> networking, no iscsi, just a fairly simple raid5, drbd, and lvm.

There is nothing simple at all about a storage architecture involving
layered lvm, drbd, and md RAID.  This may be a "popular" configuration,
but popular does not equal "simple".

>> You can get much more than 40MB/s, but you must know your tools, and
>> gain a better understanding of the Linux IO subsystem.
> 
> Apologies, it was a second late night in a row, and I wasn't doing very
> well, I should have remembered my previous lessons about this!

Remember:  High throughput requires large IOs in parallel.  High IOPS
requires small IOs in parallel.  Bandwidth and IOPS are inversely
proportional.

...
> OK, so thinking this through... We should expect really poor performance
> if we are not using O_DIRECT, and not doing large requests in parallel.

You should never expect poor performance with a single thread, but not
full hardware potential of the SSDs either.  Something odd is going on
in your current setup if a dd copy with large block size and O_DIRECT
can only hit 130 MB/s to an array of 7 of these SandForce based Intel
SSDs.  You should be able to hit a few hundred MB/s with a simultaneous
read and write stream from one LV to another.  Something is plugging a
big finger into the ends of your fat IO pipe when single streaming.
Determining what this finger is will require some investigation.

> I think the parallel part of the workload should be fine in real world
> use, since each user and machine will be generating some random load,
> which should be delivered in parallel to the stack (LVM/DRBD/MD).
> However, in 'real world' use, we don't determine the request size, only
> the application or client OS, or perhaps iscsi will determine that.

Note that in your previous testing you achieved 200 MB/s iSCSI traffic
at the Xen hosts.  Whether using many threads on the client or not,
iSCSI over GbE at the server should never be faster than a local LV to
LV copy.  Something is misconfigured or you have a bug somewhere.

> My concern is that while I can get fantastical numbers from specific
> tests (such as highly parallel, large block size requests) I don't need
> that type of I/O, 

The previous testing I assisted you with a year ago demonstrated peak
hardware read/write throughput of your RAID5 array.  Demonstrating
throughput was what you requested, not IOPS.

The broken FIO test you performed, with results down below, demonstrated
320K read IOPS, or 45K IOPS per drive.  This is the inverse test of
bandwidth.  Here you also achieved near peak hardware IO rate from the
SSDs, which is claimed by Intel at 50K read IOPS.  You have the best of
both worlds, max throughput and IOPS.  If you'd not have broken the test
your write IOPS would have been correctly demonstrated as well.

Playing the broken record again, you simply don't yet understand how to
use your benchmarking/testing tools, nor the data, the picture, they are
presenting to you.

> so my system isn't tuned to my needs.

While that statement may be true, the thing(s) not properly tuned are
not the SSDs, nor LSI, nor mobo, nor md.  That leaves LVM and DRBD.  And
the problems may not be due to tuning but bugs.

> After working with linbit (DRBD) I've found out some more useful
> information, which puts me right back to the beginning I think, but with
> a lot more experience and knowledge.
> It seems that DRBD keeps it's own "journal", so every write is written
> to the journal, then it's bitmap is marked, then the journal is written
> to the data area, then the bitmap updated again, and then start over for
> the next write. This means it is doing lots and lots of small writes to
> the same areas of the disk ie, 4k blocks.

Your 5 SSDs had a combined ~160,000 4KB IOPS write performance.  Your 7
SSDs should hit ~240,000 4KB write IOPS when configured properly.  To
put this into perspective, an array comprised of 15K SAS drives in RAID0
would require 533 and 800 drives respectively to reach the same IOPS
performance, 1066 and 1600 drives in RAID10.

With that comparison in mind, surely it's clear that your original DRBD
journal throughput was not creating a bottleneck of any kind at the SSDs.

> Anyway, I was advised to re-organise the stack from:
> RAID5 -> DRBD -> LVM -> iSCSI
> To:
> RAID5 -> LVM -> DRBD -> iSCSI
> This means each DRBD device is smaller, and so the "working set" is
> smaller, and should be more efficient. 

Makes sense.  But I saw nothing previously to suggest DRBD CPU or memory
consumption was a problem, nor write IOPS.

> So, now I am easily able to do
> tests completely excluding drbd by targeting the LV itself. Which means
> just RAID5 + LVM layers to worry about.

Recall what I said previously about knowing your tools?

...
> [global]
> filename=/dev/vg0/testing
> zero_buffers
> numjobs=16
> thread
> group_reporting
> blocksize=4k
> ioengine=libaio
> iodepth=16
> direct=1

It's generally a bad idea to mix size and run time.  It makes results
non deterministic.  Best to use one or the other.  But you have much
bigger problems here...

> runtime=60
> size=16g

16 jobs * 2 streams (read + write) * 16 GB per stream = 512 GB required
for this test.  The size= parm is per job thread, not aggregate.  What
was the capacity of /dev/vg0/testing?  Is this a filesystem or raw
device?  I'm assuming raw device of capacity well less than 512 GB.

>   read : io=74697MB, bw=1244.1MB/s, iops=318691 , runt= 60003msec
              ^^^^^^^                      ^^^^^^

318K IOPS is 45K IOPS per drive, all 7 active on reads.  This is
awesome, and close to the claimed peak hardware performance of 50K 4KB
read IOPS per drive.

>     lat (usec) : 2=3.34%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
>     lat (usec) : 100=0.01%, 250=3.67%, 500=31.43%, 750=24.55%, 1000=13.33%
>     lat (msec) : 2=19.37%, 4=4.25%, 10=0.04%, 20=0.01%, 50=0.01%
>     lat (msec) : 100=0.01%, 250=0.01%, 1000=0.01%, 2000=0.01%

76% of read IOPS completed in 1 millisecond or less, 63% in 750
microseconds or less, and 31% in 500 microseconds or less.  This is
nearly perfect for 7 of these SSDs.

...
>   write: io=13885MB, bw=236914KB/s, iops=59228 , runt= 60016msec
              ^^^^^^^                      ^^^^^
The write IOPS is roughly 10K per drive counting 6 drives no parity.
This result should be 200K-240K IOPS, 40K IPOS per drive, for these
SandForce based SSDs.  Why is it so horribly low?  The latencies yield a
clue.

>     lat (usec) : 250=0.01%, 500=1.25%, 750=8.72%, 1000=10.13%
>     lat (msec) : 2=23.87%, 4=24.78%, 10=24.87%, 20=5.85%, 50=0.39%
>     lat (msec) : 100=0.11%, 250=0.01%, 750=0.01%, 2000=0.01%, >=2000=0.01% 

80% of write IOPS required more than 2 milliseconds to complete, 56%
required more than 4ms, 31% required over 10ms, and 6.35% required over
20ms.  This is roughly equivalent to 15K SAS performance.  What tends to
make SSD write latency so high?  Erase block rewrite, garbage
collection.  Why are we experiencing this during the test?  Let's see...

Your read test was 75 GB and your write test was 14 GB.  These should
always be equal values when the size= parameter is specified.  Using
file based IO, FIO will normally create one read and one write file per
job thread of size "size=", and should throw and error and exit if the
filesystem space is not sufficient.

When performing IO to a raw block device  I don't know what the FIO
behavior is as the raw device scenario isn't documented and I've never
traced it.  Given your latency results it's clear that your SSD were
performing heavyweight garbage collection during the write test.  This
would tend to suggest that the test device was significantly smaller
than the 512 GB required, and thus the erase blocks were simply
rewritten many times over.  This scenario would tend to explain the
latencies reported.

...
> So, a maximum of 237MB/s write. Once DRBD takes that and adds it's
> overhead, I'm getting approx 10% of that performance (some of the time,
> other times I'm getting even less, but that is probably yet another issue).
> 
> Now, 237MB/s is pretty poor, and when you try and share that between a
> dozen VM's, with some of those VM's trying to work on 2+ GB files
> (outlook users), then I suspect that is why there are so many issues.
> The question is, what can I do to improve this? Should I use RAID5 with
> a smaller stripe size? Should I use RAID10 or RAID1+linear? Could the
> issue be from LVM? LVM is using 4MB Physical Extents, from reading
> though, nobody seems to worry about the PE size related to performance
> (only LVM1 had a limit on the number of PE's... which meant a larger LV
> required larger PE's).

I suspect you'll be rethinking the above after running a proper FIO test
for 4KB IOPS.  Try numjobs=8 and size=500m, for an 8 GB test, assuming
the test LV is greater than 8 GB in size.

...
> BTW, I've also split the domain controller to a win2008R2 server, and
> upgraded the file server to win2012R2.

I take it you decided this route had fewer potential pitfalls than
reassigning the DC share LUN to a new VM with the same Windows host
name, exporting/importing the shares, etc?  It'll be interesting to see
if this resolves some/all of the problems.  Have my fingers crossed for ya.

Please don't feel I'm picking on you WRT your understanding of IO
performance, benching, etc.  It is not my intent to belittle you.  It is
critical that you better understand Linux block IO, proper testing,
correctly interpreting the results.  Once you do you can realize if/when
and where you do actually have problems, instead of thinking you have a
problem where none exists.

Cheers,

Stan
