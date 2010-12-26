From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/5] external: get number of failed disks for container
Date: Sun, 26 Dec 2010 22:33:09 +1100
Message-ID: <20101226223309.1ec2f4c9@notabene.brown>
References: <20101223155614.5562.4773.stgit@gklab-170-211.igk.intel.com>
	<20101223160233.5562.15686.stgit@gklab-170-211.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101223160233.5562.15686.stgit@gklab-170-211.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 23 Dec 2010 17:02:33 +0100 Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> Container degradation here is defined as the number of failed disks in
> mostly degraded sub-array. This number is used as value for
> array.failed_disks and used in comparison to find best match.
> 
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>

Applied... but ...

> ---
>  Incremental.c |   35 ++++++++++++++++++++++++++++++++++-
>  1 files changed, 34 insertions(+), 1 deletions(-)
> 
> diff --git a/Incremental.c b/Incremental.c
> index a4ac1b5..ef719fa 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -820,6 +820,34 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
>  	return cnt;
>  }
>  
> +/* test if container has degraded member(s) */
> +int container_members_max_degradation(struct map_ent *map, struct map_ent *me)

should be 'static'.


> +{
> +	mdu_array_info_t array;
> +	int afd;
> +	int max_degraded = 0;
> +	char devname[100];
> +
> +	snprintf(devname, sizeof(devname), "md%d", me->devnum);
> +	for(; map; map = map->next) {
> +		if (!is_subarray(map->metadata) ||
> +		    strncmp(me->metadata+1, devname, strlen(devname) != 0))
> +			continue;

Rather than formatting devnum as a devname, you can use devname2devnum on
me->metadata+1 and compare that with me->devnum.

And the strncmp should have been for map->metadata+1, not me->metadata+1 !!!!

I have fixed all these.

Thanks,
NeilBrown



> +		afd = open_dev(map->devnum);
> +		if (afd < 0)
> +			continue;
> +		/* most accurate information regarding array degradation */
> +		if (ioctl(afd, GET_ARRAY_INFO, &array) >= 0) {
> +			int degraded = array.raid_disks - array.active_disks -
> +				       array.spare_disks;
> +			if (degraded > max_degraded)
> +				max_degraded = degraded;
> +		}
> +		close(afd);
> +	}
> +	return (max_degraded);
> +}
> +
>  static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
>  			   struct map_ent *target, int bare,
>  			   struct supertype *st, int verbose)
> @@ -887,7 +915,7 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
>  					 GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE|
>  					 GET_COMPONENT|GET_VERSION);
>  			if (sra)
> -				sra->array.failed_disks = 0;
> +				sra->array.failed_disks = -1;
>  		}
>  		if (!sra)
>  			continue;
> @@ -914,6 +942,11 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
>  				goto next;
>  		} else
>  			st2 = st;
> +		/* update number of failed disks for mostly degraded
> +		 * container member */
> +		if (sra->array.failed_disks == -1)
> +			sra->array.failed_disks = container_members_max_degradation(map, mp);
> +
>  		get_dev_size(dfd, NULL, &devsize);
>  		if (st2->ss->avail_size(st2, devsize) < sra->component_size) {
>  			if (verbose > 1)

