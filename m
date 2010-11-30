From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 30/53] imsm: FIX: Fill sys_name field in getinfo_super()
Date: Tue, 30 Nov 2010 13:06:04 +1100
Message-ID: <20101130130604.2dcabe4d@notabene.brown>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
	<20101126080746.5221.40610.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126080746.5221.40610.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 26 Nov 2010 09:07:46 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> sys_name field is not filled during getinfo_super() call.

No metadata ever sets sys_name.  I agree this can be confusing, but it is the
sort of thing that needs to be tidied up across-the-board, just piecemeal
like this.

What was your particular need for setting sys_name?

thanks,
NeilBrown


> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 42219f6..3243132 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -1489,6 +1489,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
>  	struct imsm_map *map = get_imsm_map(dev, 0);
>  	struct dl *dl;
>  	char *devname;
> +	int minor;
>  
>  	for (dl = super->disks; dl; dl = dl->next)
>  		if (dl->raiddisk == info->disk.raid_disk)
> @@ -1560,6 +1561,11 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
>  	free(devname);
>  	info->safe_mode_delay = 4000;  /* 4 secs like the Matrix driver */
>  	uuid_from_super_imsm(st, info->uuid);
> +
> +	/* fill sys_name field
> +	 */
> +	if (find_array_minor2(info->text_version, 1, st->devnum, &minor) == 0)
> +		sprintf(info->sys_name, "md%i", minor);
>  }
>  
>  /* check the config file to see if we can return a real uuid for this spare */
> @@ -1611,6 +1617,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
>  {
>  	struct intel_super *super = st->sb;
>  	struct imsm_disk *disk;
> +	int minor;
>  
>  	if (super->current_vol >= 0) {
>  		getinfo_super_imsm_volume(st, info);
> @@ -1712,6 +1719,10 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
>  		memcpy(info->uuid, uuid_match_any, sizeof(int[4]));
>  		fixup_container_spare_uuid(info);
>  	}
> +	/* fill sys_name field
> +	 */
> +	if (find_array_minor2(info->text_version, 1, st->devnum, &minor) == 0)
> +		sprintf(info->sys_name, "md%i", minor);
>  }
>  
>  static int is_raid_level_supported(const struct imsm_orom *orom, int level, int raiddisks);

