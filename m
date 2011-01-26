From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/4] imsm: Update metadata for second array
Date: Wed, 26 Jan 2011 15:33:39 +1000
Message-ID: <20110126153339.15ee9d2b@nbeee.brown>
References: <20110120104759.22926.66874.stgit@gklab-128-013.igk.intel.com>
	<20110120105722.22926.92369.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110120105722.22926.92369.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Thu, 20 Jan 2011 11:57:22 +0100
Adam Kwolek <adam.kwolek@intel.com> wrote:

> When second array reshape is about to start external metadata should
> be updated by mdmon in imsm_set_array_state().
> for this purposes imsm_progress_container_reshape() is reused.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |   50
> ++++++++++++++++++++++++++++++++++++++++++++++---- 1 files changed,
> 46 insertions(+), 4 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index d86e8d8..7f907ef 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -4863,7 +4863,9 @@ static void handle_missing(struct intel_super
> *super, struct imsm_dev *dev) 
>  static void imsm_set_disk(struct active_array *a, int n, int state);
>  
> -static void imsm_progress_container_reshape(struct intel_super
> *super) +static void imsm_progress_container_reshape(struct
> intel_super *super,
> +					    struct imsm_dev *dev_in,
> +					    int disk_count)
>  {


imsm_progress_container_reshape does not need to be passed a dev and a
count.

It finds the first devices that has a different number of disks than
the previous device, and changes it to have the same number.  
If there is some reason that this is not sufficient, please be more 
explicit.

Thanks,
NeilBrown



>  	/* if no device has a migr_state, but some
device has a
>  	 * different number of members than the previous device,
> start @@ -4871,7 +4873,7 @@ static void
> imsm_progress_container_reshape(struct intel_super *super)
>  	 * previous.
>  	 */
>  	struct imsm_super *mpb = super->anchor;
> -	int prev_disks = -1;
> +	int prev_disks = disk_count;
>  	int i;
>  
>  	for (i = 0; i < mpb->num_raid_devs; i++) {
> @@ -4884,6 +4886,10 @@ static void
> imsm_progress_container_reshape(struct intel_super *super) if
> (dev->vol.migr_state) return;
>  
> +		if (((dev_in != NULL) && disk_count > 0) &&
> +		     (dev_in != dev))
> +			continue;
> +
>  		if (prev_disks == -1)
>  			prev_disks = map->num_members;
>  		if (prev_disks == map->num_members)
> @@ -4999,7 +5005,9 @@ static int imsm_set_array_state(struct
> active_array *a, int consistent)
>  						       * array size
>  						       */
>  				super->updates_pending++;
> -
> imsm_progress_container_reshape(super);
> +
> imsm_progress_container_reshape(super,
> +								NULL,
> +								-1);
>  			}				
>  		}
>  	}
> @@ -5065,13 +5073,47 @@ static int imsm_set_array_state(struct
> active_array *a, int consistent) super->updates_pending++;
>  	}
>  
> -	/* finalize online capacity expansion/reshape */
>  	if ((a->curr_action != reshape) &&
>  	    (a->prev_action == reshape)) {
>  		struct mdinfo *mdi;
> +		struct imsm_dev *dev_next;
> +		int next_inst;
>  
> +
> +		/* finalize online capacity expansion/reshape */
>  		for (mdi = a->info.devs; mdi; mdi = mdi->next)
>  			imsm_set_disk(a, mdi->disk.raid_disk,
> mdi->curr_state); +
> +		/* check next volume reshape
> +		 * 2 volumes support only
> +		 * for more volumes supported next_inst should be
> found
> +		 * in another way
> +		 */
> +		next_inst = inst ? 0 : 1;
> +		dev_next = get_imsm_dev(super, next_inst);
> +		if (dev_next && dev_next->vol.migr_state == 0) {
> +			/* check here if this is container action
> +			* and next metadata should be prepared
> +			*/
> +			struct imsm_map *map_next =
> get_imsm_map(dev_next, 0);
> +			struct dl *dl = NULL;
> +			int disks_count = 0;
> +
> +			/* check if this array should be reshaped
> +			*/
> +			for (dl = super->disks; dl; dl = dl->next)
> +				if (dl->index >= 0)
> +					disks_count++;
> +
> +			if (disks_count > map_next->num_members) {
> +				/* manage changes in volume
> +				*/
> +
> imsm_progress_container_reshape(super,
> +							dev_next,
> +							disks_count);
> +				super->updates_pending++;
> +			}
> +		}
>  	}
>  
>  	return consistent;

