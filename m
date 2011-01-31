From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] imsm: Update metadata for second array
Date: Tue, 1 Feb 2011 10:23:03 +1100
Message-ID: <20110201102303.352e6da1@notabene.brown>
References: <20110131085922.7551.47081.stgit@gklab-128-013.igk.intel.com>
	<20110131085930.7551.86542.stgit@gklab-128-013.igk.intel.com>
	<20110131201916.43ff49d5@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D17701C18B@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17701C18B@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Mon, 31 Jan 2011 09:28:54 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> 
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of NeilBrown
> > Sent: Monday, January 31, 2011 10:19 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Neubauer, Wojciech
> > Subject: Re: [PATCH 2/2] imsm: Update metadata for second array
> > 
> > On Mon, 31 Jan 2011 09:59:30 +0100 Adam Kwolek <adam.kwolek@intel.com>
> > wrote:
> > 
> > > When second array reshape is about to start external metadata should
> > be updated
> > > by mdmon in imsm_set_array_state().
> > > For this purposes imsm_progress_container_reshape() is reused.
> > >
> > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > ---
> > >
> > >  super-intel.c |    6 +++++-
> > >  1 files changed, 5 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/super-intel.c b/super-intel.c
> > > index 8484df6..0ab4355 100644
> > > --- a/super-intel.c
> > > +++ b/super-intel.c
> > > @@ -5249,13 +5249,17 @@ static int imsm_set_array_state(struct
> > active_array *a, int consistent)
> > >  		super->updates_pending++;
> > >  	}
> > >
> > > -	/* finalize online capacity expansion/reshape */
> > > +	/* manage online capacity expansion/reshape */
> > >  	if ((a->curr_action != reshape) &&
> > >  	    (a->prev_action == reshape)) {
> > >  		struct mdinfo *mdi;
> > >
> > > +		/* finalize online capacity expansion/reshape */
> > >  		for (mdi = a->info.devs; mdi; mdi = mdi->next)
> > >  			imsm_set_disk(a, mdi->disk.raid_disk, mdi-
> > >curr_state);
> > > +
> > > +		/* check next volume reshape */
> > > +		imsm_progress_container_reshape(super);
> > >  	}
> > >
> > >  	return consistent;
> > 
> > You still haven't explained why you need this extra call to
> > imsm_progress_container_reshape.
> > Does the other call never get reached?  or does it do the wrong thing?
> > or is
> > it called too early? or too late or .....
> > 
> > NeilBrown
> 
> Call to imsm_progress_container_reshape() placed above (super-intel.c:5186), cannot be used as it is called for currently migrated volume only.
> If we finish migration it will be never be called (guard for migration in progress: super-intel.c:5133)
> 
> Answer is: It is never called for no migration in progress (not too early and not too late: never).
> 
> This a reason I've add second call (after finalizing migration) for next array reshape initiation .
> 

Thanks.
I've applied this for now, but I think something is badly messed up in the
handling of migration state - it is terribly convoluted.
However I don't have time to untangle it just now so I'll just take you patch
and hope it doesn't make anything worse :-)

Thanks,
NeilBrown

