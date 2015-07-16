From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH V4 00/13] MD: a caching layer for raid5/6
Date: Wed, 15 Jul 2015 17:07:39 -0700
Message-ID: <20150716000739.GA4041321@devbig257.prn2.facebook.com>
References: <20150708054344.GA2709238@devbig257.prn2.facebook.com>
 <20150710092119.297fd9e1@noble>
 <20150710040847.GA1408097@devbig257.prn2.facebook.com>
 <20150710143656.4ee7e647@noble>
 <20150715004455.GA1024035@devbig257.prn2.facebook.com>
 <20150715121234.22803890@noble>
 <20150715031615.GA1292235@devbig257.prn2.facebook.com>
 <20150715140641.3c61cf78@noble>
 <20150715194927.GA3502691@devbig257.prn2.facebook.com>
 <20150716091653.7b970b32@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150716091653.7b970b32@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, Kernel-team@fb.com
List-Id: linux-raid.ids

On Thu, Jul 16, 2015 at 09:16:53AM +1000, NeilBrown wrote:
> On Wed, 15 Jul 2015 12:49:37 -0700 Shaohua Li <shli@fb.com> wrote:
> 
> > On Wed, Jul 15, 2015 at 02:06:41PM +1000, NeilBrown wrote:
> > > On Tue, 14 Jul 2015 20:16:17 -0700 Shaohua Li <shli@fb.com> wrote:
> > > 
> 
> > > 
> > > >                                                           I don't
> > > > understand why you object adding a superblock for cache. The advantage
> > > > is it's self contained. And there is nothing about
> > > > complexity/maintaince, as we can store the most necessary fields into
> > > > the superblock.
> > > 
> > > Because there is precisely 1 number that needs to be stored in the
> > > superblock, and there seems no point having a superblock just to store
> > > one number.
> > > It isn't much extra complexity, but any extra thing is still an extra
> > > thing.
> > > Having the data section of the log device containing just a log is
> > > elegant.  Elegant is good.
> > > If we decided that keeping two copies for superblocks was a good idea
> > > (which I think it is, I just haven't created a "v1.3" layout yet), then
> > > re-using the main superblock for the head-of-log pointer would instantly
> > > give us two copies of that as well.
> > 
> > I think I need 2 fields to find log head/tail in recovery. Currently
> > cache superblock records checkpoint disk position (log tail) and
> > checkpoint sequence number, which can be used to find log head. Just
> > recording log tail doesn't work well (it might work, for example,
> > zeroing sectors before log head, so we can identify log head. But it's
> > really ugly and not efficient). I only found recovery_offset can be
> > overloaded. Do you have idea other fileds can be overloaded in MD
> > superblock?
> 
> If each metadata block contains
>   - a magic number
>   - a checksum of the block
>   - a sequence number
>   - a pointer to the "next" metadata block (which is equivalent to
>     the size of all described data)
>   - a pointer to the tail (oldest active metadata block).
> 
> Then given the address of any block in the log you can easily find the
> head:  walk the "next" pointers forward until you find a block
> that has the wrong magic or checksum or sequence or previous pointer.
> The last block that was consistent is the head.
> 
> You can then find the tail directly, and walk forward processing the
> log.
> 
> Efficiency is not really an issue.  On a clean shutdown (which should
> be the norm), the md superblock will contain a pointer to the head, and
> the "next" block after that can quickly be determined to be invalid.
> On an unclean shutdown it is expected that we need to do a bit more
> work, and skipping forward along the chain to find the head of the log
> is the least of our worries.

if superblock records 2 fileds (the log tail and the seq of log tail), metadata
block doesn't need 'a pointer to the tail (oldest active metadata block)'. The
log tail/seq pair can help us find log head easily. Adding a pointer to the
tail in every metadata block is definitionly worse than adding a filed in the
superblock.

Further, how can you handle the case when log winds. For example, initially the log is
................................
                ^ superblock points to here
then we add meta and wind
|meta n-1|meta n|meta 0|meta 1|....
                ^ superblock points to here

Next time we reload log, superblock points to a valid meta. recovery will think
this is an unclean shutdown, so we rescan the whole log disk (because all metas
are valid) and apply all the changes to raid array. this is terrible. But if
superblock stores both log tail and seq. we will find the meta 0 sequence
number doesn't match with superblock, recovery stops instantly.

Thanks,
Shaohua
