From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/9] imsm: FIX: After checkpoint mark array have to be
 clean
Date: Wed, 9 Mar 2011 09:14:17 +1100
Message-ID: <20110309091417.12db98f3@notabene.brown>
References: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
	<20110302132927.24771.39913.stgit@gklab-128-013.igk.intel.com>
	<20110308160743.35b85f6a@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D17A822DB0@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17A822DB0@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Tue, 8 Mar 2011 08:52:40 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> 
> 
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Tuesday, March 08, 2011 6:08 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Neubauer, Wojciech
> > Subject: Re: [PATCH 4/9] imsm: FIX: After checkpoint mark array have to
> > be clean
> > 
> > On Wed, 02 Mar 2011 14:29:27 +0100 Adam Kwolek <adam.kwolek@intel.com>
> > wrote:
> > 
> > > When checkpoint is marked set volume as clean.
> > > Reshape on dirty volume cannot be restarted from checkpoint.
> > >
> > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > ---
> > >
> > >  super-intel.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/super-intel.c b/super-intel.c
> > > index 11972f3..04e32ae 100644
> > > --- a/super-intel.c
> > > +++ b/super-intel.c
> > > @@ -5218,6 +5218,7 @@ static int imsm_set_array_state(struct
> > active_array *a, int consistent)
> > >  				    __le32_to_cpu(dev->vol.curr_migr_unit)) {
> > >  					dev->vol.curr_migr_unit =
> > >  						__cpu_to_le32(unit);
> > > +					dev->vol.dirty = 0;
> > >  					super->updates_pending++;
> > >  				}
> > >  			}
> > >
> > 
> > hi Adam,
> >  You'll need to explain this one a bit more.
> > 
> >  If the array isn't clean, then it is wrong to mark it as clean.
> >  If it is clean, then 'consistent' should be 'true' and it will
> >  be marked clean anyway.
> > 
> 
> This could be true if set_array_state has possibility to execute this code in general migration case.
> During reshape after updtate curr_migr_unit set array state exits (super-intel.c: 5225 /return 0/)
> 
> To achieve this it can be changed:
> 1. Consistent flag should be == 1 during reshape
> monitor.c:387
> - a->container->ss->set_array_state(a, a->curr_state <= clean);
> 
> + a->container->ss->set_array_state(a, a->curr_state <= active);

This change doesn't make any sense at all.
Whether the array is 'clean' or 'active', it completely independent of
whether the array is being reshaped.
While it is being reshaped it could sometimes be clean, and sometime
be active, and the recorded state should reflect this.
Say it is 'clean' (or 'consistent') when it actually isn't would be a lie.

> 
> Array state is active during reshape
> 
> 2. use consistent flag during reshape for imsm
> Super-intel.c: set_array_state()
> 	- remove all code for a->curr_action == reshape (around line 5211)
> 	- instead removed code add 'goto' to calculating blocks_per_unit at the end of this function
>  	   This will allow for mark clear/dirty volume also

I like this patch - nice cleanup of the code.  I have applied it, thanks.



> 
> I'll send 2 patch to make this description more clear.
>  1. FIX: During reshape array is in active state 
>  2. imsm: FIX: Mark checkpoint and array state clean during reshape
> 
> 
> >  Why cannot a reshape of a dirty volume be restarted from a checkpoint?
> >  I would think it would continue with the reshape and then when that
> >  finished, go back and do the resync.
> > 
> > NeilBrown
> 
> If array is dirty and during reshape is not assembled due to i.e:
> super-intel.c:1792 for dirty volume info->resync_start = 0; Code for analyzing migration type is not executed.

I see - that code in super-intel.c::getinfo_super_imsm_volume needs to be
fixed.  Maybe just remove the 'else' there

	if (map_to_analyse->map_state == IMSM_T_STATE_UNINITIALIZED ||
	    dev->vol.dirty) {
		info->resync_start = 0;
	} else if (dev->vol.migr_state) {
          ^^^^^

Not sure though.

NeilBrown


