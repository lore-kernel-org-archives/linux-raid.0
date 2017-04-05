From: jes.sorensen@gmail.com
Subject: Re: [PATCH 1/4] mdadm/util:integrate stat operations into one utility
Date: Wed, 05 Apr 2017 11:42:35 -0400
Message-ID: <wrfj8tneeu8k.fsf@gmail.com>
References: <20170401125145.14440-1-zlliu@suse.com>
        <20170401125145.14440-2-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170401125145.14440-2-zlliu@suse.com> (Zhilong Liu's message of
        "Sat, 1 Apr 2017 20:51:42 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Zhilong Liu <zlliu@suse.com> writes:
> mdadm/util: there are dupilicate codes about stat checking the
> block device, move the operations into one utility function and
> make it concise.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  Assemble.c    |  5 ++---
>  Build.c       | 21 +++------------------
>  Incremental.c | 12 +-----------
>  Manage.c      | 10 ++--------
>  mdadm.h       |  1 +
>  super-intel.c |  4 +---
>  util.c        | 15 +++++++++++++++
>  7 files changed, 25 insertions(+), 43 deletions(-)
>
> diff --git a/Assemble.c b/Assemble.c
> index 672cd12..c6571e6 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -522,9 +522,8 @@ static int select_devices(struct mddev_dev *devlist,
>  		struct stat stb;
>  		if (tmpdev->used != 3)
>  			continue;
> -		if (stat(tmpdev->devname, &stb)< 0) {
> -			pr_err("fstat failed for %s: %s\n",
> -			       tmpdev->devname, strerror(errno));
> +		if (check_blkdev_via_stat(tmpdev->devname) &&
> +		    stat(tmpdev->devname, &stb)) {
>  			tmpdev->used = 2;
>  		} else {
>  			struct dev_policy *pol = devid_policy(stb.st_rdev);

Sorry, but this change makes no sense. First calling a function using
stat() to check, and then call stat() one more time to get the stat data
anyway.

In fact, looking through this patch, you are doing it all over the
place.

This makes things worse, not better!

> diff --git a/Build.c b/Build.c
> index 691dd6f..b500ad7 100644
> --- a/Build.c
> +++ b/Build.c
> @@ -67,16 +67,8 @@ int Build(char *mddev, struct mddev_dev *devlist,
>  			missing_disks++;
>  			continue;
>  		}
> -		if (stat(dv->devname, &stb)) {
> -			pr_err("Cannot find %s: %s\n",
> -				dv->devname, strerror(errno));
> -			return 1;
> -		}
> -		if ((stb.st_mode & S_IFMT) != S_IFBLK) {
> -			pr_err("%s is not a block device.\n",
> -				dv->devname);
> +		if (check_blkdev_via_stat(dv->devname))
>  			return 1;
> -		}
>  	}
>  
>  	if (s->raiddisks != subdevs) {
> @@ -171,16 +163,9 @@ int Build(char *mddev, struct mddev_dev *devlist,
>  		int fd;
>  		if (strcmp("missing", dv->devname) == 0)
>  			continue;
> -		if (stat(dv->devname, &stb)) {
> -			pr_err("Weird: %s has disappeared.\n",
> -				dv->devname);
> +		if (check_blkdev_via_stat(dv->devname))
>  			goto abort;
> -		}
> -		if ((stb.st_mode & S_IFMT)!= S_IFBLK) {
> -			pr_err("Weird: %s is no longer a block device.\n",
> -				dv->devname);
> -			goto abort;
> -		}
> +		stat(dv->devname, &stb);
>  		fd = open(dv->devname, O_RDONLY|O_EXCL);
>  		if (fd < 0) {
>  			pr_err("Cannot open %s: %s\n",
> diff --git a/Incremental.c b/Incremental.c
> index 28f1f77..78adf18 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -108,18 +108,8 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>  
>  	struct createinfo *ci = conf_get_create_info();
>  
> -	if (stat(devname, &stb) < 0) {
> -		if (c->verbose >= 0)
> -			pr_err("stat failed for %s: %s.\n",
> -				devname, strerror(errno));
> +	if (check_blkdev_via_stat(devname) && stat(devname, &stb))
>  		return rv;
> -	}
> -	if ((stb.st_mode & S_IFMT) != S_IFBLK) {
> -		if (c->verbose >= 0)
> -			pr_err("%s is not a block device.\n",
> -				devname);
> -		return rv;
> -	}
>  	dfd = dev_open(devname, O_RDONLY);
>  	if (dfd < 0) {
>  		if (c->verbose >= 0)
> diff --git a/Manage.c b/Manage.c
> index 618c98b..6aec65d 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -1544,17 +1544,11 @@ int Manage_subdevs(char *devname, int fd,
>  				close(tfd);
>  			} else {
>  				int open_err = errno;
> -				if (stat(dv->devname, &stb) != 0) {
> -					pr_err("Cannot find %s: %s\n",
> -					       dv->devname, strerror(errno));
> -					goto abort;
> -				}
> -				if ((stb.st_mode & S_IFMT) != S_IFBLK) {
> +				if (check_blkdev_via_stat(dv->devname) &&
> +				    stat(dv->devname, &stb)) {
>  					if (dv->disposition == 'M')
>  						/* non-fatal. Also improbable */
>  						continue;
> -					pr_err("%s is not a block device.\n",
> -					       dv->devname);
>  					goto abort;
>  				}
>  				if (dv->disposition == 'r')
> diff --git a/mdadm.h b/mdadm.h
> index 612bd86..0aea822 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1422,6 +1422,7 @@ extern int check_raid(int fd, char *name);
>  extern int check_partitions(int fd, char *dname,
>  			    unsigned long long freesize,
>  			    unsigned long long size);
> +extern int check_blkdev_via_stat(char *dev);
>  
>  extern int get_mdp_major(void);
>  extern int get_maj_min(char *dev, int *major, int *minor);
> diff --git a/super-intel.c b/super-intel.c
> index 84dfe2b..924ad8a 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -6953,9 +6953,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
>  	}
>  
>  	/* This device must be a member of the set */
> -	if (stat(dev, &stb) < 0)
> -		return 0;
> -	if ((S_IFMT & stb.st_mode) != S_IFBLK)
> +	if (check_blkdev_via_stat(dev) && stat(dev, &stb))
>  		return 0;
>  	for (dl = super->disks ; dl ; dl = dl->next) {
>  		if (dl->major == (int)major(stb.st_rdev) &&
> diff --git a/util.c b/util.c
> index 9fc7ba0..03d4256 100644
> --- a/util.c
> +++ b/util.c
> @@ -774,6 +774,21 @@ int ask(char *mesg)
>  }
>  #endif /* MDASSEMBLE */
>  
> +int check_blkdev_via_stat(char *dev)
> +{
> +	struct stat stb;
> +
> +	if (stat(dev, &stb) != 0) {
> +		pr_err("stat failed for %s: %s\n", dev, strerror(errno));
> +		return -1;
> +	}
> +	if ((S_IFMT & stb.st_mode) != S_IFBLK) {
> +		pr_err("%s is not a block device.\n", dev);
> +		return -1;
> +	}
> +	return 0;
> +}
> +

For a function like this, lets name it better md_is_blkdev()

Jes
