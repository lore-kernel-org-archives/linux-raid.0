From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] imsm: fill working_disks according to metadata.
Date: Tue, 21 Jan 2020 13:42:26 -0500
Message-ID: <2d196b56-cd44-dcea-8175-4fb257ba3ce4@trained-monkey.org>
References: <20200117142404.25035-1-blazej.kucman@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200117142404.25035-1-blazej.kucman@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Blazej Kucman <blazej.kucman@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/17/20 9:24 AM, Blazej Kucman wrote:
> Imsm tracts as "working_disk" each visible drive.
> Assemble routine expects that the value will return count
> of active member drives recorded in metadata.
> As a side effect "--no-degraded" doesn't work correctly for imsm.
> Align this field to others.
> Added check, if the option --no-degraded is called with --scan.

I assume you meant tracks rather than tracts? I corrected this in the
description and applied this. If I was wrong, my apologies.

Thanks,
Jes


> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> ---
>  mdadm.c       | 9 ++++++---
>  super-intel.c | 5 ++---
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/mdadm.c b/mdadm.c
> index 256a97ef..13dc24e4 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1485,9 +1485,12 @@ int main(int argc, char *argv[])
>  			rv = Manage_stop(devlist->devname, mdfd, c.verbose, 0);
>  		break;
>  	case ASSEMBLE:
> -		if (devs_found == 1 && ident.uuid_set == 0 &&
> -		    ident.super_minor == UnSet && ident.name[0] == 0 &&
> -		    !c.scan ) {
> +		if (!c.scan && c.runstop == -1) {
> +			pr_err("--no-degraded not meaningful without a --scan assembly.\n");
> +			exit(1);
> +		} else if (devs_found == 1 && ident.uuid_set == 0 &&
> +			   ident.super_minor == UnSet && ident.name[0] == 0 &&
> +			   !c.scan) {
>  			/* Only a device has been given, so get details from config file */
>  			struct mddev_ident *array_ident = conf_get_ident(devlist->devname);
>  			if (array_ident == NULL) {
> diff --git a/super-intel.c b/super-intel.c
> index 5c1f759f..47809bc2 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -7946,7 +7946,8 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
>  				skip = 1;
>  			if (!skip && (ord & IMSM_ORD_REBUILD))
>  				recovery_start = 0;
> -
> +			if (!(ord & IMSM_ORD_REBUILD))
> +				this->array.working_disks++;
>  			/*
>  			 * if we skip some disks the array will be assmebled degraded;
>  			 * reset resync start to avoid a dirty-degraded
> @@ -7988,8 +7989,6 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
>  				else
>  					this->array.spare_disks++;
>  			}
> -			if (info_d->recovery_start == MaxSector)
> -				this->array.working_disks++;
>  
>  			info_d->events = __le32_to_cpu(mpb->generation_num);
>  			info_d->data_offset = pba_of_lba0(map);
> 
