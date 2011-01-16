From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md/raid5: FIX: manually-added spare is not used
Date: Mon, 17 Jan 2011 10:11:28 +1100
Message-ID: <20110117101128.60a9b683@notabene.brown>
References: <20110114125537.15648.73873.stgit@gklab-128-013.igk.intel.com>
	<20110114130000.15648.52870.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110114130000.15648.52870.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Fri, 14 Jan 2011 14:00:00 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Manually added spares are not used due to fact that they not added to md configuration.
> Counters are updated only.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  drivers/md/raid5.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a2087c7..59c4150 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5592,8 +5592,10 @@ static int raid5_start_reshape(mddev_t *mddev)
>  		} else if (rdev->raid_disk >= conf->previous_raid_disks
>  			   && !test_bit(Faulty, &rdev->flags)) {
>  			/* This is a spare that was manually added */
> -			set_bit(In_sync, &rdev->flags);
> -			added_devices++;
> +			if (raid5_add_disk(mddev, rdev) == 0) {
> +				set_bit(In_sync, &rdev->flags);
> +				added_devices++;
> +			}
>  		}
>  
>  	/* When a reshape changes the number of devices, ->degraded

This should not be needed.
When a device is manually added, the desired slot number is written to  
   ..../md/dev-XXX/slot

This calls slot_store (in md.c) which call mddev->pers->hot_add_disk which
for raid5 is raid5_add_disk.
So you shouldn't need to call raid5_add_disk again.

NeilBrown
