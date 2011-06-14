From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 1/4] imsm: FIX: Cannot create volume
Date: Tue, 14 Jun 2011 10:21:16 +0100
Message-ID: <1B9446C3081EE34E9490470AD5CEC3132F59CF20@irsmsx503.ger.corp.intel.com>
References: <20110609162050.690.87261.stgit@gklab-128-013.igk.intel.com>
	<20110609162912.690.5879.stgit@gklab-128-013.igk.intel.com>
 <20110614120704.54a58bbe@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110614120704.54a58bbe@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Tuesday, June 14, 2011 4:07 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 1/4] imsm: FIX: Cannot create volume
> 
> On Thu, 09 Jun 2011 18:29:12 +0200 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > getinfo_super_imsm_volume() clears entire 'info' structure before
> filling with new
> > information. Disk number and raid_disk can be required later by caller
> > but it is lost.
> >
> > Restore disk number information in getinfo_super_imsm_volume() call.
> 
> I need a better explanation than this.
> 
> When is getinfo_super_imsm or getinfo_super_imsm_volume *ever* called in
> a
> situation where 'info' contains a meaningful value for disk.number???
> I could not find it.

Is not a matter of meaningful value (it is ok), this is restore of cleared by memset() value only.
Function getinfo_super_imsm_volume() clears entire mdinfo structure now.
We should restore mdinfo->disk.raid_disk structure field information
Currently some information is set for first available disk in metadata, but it should be set to correct value.

Creation is made in 2 stages:
Pass 1: Collects disks in infos table (Create.c:789)
Pass 2: adds disks to md for array creation purposes (Create.c:873)

When during pass 1 inf->disk.raid_disk is not set correctly (or cleared /0/), during pass 2 it cannot be added by add_disk() correctly.
add_disk() thinks that all disks has to be configured for slot 0 (as it is 'clean' value), 


disk.number is not important here (it is set to have identical values set in Create.c).
disk.raid_number is value that cannot be cleared by getinfo to have possibility for crresc slot number configuration.

Second patch, you partially applied (for Create.c) was some kind of "plan B" only.

Please let me know if this is clear enough for you.

BR
Adam




> 
> Alternately, explain what goes wrong with the current code (yes, I could
> probably test it myself ... but if you send a patch you should justify
> it).
> 
> So for now this patch has not been applied.
> 
> Thanks,
> NeilBrown
> 
> 
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  super-intel.c |   11 ++++++++++-
> >  1 files changed, 10 insertions(+), 1 deletions(-)
> >
> > diff --git a/super-intel.c b/super-intel.c
> > index 5c840ec..e094b85 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -2075,11 +2075,18 @@ static void getinfo_super_imsm_volume(struct
> supertype *st, struct mdinfo *info,
> >  	unsigned int component_size_alligment;
> >  	int map_disks = info->array.raid_disks;
> >
> > -	memset(info, 0, sizeof(*info));
> >  	if (prev_map)
> >  		map_to_analyse = prev_map;
> >
> >  	dl = super->disks;
> > +	while (dl) {
> > +		if (dl->index == info->disk.number)
> > +			break;
> > +		dl = dl->next;
> > +	}
> > +	if (!dl)
> > +		dl = super->disks;
> > +	memset(info, 0, sizeof(*info));
> >
> >  	info->container_member	  = super->current_vol;
> >  	info->array.raid_disks    = map->num_members;
> > @@ -2147,6 +2154,8 @@ static void getinfo_super_imsm_volume(struct
> supertype *st, struct mdinfo *info,
> >  	if (dl) {
> >  		info->disk.major = dl->major;
> >  		info->disk.minor = dl->minor;
> > +		info->disk.number = dl->index;
> > +		info->disk.raid_disk = dl->index;
> >  	}
> >
> >  	info->data_offset	  = __le32_to_cpu(map_to_analyse->pba_of_lba0);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
