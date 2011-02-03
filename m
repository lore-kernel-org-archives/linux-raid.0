From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/8] FIX: Do not set array size after reshape in mdadm
Date: Thu, 3 Feb 2011 21:44:35 +1100
Message-ID: <20110203214435.1680fe72@notabene.brown>
References: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
	<20110201134944.13398.41001.stgit@gklab-128-013.igk.intel.com>
	<20110203175659.1a4fd562@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D1770B8293@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D1770B8293@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Thu, 3 Feb 2011 10:08:12 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> 
> 
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Thursday, February 03, 2011 7:57 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Neubauer, Wojciech
> > Subject: Re: [PATCH 6/8] FIX: Do not set array size after reshape in
> > mdadm
> > 
> > On Tue, 01 Feb 2011 14:49:44 +0100 Adam Kwolek <adam.kwolek@intel.com>
> > wrote:
> > 
> > > Do not set array size after reshape in mdadm,
> > > as it is up to mdmon metadata handler (set_array_state()) now.
> > 
> > I'm not sure about this...
> > 
> > I agree that it is probably more appropriate for mdmon to impose the
> > new
> > array_size rather than for mdadm to do it.
> > In general, if the kernel does something for native metadata, then
> > mdmon
> > should probably do it for external metadata (though there might be
> > exceptions
> > to this).
> > 
> > However it is not the metadata handler which should do this (and it
> > currently doesn't, which is good). The metadata handler should set
> > custom_array_array, and the core code of mdmon should use this number
> > to set array_size.
> > And I don't see that mdmon does this at the moment.  It sets the array
> > size
> > when the reshape starts (which is possibly wrong) but it does not set
> > it when the reshape finishes (which is the right time).
> > 
> > Could you please review all of this and either point out to me where
> > I am wrong, or fix up the code to do the right thing, thanks.
> > 
> > I won't apply this patch now, but am happy to apply it once I'm sure
> > mdmon is performing this task.
> > 
> > NeilBrown
> 
> I think mdmon takes carry about size now.
> If set_array_state() sets a->check_reshape variable to 1 (super-intel.c:near5206) on reshape end,
> and a->info.custom_array_size will be set to bigger value Managemon will set it in to md (manage_member():551)
> (the only problem I faced was seze value to set '/2' in one of previous path that you commented already)
> 
> In my tests mdmon does his job for size changes :).

I see ... yes.....

I'm not sure I like ->set_array_state changing ->check_reshape.
Maybe it is OK, but the intention for ->check_reshape was that it was
a reshape starting not ending.
Maybe that doesn't matter, but maybe it does.

I'll have a read through the code again and see what I think.

Thanks for the explanation.

NeilBrown


> 
> BR
> Adam
> 
> 
> 
> > 
> > >
> > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > ---
> > >
> > >  Grow.c |   35 -----------------------------------
> > >  1 files changed, 0 insertions(+), 35 deletions(-)
> > >
> > > diff --git a/Grow.c b/Grow.c
> > > index 8229b4d..a74da89 100644
> > > --- a/Grow.c
> > > +++ b/Grow.c
> > > @@ -2045,41 +2045,6 @@ started:
> > >  		}
> > >  	}
> > >
> > > -	/* set new array size if required customer_array_size is used
> > > -	 * by this metadata.
> > > -	 */
> > > -	if (reshape.before.data_disks !=
> > > -	    reshape.after.data_disks &&
> > > -	    info->custom_array_size) {
> > > -		struct mdinfo *info2;
> > > -		char *subarray = strchr(info->text_version+1, '/')+1;
> > > -
> > > -		info2 = st->ss->container_content(st, subarray);
> > > -		if (info2) {
> > > -			unsigned long long current_size = 0;
> > > -			unsigned long long new_size =
> > > -				info2->custom_array_size/2;
> > > -
> > > -			if (sysfs_get_ll(sra,
> > > -					 NULL,
> > > -					 "array_size",
> > > -					 &current_size) == 0 &&
> > > -			    new_size > current_size) {
> > > -				if (sysfs_set_num(sra, NULL,
> > > -						  "array_size", new_size)
> > > -				    < 0)
> > > -					dprintf("Error: Cannot"
> > > -						" set array size");
> > > -				else
> > > -					dprintf("Array size "
> > > -						"changed");
> > > -				dprintf(" from %llu to %llu.\n",
> > > -					current_size, new_size);
> > > -			}
> > > -			sysfs_free(info2);
> > > -		}
> > > -	}
> > > -
> > >  	if (info->new_level != reshape.level) {
> > >
> > >  		c = map_num(pers, info->new_level);
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

