From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: [PATCH] kill-subarray: fix, IMSM cannot kill-subarray with
 unsupported metadata
Date: Thu, 3 Nov 2011 15:23:03 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D4044D82@IRSMSX101.ger.corp.intel.com>
References: <F9123E44003394499FDD2B17C60621D4043755@IRSMSX101.ger.corp.intel.com>
	<20111031113151.64f566b1@notabene.brown>
	<F9123E44003394499FDD2B17C60621D4043D80@IRSMSX101.ger.corp.intel.com>
 <20111101154807.0cf42aa5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111101154807.0cf42aa5@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>
List-Id: linux-raid.ids

Hi Neil,
This is OK. 
However, reshape_container (called from Grow_continue_command) ignores info that is chosen by subarray string given by user.
Therefore, all container's arrays are possibly grown (including those we want to block)
So we need to patch Grow_continue, so it performs grow on the array that user requested, not all arrays that are in the reshape process.
Thanks,
Marcin



> I have changed the code to do what I think it should.  Please review
> patch below.
> 
> Thanks,
> NeilBrown
> 
> 
> commit 446894ea8db17a2dfc740f81d58190c5ac8167d5
> Author: NeilBrown <neilb@suse.de>
> Date:   Tue Nov 1 15:45:46 2011 +1100
> 
>     Grow: fix check_reshape and open_code it.
> 
>     check_reshape should not try to parse the subarray string - only
>     metadata handlers are allowed to do that.
> 
>     The common code and only interpret a subarray string by passing it
> to
>     "container_content" which will then return only the member for that
>     subarray.
> 
>     So remove check_reshape and place similar logic explicitly at the
> two
>     call-sites.  They are different enough that it is probably clearer
> to
>     have explicit code.
> 
>     Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/Grow.c b/Grow.c
> index 598fd59..8df4ac4 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1358,36 +1358,6 @@ static int reshape_container(char *container,
> char *devname,
>  			     char *backup_file,
>  			     int quiet, int restart, int freeze_reshape);
> 
> -/*
> - * helper routine to check metadata reshape avalability
> - * 1. Do not "grow" arrays with volume activation blocked
> - * 2. do not reshape containers with container reshape blocked
> - *
> - * IN:
> - *	subarray - array name or NULL for container wide reshape
> - *	content - md device info from container_content
> - * OUT:
> - *	0 - block reshape
> - */
> -static int check_reshape(char *subarray, struct mdinfo *content) -{
> -	char *ep;
> -	unsigned int idx;
> -
> -	if (!subarray) {
> -		if (content->array.state &
> (1<<MD_SB_BLOCK_CONTAINER_RESHAPE))
> -			return 0;
> -	} else {
> -		/* do not "grow" arrays with volume activation blocked */
> -		idx = strtoul(subarray, &ep, 10);
> -		if (*ep == '\0'
> -		    && content->container_member == (int) idx
> -		    && (content->array.state & (1<<MD_SB_BLOCK_VOLUME)))
> -			return 0;
> -	}
> -	return 1;
> -}
> -
>  int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
>  		 long long size,
>  		 int level, char *layout_str, int chunksize, int
> raid_disks, @@ -1505,12 +1475,16 @@ int Grow_reshape(char *devname, int
> fd, int quiet, char *backup_file,
> 
>  			cc = st->ss->container_content(st, subarray);
>  			for (content = cc; content ; content = content->next)
> {
> -				int allow_reshape;
> +				int allow_reshape = 1;
> 
>  				/* check if reshape is allowed based on
> metadata
>  				 * indications stored in content.array.status
>  				 */
> -				allow_reshape = check_reshape(subarray,
> content);
> +				if (content->array.state &
> (1<<MD_SB_BLOCK_VOLUME))
> +					allow_reshape = 0;
> +				if (content->array.state
> +				    & (1<<MD_SB_BLOCK_CONTAINER_RESHAPE))
> +					allow_reshape = 0;
>  				if (!allow_reshape) {
>  					fprintf(stderr, Name
>  						" cannot reshape arrays in"
> @@ -3788,10 +3762,10 @@ int Grow_continue_command(char *devname, int
> fd,
>  			goto Grow_continue_command_exit;
>  		}
> 
> -		cc = st->ss->container_content(st, NULL);
> +		cc = st->ss->container_content(st, subarray);
>  		for (content = cc; content ; content = content->next) {
>  			char *array;
> -			int allow_reshape;
> +			int allow_reshape = 1;
> 
>  			if (content->reshape_active == 0)
>  				continue;
> @@ -3800,10 +3774,14 @@ int Grow_continue_command(char *devname, int
> fd,
>  			 * content->reshape_active state, therefore we
>  			 * need to check_reshape based on
>  			 * reshape_active and subarray name
> -			*/
> -			allow_reshape =
> -			  check_reshape((content->reshape_active ==
> CONTAINER_RESHAPE)? NULL : subarray,
> -					content);
> +			 */
> +			if (content->array.state & (1<<MD_SB_BLOCK_VOLUME))
> +				allow_reshape = 0;
> +			if (content->reshape_active == CONTAINER_RESHAPE &&
> +			    (content->array.state
> +			     & (1<<MD_SB_BLOCK_CONTAINER_RESHAPE)))
> +				allow_reshape = 0;
> +
>  			if (!allow_reshape) {
>  				fprintf(stderr, Name
>  					": cannot continue reshape of an array"
> diff --git a/super-intel.c b/super-intel.c index 1caee70..34a4b34
> 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5759,8 +5759,8 @@ static struct mdinfo
> *container_content_imsm(struct supertype *st, char *subarra
>  						 map->num_members, /* raid disks */
>  						 &chunk,
>  						 1 /* verbose */)) {
> -			fprintf(stderr, Name ": IMSM RAID gemetry validation
> failed. "
> -				"Array %s activation is blocked.\n",
> +			fprintf(stderr, Name ": IMSM RAID geometry
> validation"
> +				" failed.  Array %s activation is blocked.\n",
>  				dev->volume);
>  			this->array.state |=
>  			  (1<<MD_SB_BLOCK_CONTAINER_RESHAPE) |
