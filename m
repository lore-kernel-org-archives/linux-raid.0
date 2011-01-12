From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/9] imsm: FIX: only one spare is passed in update
Date: Wed, 12 Jan 2011 16:46:51 +1100
Message-ID: <20110112164651.17b03d41@notabene.brown>
References: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
	<20110111140419.13862.65110.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111140419.13862.65110.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, 11 Jan 2011 15:04:19 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Only one spare is passed in update.
> When more than one disk is added first spare is passed multiple times.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index ef51000..321dc47 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -6448,6 +6448,7 @@ static int imsm_create_metadata_update_for_reshape(
>  	struct mdinfo *spares = NULL;
>  	int i;
>  	int delta_disks = 0;
> +	struct mdinfo *dev;
>  
>  	dprintf("imsm_update_metadata_for_reshape(enter) raid_disks = %i\n",
>  		geo->raid_disks);
> @@ -6486,15 +6487,18 @@ static int imsm_create_metadata_update_for_reshape(
>  	dprintf("imsm: %i spares are available.\n\n",
>  		spares->array.spare_disks);
>  
> +	dev = spares->devs;
>  	for (i = 0; i < delta_disks; i++) {
> -		struct mdinfo *dev = spares->devs;
>  		struct dl *dl;
>  
> +		if (dev == NULL)
> +			break;
>  		u->new_disks[i] = makedev(dev->disk.major,
>  					  dev->disk.minor);
>  		dl = get_disk_super(super, dev->disk.major, dev->disk.minor);
>  		dl->index = mpb->num_disks;
>  		mpb->num_disks++;
> +		dev = dev->next;
>  	}
>  
>  abort:


Applied, thanks.

NeilBrown

