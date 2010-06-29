From: Neil Brown <neilb@suse.de>
Subject: Re: [md PATCH 4/5] md: Fix: BIO I/O Error during reshape for
 external metadata
Date: Tue, 29 Jun 2010 12:09:50 +1000
Message-ID: <20100629120950.1c5d1142@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D11EECE8A6@irsmsx503.ger.corp.intel.com>
	<20100616150237.0009d6d1@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D11F300178@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D11F300178@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Fri, 18 Jun 2010 09:48:34 +0100
"Kwolek, Adam" <adam.kwolek@intel.com> wrote:

> 
> 
> > -----Original Message-----
> > From: Neil Brown [mailto:neilb@suse.de]
> > Sent: Wednesday, June 16, 2010 7:03 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
> > Subject: Re: [md PATCH 4/5] md: Fix: BIO I/O Error during reshape for
> > external metadata
> > 
> > On Wed, 9 Jun 2010 15:22:27 +0100
> > "Kwolek, Adam" <adam.kwolek@intel.com> wrote:
> > 
> > > (md: Online Capacity Expansion for IMSM)
> > > When sum of added disks and degraded disks is greater than
> > max_degraded number, reshape decides that stripe is broken, so bio i/o
> > error is a result.
> > > Added disks without data has no impact on volume degradation
> > (contains no data so far), so we have to be sure that all disks used to
> > reshape has In_sync flag set.
> > > We have to do this for disks without data.
> > 
> > Again, I'm not really following you.
> > I agree that devices that are added to make up numbers for a shape
> > should be
> > marked In_sync, but that is already happening, roughly in the middle of
> > raid5_start_reshape.
> > 
> > Again, can you give me a specific situation where the current code does
> > the
> > wrong thing?
> > 
> > Thanks,
> > NeilBrown
> > 
> > 
> > > ---
> > >
> > >  drivers/md/raid5.c |   17 ++++++++++++++++-
> > >  1 files changed, 16 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c index
> > dc25a32..cb74045 100644
> > > --- a/drivers/md/raid5.c
> > > +++ b/drivers/md/raid5.c
> > > @@ -5468,7 +5468,7 @@ static int raid5_start_reshape(mddev_t *mddev)
> > >  	/* Add some new drives, as many as will fit.
> > >  	 * We know there are enough to make the newly sized array work.
> > >  	 */
> > > -	list_for_each_entry(rdev, &mddev->disks, same_set)
> > > +	list_for_each_entry(rdev, &mddev->disks, same_set) {
> > >  		if (rdev->raid_disk < 0 &&
> > >  		    !test_bit(Faulty, &rdev->flags)) {
> > >  			if (raid5_add_disk(mddev, rdev) == 0) { @@ -5488,6
> > +5488,21 @@ static int raid5_start_reshape(mddev_t *mddev)
> > >  			} else
> > >  				break;
> > >  		}
> > > +		/* if there is Online Capacity Expansion
> > > +		 * on degraded array for external meta
> > > +		 */
> > > +		if (mddev->external &&
> > > +		    (conf->raid_disks <= (disk_count + conf-
> > >max_degraded))) {
> > > +			/* check if not spare */
> > > +			if (!(rdev->raid_disk < 0 &&
> > > +			      !test_bit(Faulty, &rdev->flags)))
> > > +				/* make sure that all disks,
> > > +				 * even added previously have
> > > +				 * in sync flag set
> > > +				 */
> > > +				set_bit(In_sync, &rdev->flags);
> > > +		}
> > > +	}
> > >
> > >  	/* When a reshape changes the number of devices, ->degraded
> > >  	 * is measured against the large of the pre and post number of
> > >
> 
> 
> When disks are added to md for reshape for external metadata they have cleared in_sync flag (they are not used so far).

Actually In_sync is set for these devices.  The code to do that is just above
where you have added some code.

> If the number of added disks is smaller than maximum degraded disks number, there is no problem.
> If (i.e.) 2 or more disks are added to raid5 during reshape, stripes looks as degraded and bio error occurs.
> For takeovered raid0 (it is changed to degraded raid5), if single disk only is added
> we have problem, because we exceeded allowed degradation factor. Checking stripes degradation code during reshape
> generates bio error as well.

Surely all the devices in the RAID0 will be marked In_sync, so when it is
converted to a RAID5 (in RAID4 layout) it will have N-1 In_sync devices and
one missing device.
raid5_start_reshape will then add a spare but *not* mark it in_sync as 
  if (rdev->raid_disk >= conf->previous_raid_disks) {

will fail.  This is correct, you end up with 4 in-sync devices and one which
is not in_sync.  The reshape process will rearrange the data and at the end
of the process, the new device will be in_sync.

During the reshape, IO to the section that has already been reshaped will see
a degraded array (but not overly degraded) and might reconstruct using parity
rather than reading directly, but it should work.
IO to the section that has not been reshaped yet will just be normal RAID0
style IO.

There might be some issues here when converting e.g. a 3 drive RAID0 to 5
drive RAID5, and not all new devices are available.
I came across something similar recently and I think those issues are fixed
by the patches that are in -next and that I submitted to Linus yesterday. 
Maybe try applying those and see if they fix your problem.


Thanks,
NeilBrown


> 
> To avoid this in_sync flag has to be set for all disks that are taken in to reshape/grow before process is executed.
> 
> For native metadata, in_sync flag is maintained during metadata writing/validating ...
> 
> BR
> Adam
> 
> 

