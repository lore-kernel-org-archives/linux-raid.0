From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH] imsm: FIX: Use first map only in migration record disk
 operations
Date: Mon, 12 Dec 2011 11:55:35 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A056A94@IRSMSX101.ger.corp.intel.com>
References: <20111209115720.5396.83087.stgit@gklab-128-013.igk.intel.com>
 <20111212161907.0b35fc80@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111212161907.0b35fc80@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

I'm sending second answer with more information /below/
.

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Monday, December 12, 2011 6:19 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Williams,
> Dan J
> Subject: Re: [PATCH] imsm: FIX: Use first map only in migration record disk
> operations
> 
> On Fri, 09 Dec 2011 12:57:20 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > This patch is addition to patch:
> >     "imsm: FIX: Limit migration record operation by disk slot not by index"
> > Location of migration record (2 first slots) should be taken on up to
> > date information. It is in first map.
> > Change slot verification to use first map only.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  super-intel.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/super-intel.c b/super-intel.c index 879f4c4..92ff79c
> > 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -1185,7 +1185,7 @@ void examine_migr_rec_imsm(struct intel_super
> *super)
> >  		printf("\nMigration Record Information:");
> >
> >  		/* map under migration */
> > -		map = get_imsm_map(dev, MAP_1);
> > +		map = get_imsm_map(dev, MAP_0);
> >  		if (map)
> >  			slot = get_imsm_disk_slot(map, super->disks-
> >index);
> >  		if ((map == NULL) || (slot > 1) || (slot < 0)) { @@ -2138,7
> +2138,7
> > @@ static int load_imsm_migr_rec(struct intel_super *super, struct
> mdinfo *info)
> >  	*/
> >  	if (dev == NULL)
> >  		return 0;
> > -	map = get_imsm_map(dev, MAP_1);
> > +	map = get_imsm_map(dev, MAP_0);
> >
> >  	if (info) {
> >  		for (sd = info->devs ; sd ; sd = sd->next) { @@ -2269,7
> +2269,7 @@
> > static int write_imsm_migr_rec(struct supertype *st)
> >  			vol = 0;
> >  		dev = get_imsm_dev(super, super->current_vol);
> >  	}
> > -	map = get_imsm_map(dev, MAP_X);
> > +	map = get_imsm_map(dev, MAP_0);
> >
> >  	for (sd = super->disks ; sd ; sd = sd->next) {
> >  		int slot = -1;
>                 ^^^^^^^^^^^^^^^^
> 
> Patch doesn't apply (Without fuzz) as in my code this is just
>                 int slot;


It should be put after patch:  imsm: FIX: Correct make everything and variable initialization
Sent: Thu 12/8/2011 2:47 PM

In this  patch variable initialization was changed.

> 
> It doesn't need to be initialised from what I can see, so I've left it as it is.


Without this initialization 'make everything' fails for me /warning: 'slot' may be used uninitialized/.


> 
> Pending confirmation of the earlier patch (vol not used), I've applied these
> last 3:

As I've pointed above second correction for 'make everything'  is missing.
I'll resend corrected ' imsm: FIX: Limit migration record operation by disk slot not by index' also,
as you pointed for correction.

If you would have all those patches in one series, please let me know.

BR
Adam

> 
> Subject: [PATCH] imsm: FIX: Limit migration record operation by disk slot not
> by index
> Subject: [PATCH] imsm: FIX: Use definitions for migration record disk
> operations
> Subject: [PATCH] imsm: FIX: Use first map only in migration record disk
> operations
> 
> NeilBrown

