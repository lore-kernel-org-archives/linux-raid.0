From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [md PATCH 4/5] md: Fix: BIO I/O Error during reshape for
 external metadata
Date: Fri, 18 Jun 2010 09:48:34 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11F300178@irsmsx503.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D11EECE8A6@irsmsx503.ger.corp.intel.com>
 <20100616150237.0009d6d1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100616150237.0009d6d1@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Wednesday, June 16, 2010 7:03 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [md PATCH 4/5] md: Fix: BIO I/O Error during reshape for
> external metadata
> 
> On Wed, 9 Jun 2010 15:22:27 +0100
> "Kwolek, Adam" <adam.kwolek@intel.com> wrote:
> 
> > (md: Online Capacity Expansion for IMSM)
> > When sum of added disks and degraded disks is greater than
> max_degraded number, reshape decides that stripe is broken, so bio i/o
> error is a result.
> > Added disks without data has no impact on volume degradation
> (contains no data so far), so we have to be sure that all disks used to
> reshape has In_sync flag set.
> > We have to do this for disks without data.
> 
> Again, I'm not really following you.
> I agree that devices that are added to make up numbers for a shape
> should be
> marked In_sync, but that is already happening, roughly in the middle of
> raid5_start_reshape.
> 
> Again, can you give me a specific situation where the current code does
> the
> wrong thing?
> 
> Thanks,
> NeilBrown
> 
> 
> > ---
> >
> >  drivers/md/raid5.c |   17 ++++++++++++++++-
> >  1 files changed, 16 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c index
> dc25a32..cb74045 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -5468,7 +5468,7 @@ static int raid5_start_reshape(mddev_t *mddev)
> >  	/* Add some new drives, as many as will fit.
> >  	 * We know there are enough to make the newly sized array work.
> >  	 */
> > -	list_for_each_entry(rdev, &mddev->disks, same_set)
> > +	list_for_each_entry(rdev, &mddev->disks, same_set) {
> >  		if (rdev->raid_disk < 0 &&
> >  		    !test_bit(Faulty, &rdev->flags)) {
> >  			if (raid5_add_disk(mddev, rdev) == 0) { @@ -5488,6
> +5488,21 @@ static int raid5_start_reshape(mddev_t *mddev)
> >  			} else
> >  				break;
> >  		}
> > +		/* if there is Online Capacity Expansion
> > +		 * on degraded array for external meta
> > +		 */
> > +		if (mddev->external &&
> > +		    (conf->raid_disks <= (disk_count + conf-
> >max_degraded))) {
> > +			/* check if not spare */
> > +			if (!(rdev->raid_disk < 0 &&
> > +			      !test_bit(Faulty, &rdev->flags)))
> > +				/* make sure that all disks,
> > +				 * even added previously have
> > +				 * in sync flag set
> > +				 */
> > +				set_bit(In_sync, &rdev->flags);
> > +		}
> > +	}
> >
> >  	/* When a reshape changes the number of devices, ->degraded
> >  	 * is measured against the large of the pre and post number of
> >


When disks are added to md for reshape for external metadata they have cleared in_sync flag (they are not used so far).
If the number of added disks is smaller than maximum degraded disks number, there is no problem.
If (i.e.) 2 or more disks are added to raid5 during reshape, stripes looks as degraded and bio error occurs.
For takeovered raid0 (it is changed to degraded raid5), if single disk only is added
we have problem, because we exceeded allowed degradation factor. Checking stripes degradation code during reshape
generates bio error as well.

To avoid this in_sync flag has to be set for all disks that are taken in to reshape/grow before process is executed.

For native metadata, in_sync flag is maintained during metadata writing/validating ...

BR
Adam



