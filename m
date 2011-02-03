From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 2/8] imsm: FIX: array size is wrong
Date: Thu, 3 Feb 2011 09:56:12 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1770B8264@irsmsx503.ger.corp.intel.com>
References: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
	<20110201134912.13398.64773.stgit@gklab-128-013.igk.intel.com>
 <20110203174118.5879e8be@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110203174118.5879e8be@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Thursday, February 03, 2011 7:41 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 2/8] imsm: FIX: array size is wrong
> 
> On Tue, 01 Feb 2011 14:49:12 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > Calculation of size is almost ok, except concept of blocks.
> > Size for setting in md has to be divided by 2 to be correct.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  super-intel.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/super-intel.c b/super-intel.c
> > index ee0d9c4..42f7065 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -5187,7 +5187,7 @@ static int imsm_set_array_state(struct
> active_array *a, int consistent)
> >  					<< SECT_PER_MB_SHIFT;
> >  				dev->size_low = __cpu_to_le32((__u32)
> array_blocks);
> >  				dev->size_high = __cpu_to_le32((__u32)
> (array_blocks >> 32));
> > -				a->info.custom_array_size = array_blocks;
> > +				a->info.custom_array_size = array_blocks/2;
> >  				a->check_reshape = 1; /* encourage manager to
> update
> >  						       * array size
> >  						       */
> >
> 
> 
> I think the original code is correct.
> custom_array_size is measured in sectors.
> In grow.c we divide by 2 before comparing with the "array_size" sysfs
> attribute which is measured in kilobytes.
> Also in getinfo_super_imsm_volume, custom_array_size is set from
> the same size_low/size_high fields as used here.
> 
> However in manage_member custom_array_size is compared directly
> with "array_size" which is wrong and is probably causing whatever
> problem you experienced.
> 
> So I'll change this patch to fix that up instead - see below.
> 
> Thanks,
> NeilBrown

Thanks 
Adam

> 
> commit 02eedb57aa0c6f7fdeda1b612f35545ab4eee58f
> Author: Adam Kwolek <adam.kwolek@intel.com>
> Date:   Thu Feb 3 17:40:18 2011 +1100
> 
>     imsm: FIX: array size is wrong
> 
>     Calculation of size is almost ok, except concept of blocks.
>     Size for setting in md has to be divided by 2 to be correct.
> 
>     Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
>     Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/managemon.c b/managemon.c
> index 63c9705..6001f6a 100644
> --- a/managemon.c
> +++ b/managemon.c
> @@ -549,9 +549,9 @@ static void manage_member(struct mdstat_ent
> *mdstat,
>  			disk_init_and_add(newd, d, newa);
>  		}
>  		if (sysfs_get_ll(info, NULL, "array_size", &array_size) ==
> 0
> -		    && a->info.custom_array_size > array_size) {
> +		    && a->info.custom_array_size > array_size*2) {
>  			sysfs_set_num(info, NULL, "array_size",
> -				      a->info.custom_array_size);
> +				      a->info.custom_array_size/2);
>  		}
>  	out2:
>  		sysfs_free(info);
