From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] mdadm/util:integrate fstat and stat into a utility
 function
Date: Thu, 30 Mar 2017 14:46:51 -0400
Message-ID: <38653956-4c7b-1e7c-7a50-4d3744a3a115@gmail.com>
References: <20170330044622.2397-1-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170330044622.2397-1-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/30/2017 12:46 AM, Zhilong Liu wrote:
> mdadm/util: lots of dupilicate codes about stat and fstat
> check the block device, move them into a utility function
> to make it concise.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  Assemble.c    |  9 +--------
>  Build.c       | 10 +---------
>  Create.c      |  5 +----
>  Dump.c        |  3 +--
>  Grow.c        |  4 +---
>  Incremental.c | 27 +++------------------------
>  Manage.c      |  9 +--------
>  mdadm.h       |  1 +
>  super-intel.c |  9 +--------
>  util.c        | 15 +++++++++++++++
>  10 files changed, 26 insertions(+), 66 deletions(-)

I'm a little mixed on this one. Defaulting to stat() rather than fstat() 
seems like a sledgehammer approach for the cases where we already have 
the fd open. I would prefer to default to fstat or have two versions I'd 
say.

Cheers,
Jes


> diff --git a/Assemble.c b/Assemble.c
> index 6a6a56b..d3bfaa2 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -204,14 +204,7 @@ static int select_devices(struct mddev_dev *devlist,
>  				pr_err("cannot open device %s: %s\n",
>  				       devname, strerror(errno));
>  			tmpdev->used = 2;
> -		} else if (fstat(dfd, &stb)< 0) {
> -			/* Impossible! */
> -			pr_err("fstat failed for %s: %s\n",
> -			       devname, strerror(errno));
> -			tmpdev->used = 2;
> -		} else if ((stb.st_mode & S_IFMT) != S_IFBLK) {
> -			pr_err("%s is not a block device.\n",
> -			       devname);
> +		} else if (check_block_dev(devname)) {
>  			tmpdev->used = 2;
>  		} else if (must_be_container(dfd)) {
>  			if (st) {
> diff --git a/Build.c b/Build.c
> index a5fcc06..4fa606c 100644
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
> +		if (check_block_dev(dv->devname))
>  			return 1;
> -		}
>  	}
>
>  	if (s->raiddisks != subdevs) {
> diff --git a/Create.c b/Create.c
> index 10e7d10..dbd9ce3 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -327,11 +327,8 @@ int Create(struct supertype *st, char *mddev,
>  				dname, strerror(errno));
>  			exit(2);
>  		}
> -		if (fstat(dfd, &stb) != 0 ||
> -		    (stb.st_mode & S_IFMT) != S_IFBLK) {
> +		if (check_block_dev(dname)) {
>  			close(dfd);
> -			pr_err("%s is not a block device\n",
> -				dname);
>  			exit(2);
>  		}
>  		close(dfd);
> diff --git a/Dump.c b/Dump.c
> index 7bdbf6f..29fc02a 100644
> --- a/Dump.c
> +++ b/Dump.c
> @@ -131,8 +131,7 @@ int Dump_metadata(char *dev, char *dir, struct context *c,
>  		if (de->d_name[0] == '.')
>  			continue;
>  		xasprintf(&p, "/dev/disk/by-id/%s", de->d_name);
> -		if (stat(p, &stb) != 0 ||
> -		    (stb.st_mode & S_IFMT) != S_IFBLK ||
> +		if (check_block_dev(p) != 0 ||
>  		    stb.st_rdev != dstb.st_rdev) {
>  			/* Not this one */
>  			free(p);
> diff --git a/Grow.c b/Grow.c
> index b86b53e..063996d 100755
> --- a/Grow.c
> +++ b/Grow.c
> @@ -145,9 +145,7 @@ int Grow_Add_device(char *devname, int fd, char *newdev)
>  		free(st);
>  		return 1;
>  	}
> -	fstat(nfd, &stb);
> -	if ((stb.st_mode & S_IFMT) != S_IFBLK) {
> -		pr_err("%s is not a block device!\n", newdev);
> +	if (check_block_dev(newdev)) {
>  		close(nfd);
>  		free(st);
>  		return 1;
> diff --git a/Incremental.c b/Incremental.c
> index 81afc7e..b2fad39 100644
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
> +	if (check_block_dev(devname))
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
> @@ -159,8 +149,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>  		devlist = conf_get_devs();
>  		for (;devlist; devlist = devlist->next) {
>  			struct stat st2;
> -			if (stat(devlist->devname, &st2) == 0 &&
> -			    (st2.st_mode & S_IFMT) == S_IFBLK &&
> +			if (check_block_dev(devlist->devname) == 0 &&
>  			    st2.st_rdev == stb.st_rdev)
>  				break;
>  		}
> @@ -175,18 +164,8 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>  	/* 2/ Find metadata, reject if none appropriate (check
>  	 *            version/name from args) */
>
> -	if (fstat(dfd, &stb) < 0) {
> -		if (c->verbose >= 0)
> -			pr_err("fstat failed for %s: %s.\n",
> -				devname, strerror(errno));
> +	if (check_block_dev(devname))
>  		goto out;
> -	}
> -	if ((stb.st_mode & S_IFMT) != S_IFBLK) {
> -		if (c->verbose >= 0)
> -			pr_err("%s is not a block device.\n",
> -				devname);
> -		goto out;
> -	}
>
>  	dinfo.disk.major = major(stb.st_rdev);
>  	dinfo.disk.minor = minor(stb.st_rdev);
> diff --git a/Manage.c b/Manage.c
> index 55218d9..8687084 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -1543,17 +1543,10 @@ int Manage_subdevs(char *devname, int fd,
>  				close(tfd);
>  			} else {
>  				int open_err = errno;
> -				if (stat(dv->devname, &stb) != 0) {
> -					pr_err("Cannot find %s: %s\n",
> -					       dv->devname, strerror(errno));
> -					goto abort;
> -				}
> -				if ((stb.st_mode & S_IFMT) != S_IFBLK) {
> +				if (check_block_dev(dv->devname) != 0) {
>  					if (dv->disposition == 'M')
>  						/* non-fatal. Also improbable */
>  						continue;
> -					pr_err("%s is not a block device.\n",
> -					       dv->devname);
>  					goto abort;
>  				}
>  				if (dv->disposition == 'r')
> diff --git a/mdadm.h b/mdadm.h
> index dbf1f92..ad43a35 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1416,6 +1416,7 @@ extern int parse_cluster_confirm_arg(char *inp, char **devname, int *slot);
>  extern int check_ext2(int fd, char *name);
>  extern int check_reiser(int fd, char *name);
>  extern int check_raid(int fd, char *name);
> +extern int check_block_dev(char *dev);
>  extern int check_partitions(int fd, char *dname,
>  			    unsigned long long freesize,
>  			    unsigned long long size);
> diff --git a/super-intel.c b/super-intel.c
> index 785488a..21b5887 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -6584,14 +6584,7 @@ count_volumes_list(struct md_list *devlist, char *homehost,
>  			dprintf("cannot open device %s: %s\n",
>  				devname, strerror(errno));
>  			tmpdev->used = 2;
> -		} else if (fstat(dfd, &stb)< 0) {
> -			/* Impossible! */
> -			dprintf("fstat failed for %s: %s\n",
> -				devname, strerror(errno));
> -			tmpdev->used = 2;
> -		} else if ((stb.st_mode & S_IFMT) != S_IFBLK) {
> -			dprintf("%s is not a block device.\n",
> -				devname);
> +		} else if (check_block_dev(devname)) {
>  			tmpdev->used = 2;
>  		} else if (must_be_container(dfd)) {
>  			struct supertype *cst;
> diff --git a/util.c b/util.c
> index 683c869..e7aeb54 100644
> --- a/util.c
> +++ b/util.c
> @@ -750,6 +750,21 @@ int ask(char *mesg)
>  }
>  #endif /* MDASSEMBLE */
>
> +int check_block_dev(char *dev)
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
>  int is_standard(char *dev, int *nump)
>  {
>  	/* tests if dev is a "standard" md dev name.
>

