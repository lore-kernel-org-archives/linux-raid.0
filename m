From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/6] Set delta_disks for raid10 -> raid0 takeover
Date: Thu, 13 Jan 2011 13:48:20 +1100
Message-ID: <20110113134820.0b6b0a63@notabene.brown>
References: <20110112155905.18013.73701.stgit@gklab-128-111.igk.intel.com>
	<20110112160115.18013.26281.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112160115.18013.26281.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Wed, 12 Jan 2011 17:01:15 +0100 Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:

> remove_disks_on_raid10_to_raid0_takeover function has been
> changed to return number of removed disks.
> Returned value is used to set info.delta_disks to proper value.
> Part of code used to set delta_disks for case when raid_disks
> is not zero has been moved above remove_disks_on_raid10_to_raid0_takeover
> function to avoid overwrite delta_disks variable.
> 
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>

I'm not really sure what this is trying to do, but it is doing it wrongly.

delta_disks should be the number to reduce 'raid_disks' by.  So when
converting a copies=2 raid10 to a raid0 it must be exactly half of raid_disks.
But you are counting the number of active disks that get removed.  That is
wrong and there could be some faulty disks that get removed as well.

Not applied.

NeilBrown





> ---
>  Grow.c |   34 +++++++++++++++++++---------------
>  1 files changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 3455115..c06561f 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -666,6 +666,7 @@ int remove_disks_on_raid10_to_raid0_takeover(struct supertype *st,
>  	int nr_of_copies;
>  	struct mdinfo *remaining;
>  	int slot;
> +	int delta = 0;
>  
>  	nr_of_copies = layout & 0xff;
>  
> @@ -710,7 +711,7 @@ int remove_disks_on_raid10_to_raid0_takeover(struct supertype *st,
>  			e = &(*e)->next;
>  		*e = sra->devs;
>  		sra->devs = remaining;
> -		return 1;
> +		return 0;
>  	}
>  
>  	/* Remove all 'remaining' devices from the array */
> @@ -725,8 +726,9 @@ int remove_disks_on_raid10_to_raid0_takeover(struct supertype *st,
>  		sd->disk.state &= ~(1<<MD_DISK_SYNC);
>  		sd->next = sra->devs;
>  		sra->devs = sd;
> +		delta--;
>  	}
> -	return 0;
> +	return delta;
>  }
>  
>  void reshape_free_fdlist(int *fdlist,
> @@ -1456,6 +1458,17 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
>  			size = array.size;
>  	}
>  
> +	info.array = array;
> +	sysfs_init(&info, fd, NoMdDev);
> +	strcpy(info.text_version, sra->text_version);
> +	info.component_size = size*2;
> +	info.new_level = level;
> +	info.new_chunk = chunksize * 1024;
> +	if (raid_disks)
> +		info.delta_disks = raid_disks - info.array.raid_disks;
> +	else
> +		info.delta_disks = UnSet;
> +
>  	/* ========= check for Raid10 -> Raid0 conversion ===============
>  	 * current implementation assumes that following conditions must be met:
>  	 * - far_copies == 1
> @@ -1463,27 +1476,18 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
>  	 */
>  	if (level == 0 && array.level == 10 && sra &&
>  	    array.layout == ((1 << 8) + 2) && !(array.raid_disks & 1)) {
> -		int err;
> -		err = remove_disks_on_raid10_to_raid0_takeover(st, sra, array.layout);
> -		if (err) {
> +		int rv;
> +		rv = remove_disks_on_raid10_to_raid0_takeover(st, sra, array.layout);
> +		if (!rv) {
>  			dprintf(Name": Array cannot be reshaped\n");
>  			if (cfd > -1)
>  				close(cfd);
>  			rv = 1;
>  			goto release;
>  		}
> +		info.delta_disks = rv;
>  	}
>  
> -	info.array = array;
> -	sysfs_init(&info, fd, NoMdDev);
> -	strcpy(info.text_version, sra->text_version);
> -	info.component_size = size*2;
> -	info.new_level = level;
> -	info.new_chunk = chunksize * 1024;
> -	if (raid_disks)
> -		info.delta_disks = raid_disks - info.array.raid_disks;
> -	else
> -		info.delta_disks = UnSet;
>  	if (layout_str == NULL) {
>  		info.new_layout = UnSet;
>  		if (info.array.level == 6 &&

