From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [md PATCH 3/5] md: Use added disks for external metadata case
 in start_reshape()
Date: Fri, 18 Jun 2010 09:35:10 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11F300151@irsmsx503.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D11EECE8A3@irsmsx503.ger.corp.intel.com>
 <20100616145818.75bf0720@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100616145818.75bf0720@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Wednesday, June 16, 2010 6:58 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [md PATCH 3/5] md: Use added disks for external metadata
> case in start_reshape()
> 
> On Wed, 9 Jun 2010 15:21:44 +0100
> "Kwolek, Adam" <adam.kwolek@intel.com> wrote:
> 
> > (md: Online Capacity Expansion for IMSM)
> > Disks added by mdadm for external metadata are not taken for
> configuration check before reshape.
> > This causes configuration check fail.
> >
> > For reshape, we should check if added disks to volume by mdadm, will
> satisfy degradation condition after operation (comparing difference of
> target disk number and available disks number to mddev->max_degraded
> field).
> > ---
> 
> I'm sorry but I don't understand what you are saying, and I think the
> required check is already in place.
> Could you please describe a specific circumstance where the current
> code
> fails?
> 
> Thanks,
> NeilBrown
> 
> 
> >
> >  drivers/md/raid5.c |   11 ++++++++++-
> >  1 files changed, 10 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c index
> 546e23e..dc25a32 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -5411,6 +5411,7 @@ static int raid5_start_reshape(mddev_t *mddev)
> >  	int spares = 0;
> >  	int added_devices = 0;
> >  	unsigned long flags;
> > +	int disk_count = 0;
> >
> >  	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
> >  		return -EBUSY;
> > @@ -5422,12 +5423,20 @@ static int raid5_start_reshape(mddev_t
> *mddev)
> >  		if (rdev->raid_disk < 0 &&
> >  		    !test_bit(Faulty, &rdev->flags))
> >  			spares++;
> > +		else
> > +			/* check reshape condition/spares are added already
> > +			 */
> > +			disk_count++;
> >
> >  	if (spares - mddev->degraded < mddev->delta_disks - conf-
> >max_degraded)
> >  		/* Not enough devices even to make a degraded array
> >  		 * of that size
> > +		 * but check first if this is not reshape case
> > +		 * if not reshape on degraded array /takeover/ than exit
> >  		 */
> > -		return -EINVAL;
> > +		if ((conf->raid_disks + mddev->delta_disks)
> > +		    > (disk_count + conf->max_degraded))
> > +			return -EINVAL;
> >
> >  	/* Refuse to reduce size of the array.  Any reductions in
> >  	 * array size must be through explicit setting of array_size
> >


First, all disks are counted that are not spares. This is total number of disks in volume.
Disks added by mdadm for external metadata to volume before reshape are not longer in spares pool,
so md in current condition:

if (spares - mddev->degraded < mddev->delta_disks - conf->max_degraded)

has less spares disks and more in delta_disks. This causes that condition value is true, but this is not true for our case.
This is the reason of the second check:
if ((conf->raid_disks + mddev->delta_disks) > (disk_count + conf->max_degraded))

It tells if currently raid_disks configured in array (before reshape reconfiguration value) and currently degraded disks
(degradation can happen i.e. after raid0 takeover) is greater than counted_disks (that will be present after reshape)
and maximum of degraded disks number. If so, this is real problem and error is returned.

As I wrote above spares in first condition for external configuration shows number of available spares, so disks already used for reshape configuration 
are not counted there.

I think that condition for external metadata has to be added to this patch additionally, to not affect native metadata code logic.

BR
Adam
 
