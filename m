From: keld@keldix.com
Subject: Re: RAID 5 doesn't scale
Date: Wed, 3 Apr 2013 17:23:15 +0200
Message-ID: <20130403152315.GA19412@www5.open-std.org>
References: <loom.20130403T122905-373@post.gmane.org> <515C2C3C.3020400@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <515C2C3C.3020400@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Peter Landmann <sfrazt@googlemail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Peter

In general Linux RAID 5 scales well,
See https://raid.wiki.kernel.org/index.php/Performance

Best regards
keld

On Wed, Apr 03, 2013 at 08:18:52AM -0500, Stan Hoeppner wrote:
> On 4/3/2013 6:00 AM, Peter Landmann wrote:
> 
> You didn't mention your stripe_cache_size value.  It'll make a lot of
> difference.  Make sure it's at least 4096.  The default is 256.
> 
> ~$ /bin/echo 4096 > /sys/block/md[X]/md/stripe_cache_size
> 
> > FIO settings:
> > bs=4096
> > iodepth=248
> > direct=1
> > continue_on_error=1
> > rw=randwrite
> > ioengine=libaio
> > norandommap
> > refill_buffers
> > group_reporting
> 
> > numjobs=1
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
> 
> -- 
> Stan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
