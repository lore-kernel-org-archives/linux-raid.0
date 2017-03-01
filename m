From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v4 3/7] raid5-ppl: Partial Parity Log write logging
 implementation
Date: Wed, 1 Mar 2017 09:51:33 -0800
Message-ID: <20170301175133.jimllzchgsemndak@kernel.org>
References: <20170221194401.18733-1-artur.paszkiewicz@intel.com>
 <20170221194401.18733-4-artur.paszkiewicz@intel.com>
 <20170228000419.rljabgaurh7e3rqq@kernel.org>
 <d1021e37-f40d-955b-0726-1b64cc4f8064@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d1021e37-f40d-955b-0726-1b64cc4f8064@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 01, 2017 at 05:13:38PM +0100, Artur Paszkiewicz wrote:
> On 02/28/2017 01:04 AM, Shaohua Li wrote:
> > On Tue, Feb 21, 2017 at 08:43:57PM +0100, Artur Paszkiewicz wrote:
> >> This implements the PPL write logging functionality. The description
> >> of PPL is added to the documentation. More details can be found in the
> >> comments in raid5-ppl.c.
> >>
> >> Put the PPL metadata structures to md_p.h because userspace tools
> >> (mdadm) will also need to read/write PPL.
> >>
> >> Warn about using PPL with enabled disk volatile write-back cache for
> >> now. It can be removed once disk cache flushing before writing PPL is
> >> implemented.
> >>
> >> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> >> ---
> >>  Documentation/md/raid5-ppl.txt |  44 +++
> >>  drivers/md/Makefile            |   2 +-
> >>  drivers/md/raid5-ppl.c         | 617 +++++++++++++++++++++++++++++++++++++++++
> >>  drivers/md/raid5.c             |  49 +++-
> >>  drivers/md/raid5.h             |   8 +
> >>  include/uapi/linux/raid/md_p.h |  26 ++
> >>  6 files changed, 738 insertions(+), 8 deletions(-)
> >>  create mode 100644 Documentation/md/raid5-ppl.txt
> >>  create mode 100644 drivers/md/raid5-ppl.c
> >>
> >> diff --git a/Documentation/md/raid5-ppl.txt b/Documentation/md/raid5-ppl.txt
> >> new file mode 100644
> >> index 000000000000..127072b09363
> >> --- /dev/null
> >> +++ b/Documentation/md/raid5-ppl.txt
> >> @@ -0,0 +1,44 @@
> >> +Partial Parity Log
> >> +
> >> +
> >> +		while (stripes_count--) {
> >> +			/*
> >> +			 * if entry without partial parity just skip its stripes
> >> +			 * without adding pages to bio
> >> +			 */
> >> +			if (pp_size > 0 &&
> >> +			    !bio_add_page(bio, sh->ppl_page, PAGE_SIZE, 0)) {
> >> +				struct bio *prev = bio;
> >> +
> >> +				bio = bio_alloc_bioset(GFP_NOIO, BIO_MAX_PAGES,
> >> +						       ppl_conf->bs);
> > 
> > The code keeps allocating bios but doesn't dispatch any yet. The bioset can't
> > guarantee the allocation successes. To have the guarantee, we must make sure
> > previous bios could finish.
> 
> Is it ok to submit the bio before allocating another from the same
> bioset, without waiting for it to complete? The description for
> bio_alloc_bioset() suggests this, if I understand it correctly: "Callers
> that need to allocate more than 1 bio must always submit the previously
> allocated bio for IO before attempting to allocate a new one." 

Yes, I mean submit.
  
> >>  		return -EINVAL;
> >>  	if (mddev->delta_disks == 0 &&
> >>  	    mddev->new_layout == mddev->layout &&
> >> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> >> index 3cc4cb28f7e6..f915a7a0e752 100644
> >> --- a/drivers/md/raid5.h
> >> +++ b/drivers/md/raid5.h
> >> @@ -230,6 +230,7 @@ struct stripe_head {
> >>  	struct list_head	r5c; /* for r5c_cache->stripe_in_journal */
> >>  
> >>  	struct page		*ppl_page; /* partial parity of this stripe */
> >> +	struct ppl_io_unit	*ppl_log_io;
> > 
> > Maybe we should put the ppl fields and raid5 fields to a union
> 
> Good idea, will do.
> 
> >>  	/**
> >>  	 * struct stripe_operations
> >>  	 * @target - STRIPE_OP_COMPUTE_BLK target
> >> @@ -689,6 +690,7 @@ struct r5conf {
> >>  	int			group_cnt;
> >>  	int			worker_cnt_per_group;
> >>  	struct r5l_log		*log;
> >> +	struct ppl_conf		*ppl;
> > 
> > Maybe use void * log_private, so works for both raid5-cache and ppl
> 
> Do you mean replace "struct ppl_conf *ppl" with "void *log_private"?

Right. But if this makes checking the log type hard, ignore it.

Thanks,
Shaohua
