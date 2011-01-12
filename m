From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 02/13] imsm: FIX: allow for container reshape any unset
 size value
Date: Wed, 12 Jan 2011 21:43:36 +1100
Message-ID: <20110112214336.303679ac@notabene.brown>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
	<20110110112742.10776.5211.stgit@gklab-128-013.igk.intel.com>
	<20110112145253.63d55739@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D176E1A820@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176E1A820@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Wed, 12 Jan 2011 08:32:10 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:


> This issue can be addressed in the following way:
> 
> >From ce0a720c162c425ae46684ac7866f7076e65d5e5 Mon Sep 17 00:00:00 2001
> From: Adam Kwolek <adam.kwolek@intel.com>
> Date: Wed, 12 Jan 2011 09:23:53 +0100
> Subject: [PATCH] FIX: size is passed incorrectly
> 
> reshape_super() called from reshape_container() with size set to info->component_size
> gives size in reshape_super == -2 due to unsigned signed conversion
> (info->component_size is not initializes).
> 
> As size is not changed during container reshape '-1' value is passed to indicate this.

Excellent problem description that allows me to immediately see the that the
solution is obviously correct.
Thanks.  Applied and pushed out.

NeilBrown


> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>  Grow.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 4cbe427..466d546 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2120,7 +2120,7 @@ int reshape_container(char *container, int cfd, char *devname,
>  {
>  	struct mdinfo *cc = NULL;
>  
> -	if (reshape_super(st, info->component_size, info->new_level,
> +	if (reshape_super(st, -1, info->new_level,
>  			  info->new_layout, info->new_chunk,
>  			  info->array.raid_disks + info->delta_disks,
>  			  backup_file, devname, quiet))

