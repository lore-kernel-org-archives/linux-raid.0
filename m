From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/5] MD: attach data to each bio
Date: Mon, 13 Feb 2017 10:49:42 -0800
Message-ID: <20170213184942.x3s2hawueq3ryzj3@kernel.org>
References: <cover.1486485935.git.shli@fb.com>
 <79515b1372fa1a1813c00ef0d7e0613a4512183d.1486485935.git.shli@fb.com>
 <87r336tw5l.fsf@notabene.neil.brown.name>
 <20170210064715.tpr5mzvccmgxz2af@kernel.org>
 <8760ke4dzm.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8760ke4dzm.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, khlebnikov@yandex-team.ru, hch@lst.de
List-Id: linux-raid.ids

On Mon, Feb 13, 2017 at 08:49:33PM +1100, Neil Brown wrote:
> On Thu, Feb 09 2017, Shaohua Li wrote:
> 
> > On Fri, Feb 10, 2017 at 05:08:54PM +1100, Neil Brown wrote:
> >> On Tue, Feb 07 2017, Shaohua Li wrote:
> >> 
> >> > Currently MD is rebusing some bio fields. To remove the hack, we attach
> >> > extra data to each bio. Each personablity can attach extra data to the
> >> > bios, so we don't need to rebuse bio fields.
> >> 
> >> I must say that I don't really like this approach.
> >> Temporarily modifying ->bi_private and ->bi_end_io seems
> >> .... intrusive.   I suspect it works, but I wonder if it is really
> >> robust in the long term.
> >> 
> >> How about a different approach..  Your main concern with my first patch
> >> was that it called md_write_start() and md_write_end() much more often,
> >> and these performed atomic ops on "global" variables, particular
> >> writes_pending.
> >> 
> >> We could change writes_pending to a per-cpu array which we only count
> >> occasionally when needed.  As writes_pending is updated often and
> >> checked rarely, a per-cpu array which is summed on demand seems
> >> appropriate.
> >> 
> >> The following patch is an early draft - it doesn't obviously fail and
> >> isn't obviously wrong to me.  There is certainly room for improvement
> >> and may be bugs.
> >> Next week I'll work on collection the re-factoring into separate
> >> patches, which are possible good-to-have anyway.
> >
> > For your first patch, I don't have much concern. It's ok to me. What I don't
> > like is the bi_phys_segments handling part. The patches add a lot of logic to
> > handle the reference count. They should work, but I'd say it's not easy to
> > understand and could be error prone. What we really need is a reference count
> > for the bio, so let's just add a reference count. That's my logic and it's
> > simple.
> 
> We already have two reference counts, and you want to add a third one.
> 
> bi_phys_segments is currently used for two related purposes.
> It counts the number of stripe_heads currently attached to the bio so
> that when the count reaches zero:
>  1/ ->writes_pending can be decremented
>  2/ bio_endio() can be called.
> 
> When the code was written, the __bi_remaining counter didn't exist.  Now
> it does and it is integrated with bio_endio() so it should make the code
> easier to understand if we just use bio_endio() rather and doing our own
> accounting.
> 
> That just leaves '1'.  We can easily decrement ->writes_pending directly
> instead of decrementing a per-bio refcount, and then when it reaches
> zero, decrement ->writes_pending.  As you pointed out, that comes with a
> cost.  If ->writes_pending is changed to a per-cpu array which is summed
> on demand, the cost goes away.
> 
> Having an extra refcount in the bio just adds a level of indirection
> that doesn't (that I can see) provide actual value.

Ok, fair enough. I do think an explict counter in the driver side will help us
a lot, eg, we can better control when to endio and do something there (for
example the current blk trace, or something we want to add in the future). But
I don't insist currently.

For the patches, can you repost? I think:
- patch 2 missed md_write_start for make_discard_request
- It's unnecessary to zero bi_phys_segments in patch 5. And raid5-cache need do
  the same change of bio_endio.
For the md_write_start optimization, we can do it later.

Thanks,
Shaohua
