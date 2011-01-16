From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] md/raid5: FIX: reshape on degraded devices has
 wrong configuration
Date: Mon, 17 Jan 2011 10:30:00 +1100
Message-ID: <20110117103000.09a21d28@notabene.brown>
References: <20110114125537.15648.73873.stgit@gklab-128-013.igk.intel.com>
	<20110114130007.15648.48487.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110114130007.15648.48487.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Fri, 14 Jan 2011 14:00:08 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When we performing expansion on degraded array (takeovered raid0),
> and we are adding i.e. 2 disks, one disk is added only.
> 
> this is due to fact that parity (missing) disk is moved to the end
> and added disk index is smaller than starting disk number in array.
> 
> To resolve this situation array degradation should be used for adding
> disk(s) on reshape start.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  drivers/md/raid5.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 59c4150..3b9da76 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5528,7 +5528,8 @@ static int raid5_start_reshape(mddev_t *mddev)
>  		return -ENOSPC;
>  
>  	list_for_each_entry(rdev, &mddev->disks, same_set)
> -		if ((rdev->raid_disk < 0 || rdev->raid_disk >= conf->raid_disks)
> +		if ((rdev->raid_disk < 0 ||
> +		     rdev->raid_disk >= (conf->raid_disks - mddev->degraded))
>  		     && !test_bit(Faulty, &rdev->flags))
>  			spares++;
>  
> @@ -5589,7 +5590,8 @@ static int raid5_start_reshape(mddev_t *mddev)
>  					/* Failure here is OK */;
>  			} else
>  				break;
> -		} else if (rdev->raid_disk >= conf->previous_raid_disks
> +		} else if (rdev->raid_disk >= (conf->previous_raid_disks
> +						- mddev->degraded)
>  			   && !test_bit(Faulty, &rdev->flags)) {
>  			/* This is a spare that was manually added */
>  			if (raid5_add_disk(mddev, rdev) == 0) {

I see the problem you are trying to fix, but I think the fix is wrong.
The range check is correct, but the test for Faulty isn't quite right.
I think we need to check for In_sync and not Faulty, or something like that.
I work something out.

Thanks,
NeilBrown

