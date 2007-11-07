From: Jeff Lessem <Jeff@Lessem.org>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Tue, 06 Nov 2007 22:00:03 -0700
Message-ID: <47314653.80905@Lessem.org>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>	 <18222.16003.92062.970530@notabene.brown>	 <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>	 <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>	 <Pine.LNX.4.64.0711051335450.11422@p34.internal.lan>	 <e9c3a7c20711051619u7054aab9l208b604b9e58fb61@mail.gmail.com>	 <47303FB8.7000801@systella.fr> <1194398700.2970.18.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1194398700.2970.18.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: =?UTF-8?B?QkVSVFJBTkQgSm/Dq2w=?= <joel.bertrand@systella.fr>, Justin Piszcz <jpiszcz@lucidpixels.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Williams wrote:
 > The following patch, also attached, cleans up cases where the code looks
 > at sh->ops.pending when it should be looking at the consistent
 > stack-based snapshot of the operations flags.

I tried this patch (against a stock 2.6.23), and it did not work for
me.  Not only did I/O to the effected RAID5 & XFS partition stop, but
also I/O to all other disks.  I was not able to capture any debugging
information, but I should be able to do that tomorrow when I can hook
a serial console to the machine.

I'm not sure if my problem is identical to these others, as mine only
seems to manifest with RAID5+XFS.  The RAID rebuilds with no problem,
and I've not had any problems with RAID5+ext3.

 >
 >
 > ---
 >
 >  drivers/md/raid5.c |   16 +++++++++-------
 >  1 files changed, 9 insertions(+), 7 deletions(-)
 >
 > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
 > index 496b9a3..e1a3942 100644
 > --- a/drivers/md/raid5.c
 > +++ b/drivers/md/raid5.c
 > @@ -693,7 +693,8 @@ ops_run_prexor(struct stripe_head *sh, struct 
dma_async_tx_descriptor *tx)
 >  }
 >
 >  static struct dma_async_tx_descriptor *
 > -ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 > +ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
 > +		 unsigned long pending)
 >  {
 >  	int disks = sh->disks;
 >  	int pd_idx = sh->pd_idx, i;
 > @@ -701,7 +702,7 @@ ops_run_biodrain(struct stripe_head *sh, struct 
dma_async_tx_descriptor *tx)
 >  	/* check if prexor is active which means only process blocks
 >  	 * that are part of a read-modify-write (Wantprexor)
 >  	 */
 > -	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
 > +	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 >
 >  	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 >  		(unsigned long long)sh->sector);
 > @@ -778,7 +779,8 @@ static void ops_complete_write(void *stripe_head_ref)
 >  }
 >
 >  static void
 > -ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 > +ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
 > +		unsigned long pending)
 >  {
 >  	/* kernel stack size limits the total number of disks */
 >  	int disks = sh->disks;
 > @@ -786,7 +788,7 @@ ops_run_postxor(struct stripe_head *sh, struct 
dma_async_tx_descriptor *tx)
 >
 >  	int count = 0, pd_idx = sh->pd_idx, i;
 >  	struct page *xor_dest;
 > -	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
 > +	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 >  	unsigned long flags;
 >  	dma_async_tx_callback callback;
 >
 > @@ -813,7 +815,7 @@ ops_run_postxor(struct stripe_head *sh, struct 
dma_async_tx_descriptor *tx)
 >  	}
 >
 >  	/* check whether this postxor is part of a write */
 > -	callback = test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending) ?
 > +	callback = test_bit(STRIPE_OP_BIODRAIN, &pending) ?
 >  		ops_complete_write : ops_complete_postxor;
 >
 >  	/* 1/ if we prexor'd then the dest is reused as a source
 > @@ -901,12 +903,12 @@ static void raid5_run_ops(struct stripe_head *sh, 
unsigned long pending)
 >  		tx = ops_run_prexor(sh, tx);
 >
 >  	if (test_bit(STRIPE_OP_BIODRAIN, &pending)) {
 > -		tx = ops_run_biodrain(sh, tx);
 > +		tx = ops_run_biodrain(sh, tx, pending);
 >  		overlap_clear++;
 >  	}
 >
 >  	if (test_bit(STRIPE_OP_POSTXOR, &pending))
 > -		ops_run_postxor(sh, tx);
 > +		ops_run_postxor(sh, tx, pending);
 >
 >  	if (test_bit(STRIPE_OP_CHECK, &pending))
 >  		ops_run_check(sh);
 >
 >

