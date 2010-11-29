From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 21/53] imsm: FIX: core dump during imsm metadata writing
Date: Mon, 29 Nov 2010 12:54:21 +1100
Message-ID: <20101129125421.451a1a16@notabene.brown>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
	<20101126080638.5221.2095.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126080638.5221.2095.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 26 Nov 2010 09:06:38 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Wrong number of disks during metadata update causes core dump.
> New disks number based on internal mdmon information has to used for calculation (not previously read from metadata).
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

I've applied this, thanks.

One small comment ....


> ---
> 
>  super-intel.c |   27 ++++++++++++++++++---------
>  1 files changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 98e4c6d..1231fa8 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -3510,8 +3510,9 @@ static int write_super_imsm_spares(struct intel_super *super, int doclose)
>  	return 0;
>  }
>  
> -static int write_super_imsm(struct intel_super *super, int doclose)
> +static int write_super_imsm(struct supertype *st, int doclose)
>  {
> +	struct intel_super *super = st->sb;
>  	struct imsm_super *mpb = super->anchor;
>  	struct dl *d;
>  	__u32 generation;
> @@ -3519,6 +3520,7 @@ static int write_super_imsm(struct intel_super *super, int doclose)
>  	int spares = 0;
>  	int i;
>  	__u32 mpb_size = sizeof(struct imsm_super) - sizeof(struct imsm_disk);
> +	int num_disks = 0;
>  
>  	/* 'generation' is incremented everytime the metadata is written */
>  	generation = __le32_to_cpu(mpb->generation_num);
> @@ -3531,21 +3533,28 @@ static int write_super_imsm(struct intel_super *super, int doclose)
>  	if (mpb->orig_family_num == 0)
>  		mpb->orig_family_num = mpb->family_num;
>  
> -	mpb_size += sizeof(struct imsm_disk) * mpb->num_disks;
>  	for (d = super->disks; d; d = d->next) {
>  		if (d->index == -1)
>  			spares++;
> -		else
> +		else {
>  			mpb->disk[d->index] = d->disk;
> +			num_disks++;
> +		}
>  	}
> -	for (d = super->missing; d; d = d->next)
> +	for (d = super->missing; d; d = d->next) {
>  		mpb->disk[d->index] = d->disk;
> +		num_disks++;
> +	}
> +	mpb->num_disks = num_disks;
> +	mpb_size += sizeof(struct imsm_disk) * mpb->num_disks;
>  
>  	for (i = 0; i < mpb->num_raid_devs; i++) {
>  		struct imsm_dev *dev = __get_imsm_dev(mpb, i);
> -
> -		imsm_copy_dev(dev, get_imsm_dev(super, i));
> -		mpb_size += sizeof_imsm_dev(dev, 0);
> +		struct imsm_dev *dev2 = get_imsm_dev(super, i);
> +		if ((dev) && (dev2)) {

I don't like these extra parentheses.  They are just noise and don't improve
clarity.  Please just:
                if (dev && dev2) {

NeilBrown






> +			imsm_copy_dev(dev, dev2);
> +			mpb_size += sizeof_imsm_dev(dev, 0);
> +		}
>  	}
>  	mpb_size += __le32_to_cpu(mpb->bbm_log_size);
>  	mpb->mpb_size = __cpu_to_le32(mpb_size);
> @@ -3665,7 +3674,7 @@ static int write_init_super_imsm(struct supertype *st)
>  		struct dl *d;
>  		for (d = super->disks; d; d = d->next)
>  			Kill(d->devname, NULL, 0, 1, 1);
> -		return write_super_imsm(st->sb, 1);
> +		return write_super_imsm(st, 1);
>  	}
>  }
>  #endif
> @@ -4938,7 +4947,7 @@ static void imsm_sync_metadata(struct supertype *container)
>  	if (!super->updates_pending)
>  		return;
>  
> -	write_super_imsm(super, 0);
> +	write_super_imsm(container, 0);
>  
>  	super->updates_pending = 0;
>  }

