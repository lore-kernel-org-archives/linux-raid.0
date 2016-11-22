From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 0/5] Stop using bi_phys_segments as a counter
Date: Mon, 21 Nov 2016 17:02:20 -0800
Message-ID: <20161122010220.dcq6brjhsliw4io6@kernel.org>
References: <147969099621.5434.12384452255155063186.stgit@noble>
 <20161121234311.6qhwa2g3oa4uhcbi@kernel.org>
 <87mvgscqe7.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87mvgscqe7.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 22, 2016 at 11:25:04AM +1100, Neil Brown wrote:
> On Tue, Nov 22 2016, Shaohua Li wrote:
> 
> > On Mon, Nov 21, 2016 at 12:19:43PM +1100, Neil Brown wrote:
> >> There are 2 problems with using bi_phys_segments as a counter
> >> 1/ we only use 16bits, which limits bios to 256M
> >> 2/ it is poor form to reuse a field like this.  It interferes
> >>    with other changes to bios.
> >> 
> >> We need to clean up a few things before we can change the use the
> >> counter which is now available inside a bio.
> >> 
> >> I have only tested this lightly.  More review and testing would be
> >> appreciated.
> >
> > So without the accounting, we:
> > - don't do bio completion trace
> 
> Yes, but hopefully that will be added back to bio_endio() soon.
> 
> > - call md_write_start/md_write_end excessively, which involves atomic operation.
> 
> raid5_inc_bio_active_stripes() did an atomic operation.  I don't think
> there is a net increase in the number of atomic operations.

That's different. md_write_start/end uses a global atomic.
raid5_inc_bio_active_stripes uses a bio atomic. So we have more cache bouncing now.
 
> >
> > Not big problems. But we are actually reusing __bi_remaining, I'm wondering why
> > we not explicitly reuse it. Eg, adds bio_dec_remaining_return() and uses it
> > like raid5_dec_bi_active_stripes.
> 
> Because using it exactly the same way that other places use it leads to
> fewer surprises, now or later.
> And I think that the effort to rearrange the code so that we could just
> call bio_endio() brought real improvements in code clarity and
> simplicity.

Not the same way. The return_bi list and retry list fix are still good. We can
replace the bio_endio in your patch with something like:
if (bio_dec_remaining_return() == 0) {
	trace_block_bio_complete()
	md_write_end()
	bio_endio();
}
This will give us better control when to end io.

Thanks,
Shaohua
