From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 5/9] imsm: Update metadata for second array
Date: Wed, 12 Jan 2011 16:48:34 +1100
Message-ID: <20110112164834.2de9f413@notabene.brown>
References: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
	<20110111140427.13862.29204.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111140427.13862.29204.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, 11 Jan 2011 15:04:27 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When second array reshape is about to start metadata should be updated
> by mdmon in imsm_set_array_state().
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 77 insertions(+), 0 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 321dc47..1db15c2 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5069,6 +5069,83 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
>  
>  		for (mdi = a->info.devs; mdi; mdi = mdi->next)
>  			imsm_set_disk(a, mdi->disk.raid_disk, mdi->curr_state);
> +	} else if (dev->vol.migr_state == 0) {
> +		/* check here if this is container action
> +		 * and next metadata should be prepared
> +		*/
> +		struct active_array *aa = a->container->arrays;
> +		int arrays_under_reshape = 0;
> +
> +		/* check if no other arrays is under reshape
> +		 */
> +		while (aa) {
> +			if (aa->container) {
> +				int inst = aa->info.container_member;
> +				struct intel_super *super = aa->container->sb;
> +				struct imsm_dev *dev =
> +						get_imsm_dev(super, inst);
> +				struct imsm_map *map2 = get_imsm_map(dev, 1);
> +
> +				if (map2)
> +					arrays_under_reshape++;
> +			}
> +			aa = aa->next;
> +		}
> +		if (arrays_under_reshape == 0) {
> +			struct imsm_map *map = get_imsm_map(dev, 0);
> +			struct dl *dl = NULL;
> +			int disks_count = 0;
> +
> +			/* check if this array should be reshaped
> +			*/
> +			for (dl = super->disks; dl; dl = dl->next)
> +				if (dl->index >= 0)
> +					disks_count++;
> +			if (disks_count > map->num_members) {
> +				/* manage changes in volume
> +				 */
> +				struct imsm_map *map, *map2;
> +				int prev_num_members;
> +				int used_disks;
> +				int i;
> +
> +				map = get_imsm_map(dev, 0);
> +				prev_num_members = map->num_members;
> +				map->num_members = disks_count;
> +				dev->vol.migr_state = 1;
> +				dev->vol.curr_migr_unit = 0;
> +				dev->vol.migr_type = MIGR_GEN_MIGR;
> +				for (i = prev_num_members;
> +					i < map->num_members; i++)
> +					set_imsm_ord_tbl_ent(map, i, i);
> +				map2 = get_imsm_map(dev, 1);
> +				/* Copy the current map */
> +				memcpy(map2, map, sizeof_imsm_map(map));
> +				map2->num_members = prev_num_members;
> +
> +				/* calculate new size
> +				 */
> +				used_disks = imsm_num_data_members(dev, 0);
> +				if (used_disks) {
> +					unsigned long long array_blocks;
> +
> +					array_blocks =
> +						map->blocks_per_member
> +						* used_disks;
> +					/* round array size down to closest MB
> +					 */
> +					array_blocks = (array_blocks
> +							>> SECT_PER_MB_SHIFT)
> +							<< SECT_PER_MB_SHIFT;
> +					dev->size_low =
> +					     __cpu_to_le32((__u32)array_blocks);
> +					dev->size_high =
> +						__cpu_to_le32(
> +						(__u32)(array_blocks >> 32));
> +				}
> +				super->updates_pending++;
> +			}
> +		}
>  	}
>  
>  	return consistent;


Most of this code is identical to  imsm_progress_container_reshape.
Maybe you just want to put another call to that function in somewhere.

NeilBrown

