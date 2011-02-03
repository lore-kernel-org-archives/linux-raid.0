From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/8] imsm: FIX: Size is already set in metadata
Date: Thu, 3 Feb 2011 21:42:48 +1100
Message-ID: <20110203214248.0f30fdb6@notabene.brown>
References: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
	<20110201134920.13398.77330.stgit@gklab-128-013.igk.intel.com>
	<20110203174519.105469f5@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D1770B8253@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D1770B8253@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Thu, 3 Feb 2011 09:52:46 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of NeilBrown
> > Sent: Thursday, February 03, 2011 7:45 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Neubauer, Wojciech
> > Subject: Re: [PATCH 3/8] imsm: FIX: Size is already set in metadata
> > 
> > On Tue, 01 Feb 2011 14:49:20 +0100 Adam Kwolek <adam.kwolek@intel.com>
> > wrote:
> > 
> > > In metadata size is set already during migration initialization.
> > > There is no reason for second /the same/ calculation.
> > >
> > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > ---
> > >
> > >  super-intel.c |    5 +----
> > >  1 files changed, 1 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/super-intel.c b/super-intel.c
> > > index 42f7065..62b13b0 100644
> > > --- a/super-intel.c
> > > +++ b/super-intel.c
> > > @@ -5185,15 +5185,12 @@ static int imsm_set_array_state(struct
> > active_array *a, int consistent)
> > >  				/* round array size down to closest MB */
> > >  				array_blocks = (array_blocks >>
> > SECT_PER_MB_SHIFT)
> > >  					<< SECT_PER_MB_SHIFT;
> > > -				dev->size_low = __cpu_to_le32((__u32)
> > array_blocks);
> > > -				dev->size_high = __cpu_to_le32((__u32)
> > (array_blocks >> 32));
> > >  				a->info.custom_array_size = array_blocks/2;
> > >  				a->check_reshape = 1; /* encourage manager to
> > update
> > >  						       * array size
> > >  						       */
> > > -				super->updates_pending++;
> > >  				imsm_progress_container_reshape(super);
> > > -			}
> > > +			}
> > >  		}
> > >  	}
> > >
> > >
> > 
> > Doing the same calculation in two placed does seem wrong, but are you
> > sure this is the right one to remove?
> > 
> > The available space in the array does not change until the reshape
> > completes.  So changing dev->size_{low,high} during initialisation
> > seems wrong.
> > 
> > Are you able to confirm what the windows driver does?
> 
> Yes (look below).
> 
> > 
> > If we do set the size early, then we have to be careful to reduce to
> > the
> > original size when assembling an array that is in the middle of
> > reshape.
> 
> Yes (as you describes in your roadmap, it will be part of 3.2.1 code changes/investigation).
> Size for array with reshape in progress process, should be calculated based on second map information.
> 
> > 
> > So I won't apply this patch now, and will wait for you to confirm when
> > the
> > windows driver updates dev->size_{low,high}
> > 
> > Thanks,
> > NeilBrown
> 
> I've (double) checked Windows driver behavior. Array size is set during expansion initialization (first metadata update).

That sounds like a weird design decision, but I guess we have to work with
it.  I've applied that patch now.
These patches are still going in to my devel-3.2 branch.

Thanks,
NeilBrown


> This means, that code for size changes on reshape end has to be removed as it was proposed.
> For volume expansion, size in imsm metadata has to be set in 2 places/cases:
> 1. in metadata update during reshape update processing for first array(it is implemented)
> 2. In initialization reshape by set_array_state on second array (it is implemented)
> 
> BR
> Adam
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

