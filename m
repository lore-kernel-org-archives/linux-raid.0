From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 09/18] md/raid6: remove expectation that Q device is immediately after P device.
Date: Mon, 16 Feb 2009 11:08:30 +1100
Message-ID: <18840.44670.362323.595496@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
	<20090212031010.23983.26264.stgit@notabene.brown>
	<20090212165625.GH32416@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Thursday February 12
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 12, maan@systemlinux.org wrote:
> On 14:10, NeilBrown wrote:
> 
> > -static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int previous);
> > +static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int previous,
> > +			   int *qd_idx);
> 
> That's a bit ugly, isn't it? The function computes both the p index
> and the q index which is not obvious from its name. Also, the p index
> is the return value and the q index is returned via a pointer which
> is a bit unsymmetric.
> 
> static void get_parity_indices(sector_t stripe, raid5_conf_t *conf, int previous,
> 				 int *pd_idx, int *qd_idx);
> 
> perhaps?

Probably a good idea, except that it is only an interim state on the
way to changing the function to "stripe_set_idx" where we pass a
'struct stripe_head *' and it fills the details in directly.

So, while I agree it is ugly, I think I'll leave it as it is.

> 
> > +	/* Note that unlike RAID-5, the ordering of the disks matters greatly.*/
> > +	/* FIX: Is this ordering of drives even remotely optimal? */
> > +	count = 0;
> > +	i = d0_idx;
> > +	do {
> > +		if (i == sh->pd_idx)
> > +			ptrs[disks-2] = page_address(sh->dev[i].page);
> > +		else if (i == sh->qd_idx)
> > +			ptrs[disks-1] = page_address(sh->dev[i].page);
> > +		else {
> >  			ptrs[count++] = page_address(sh->dev[i].page);
> > -			if (count <= disks-2 && !test_bit(R5_UPTODATE, &sh->dev[i].flags))
> > +			if (!test_bit(R5_UPTODATE, &sh->dev[i].flags))
> >  				printk("block %d/%d not uptodate on parity calc\n", i,count);
> > -			i = raid6_next_disk(i, disks);
> > -		} while ( i != d0_idx );
> > -//		break;
> > -//	}
> > +		}
> > +		i = raid6_next_disk(i, disks);
> > +	} while (i != d0_idx);
> > +	BUG_ON(count+2 != disks);
> 
> Isn't it really dangerous to ignore a dirty stripe head during parity
> calculation? I understand that compute_parity6() does not have a
> return value and that dirty stripe heads have always been ignored by
> compute_parity6(). But it looks much saner to fail in this case.
> 
> BTW, the printk lacks a KERN_ERR.
> 

Good points.
The printk should probably be a BUG really.  It certainly is dangerous
to ignore blocks that aren't up-to-date, but they should never be
found.  If the block is not UPTODATE then there is a bug in the code.
And as such a bug could lead to data corrupt, a BUG() call is probably
justified.
I've added the BUG and the KERN_ERR.

> > +	/**** FIX THIS: This could be very bad if disks is close to 256 ****/
> > +	void *ptrs[disks];
> 
> How serious is this? It's probably not a problem for version 0.90
> superblocks as one can't have more than 26 disks. OTOH, for version
> 1 superblocks we might end up using up to 2K of stack space on 64
> bit machines.
> 
> Would it be a reasonable to always allocate 26 pointers, say, and
> fall back to malloc() if this turns out to be too small?

As Dan Williams has said, malloc is not really an option in this
context, and it probably isn't a real problem - at the moment at
least.

However it feels rather fragile to me.  I think I would like to
allocate space somewhere for these sort of arrays, possibly in the
conf_t.  Before doing that we need to be sure to understand where we
could ever want more than one at a time, and ensure that any future
change that might add more parallelism won't silently break any
assumptions we make now.

> 
> > +	count = 0;
> > +	i = d0_idx;
> > +	do {
> > +		int slot;
> > +		if (i == sh->pd_idx)
> > +			slot = disks-2;
> > +		else if (i == sh->qd_idx)
> > +			slot = disks-1;
> > +		else
> > +			slot = count++;
> > +		ptrs[slot] = page_address(sh->dev[i].page);
> > +		if (i == dd_idx1)
> > +			faila = slot;
> > +		if (i == dd_idx2)
> > +			failb = slot;
> > +		i = raid6_next_disk(i, disks);
> > +	} while (i != d0_idx);
> > +	BUG_ON(count+2 != disks);
> 
> Deja vu. How about using a helper function like
> 
> static inline int is_parity_idx(int idx, struct stripe_head_sh)
> {
> 	if (idx == sh->pd_idx)
> 		return sh->disks - 2;
> 	if (idx == sh->qd_idx)
> 		return sh->disks - 1;
> 	return 0;
> }
> 
> Then the above becomes
> 
> 	int slot = is_parity_idx(i, sh);
> 	if (!slot)
> 		slot = count++;
> 
> And in compute_parity6() we could write
> 
> 	count = 0;
> 	i = d0_idx;
> 	do {
> 		int slot = is_parity_idx(i, sh);
> 		if (!slot)
> 			slot = count++;
> 		ptrs[slot] = page_address(sh->dev[i].page);

That is a nice improvement.... except that "is_parity_idx" sounds like
it should return True or False, but it actually returns False or a
slot number.
I might make it:
static int raid6_idx_to_slot(int idx, struct stripe_head *sh, int *count)
{
	int slot;
	if (idx == sh->pd_idx)
		return sh->disks - 2;
	if (idx == sh->qd_idx)
		return sh->disks - 1;
	slot = (*count)++;
	return slot;
}

and add a suitable comment

Thanks,
NeilBrown
