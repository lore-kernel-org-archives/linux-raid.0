From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 7/9] imsm: FIX: monitor should initialize 2nd reshape
 only
Date: Wed, 12 Jan 2011 16:57:18 +1100
Message-ID: <20110112165718.7ffd5cdc@notabene.brown>
References: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
	<20110111140443.13862.80670.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111140443.13862.80670.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, 11 Jan 2011 15:04:43 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> in case configuration:
> 	raid5
> 	raid0
> first array is monitored only.
> During reshape of such container first array (raid5), in metadata
> migration is initialized for both arrays.
> This is imsm incompatible case.
> 
> Allow for 2nd array in metadata reshape initialization when there is more than 1 array monitored.

I'm sorry, but I cannot follow what you are saying here.

Maybe if you could explain what you see happening, and what should actually
happen instead.  At which stop in the process does something go wrong?

NeilBrown

> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 1db15c2..c465288 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5075,10 +5075,20 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
>  		*/
>  		struct active_array *aa = a->container->arrays;
>  		int arrays_under_reshape = 0;
> +		int array_counter = 0;
>  
>  		/* check if no other arrays is under reshape
>  		 */
>  		while (aa) {
> +			array_counter++;
> +			/* when we have takeovered array even single array
> +			 * can be initialized for reshape, if mdadm didn't
> +			 * do this.
> +			 * This is due to fact, that raid0 (takeovered to raid4)
> +			 * appears in monitor one by one
> +			 */
> +			if (aa->info.array.level == 4)
> +				array_counter++;
>  			if (aa->container) {
>  				int inst = aa->info.container_member;
>  				struct intel_super *super = aa->container->sb;
> @@ -5091,7 +5101,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
>  			}
>  			aa = aa->next;
>  		}
> -		if (arrays_under_reshape == 0) {
> +		if ((arrays_under_reshape == 0) && (array_counter > 1)) {
>  			struct imsm_map *map = get_imsm_map(dev, 0);
>  			struct dl *dl = NULL;
>  			int disks_count = 0;

