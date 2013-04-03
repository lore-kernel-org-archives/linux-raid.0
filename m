From: Peter Landmann <sfrazt@googlemail.com>
Subject: Re: RAID 5 doesn't scale
Date: Wed, 3 Apr 2013 15:31:18 +0000 (UTC)
Message-ID: <loom.20130403T171527-93@post.gmane.org>
References: <loom.20130403T122905-373@post.gmane.org> <515C2C3C.3020400@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner <stan <at> hardwarefreak.com> writes:

> 
> On 4/3/2013 6:00 AM, Peter Landmann wrote:
> 
> You didn't mention your stripe_cache_size value.  It'll make a lot of
> difference.  Make sure it's at least 4096.  The default is 256.

You are very right.
I increased it to 4096 - 32768 and the performance increased much.
Also i played a bit with deadline parameters and it helped also to increase 
performance.

With Raid 5 and 6 SSDs i got 33936 IOPS (fio settings as before) which is not 
far away from theoretical 40000 (i know from former tests that the performance 
could be increased for some more jobs).

For your info: With Raid 6 and 6 SSDs i got 32526 IOPS which is also a very good 
result.

So i conclude that there is no (big) problem with scalability at this hw level, 
right?

> 
> ^^^^^^^^^^^  Even when using AIO you're still serialized when using a
> single thread, regardless of queue depth.  Thus there is non trivial
> latency between IO operations.  Retest with only these global parameters
> to get some concurrency.  Along with a larger stripe cache your numbers
> should go up substantially.  This test runs 4 threads/core to ensure you
> saturate md with IO.
> 
> [global]
> zero_buffers
> numjobs=24
> thread
> group_reporting
> blocksize=4096
> ioengine=libaio
> iodepth=16
> direct=1
> size=8G
Yeah, that brings me near 40k IOPS (Raid 5, 6 SSDs)
> 
> > So you have an idea why the real performance is only 50% of the theoretical 
> > performance? 
> 
> Three reasons:  IO latency, limited stripe_cache_size, parity RMW
> 
> > No cpu core is at its limits.
> 
> Because you're not cycle limited but latency limited.  With this FIO
> test your CPU burn should increase a bit.
> 
> > As i said in my other post. I would be interested to solve the problem but i 
> > have problems to identify it.
> 
> Note also that you're doing 4KB random writes against RAID5.  This is
> going to generate substantial RMW cycles.  The Intel X25-M G2 is not a
> speed daemon.  Its published max 4KB IOPS throughput is for purely
> random writes, not the read+write pattern created by parity RMW.  So
> while your random read should get a nice jump with this test, your
> random write may not improve as much.  The limitation here is a function
> of the SSD controller on the X25-M G2, not md/RAID5.  If you test 5
> drives in md/RAID0 you'll see a bump in random write IOPS.

FYI: The scheduler makes the difference. If you alternate writes and reades in 
small steps (R W R R W R W W R ..) then the performce decreases heavily. If you 
group read and write operations (20xW  20xR 20xW ..)then the performance will be 
better. Tested it without raid and a patched fio (and noop scheduler). But 
deadline scheduler can reach the same i learned.


Thx for your informations and hints
Peter



