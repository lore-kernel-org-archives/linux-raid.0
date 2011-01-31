From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: Update metadata for second array
Date: Mon, 31 Jan 2011 11:04:53 +1100
Message-ID: <20110131110453.7447d9d6@notabene.brown>
References: <20110128082141.7609.85545.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110128082141.7609.85545.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Fri, 28 Jan 2011 09:21:41 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When second array reshape is about to start external metadata should be updated
> by mdmon in imsm_set_array_state().
> for this purposes imsm_progress_container_reshape() is reused.
> 
> In imsm_progress_container_reshape() we have to make sure that prev_disks
> shows expanded disks number. Current decision about prev_disks in 'for'
> loop doesn't make us sure about this. We are getting first positive value,
> but not necessarily right one.

When is the first value not the right one?

What is wrong with the following logic?

 - initially there are 2 arrays in the container, each containing N disks.
 - We start a reshape to M disks (M > N).
    So now dev[0]->map[0]->num_members == M
       and dev[1]->map[0]->num_members == N

 - When the reshape completes we call imsm_progress_container_reshape.
   It looks at dev[0], sees that num_members is M and stores that in
   prev_disks
 - Then it loops around, looks at dev[1];.  num_members < prev_disks
   so it starts migration for dev[1].

Why does it not work like that?


> 
> prev_disks have to be found before we enter 'for' loop.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |   15 ++++++++++++++-
>  1 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index d5501bd..4ae4764 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5062,6 +5062,15 @@ static void imsm_progress_container_reshape(struct intel_super *super)
>  	int prev_disks = -1;
>  	int i;
>  
> +	/* find maximum number of disks used in any array
> +	 */
> +	for (i = 0; i < mpb->num_raid_devs; i++) {
> +		struct imsm_dev *dev = get_imsm_dev(super, i);
> +		struct imsm_map *map = get_imsm_map(dev, 0);
> +		if (map->num_members > prev_disks)
> +			prev_disks = map->num_members;
> +	}
> +
>  	for (i = 0; i < mpb->num_raid_devs; i++) {
>  		struct imsm_dev *dev = get_imsm_dev(super, i);
>  		struct imsm_map *map = get_imsm_map(dev, 0);
> @@ -5253,13 +5262,17 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
>  		super->updates_pending++;
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
>  			imsm_set_disk(a, mdi->disk.raid_disk, mdi->curr_state);
> +
> +		/* check next volume reshape */
> +		imsm_progress_container_reshape(super);

It also isn't clear why you need to call imsm_progress_container_reshape here.
It is already called earlier in the place where the first array has
vol.migr_state cleared.

Why is that call not sufficient?

NeilBrown




>  	}
>  
>  	return consistent;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

