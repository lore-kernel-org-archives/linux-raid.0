From: Shaohua Li <shli@kernel.org>
Subject: Re: raid0 vs. mkfs
Date: Wed, 7 Dec 2016 08:59:33 -0800
Message-ID: <20161207165933.isq64dbkxye772nz@kernel.org>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
 <87oa108a1x.fsf@notabene.neil.brown.name>
 <286a5fc1-eda3-0421-a88e-b03c09403259@scylladb.com>
 <87inr880au.fsf@notabene.neil.brown.name>
 <df73ebc4-9b78-09b5-022b-089c30dea17c@scylladb.com>
 <87d1he7zv9.fsf@notabene.neil.brown.name>
 <33bb250a-4dfd-0acc-9958-30fdac10918c@scylladb.com>
 <ccf447df-e7b5-0a08-7753-67ee4ad574ef@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ccf447df-e7b5-0a08-7753-67ee4ad574ef@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Avi Kivity <avi@scylladb.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 07, 2016 at 07:50:33PM +0800, Coly Li wrote:
> On 2016/11/30 上午6:45, Avi Kivity wrote:
> > On 11/29/2016 11:14 PM, NeilBrown wrote:
> [snip]
> 
> >>> So I disagree that all the work should be pushed to the merging layer.
> >>> It has less information to work with, so the fewer decisions it has to
> >>> make, the better.
> >> I think that the merging layer should be as efficient as it reasonably
> >> can be, and particularly should take into account plugging.  This
> >> benefits all callers.
> > 
> > Yes, but plugging does not mean "please merge anything you can until the
> > unplug".
> > 
> >> If it can be demonstrated that changes to some of the upper layers bring
> >> further improvements with acceptable costs, then certainly it is good to
> >> have those too.
> > 
> > Generating millions of requests only to merge them again is
> > inefficient.  It happens in an edge case (TRIM of the entirety of a very
> > large RAID), but it already caused on user to believe the system
> > failed.  I think the system should be more robust than that.
> 
> Neil,
> 
> As my understand, if a large discard bio received by
> raid0_make_request(), for example it requests to discard chunk 1 to 24
> on a raid0 device built by 4 SSDs. This large discard bio will be split
> and written to each SSD as the following layout,
> 
> SSD1: C1,C5,C9,C13,C17,C21
> SSD2: C2,C6,C10,C14,C18,C22
> SSD3: C3,C7,C11,C15,C19,C23
> SSD4: C4,C8,C12,C16,C20,C24
> 
> Current raid0 code will call generic_make_request() for 24 times for
> each split bio. But it is possible to calculate the final layout of each
> split bio, so we can combine all the bios into four per-SSD large bio,
> like this,
> 
> bio1 (on SSD1): C{1,5,9,13,17,21}
> bio2 (on SSD2): C{2,6,10,14,18,22}
> bio3 (on SSD3): C{3,7,11,15,19,23}
> bio4 (on SSD4): C{4,8,12,16,20,24}
> 
> Now we only need to call generic_make_request() for 4 times. Rebuild the
> per-device discard bios is more efficient in raid0 code then in block
> layer. There are some reasons that I know,
> - there are splice timeout, block layer cannot merge all split bio into
> one large bio before time out.
> - rebuilt per-device bio in raid0 is just by a few calculation, block
> layer does merge on queue with list operations, it is slower.
> - raid0 code knows its on disk layout, so rebuild per-device bio is
> possible here. block layer has no idea on raid0 layout, it can only do
> request merge.

Thanks for doing this, Coly! For raid0, this totally makes sense. The raid0
zones make things a little complicated though. I just had a brief look of your
proposed patch, which looks really complicated. I'd suggest something like
this:
1. split the bio according to zone boundary.
2. handle the splitted bio. since the bio is within zone range, calculating
the start and end sector for each rdev should be easy.

This will create slightly more bio to each rdev (not too many, since there
aren't too many zones in practice) and block layer should easily merge these
bios without much overhead. The benefit is a much simpler implementation.

> I compose a prototype patch, the code is not simple, indeed it is quite
> complicated IMHO.
> 
> I do a little research, some NVMe SSDs support whole device size
> DISCARD, also I observe mkfs.xfs sends out a raid0 device size DISCARD
> bio to block layer. But raid0_make_request() only receives 512KB size
> DISCARD bio, block/blk-lib.c:__blkdev_issue_discard() splits the
> original large bio into 512KB small bios, the limitation is from
> q->limits.discard_granularity.

please adjust the max discard sectors for the queue. The original setting is
chunk size.

Thanks,
Shaohua
