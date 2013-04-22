From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Odd IO traffic during raid5 reshape
Date: Mon, 22 Apr 2013 11:00:27 +0200
Message-ID: <20130422090027.GA26360@frosties>
References: <20130418184822.GB16749@frosties>
 <20130422082633.6430312c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130422082633.6430312c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 22, 2013 at 08:26:33AM +1000, NeilBrown wrote:
> On Thu, 18 Apr 2013 20:48:22 +0200 Goswin von Brederlow <goswin-v-b@web.de>
> wrote:
> 
> > Hi,
> > 
> > I'm currently upgrading a NAS system with new disks. Since I'm
> > changing the filesystem type and due to a lack of enough SATA ports I
> > have to do add one new disk at a time, copy data, shrink the old
> > filesystem, remove an old disks and repeat. I've started with a 2 disk
> > raid5, copied data, freed a 3rd SATA slot and added the 3rd new disk.
> > 
> > Now I'm reshaping the new raid5 from 2 disks to 3 disks:
> > 
> > md0 : active raid5 sdd1[3] sdc1[2] sda1[0]
> >       3907015168 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
> >       [==>..................]  reshape = 14.0% (547848840/3907015168) finish=1355.4min speed=41302K/sec
> > 
> > so far everything works fine. But the speed is rather low and the IO
> > traffic is higher than I think it should be:
> > 
> > Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> > sda             604.33     81706.00     40904.73    4902360    2454284
> > md0               0.00         0.00         0.00          0          0
> > sdc             440.78     81839.40     40542.07    4910364    2432524
> > sdd             509.72         0.00     40817.67          0    2449060
> > 
> > To reshape the kernel needs to read 1 data block from sda, 1 data
> > block from sdc, compute the XOR of both blocks and write 2 data blocks
> > + parity block back to the 3 disks. The kernel read 160MB/s, add
> > 80MB/s parity and it should write 240MB/s (or 80MB/s per disk).
> > Instead it only writes 120MB/s (40MB/s per disk), only half of what I
> > expect.
> > 
> > So what is going on there? Is the kernel reading both data and parity
> > blocks and verifying them?
> 
> The kernel is reading data and parity.  Maybe it doesn't need to, but unless
> your chunks are very big (10s of megatabyes?) reading takes about as long as
> seeking over, so it is unlikely to affect total time.

The disk might not be faster when skipping the parity blocks but why
waste cpu time, SATA and PCI bus bandwidth and memory on reading the
parity?

Here are some stats while reshaping raid5 from 3 to 6 disks:

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda             263.80     45466.80     21632.20     454668     216322
sdd             152.90     46723.20     20633.80     467232     206338
sdc             183.50     45758.00     21430.60     457580     214306
sde             206.90         0.00     19659.00          0     196590
sdf             219.10         0.00     19609.80          0     196098
sdb             101.10         0.00     19686.60          0     196866

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
 2097 root      20   0     0    0    0 R   63  0.0 774:51.35 md0_raid6
 2126 root      20   0     0    0    0 R   23  0.0 277:22.04 md0_reshape

You can see that the disks have gone from 120MB/s down to 66MB/s. Not
sure why. There shouldn't be more seeks than with the previous resize,
the cpu (dual core) still has breathing room and the SATA controllers
can do >500MB/s when using all 6 disks in parallel (tested with dd).
Unlike the first reshape it shouldn't be hitting any bottleneck yet.

> Reshape simple is not a fast operation, nowhere near as fast as resync.
> It needs to
>   - read a few stripes
>   - seek backward to where that data now belong
>   - write the data as slightly fewer stripes
>   - update the metadata to record where the data now is.
>   - repeat
> 
> So there is lots of seeking.  md/raid5 tries to avoid unnecessary seeking,
> but quite a bit of it is necessary.
> 
> It looks to me like it is performing quite well.
> 
> NeilBrown

I've set the stripe_cache_size to 32768 to get the performance.
Otherwise it is way less than that. I figure the extra large stripe
cache means the reshape can read more stripes in cache before seeking
to write them back. The performance wasn't in question, just the extra
reads.


I still wonder. As you said reading takes about as long as seeking
over small chunks. Am I right that the chunk size is the amount of
data on each disk before it continues on the next disk? And in raid5
the parity rotates to the next disk after every stripe?

Shouldn't there be two 2 parameters for this? The chunk size and the
number of stripes before rotating parity to the next disk? I would
like a chunk size of 4k to get maximum striping for small files but
only rotate the parity every 1GB to improve reshape and rebuild
operations.

MfG
	Goswin
