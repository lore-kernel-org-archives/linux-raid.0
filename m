From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/9] imsm: FIX: Do not clean checkpoint for active
 reshape
Date: Thu, 10 Mar 2011 11:33:40 +1100
Message-ID: <20110310113340.5ab9057e@notabene.brown>
References: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
	<20110309134602.8939.42234.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110309134602.8939.42234.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 09 Mar 2011 14:46:02 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Smaller checkpoint can be stored when metadata is not in migration state
> (this means when there is no second map).
> Without this additional condition it can occur that during array start/stop
> sequence checkpoint was roll back to 0.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index cd409e9..4e3de8a 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5335,9 +5335,15 @@ mark_checkpoint:
>  		 */
>  		if (units32 == units &&
>  		    __le32_to_cpu(dev->vol.curr_migr_unit) != units32) {
> -			dprintf("imsm: mark checkpoint (%u)\n", units32);
> -			dev->vol.curr_migr_unit = __cpu_to_le32(units32);
> -			super->updates_pending++;
> +			struct imsm_map *map2 = get_imsm_map(dev, 1);
> +			if ((__le32_to_cpu(dev->vol.curr_migr_unit) < units32)
> +			    || (map2 == NULL)) {
> +				dprintf("imsm: mark checkpoint (%u)\n",
> +					units32);
> +				dev->vol.curr_migr_unit =
> +					__cpu_to_le32(units32);
> +				super->updates_pending++;
> +			}
>  		}
>  	}
>  
> 

Not applied.

I don't really understand the change you are making here.

As it seems to me that:
  - before the patch, we only update the 'curr_migr_unit' when
    units32 is different
  - after the patch, we only update it if units32 is bigger, or if
    map2==NULL (meaning this isn't a migration?).

So when would units32 be smaller??  What is the important case that this
fixes?

From the comment, it seems to be to avoid 'roll back to 0'.   I don't see
how it does that, and I don't see why that is a problem.

If some reshape has happened but curr_migr_unit is 0, that just means
that we need to replay the backed-up data and set curr_migr_unit
accordingly (or reflect that the backed-up data has been migrated).
So after Grow_restart has run, curr_migr_unit should never be zero.
You will need to get update_super_imsm to understand '_reshape_progress'
for this to work properly.

NeilBrown

