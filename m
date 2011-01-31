From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] imsm:FIX: change arrays reshape order
Date: Tue, 1 Feb 2011 10:18:20 +1100
Message-ID: <20110201101820.3c836f3e@notabene.brown>
References: <20110131085922.7551.47081.stgit@gklab-128-013.igk.intel.com>
	<20110131201800.3a0226de@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D17701C192@irsmsx503.ger.corp.intel.com>
	<905EDD02F158D948B186911EB64DB3D17701C24A@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17701C24A@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Mon, 31 Jan 2011 10:10:30 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> 
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Kwolek, Adam
> > Sent: Monday, January 31, 2011 10:30 AM
> > To: NeilBrown
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Neubauer, Wojciech
> > Subject: RE: [PATCH 1/2] imsm:FIX: change arrays reshape order
> > 
> > 
> > 
> > > -----Original Message-----
> > > From: NeilBrown [mailto:neilb@suse.de]
> > > Sent: Monday, January 31, 2011 10:18 AM
> > > To: Kwolek, Adam
> > > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > > Neubauer, Wojciech
> > > Subject: Re: [PATCH 1/2] imsm:FIX: change arrays reshape order
> > >
> > > On Mon, 31 Jan 2011 09:59:22 +0100 Adam Kwolek
> > <adam.kwolek@intel.com>
> > > wrote:
> > >
> > > > Reshape is started from second array, so it causes imsm
> > > incompatibility
> > > > and problems during second array start.
> > > >
> > > > Reshape should be started in arrays metadata order.
> > > >
> > > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > > ---
> > > >
> > > >  super-intel.c |    9 ++++++++-
> > > >  1 files changed, 8 insertions(+), 1 deletions(-)
> > > >
> > > > diff --git a/super-intel.c b/super-intel.c
> > > > index f578057..8484df6 100644
> > > > --- a/super-intel.c
> > > > +++ b/super-intel.c
> > > > @@ -5848,6 +5848,7 @@ static int
> > > apply_reshape_container_disks_update(struct imsm_update_reshape *u,
> > > >  	int devices_to_reshape = 1;
> > > >  	struct imsm_super *mpb = super->anchor;
> > > >  	int ret_val = 0;
> > > > +	unsigned int dev_id;
> > > >
> > > >  	dprintf("imsm: imsm_process_update() for update_reshape\n");
> > > >
> > > > @@ -5877,11 +5878,17 @@ static int
> > > apply_reshape_container_disks_update(struct imsm_update_reshape *u,
> > > >  		" mpb->num_raid_devs = %i\n", mpb->num_raid_devs);
> > > >  	/* manage changes in volume
> > > >  	 */
> > > > -	for (id = super->devlist ; id; id = id->next) {
> > > > +	for (dev_id = 0; dev_id < mpb->num_raid_devs; dev_id++) {
> > > >  		void **sp = *space_list;
> > > >  		struct imsm_dev *newdev;
> > > >  		struct imsm_map *newmap, *oldmap;
> > > >
> > > > +		for (id = super->devlist ; id; id = id->next) {
> > > > +			if (id->index == dev_id)
> > > > +				break;
> > > > +		}
> > >
> > > Could you replace that loop with a call to get_imsm_dev please?
> > >
> > > Otherwise, this look good.
> > >
> > > Thanks,
> > > NeilBrown
> > 
> > In a while ;)
> > BR
> > Adam
> 
> I think we should leave this patch as I've proposed. I need to work not on imsm_dev but on intel_dev.
> intel_dev is required for memory re-linking.
> If I use there get_imsm_dev() I have to work on 2 pointers set, and keep them in sync. This can introduce more noise in to code.
> Than 'for' loop you want to remove.
> 
> Summarizing if I use get_imsm_dev(), I cannot remove this loop (it is required for memory management purposes,
> few lines below: id->dev = newdev, I need reference to correct intel_dev).
> 

Fair enough - I've applied the original version (not the v2).

Thanks,
NeilBrown 

