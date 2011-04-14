From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] FIX: In Grow_restart() array parameters are wrongly
 used
Date: Thu, 14 Apr 2011 17:45:30 +1000
Message-ID: <20110414174530.4f3bba5a@notabene.brown>
References: <20110411133908.4917.6842.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110411133908.4917.6842.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Mon, 11 Apr 2011 15:39:08 +0200 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Problem can be obvious visible when to 3-disks raid5 array 2 disks are added.
> (added disks number + parity == old disks number)
> Mdadm generates floating point exception and core file is generated
> due to division by 0 (odata == 0).
> 
> During restart for external metadata, getinfo_super() returns
> in mdinfo->array.raid_disks old disks number, that has to be increased
> by delta_disks to receive new value. Function getinfo_super()
> cannot return raid_disks field in different way, as array starting
> geometry information. We are still going to final array geometry.
> This Grow_restart() should have in mind and calculate local variables
> in proper way.
> 
> This change makes Grow_restart() to interpret parameters in the same way
> as reshape_array() did during reshape start, and it will do it in the same
> way when it will be called from Continue_reshape().

sorry, but I don't like this change.
I never like having different handling for 'external' and 'non-external'.
Sometimes it is obviously necessary, but we should avoid it if possible.

Once reshape has started, 'raid_disks' is the new number of disks, not the
old number.

So sysfs_set_array should be changed to set raid_disks to
    raid_disk - delta_disks
in the first instance, then if reshape is active, to raid_disks.

And getinfo_super should return the 'new' number of disks.

And reshape_array might need to fiddle with raid_disks before calling 
analyse_change in the reshape_active case.

So it is more changes, but I think it is a better result.

Thanks,
NeilBrown

> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Grow.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index d4308bc..1fdee7e 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3102,13 +3102,17 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
>  	unsigned long long  nstripe, ostripe;
>  	int ndata, odata;
>  
> -	odata = info->array.raid_disks - info->delta_disks - 1;
> +	if (st->ss->external) {
> +		old_disks = info->array.raid_disks;
> +		ndata = info->array.raid_disks + info->delta_disks - 1;
> +	} else {
> +		old_disks = info->array.raid_disks - info->delta_disks;
> +		ndata = info->array.raid_disks - 1;
> +	}
> +	odata = old_disks - 1;
>  	if (info->array.level == 6) odata--; /* number of data disks */
> -	ndata = info->array.raid_disks - 1;
>  	if (info->new_level == 6) ndata--;
>  
> -	old_disks = info->array.raid_disks - info->delta_disks;
> -
>  	if (info->delta_disks <= 0)
>  		/* Didn't grow, so the backup file must have
>  		 * been used

