From: Shaohua Li <shli@fb.com>
Subject: Re: [RFC] raid5: add a log device to fix raid5/6 write hole issue
Date: Wed, 1 Apr 2015 16:40:57 -0700
Message-ID: <20150401234055.GA3375744@devbig257.prn2.facebook.com>
References: <20150330222459.GA575371@devbig257.prn2.facebook.com>
 <20150402085312.5ea3d518@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150402085312.5ea3d518@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org, songliubraving@fb.com, Kernel-team@fb.com
List-Id: linux-raid.ids

On Thu, Apr 02, 2015 at 08:53:12AM +1100, NeilBrown wrote:
> On Mon, 30 Mar 2015 15:25:17 -0700 Shaohua Li <shli@fb.com> wrote:
> 
> > This is my attempt to fix raid5/6 write hole issue, it's not for merge
> > yet, I post it out for comments. Any comments and suggestions are
> > welcome!
> > 
> > Thanks,
> > Shaohua
> > 
> > We expect a completed raid5/6 stack with reliability and high
> > performance. Currently raid5/6 has 2 issues:
> > 
> > 1. read-modify-write for small size IO. To fix this issue, a cache layer
> > above raid5/6 can be used to aggregate write to full stripe write.
> > 2. write hole issue. A write log below raid5/6 can fix the issue.
> > 
> > We plan to use a SSD to fix the two issues. Here we just fix the write
> > hole issue.
> > 
> > 1. We don't try to fix the issues together. A cache layer will do write
> > acceleration. A log layer will fix write hole. The seperation will
> > simplify things a lot.
> > 
> > 2. Current assumption is flashcache/bcache will be used as the cache
> > layer. If they don't work well, we can fix them or add a simple cache
> > layer for raid write aggregation later. We also assume cache layer will
> > absorb write, so log doesn't worry about write latency.
> > 
> > 3. For log, write will hit to log disk first, then raid disks, and
> > finally IO completion is reported. An optimal way is to report IO
> > completion just after IO hits to log disk to cut write latency. But in
> > that way, read path need query log disk and increase complexity. And
> > since we don't worry about write latency, we choose a simple soltuion.
> > This will be revisited if there is performance issue.
> > 
> > This design isn't intrusive for raid5/6. Actully only very few changes
> > of existing code is required.
> > 
> > Log looks like jbd. Stripe IO to raid disks will be written to log disk
> > first in atomic way. Several stripe IO will consist a transaction. If
> > all stripes of a transaction are finished, the tranaction can be
> > checkpoint.
> > 
> > Basic logic of raid 5/6 write will be:
> > 1. normal raid5/6 steps for a stripe (fetch data, calculate checksum,
> > and etc). log hooks to ops_run_io.
> > 2. stripe is added to a transaction. Write stripe data to log disk (metadata
> > block, stripe data)
> > 3. write commit block to log disk
> > 4. flush log disk cache.
> > 5. stripe is logged now and normal stripe handling continues
> > 
> > Transaction checkpoint process:
> > 1. all stripes of a transaction are finished
> > 2. flush disk cache of all raid disks
> > 3. change log super to reflect new log checkpoint position
> > 4. WRITE_FUA log super
> > 
> > metadata, data and commit block IO can run in the meaning time, as
> > checksum will be used to make sure their data is correct (like jbd2).
> > Log IO doesn't wait 5s to start like jbd, instead the IO will start
> > every time a metadata block is full. This can cut some latency.
> > 
> > Disk layout:
> > 
> > |super|metadata|data|metadata| data ... |commitdata|metadata|data| ... |commitdata|
> > super, metadata, commit will use one block
> > 
> > This is an initial version, which works but a lot of stuffes are
> > missing:
> > 1. error handling
> > 2. log recovery and impact to raid resync (don't need resync anymore)
> > 3. utility changes
> > 
> > The big question is how we report log disk. In this patch, I simply use
> > a spare disk for testing. We need a new raid disk role for log disk.
> > 
> > Signed-off-by: Shaohua Li <shli@fb.com>
> 
> 
> Hi,
>  thanks for the proposal and the patch which makes it nice and concrete...
> 
>  I should start out by saying that I'm not really sold on the importance of
>  the issues you are addressing here.
>  The "write hole" is certainly of theoretical significance, but I do wonder
>  how much practical significance it has.  It can only be a problem if you
>  have a system failure and a degraded array at the same time, and both of
>  those should be very rare event individually...  
>  I wonder if anyone has *ever* lost data to the "write hole".

We have tens of thousands of machines. Rare event in terms of huge amount
of machines become a normal event :). It's not a significant issue, but
we don't want to take the risk.

>  As for write-ahead caching to reduce latency, most writes from Linux are
>  async and so would not benefit from that.  If you do have a heavily
>  synchronous write load, then that can be fixed in the filesystem.
>  e.g. with ext3 and an external log to a low-latency device you can get
>  low-latency writes which largely mask the latency issues introduced by
>  RAID5.

Maybe I should write more about the caching, I didn't because the patch
is about the write hole issue. Any way, the side effect of caching is
write-hole-protection log doesn't need worry about latency. The main
purpose of caching is to produce full stripe write or reduce
read-modify-write if full stripe write is not possible. The caching can
also reduce hard disk spindle seek, because we can sort when flush data
from caching to raid.

>  The fact that I'm "not really sold" doesn't mean I am against them ... maybe
>  it is just an encouragement for someone to sell them more :-)
> 
>  While I understand that keeping the two separate might simplify the
>  problem, I'm not at all sure it is a good idea.  It would mean that every
>  data block were written three times - once to the write-ahead log, once to
>  the write-hole-protection log, and once to the RAID5.

yes, it the write-ahead log and write-hole-protection log are combined,
one write can be avoid.

>  Your code does avoid write-hole-protection for fill-stripe-writes, and this
>  would greatly reduce the  number of block that were written multiple times.
>  However I'm not convinced that is correct.
>  A reasonable  goal is that if the system crashes while writing to a storage
>  device, then reads should return the old data or not new data, not anything
>  else.  A crash in the middle of a full-stripe-write to a degraded array
>  could result in some block in the stripe appearing to contain data that is
>  different to both the old and the new.  If you are going to close the whole,
>  I think it should be done properly.

I can do it simpley. But don't think this assumption is true. If you
write to a disk range and there is failure, there is nothing guarantee
you can either read old data or new data.

> 
>  A combined log would "simply" involve writing every data block and  every
>  compute parity block (with index information) to the log device.
>  Replaying the log would collect data blocks and flush out those in a stripe
>  once the parity block(s) for that stripe became available.
> 
>  I think this would actually turn into a fairly simple logging mechanism.

It's not simple at all. It's unlikely we write data and parity
continuously in disk and in the same time. This will make log checkpoint
fairly complex.

Thanks,
Shaohua
