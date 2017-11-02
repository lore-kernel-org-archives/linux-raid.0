From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: Re: [md PATCH 2/2] md: be cautious about using
 ->curr_resync_completed for ->recovery_offset
Date: Thu, 2 Nov 2017 09:40:50 +0100
Message-ID: <20171102084050.GA21840@proton.igk.intel.com>
References: <150821741376.9754.10397416458024667409.stgit@noble>
 <150821751632.9754.9103449859789225425.stgit@noble>
 <20171031144231.GA16181@proton.igk.intel.com>
 <87375yx0lp.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87375yx0lp.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 01, 2017 at 12:13:22PM +1100, NeilBrown wrote:
> On Tue, Oct 31 2017, Tomasz Majchrzak wrote:
> 
> > On Tue, Oct 17, 2017 at 04:18:36PM +1100, NeilBrown wrote:
> >> The ->recovery_offset shows how much of a non-InSync device is actually
> >> in sync - how much has been recoveryed.
> >> 
> >> When performing a recovery, ->curr_resync and ->curr_resync_completed
> >> follow the device address being recovered and so can be used to update
> >> ->recovery_offset.
> >> 
> >> When performing a reshape, ->curr_resync* might follow the device
> >> addresses (raid5) or might follow array addresses (raid10), so cannot
> >> in general be used to set ->recovery_offset.  When reshaping backwards,
> >> ->curre_resync* measures from the *end* of the array-or-device, so is
> >> particularly unhelpful.
> >> 
> >> So change the common code in md.c to only use ->curr_resync_complete
> >> for the simple recovery case, and add code to raid5.c to update
> >> ->recovery_offset during a forwards reshape.
> >> 
> >> Signed-off-by: NeilBrown <neilb@suse.com>
> >> ---
> >>  drivers/md/md.c    |   32 +++++++++++++++++++++-----------
> >>  drivers/md/raid5.c |   18 ++++++++++++++++++
> >>  2 files changed, 39 insertions(+), 11 deletions(-)
> >> 
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index a9f1352b3849..d1dfc9879368 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -2453,10 +2453,17 @@ void md_update_sb(struct mddev *mddev, int force_change)
> >>  		}
> >>  	}
> >>  
> >> -	/* First make sure individual recovery_offsets are correct */
> >> +	/* First make sure individual recovery_offsets are correct
> >> +	 * curr_resync_completed can only be used during recovery.
> >> +	 * During reshape/resync it might use array-addresses rather
> >> +	 * that device addresses.
> >> +	 */
> >>  	rdev_for_each(rdev, mddev) {
> >>  		if (rdev->raid_disk >= 0 &&
> >>  		    mddev->delta_disks >= 0 &&
> >> +		    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
> >> +		    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
> >> +		    !test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> >>  		    !test_bit(Journal, &rdev->flags) &&
> >>  		    !test_bit(In_sync, &rdev->flags) &&
> >>  		    mddev->curr_resync_completed > rdev->recovery_offset)
> >> @@ -8507,16 +8514,19 @@ void md_do_sync(struct md_thread *thread)
> >>  		} else {
> >>  			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
> >>  				mddev->curr_resync = MaxSector;
> >> -			rcu_read_lock();
> >> -			rdev_for_each_rcu(rdev, mddev)
> >> -				if (rdev->raid_disk >= 0 &&
> >> -				    mddev->delta_disks >= 0 &&
> >> -				    !test_bit(Journal, &rdev->flags) &&
> >> -				    !test_bit(Faulty, &rdev->flags) &&
> >> -				    !test_bit(In_sync, &rdev->flags) &&
> >> -				    rdev->recovery_offset < mddev->curr_resync)
> >> -					rdev->recovery_offset = mddev->curr_resync;
> >> -			rcu_read_unlock();
> >> +			if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> >> +			    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
> >> +				rcu_read_lock();
> >> +				rdev_for_each_rcu(rdev, mddev)
> >> +					if (rdev->raid_disk >= 0 &&
> >> +					    mddev->delta_disks >= 0 &&
> >> +					    !test_bit(Journal, &rdev->flags) &&
> >> +					    !test_bit(Faulty, &rdev->flags) &&
> >> +					    !test_bit(In_sync, &rdev->flags) &&
> >> +					    rdev->recovery_offset < mddev->curr_resync)
> >> +						rdev->recovery_offset = mddev->curr_resync;
> >> +				rcu_read_unlock();
> >> +			}
> >>  		}
> >>  	}
> >>   skip:
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index a8df52130f8a..89ad79614309 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -5739,6 +5739,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
> >>  	 */
> >>  	struct r5conf *conf = mddev->private;
> >>  	struct stripe_head *sh;
> >> +	struct md_rdev *rdev;
> >>  	sector_t first_sector, last_sector;
> >>  	int raid_disks = conf->previous_raid_disks;
> >>  	int data_disks = raid_disks - conf->max_degraded;
> >> @@ -5861,6 +5862,15 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
> >>  			return 0;
> >>  		mddev->reshape_position = conf->reshape_progress;
> >>  		mddev->curr_resync_completed = sector_nr;
> >> +		if (!mddev->reshape_backwards)
> >> +			/* Can update recovery_offset */
> >> +			rdev_for_each(rdev, mddev)
> >> +				if (rdev->raid_disk >= 0 &&
> >> +				    !test_bit(Journal, &rdev->flags) &&
> >> +				    !test_bit(In_sync, &rdev->flags) &&
> >> +				    rdev->recovery_offset < sector_nr)
> >> +					rdev->recovery_offset = sector_nr;
> >> +
> >>  		conf->reshape_checkpoint = jiffies;
> >>  		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> >>  		md_wakeup_thread(mddev->thread);
> >> @@ -5959,6 +5969,14 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
> >>  			goto ret;
> >>  		mddev->reshape_position = conf->reshape_progress;
> >>  		mddev->curr_resync_completed = sector_nr;
> >> +		if (!mddev->reshape_backwards)
> >> +			/* Can update recovery_offset */
> >> +			rdev_for_each(rdev, mddev)
> >> +				if (rdev->raid_disk >= 0 &&
> >> +				    !test_bit(Journal, &rdev->flags) &&
> >> +				    !test_bit(In_sync, &rdev->flags) &&
> >> +				    rdev->recovery_offset < sector_nr)
> >> +					rdev->recovery_offset = sector_nr;
> >>  		conf->reshape_checkpoint = jiffies;
> >>  		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> >>  		md_wakeup_thread(mddev->thread);
> >> 
> >> 
> >> --
> >
> > Hi,
> >
> > This patch has caused a regression in following IMSM RAID scenario:
> 
> That's unfortunate.
> 
> >
> > mdadm --create /dev/md/imsm0 --metadata=imsm --raid-devices=4 /dev/nvme[0-3]n1 --run
> > mdadm --create /dev/md/r10 --level=10 --size=100M --raid-devices=4 /dev/nvme[0-3]n1 --run --assume-clean
> >
> > MDADM_EXPERIMENTAL=1 mdadm --grow /dev/md/r10 --level=0
> > MDADM_EXPERIMENTAL=1 mdadm --grow /dev/md/imsm0 --raid-devices=4
> >
> > cat /proc/mdstat 
> > Personalities : [raid10] [raid0] [raid6] [raid5] [raid4] 
> > md126 : active raid4 nvme0n1[3] nvme2n1[2] nvme1n1[1]
> >       409600 blocks super external:/md127/0 level 4, 128k chunk, algorithm 0 [5/3] [UU_U_]
> >       
> > md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
> >       4420 blocks super external:imsm
> 
> Why isn't nvme3n1 in md126?  Did it not get added, or did it get removed
> for some reason?
> If it wasn't added, raid5_start_reshape() would have failed, so I guess
> it must have been removed??

It got removed. It's in the array during the reshape:

cat /proc/mdstat 
Personalities : [raid10] [raid0] [raid6] [raid5] [raid4] [raid1] 
md126 : active raid4 nvme3n1[4] nvme0n1[3] nvme2n1[2] nvme1n1[1]
      4194304 blocks super external:-md127/0 level 4, 128k chunk, algorithm 5 [5/4] [UU_U_]
      [===>.................]  reshape = 16.6% (350476/2097152) finish=0.1min speed=175238K/sec
      
md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
      4420 blocks super external:imsm

> 
> >
> > The array should have been reshaped to 4-disk RAID0 but it has failed in
> > the middle of reshape as RAID4.
> >
> > Following condition is not true for above scenario:
> >
> >> +			if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> >> +			    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
> 
> No, it isn't meant to be.  This code doesn't work reliably in the
> reshape case. When reshaping raid5 (or raid4), reshape_request updates
> rdev->recovery_offset. ... maybe end_reshape needs to update it too.
> 
> If you add this patch, does it help?
>
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 89ad79614309..a99ae1be9175 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7964,6 +7964,7 @@ static void end_reshape(struct r5conf *conf)
>  {
>  
>  	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
> +		struct md_rdev *rdev;
>  
>  		spin_lock_irq(&conf->device_lock);
>  		conf->previous_raid_disks = conf->raid_disks;
> @@ -7971,6 +7972,12 @@ static void end_reshape(struct r5conf *conf)
>  		smp_wmb();
>  		conf->reshape_progress = MaxSector;
>  		conf->mddev->reshape_position = MaxSector;
> +		rdev_for_each(rdev, conf->mddev)
> +			if (rdev->raid_disk >= 0 &&
> +			    !test_bit(Journal, &rdev->flags) &&
> +			    !test_bit(In_sync, &rdev->flags))
> +				rdev->recovery_offset = MaxSector;
> +
>  		spin_unlock_irq(&conf->device_lock);
>  		wake_up(&conf->wait_for_overlap);
>  

Yes, this patch fixes the problem. I have also checked that reshape position
is really stored and reshape interrupted in the middle restarts from the
last checkpoint.

Thank you,

Tomek
