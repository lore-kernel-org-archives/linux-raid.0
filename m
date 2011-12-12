From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH] imsm: FIX: Limit migration record operation by disk
 slot not by index
Date: Mon, 12 Dec 2011 08:14:19 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A0569F5@IRSMSX101.ger.corp.intel.com>
References: <20111208084655.7455.66462.stgit@gklab-128-013.igk.intel.com>
 <20111212161705.1a13cdbc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111212161705.1a13cdbc@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Monday, December 12, 2011 6:17 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Williams,
> Dan J
> Subject: Re: [PATCH] imsm: FIX: Limit migration record operation by disk slot
> not by index
> 
> On Thu, 08 Dec 2011 09:46:56 +0100 Adam Kwolek
> <adam.kwolek@intel.com> wrote:
> 
> > imsm should store migration record in to 2 first disks in array.
> > This should be evaluated based on disk slots, not on disks index.
> > It is not guaranteed that indexes are equal to slots.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> ...
> 
> > @@ -2200,11 +2245,37 @@ static int write_imsm_migr_rec(struct
> supertype *st)
> >  	struct dl *sd;
> >  	int len;
> >  	struct imsm_update_general_migration_checkpoint *u;
> > +	struct imsm_dev *dev;
> > +	struct imsm_map *map = NULL;
> > +
> > +	/* find map under migration */
> > +	dev = imsm_get_device_during_migration(super);
> > +	/* if no migration, write buffer anyway to clear migr_record
> > +	 * on disk based on first available device
> > +	*/
> > +	if (dev == NULL) {
> > +		int vol;
> > +
> > +		if (super->current_vol >= 0)
> > +			vol = super->current_vol;
> > +		else
> > +			vol = 0;
> > +		dev = get_imsm_dev(super, super->current_vol);
> > +	}
> 
> 'vol' is unused here.  Should it be:
>                 dev = get_imsm_dev(super, vol); ??
> 
> NeilBrown
> 
Yes you are right, I'll sent corrected one.
BR
Adam


