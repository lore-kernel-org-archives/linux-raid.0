From: Shaohua Li <shli@kernel.org>
Subject: Re: raid0 vs. mkfs
Date: Thu, 8 Dec 2016 11:19:06 -0800
Message-ID: <20161208191906.ealqsudmgopn7wa3@kernel.org>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
 <87oa108a1x.fsf@notabene.neil.brown.name>
 <286a5fc1-eda3-0421-a88e-b03c09403259@scylladb.com>
 <87inr880au.fsf@notabene.neil.brown.name>
 <df73ebc4-9b78-09b5-022b-089c30dea17c@scylladb.com>
 <87d1he7zv9.fsf@notabene.neil.brown.name>
 <33bb250a-4dfd-0acc-9958-30fdac10918c@scylladb.com>
 <ccf447df-e7b5-0a08-7753-67ee4ad574ef@suse.de>
 <20161207165933.isq64dbkxye772nz@kernel.org>
 <c384d070-457c-cfee-e35f-53b9195ace10@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c384d070-457c-cfee-e35f-53b9195ace10@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Avi Kivity <avi@scylladb.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 09, 2016 at 12:44:57AM +0800, Coly Li wrote:
> On 2016/12/8 上午12:59, Shaohua Li wrote:
> > On Wed, Dec 07, 2016 at 07:50:33PM +0800, Coly Li wrote:
> [snip]
> > Thanks for doing this, Coly! For raid0, this totally makes sense. The raid0
> > zones make things a little complicated though. I just had a brief look of your
> > proposed patch, which looks really complicated. I'd suggest something like
> > this:
> > 1. split the bio according to zone boundary.
> > 2. handle the splitted bio. since the bio is within zone range, calculating
> > the start and end sector for each rdev should be easy.
> > 
> 
> Hi Shaohua,
> 
> Thanks for your suggestion! I try to modify the code by your suggestion,
> it is even more hard to make the code that way ...
> 
> Because even split bios for each zone, all the corner cases still exist
> and should be taken care in every zoon. The code will be more complicated.

Not sure why it makes the code more complicated. Probably I'm wrong, but Just
want to make sure we are in the same page: split the bio according to zone
boundary, then handle the splitted bio separately. Calculating end/start point
of each rdev for the new bio within a zone should be simple. we then clone a
bio for each rdev and dispatch. So for example:
Disk 0: D0 D2 D4 D6 D7
Disk 1: D1 D3 D5
zone 0 is from D0 - D5, zone 1 is from D6 - D7
If bio is from D1 to D7, we split it to 2 bios, one is D1 - D5, the other D6 - D7.
For D1 - D5, we dispatch 2 bios. D1 - D5 for disk 1, D2 - D4 for disk 0
For D6 - D7, we just dispatch to disk 0.
What kind of corner case makes this more complicated?
 
> > This will create slightly more bio to each rdev (not too many, since there
> > aren't too many zones in practice) and block layer should easily merge these
> > bios without much overhead. The benefit is a much simpler implementation.
> > 
> >> I compose a prototype patch, the code is not simple, indeed it is quite
> >> complicated IMHO.
> >>
> >> I do a little research, some NVMe SSDs support whole device size
> >> DISCARD, also I observe mkfs.xfs sends out a raid0 device size DISCARD
> >> bio to block layer. But raid0_make_request() only receives 512KB size
> >> DISCARD bio, block/blk-lib.c:__blkdev_issue_discard() splits the
> >> original large bio into 512KB small bios, the limitation is from
> >> q->limits.discard_granularity.
> > 
> > please adjust the max discard sectors for the queue. The original setting is
> > chunk size.
> 
> This is a powerful suggestion, I change the max_discard_sectors to raid0
> size, and fix some bugs, now the patch looks working well. The
> performance number is not bad.
> 
> On 4x3TB NVMe raid0, format it with mkfs.xfs. Current upstream kernel
> spends 306 seconds, the patched kernel spends 15 seconds. I see average
> request size increases from 1 chunk (1024 sectors) to 2048 chunks
> (2097152 sectors).
> 
> I don't know why the bios are still be split before raid0_make_request()
> receives them, after I set q->limits.max_discard_sectors to
> mddev->array_sectors. Can anybody give me a hint ?

That probably is from disk_stack_limits. try set the max_discard_sectors after it.

> Here I attach the RFC v2 patch, if anybody wants to try it, please do it
> and response the result :-)
> 
> I will take time to write a very detailed commit log and code comments
> to make this patch more easier to be understood. Ugly code, that's what
> I have to pay to gain better performance ....

Can't say I like it :). Hard to read and the memory allocation is ugly. Please
check if there is simpler solution first before writting detailed commit log.

Thanks,
Shaohua
