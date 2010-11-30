From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 32/53] imsm: FIX: spare list contains one device several
 times
Date: Tue, 30 Nov 2010 13:17:25 +1100
Message-ID: <20101130131725.61bda6ce@notabene.brown>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
	<20101126080801.5221.57631.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126080801.5221.57631.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 26 Nov 2010 09:08:01 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Assumption for spares searching was that after picking new device, it has to be added to array before next search.
> This causes returning different disk on each call.
> 
> When spares list is created during Online Capacity Expansion, first devices list is collected and then all devices are added to md.
> Picked device from spares pool has to be checked against picked devices so far. If not, the same disk will be returned all the time.
> Already picked devices are stored in the list and this list is used for new devices verification also.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

I have applied this without the change in imsm_grow_array, because I haven't
yet accepted the patch which adds that function.
So when we do add imsm_grow_array, imsm_add_spare will be read for it.

Also the two conversions from dprintf to fprintf didn't apply to my current
tree so I dropped them.  I mention it only because this is a perfect example
of when I might be appropriate to include those extra changes in this patch,
but it would have been nice to see it mentioned in the description:

  Two dprintf calls change to fprintf because .....


Thanks,
NeilBrown


> ---
> 
>  super-intel.c |   24 +++++++++++++++++-------
>  1 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 3f75550..e4ba875 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5006,7 +5006,8 @@ static struct dl *imsm_readd(struct intel_super *super, int idx, struct active_a
>  }
>  
>  static struct dl *imsm_add_spare(struct intel_super *super, int slot,
> -				 struct active_array *a, int activate_new)
> +				 struct active_array *a, int activate_new,
> +				 struct mdinfo *additional_test_list)
>  {
>  	struct imsm_dev *dev = get_imsm_dev(super, a->info.container_member);
>  	int idx = get_imsm_disk_idx(dev, slot);
> @@ -5032,6 +5033,16 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
>  			}
>  		if (d)
>  			continue;
> +		while (additional_test_list) {
> +			if (additional_test_list->disk.major == dl->major &&
> +			    additional_test_list->disk.minor == dl->minor) {
> +				dprintf("%x:%x already in additional test list\n", dl->major, dl->minor);
> +				break;
> +			}
> +			additional_test_list = additional_test_list->next;
> +		}
> +		if (additional_test_list)
> +			continue;
>  
>  		/* skip in use or failed drives */
>  		if (is_failed(&dl->disk) || idx == dl->index ||
> @@ -5165,9 +5176,9 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
>  		 */
>  		dl = imsm_readd(super, i, a);
>  		if (!dl)
> -			dl = imsm_add_spare(super, i, a, 0);
> +			dl = imsm_add_spare(super, i, a, 0, NULL);
>  		if (!dl)
> -			dl = imsm_add_spare(super, i, a, 1);
> +			dl = imsm_add_spare(super, i, a, 1, NULL);
>  		if (!dl)
>  			continue;
>   
> @@ -6422,11 +6433,11 @@ struct mdinfo *get_spares_imsm(int devnum)
>  	sprintf(buf, "/dev/md/%s", info->name);
>  	ret_val = sysfs_get_unused_spares(cont_id, fd);
>  	if (ret_val == NULL) {
> -		dprintf("imsm: ERROR: Cannot get spare devices.\n");
> +		fprintf(stderr, Name": imsm: ERROR: Cannot get spare devices.\n");
>  		goto abort;
>  	}
>  	if (ret_val->array.spare_disks == 0) {
> -		dprintf("imsm: ERROR: No available spares.\n");
> +		fprintf(stderr, Name": imsm: ERROR: No available spares.\n");
>  		free(ret_val);
>  		ret_val = NULL;
>  		goto abort;
> @@ -7013,10 +7024,9 @@ struct mdinfo *imsm_grow_array(struct active_array *a)
>  	for (i = prev_raid_disks; i < new_raid_disks; i++) {
>  		/* OK, this device can be added.  Try to add.
>  		 */
> -		dl = imsm_add_spare(super, i, a, 0);
> +		dl = imsm_add_spare(super, i, a, 0, rv);
>  		if (!dl)
>  			continue;
> -
>  		if (dl->index < 0)
>  			dl->index = i;
>  		/* found a usable disk with enough space */

