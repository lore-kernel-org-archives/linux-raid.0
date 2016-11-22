From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 0/5] Stop using bi_phys_segments as a counter
Date: Tue, 22 Nov 2016 00:01:27 -0800
Message-ID: <20161122080127.rv4kgmeyluyfyxnd@kernel.org>
References: <147969099621.5434.12384452255155063186.stgit@noble>
 <20161121234311.6qhwa2g3oa4uhcbi@kernel.org>
 <87mvgscqe7.fsf@notabene.neil.brown.name>
 <20161122010220.dcq6brjhsliw4io6@kernel.org>
 <87k2bwcl44.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k2bwcl44.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 22, 2016 at 01:19:07PM +1100, Neil Brown wrote:
> On Tue, Nov 22 2016, Shaohua Li wrote:
> 
> > On Tue, Nov 22, 2016 at 11:25:04AM +1100, Neil Brown wrote:
> >> On Tue, Nov 22 2016, Shaohua Li wrote:
> >> 
> >> > On Mon, Nov 21, 2016 at 12:19:43PM +1100, Neil Brown wrote:
> >> >> There are 2 problems with using bi_phys_segments as a counter
> >> >> 1/ we only use 16bits, which limits bios to 256M
> >> >> 2/ it is poor form to reuse a field like this.  It interferes
> >> >>    with other changes to bios.
> >> >> 
> >> >> We need to clean up a few things before we can change the use the
> >> >> counter which is now available inside a bio.
> >> >> 
> >> >> I have only tested this lightly.  More review and testing would be
> >> >> appreciated.
> >> >
> >> > So without the accounting, we:
> >> > - don't do bio completion trace
> >> 
> >> Yes, but hopefully that will be added back to bio_endio() soon.
> >> 
> >> > - call md_write_start/md_write_end excessively, which involves atomic operation.
> >> 
> >> raid5_inc_bio_active_stripes() did an atomic operation.  I don't think
> >> there is a net increase in the number of atomic operations.
> >
> > That's different. md_write_start/end uses a global atomic.
> > raid5_inc_bio_active_stripes uses a bio atomic. So we have more cache bouncing now.
> 
> Maybe.
> Most md_write_start() calls are made in the context of
> raid5_make_request().
> We could
>  - call md_write_start() once at the start
>  - count how many times we want to call it in a variable local to
>    raid5_make_request()
>  - atomically add that to the counter at the end.
> 
> Similarly mode md_write_end() requests are in the context of raid5d.  It
> could maintain local counter and apply them all in a single update
> before it sleeps.
> 
> It would be a little messy, but not too horrible I think.

this is messy actually, don't think it's justified.

> >> >
> >> > Not big problems. But we are actually reusing __bi_remaining, I'm wondering why
> >> > we not explicitly reuse it. Eg, adds bio_dec_remaining_return() and uses it
> >> > like raid5_dec_bi_active_stripes.
> >> 
> >> Because using it exactly the same way that other places use it leads to
> >> fewer surprises, now or later.
> >> And I think that the effort to rearrange the code so that we could just
> >> call bio_endio() brought real improvements in code clarity and
> >> simplicity.
> >
> > Not the same way. The return_bi list and retry list fix are still good. We can
> > replace the bio_endio in your patch with something like:
> > if (bio_dec_remaining_return() == 0) {
> > 	trace_block_bio_complete()
> > 	md_write_end()
> > 	bio_endio();
> > }
> > This will give us better control when to end io.
> 
> This isn't safe.  The bio arriving at raid5_make_request() might already
> have been split and could be chained.  Then raid5 might never see
> bio_dec_remaining_return() return zero.
> 
> For example, suppose there is a RAID0 make of some other device, and
> this RAID5.
> A write request arrives which crosses a chunk boundary.
> raid0.c calls bio_split to split off a new bio that will fit in the other
> device, leaving the original bio with a larger bi_sector which will get
> mapped only into the raid5.
> The split bio is chained into the original bio, elevating its
> __bi_remaining count.
> If the other device is particularly slow, or the RAID5 is particularly
> fast, the RAID5 IO might complete before the split bio completes, so
> raid5 will only see __bi_remaining go down to one, not zero.
> When the split bio finally completes, it's bi_endio is
> bio_chain_endio(), and that will call the final bio_endio() on the
> original bio.  md_write_end() would then never be called.
ok, this makes sense.

I still don't like we have no control when to do endio, but don't have better
idea either. These patches work for raid5, but we need to find similar tricky
way to workaround raid1/raid10, which reuse bi_phys_segments too. Probably it's
time MD allocates additional data and attaches to bio. Adding a counter will
solve the issue in a consistency/clean way for raid1/10/5.

Thanks,
Shaohua
