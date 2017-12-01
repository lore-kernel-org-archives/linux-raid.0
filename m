From: Shaohua Li <shli@kernel.org>
Subject: Re: mdadm: using ioctl to set disk faulty instead of sysfs
Date: Fri, 1 Dec 2017 12:28:40 -0800
Message-ID: <20171201202840.ht5vaf3tj7orgth5@kernel.org>
References: <33BB30F4-F2A1-437B-ABFE-6A03E9563F01@mails.ucas.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <33BB30F4-F2A1-437B-ABFE-6A03E9563F01@mails.ucas.ac.cn>
Sender: linux-raid-owner@vger.kernel.org
To: wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 21, 2017 at 09:09:46PM +0800, wuzhouhui wrote:
> Hi, I have a suggest about mdadm to set disk faulty. Since commit 1ca69c4bc4b1ef
> (md: avoid taking the mutex on some ioctls) removes lock when set disk faulty,
> so we'd better using ioctl(SET_DISK_FAULTY) to set disk faulty, instead of 
> echo faulty > /sys/block/<md>/md/dev-<disk>/state, because caller of state's
> handler would lock mddev. Like following:

While avoiding the lock is good of course, this isn't a hot path, this doesn't
change anything. Did you see lock contention because of this?

Thanks,
Shaohua
 
> Index: mdadm-4.0/Manage.c
> ===================================================================
> --- mdadm-4.0.orig/Manage.c
> +++ mdadm-4.0/Manage.c
> @@ -1662,9 +1662,7 @@ int Manage_subdevs(char *devname, int fd
>  
>  		case 'f': /* set faulty */
>  			/* FIXME check current member */
> -			if ((sysfd >= 0 && write(sysfd, "faulty", 6) != 6) ||
> -			    (sysfd < 0 && ioctl(fd, SET_DISK_FAULTY,
> -						rdev))) {
> +			if (ioctl(fd, SET_DISK_FAULTY, rdev)) {
>  				if (errno == EBUSY)
>  					busy = 1;
>  				pr_err("set device faulty failed for %s:  %s\n",
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
