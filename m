From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: [PATCH 2.6.23-rc7 0/3] async_tx and md-accel fixes for 2.6.23
Date: Fri, 21 Sep 2007 17:45:39 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E52027D927D@azsmsx413.amr.corp.intel.com>
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com><20070921114823.49d00263.akpm@linux-foundation.org> <18164.23902.732535.384492@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <18164.23902.732535.384492@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yur@emcraft.com, saeed.bishara@gmail.com, "Nelson, Shannon" <shannon.nelson@intel.com>
List-Id: linux-raid.ids

> From: Neil Brown [mailto:neilb@suse.de]
> On Friday September 21, akpm@linux-foundation.org wrote:
> > On Thu, 20 Sep 2007 18:27:35 -0700
> > Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > > Fix a couple bugs and provide documentation for the async_tx api.
> > >
> > > Neil, please 'ack' patch #3.
> > >
> > > git://lost.foo-projects.org/~dwillia2/git/iop
async-tx-fixes-for-linus
> >
> > Well it looks like Neil is on vacation or is hiding from us or
something.
> 
> Neil is just not coping well with jet-lag....
> 
> Patch #3 looks good and necessary
>   Acked-By: NeilBrown <neilb@suse.de>
> 
> I know that should probably be a "reviewed-by"....  I was a bit
I went ahead and added reviewed-by.

> surprised that the "handle_completed_read_requests" call was so early
> in handle_stripe5 - I don't think the code was originally that early.
It is slightly earlier than 2.6.22 (outside the '/* now count some
things */' loop) to make sure the R5_Wantfill flags from the last
request have been cleared before starting a new one:

		/* maybe we can request a biofill operation
		 *
		 * new wantfill requests are only permitted while
		 * STRIPE_OP_BIOFILL is clear
		 */
		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread &&
			!test_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
			set_bit(R5_Wantfill, &dev->flags);

> But it is probably right.   Hopefully my brain will have cleared by
> Monday and I'll review it again then.
>

Ok, the tree is updated with 'Reviewed-by' tags and the proposed
documentation updates from Randy and Shannon.

git://lost.foo-projects.org/~dwillia2/git/iop async-tx-fixes-for-linus

Dan Williams (3):
      async_tx: usage documentation and developer notes (v2)
      async_tx: fix dma_wait_for_async_tx
      raid5: fix ops_complete_biofill

> NeilBrown

--
Dan
