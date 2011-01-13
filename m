From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/6] FIX: Mistake in delta_disk comparison.
Date: Thu, 13 Jan 2011 13:48:34 +1100
Message-ID: <20110113134834.7de4dc59@notabene.brown>
References: <20110112155905.18013.73701.stgit@gklab-128-111.igk.intel.com>
	<20110112160124.18013.96944.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112160124.18013.96944.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Wed, 12 Jan 2011 17:01:24 +0100 Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:

> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
>  Grow.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index c06561f..253f289 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -963,7 +963,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
>  			return "RAID10 can only be changed to RAID0";
>  		new_disks = (info->array.raid_disks
>  			     / (info->array.layout & 0xff));
> -		if (info->delta_disks != UnSet) {
> +		if (info->delta_disks == UnSet) {
>  			info->delta_disks = (new_disks
>  					     - info->array.raid_disks);
>  		}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Applied, thanks.

NeilBrown

