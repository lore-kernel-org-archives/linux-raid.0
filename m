From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: array is reassembled inactive if stopped during
 resync
Date: Tue, 8 Feb 2011 11:46:38 +1100
Message-ID: <20110208114638.46bb9f56@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010EC8FB8B@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010EC8FB8B@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Thu, 3 Feb 2011 13:40:56 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> >From 085fade553c653f89c2b486b7ec552303a5fb9f1 Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska <anna.czarnowska@intel.com>
> Date: Thu, 3 Feb 2011 14:30:43 +0100
> Subject: [PATCH] fix: array is reassembled inactive if stopped during resync
> Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>
> 
> If initial resync or recovery of a redundant array is not finished
> before it is stopped then during assembly md will start it as inactive.
> Writing readonly to array_state in assemble_container_content
> fails because md thinks the array is during reshape.
> 
> In fact we only have a reshape if both current and previous map
> states are the same. Otherwise we may have resync or recovery.
> Setting reshape_active in such cases causes the issue.
> 
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>  super-intel.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index d049cb7..59356e0 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -1772,7 +1772,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
>  		__le32_to_cpu(map_to_analyse->blocks_per_member);
>  	memset(info->uuid, 0, sizeof(info->uuid));
>  	info->recovery_start = MaxSector;
> -	info->reshape_active = (prev_map != NULL);
> +	info->reshape_active = (prev_map != NULL) &&
> +			       (map->map_state == prev_map->map_state);
>  	if (info->reshape_active)
>  		info->delta_disks = map->num_members - prev_map->num_members;
>  	else


Applied, thanks.

NeilBrown
