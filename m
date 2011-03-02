From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 3/7] FIX: configure disks slot for expansion
Date: Wed, 2 Mar 2011 07:48:53 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A534A20@irsmsx503.ger.corp.intel.com>
References: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
	<20110301145706.10678.63966.stgit@gklab-128-013.igk.intel.com>
 <20110302121001.6a1694dc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110302121001.6a1694dc@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Wednesday, March 02, 2011 2:10 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 3/7] FIX: configure disks slot for expansion
> 
> On Tue, 01 Mar 2011 15:57:06 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > Some raid_disks that are used for expansion, are not configured yet.
> > This is due to earlier set raid_disks limitation.
> > Set raid_disks to new (bigger) value and finish disks slot
> configuration.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  Assemble.c |   15 ++++++++++++++-
> >  1 files changed, 14 insertions(+), 1 deletions(-)
> >
> > diff --git a/Assemble.c b/Assemble.c
> > index 6aff049..fa3a0a6 100644
> > --- a/Assemble.c
> > +++ b/Assemble.c
> > @@ -1586,9 +1586,22 @@ int assemble_container_content(struct supertype
> *st, int mdfd,
> >  					chosen_name, working + preexist);
> >  			if (preexist)
> >  				fprintf(stderr, " (%d new)", working);
> > -			if (expansion)
> > +			if (expansion) {
> >  				fprintf(stderr, " ( + %d for expansion)",
> >  					expansion);
> > +			sysfs_set_num(content, NULL, "raid_disks",
> > +				      content->array.raid_disks + expansion);
> > +			for (dev = content->devs; dev; dev = dev->next)
> > +				if (dev->disk.raid_disk >=
> > +				    content->array.raid_disks) {
> > +					int rv;
> > +					dprintf("\n\tExpansion: configure slot:"
> > +						"%i", dev->disk.raid_disk);
> > +					rv = sysfs_set_num(content, dev, "slot",
> > +							   dev->disk.raid_disk);
> > +					dprintf(" (status = %i)\n", rv);
> > +				}
> > +			}
> >  			fprintf(stderr, "\n");
> >  		}
> >  		if (!err)
> 
> 
> I thought I explained how this was suppose to work....
> 
> 1/ Set the 'old' geometry of the array.  sysfs_set_array does this.
> 2/ Set 'reshape_position'.  sysfs_set_array does this.
> 3/ Set the 'new' geometry of the array.  sysfs_set_array should do this
> but
>          it doesn't.
> 4/ Add all the disks.  Repeated calls to sysfs_add_disk will do this.
> 5/ start the array readonly .  assemble_container_content calls
> sysfs_set_str
>          to do this.
> 
> That is all.
> 
> NeilBrown

Yes, I remember that.
I want to run correctly process first and then, I'll switch to points you specified above.

So this is not misunderstanding but work in progress /midpoint/ only ;)

BR
Adam

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
