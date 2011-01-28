From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/7] imsm: Update metadata for second array
Date: Fri, 28 Jan 2011 10:24:59 +1000
Message-ID: <20110128102459.6e3a3439@nbeee.brown>
References: <20110126145632.20454.20432.stgit@gklab-128-013.igk.intel.com>
	<20110126150317.20454.62750.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110126150317.20454.62750.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 26 Jan 2011 16:03:17 +0100
Adam Kwolek <adam.kwolek@intel.com> wrote:

> When second array reshape is about to start external metadata should
> be updated by mdmon in imsm_set_array_state().
> for this purposes imsm_progress_container_reshape() is reused.

We seem to be failing to communicate...

I told you that you didn't need extra arguments to
imsm_progress_container_reshape because IT ALREADY DOES THE RIGHT THING.
It finds the array that needs to be reshaped next, and it starts the
reshape.

You removed the extra arguments from your previous patch, but put extra
code in imsm_progress_container_reshape to to what it ALREADY DOES.

Have you read and understood the code?

If something isn't working the way you expect, please detail exactly
what.
It is quite possible that the code isn't quite right, but trying to
change it when you don't appear to understand it isn't going to
achieve anything useful.

NeilBrown


> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |   49
> ++++++++++++++++++++++++++++++++++++++++++++++++- 1 files changed, 48
> insertions(+), 1 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 8d1f0ad..4e96196 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5052,6 +5052,46 @@ static void
> imsm_progress_container_reshape(struct intel_super *super) struct
> imsm_super *mpb = super->anchor; int prev_disks = -1;
>  	int i;
> +	int any_migration_in_progress = 0;
> +	int disks_count_max = 0;
> +	struct imsm_dev *dev_next = NULL;
> +
> +	/* find maximum number of disks used in any array
> +	 * and check if any migration is in progress
> +	*/
> +	for (i = 0; i < mpb->num_raid_devs; i++) {
> +		struct imsm_dev *dev = get_imsm_dev(super, i);
> +		struct imsm_map *map = get_imsm_map(dev, 0);
> +		struct imsm_map *migr_map = get_imsm_map(dev, 1);
> +		if (migr_map)
> +			any_migration_in_progress = 1;
> +		if (map->num_members > disks_count_max)
> +			disks_count_max = map->num_members;
> +	}
> +
> +	if (any_migration_in_progress == 0) {
> +		/* no migration in progress
> +		 * so we can check if next migration in container
> +		 * should be started
> +		 */
> +		int next_inst = -1;
> +
> +		for (i = 0; i < mpb->num_raid_devs; i++) {
> +			struct imsm_dev *dev = get_imsm_dev(super,
> i);
> +			struct imsm_map *map = get_imsm_map(dev, 0);
> +			if (map->num_members < disks_count_max) {
> +				next_inst = i;
> +				break;
> +			}
> +		}
> +		if (next_inst >= 0) {
> +			/* found array with smaller number of disks
> in array,
> +			 * this array should be expanded
> +			 */
> +			dev_next = get_imsm_dev(super, next_inst);
> +			prev_disks = disks_count_max;
> +		}
> +	}
>  
>  	for (i = 0; i < mpb->num_raid_devs; i++) {
>  		struct imsm_dev *dev = get_imsm_dev(super, i);
> @@ -5063,6 +5103,9 @@ static void
> imsm_progress_container_reshape(struct intel_super *super) if
> (dev->vol.migr_state) return;
>  
> +		if ((dev_next != NULL) && (dev_next != dev))
> +			continue;
> +
>  		if (prev_disks == -1)
>  			prev_disks = map->num_members;
>  		if (prev_disks == map->num_members)
> @@ -5244,13 +5287,17 @@ static int imsm_set_array_state(struct
> active_array *a, int consistent) super->updates_pending++;
>  	}
>  
> -	/* finalize online capacity expansion/reshape */
> +	/* manage online capacity expansion/reshape */
>  	if ((a->curr_action != reshape) &&
>  	    (a->prev_action == reshape)) {
>  		struct mdinfo *mdi;
>  
> +		/* finalize online capacity expansion/reshape */
>  		for (mdi = a->info.devs; mdi; mdi = mdi->next)
>  			imsm_set_disk(a, mdi->disk.raid_disk,
> mdi->curr_state); +
> +		/* check next volume reshape */
> +		imsm_progress_container_reshape(super);
>  	}
>  
>  	return consistent;

