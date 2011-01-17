From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 1/2] md/raid5: FIX: manually-added spare is not used
Date: Mon, 17 Jan 2011 14:13:34 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176EA541F@irsmsx503.ger.corp.intel.com>
References: <20110114125537.15648.73873.stgit@gklab-128-013.igk.intel.com>
	<20110114130000.15648.52870.stgit@gklab-128-013.igk.intel.com>
	<20110117101128.60a9b683@notabene.brown>
	<20110117102821.3460a918@notabene.brown>
 <20110117114441.141f249f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110117114441.141f249f@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Monday, January 17, 2011 1:45 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 1/2] md/raid5: FIX: manually-added spare is not
> used
> 
> On Mon, 17 Jan 2011 10:28:21 +1100 NeilBrown <neilb@suse.de> wrote:
> 
> > On Mon, 17 Jan 2011 10:11:28 +1100 NeilBrown <neilb@suse.de> wrote:
> >
> > > On Fri, 14 Jan 2011 14:00:00 +0100 Adam Kwolek
> <adam.kwolek@intel.com> wrote:
> > >
> > > > Manually added spares are not used due to fact that they not
> added to md configuration.
> > > > Counters are updated only.
> > > >
> > > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > > ---
> > > >
> > > >  drivers/md/raid5.c |    6 ++++--
> > > >  1 files changed, 4 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > > index a2087c7..59c4150 100644
> > > > --- a/drivers/md/raid5.c
> > > > +++ b/drivers/md/raid5.c
> > > > @@ -5592,8 +5592,10 @@ static int raid5_start_reshape(mddev_t
> *mddev)
> > > >  		} else if (rdev->raid_disk >= conf-
> >previous_raid_disks
> > > >  			   && !test_bit(Faulty, &rdev->flags)) {
> > > >  			/* This is a spare that was manually added */
> > > > -			set_bit(In_sync, &rdev->flags);
> > > > -			added_devices++;
> > > > +			if (raid5_add_disk(mddev, rdev) == 0) {
> > > > +				set_bit(In_sync, &rdev->flags);
> > > > +				added_devices++;
> > > > +			}
> > > >  		}
> > > >
> > > >  	/* When a reshape changes the number of devices, ->degraded
> > >
> > > This should not be needed.
> > > When a device is manually added, the desired slot number is written
> to
> > >    ..../md/dev-XXX/slot
> > >
> > > This calls slot_store (in md.c) which call mddev->pers-
> >hot_add_disk which
> > > for raid5 is raid5_add_disk.
> > > So you shouldn't need to call raid5_add_disk again.
> > >
> >
> > ahhh... I see.  raid5_add_disk doesn't do the right thing in that
> case.  It
> > actually indexes beyond the end of an array, which is bad.
> >
> > We possibly do need the raid5_add_disk where you had put it.  I'll
> have a
> > think and see what is best.
> 
> On third thoughts, I cannot see the problem you are seeing.
> I even did some simple testing (manually writing to things in sysfs)
> and it
> seems to include the new device properly.
> 
> There are some issues that I found which are address by the following
> patch,
> but it isn't clear to me that any of them relate to what you are
> seeing.
> Maybe if you could be more specific about what you see happening?
> 
> Thanks,
> NeilBrown


When I'm not using raid5_add_disk() in raid5_start_reshape() added disk LED light doesn't blinks
(but it should during reshape ;)),
md doesn't make any signs that something goes wrong (even size can be increased).

I've made some debug, and at second (during reshape start) raid5_add_disk() call rcu_assign_pointer() is called again.
This means that somehow previous assignment when slot is set was cleared.

Correct situation (all disks are used during reshape) I can archive when instead raid5_add_disk() call
I've add the following code:

     struct disk_info *p = conf->disks + rdev->raid_disk;
     rcu_assign_pointer(p->rdev, rdev);

and (conf->disks + rdev->raid_disk)->rdev pointer is present in configuration.
I've checked that if I do not do call to rcu_assign_pointer() pointer  (p->rdev) has NULL value.
In both cases call rcu_assign_pointer() sets p->rdev to the same value, so rdev doesn't change his location in memory.


BR
Adam








> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3194a80..cd4cccd 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5585,6 +5585,8 @@ static int update_raid_disks(mddev_t *mddev, int
> raid_disks)
>  	mddev->delta_disks = raid_disks - mddev->raid_disks;
> 
>  	rv = mddev->pers->check_reshape(mddev);
> +	if (rv < 0)
> +		mddev->delta_disks = 0;
>  	return rv;
>  }
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 5044bab..2902454 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5527,8 +5527,8 @@ static int raid5_start_reshape(mddev_t *mddev)
>  		return -ENOSPC;
> 
>  	list_for_each_entry(rdev, &mddev->disks, same_set)
> -		if ((rdev->raid_disk < 0 || rdev->raid_disk >= conf-
> >raid_disks)
> -		     && !test_bit(Faulty, &rdev->flags))
> +		if (!test_bit(In_sync, &rdev->flags)
> +		    && !test_bit(Faulty, &rdev->flags))
>  			spares++;
> 
>  	if (spares - mddev->degraded < mddev->delta_disks - conf-
> >max_degraded)
> @@ -5571,7 +5571,7 @@ static int raid5_start_reshape(mddev_t *mddev)
>  	 * to correctly record the "partially reconstructed" state of
>  	 * such devices during the reshape and confusion could result.
>  	 */
> -	if (mddev->delta_disks >= 0)
> +	if (mddev->delta_disks >= 0) {
>  	    list_for_each_entry(rdev, &mddev->disks, same_set)
>  		if (rdev->raid_disk < 0 &&
>  		    !test_bit(Faulty, &rdev->flags)) {
> @@ -5586,8 +5586,7 @@ static int raid5_start_reshape(mddev_t *mddev)
>  				if (sysfs_create_link(&mddev->kobj,
>  						      &rdev->kobj, nm))
>  					/* Failure here is OK */;
> -			} else
> -				break;
> +			}
>  		} else if (rdev->raid_disk >= conf->previous_raid_disks
>  			   && !test_bit(Faulty, &rdev->flags)) {
>  			/* This is a spare that was manually added */
> @@ -5595,14 +5594,14 @@ static int raid5_start_reshape(mddev_t *mddev)
>  			added_devices++;
>  		}
> 
> -	/* When a reshape changes the number of devices, ->degraded
> -	 * is measured against the larger of the pre and post number of
> -	 * devices.*/
> -	if (mddev->delta_disks > 0) {
> -		spin_lock_irqsave(&conf->device_lock, flags);
> -		mddev->degraded += (conf->raid_disks - conf-
> >previous_raid_disks)
> -			- added_devices;
> -		spin_unlock_irqrestore(&conf->device_lock, flags);
> +	    /* When a reshape changes the number of devices,
> +	     * ->degraded is measured against the larger of the pre
> +	     * and post number of devices.
> +	     */
> +	    spin_lock_irqsave(&conf->device_lock, flags);
> +	    mddev->degraded += (conf->raid_disks - conf-
> >previous_raid_disks)
> +		    - added_devices;
> +	    spin_unlock_irqrestore(&conf->device_lock, flags);
>  	}
>  	mddev->raid_disks = conf->raid_disks;
>  	mddev->reshape_position = conf->reshape_progress;
