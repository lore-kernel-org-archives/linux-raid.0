From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH] imsm: Update metadata for second array
Date: Mon, 31 Jan 2011 08:48:13 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17701C0F7@irsmsx503.ger.corp.intel.com>
References: <20110128082141.7609.85545.stgit@gklab-128-013.igk.intel.com>
	<20110131110453.7447d9d6@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D17701C03E@irsmsx503.ger.corp.intel.com>
 <20110131192950.7dfa10d0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131192950.7dfa10d0@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Monday, January 31, 2011 9:30 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH] imsm: Update metadata for second array
> 
> On Mon, 31 Jan 2011 07:43:44 +0000 "Kwolek, Adam"
> <adam.kwolek@intel.com>
> wrote:
> 
> >
> >
> > > -----Original Message-----
> > > From: NeilBrown [mailto:neilb@suse.de]
> > > Sent: Monday, January 31, 2011 1:05 AM
> > > To: Kwolek, Adam
> > > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > > Neubauer, Wojciech
> > > Subject: Re: [PATCH] imsm: Update metadata for second array
> > >
> > > On Fri, 28 Jan 2011 09:21:41 +0100 Adam Kwolek
> <adam.kwolek@intel.com>
> > > wrote:
> > >
> > > > When second array reshape is about to start external metadata
> should
> > > be updated
> > > > by mdmon in imsm_set_array_state().
> > > > for this purposes imsm_progress_container_reshape() is reused.
> > > >
> > > > In imsm_progress_container_reshape() we have to make sure that
> > > prev_disks
> > > > shows expanded disks number. Current decision about prev_disks in
> > > 'for'
> > > > loop doesn't make us sure about this. We are getting first
> positive
> > > value,
> > > > but not necessarily right one.
> > >
> > > When is the first value not the right one?
> >
> > When second array in mdmon list is reshaped first.
> > It is not guaranteed that searching order is the same as reshape
> order.
> > I.e. arrays are in reversed order in any list (last element is put in
> to list head)
> > comparing to order in metadata.
> >
> > >
> > > What is wrong with the following logic?
> > >
> > >  - initially there are 2 arrays in the container, each containing N
> > > disks.
> > >  - We start a reshape to M disks (M > N).
> > >     So now dev[0]->map[0]->num_members == M
> > >        and dev[1]->map[0]->num_members == N
> > >
> > >  - When the reshape completes we call
> imsm_progress_container_reshape.
> > >    It looks at dev[0], sees that num_members is M and stores that
> in
> > >    prev_disks
> > >  - Then it loops around, looks at dev[1];.  num_members <
> prev_disks
> > >    so it starts migration for dev[1].
> > >
> > > Why does it not work like that?
> >
> >
> > Reshape is started by mdadm from the second array. It is based on
> created array list, where second array is put in to list head.
> > This makes second array first for reshape as arrays are taken in
> order from list head.
> 
> If mdadm is reshaping the second array first then it would seem to make
> more
> sense to fix mdadm so that it does the first array first.
> >
> > Are you comfortable with this that fault guard is arrays order
> assumption only? I'm not :(
> >
> 
> The important question is: what does the Windows driver do?  In what
> order
> does it reshape the two arrays?
> We should make sure that mdadm always does the reshape in a well
> defined
> order that is compatible with the windows driver.
> Can you check what the windows driver does?
> 
> > Please apply this patch.
> 
> No.  Not until I understand exactly what is happening and why.  Then I
> will
> apply the appropriate patch which almost certainly will not be this
> one.
> 
> NeilBrown

I'm not standing, that we should not correct root cause:
super-intel.c:5880 : 'for' command walks list in reversed order while first array metadata preparation
in apply_reshape_container_disk_update().
It is reversed order comparing to metadata order. You are right it is not in the way that windows driver does it
and bug fix it is required.

I'm still thinking that finding maximum disk number should be order independent (or process should be blocked on metadata incompatible situation)
(if mdadm will be this free of this bug, we cannot assume that any other software that operates on imsm metadata will be ok also).

Fix for root cause I'll sent shortly.

BR
Adam	



> 
> >
> > BR
> > Adam
> >
> >
> > >
> > >
> > > >
> > > > prev_disks have to be found before we enter 'for' loop.
> > > >
> > > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > > ---
> > > >
> > > >  super-intel.c |   15 ++++++++++++++-
> > > >  1 files changed, 14 insertions(+), 1 deletions(-)
> > > >
> > > > diff --git a/super-intel.c b/super-intel.c
> > > > index d5501bd..4ae4764 100644
> > > > --- a/super-intel.c
> > > > +++ b/super-intel.c
> > > > @@ -5062,6 +5062,15 @@ static void
> > > imsm_progress_container_reshape(struct intel_super *super)
> > > >  	int prev_disks = -1;
> > > >  	int i;
> > > >
> > > > +	/* find maximum number of disks used in any array
> > > > +	 */
> > > > +	for (i = 0; i < mpb->num_raid_devs; i++) {
> > > > +		struct imsm_dev *dev = get_imsm_dev(super, i);
> > > > +		struct imsm_map *map = get_imsm_map(dev, 0);
> > > > +		if (map->num_members > prev_disks)
> > > > +			prev_disks = map->num_members;
> > > > +	}
> > > > +
> > > >  	for (i = 0; i < mpb->num_raid_devs; i++) {
> > > >  		struct imsm_dev *dev = get_imsm_dev(super, i);
> > > >  		struct imsm_map *map = get_imsm_map(dev, 0);
> > > > @@ -5253,13 +5262,17 @@ static int imsm_set_array_state(struct
> > > active_array *a, int consistent)
> > > >  		super->updates_pending++;
> > > >  	}
> > > >
> > > > -	/* finalize online capacity expansion/reshape */
> > > > +	/* manage online capacity expansion/reshape */
> > > >  	if ((a->curr_action != reshape) &&
> > > >  	    (a->prev_action == reshape)) {
> > > >  		struct mdinfo *mdi;
> > > >
> > > > +		/* finalize online capacity expansion/reshape */
> > > >  		for (mdi = a->info.devs; mdi; mdi = mdi->next)
> > > >  			imsm_set_disk(a, mdi->disk.raid_disk, mdi-
> > > >curr_state);
> > > > +
> > > > +		/* check next volume reshape */
> > > > +		imsm_progress_container_reshape(super);
> > >
> > > It also isn't clear why you need to call
> > > imsm_progress_container_reshape here.
> > > It is already called earlier in the place where the first array has
> > > vol.migr_state cleared.
> > >
> > > Why is that call not sufficient?
> > >
> > > NeilBrown
> > >
> > >
> > >
> > >
> > > >  	}
> > > >
> > > >  	return consistent;
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-
> raid"
> > > in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-
> info.html

