From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 3.1.1  fails to hot remove device - No such device or
 address
Date: Sat, 27 Feb 2010 07:42:33 +1100
Message-ID: <20100227074233.65f90d97@notabene.brown>
References: <D27CA15508148C428A25104ADEFAAC8105728535@CORPUSMX50C.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D27CA15508148C428A25104ADEFAAC8105728535@CORPUSMX50C.corp.emc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Foster_Brian@emc.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 26 Feb 2010 08:37:51 -0500
Foster_Brian@emc.com wrote:

> Hi Neil,
> 
> We run mdadm in a NAS framework and recently updated to 3.1.1 after
> using older revs for quite some time. We recently observed an issue
> where we've been unable to hot remove a failed device from an array,
> where that member device has been physically removed from the system.
> 'mdadm /dev/md# -r /dev/sdg#' returns a "No such device or address
> error."
> 
> It turns out this occurs due to the dev_open() call added in the code
> referenced below. The hot remove works as expected if we revert this
> change with the patch shown below. Was the dev_open() added for some
> functional reason I'm not aware of (i.e., are we now breaking some other
> error path by doing this)? For future reference, is there a better way
> to handle the situation where the member device is physically gone? Note
> that we currently have a static set of devnodes; no udev or anything
> like that. Thanks.

Thanks for the report.  I have put it on my list of things to check before
releasing 3.1.2.  The switch to use 'dev_open' was to allow ->devname to be
e.g. "8:32" which is used by the spare-group code in Monitor.c.
However it is a regression and I will give some thought to fixing it.

However the "recommended" way of removing devices which have been detached is:
   mdadm /dev/md# -r detached

NeilBrown


> 
> Brian
> 
> diff -urpN mdadm-3.1.1/Manage.c mdadm-3.1.1_b/Manage.c
> --- mdadm-3.1.1/Manage.c	2009-11-19 00:13:29.000000000 -0500
> +++ mdadm-3.1.1_b/Manage.c	2010-02-26 07:51:24.000000000 -0500
> @@ -424,19 +424,12 @@ int Manage_subdevs(char *devname, int fd
>  		} else {
>  			j = 0;
>  
> -			tfd = dev_open(dv->devname, O_RDONLY);
> -			if (tfd < 0 || fstat(tfd, &stb) != 0) {
> -				fprintf(stderr, Name ": cannot find %s:
> %s\n",
> -					dv->devname, strerror(errno));
> -				if (tfd >= 0)
> -					close(tfd);
> +			if (stat(dv->devname, &stb)) {
> +				fprintf(stderr, Name ": cannot find %s:
> %s\n", dv->devname, strerror(errno));
>  				return 1;
>  			}
> -			close(tfd);
>  			if ((stb.st_mode & S_IFMT) != S_IFBLK) {
> -				fprintf(stderr, Name ": %s is not a "
> -					"block device.\n",
> -					dv->devname);
> +				fprintf(stderr, Name ": %s is not a
> block device.\n", dv->devname);
>  				return 1;
>  			}
>  		}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

