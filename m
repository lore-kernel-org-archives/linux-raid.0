From: Neil Brown <neilb@suse.de>
Subject: Re: Bug in md grow code
Date: Fri, 24 Mar 2006 11:06:00 +1100
Message-ID: <17443.14312.975082.563189@cse.unsw.edu.au>
References: <20060323223929.GO17043@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Thursday March 23
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 23, dledford@redhat.com wrote:
> The code that checks all the devices in an array and tries to fit a grow
> request to the largest possible value is broken and will only do this
> successfully if the first element of the array isn't <= all other elements
> in the array.  Not re-initializing the fit variable with each loop of the
> check solves the problems.

Ahh...yes, thanks.
Not quite critical enough to get into 2.6.16.1 I suspect, but I'll
make sure it heads upstream for 2.6.17.

Thanks again,
NeilBrown

> 
> Signed-off-by: Doug Ledford <dledford@redhat.com>
> 
> -- 
>   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
>          Red Hat, Inc. 
>          1801 Varsity Dr.
>          Raleigh, NC 27606
>   
> --- linux-2.6.9/drivers/md/md.c.save	2006-03-22 18:32:38.000000000 -0500
> +++ linux-2.6.9/drivers/md/md.c	2006-03-22 18:33:40.000000000 -0500
> @@ -2426,6 +2426,7 @@
>  	if (mddev->size != info->size) {
>  		mdk_rdev_t * rdev;
>  		struct list_head *tmp;
> +		int fit = (info->size == 0);
>  		if (mddev->pers->resize == NULL)
>  			return -EINVAL;
>  		/* The "size" is the amount of each device that is used.
> @@ -2442,7 +2443,6 @@
>  			return -EBUSY;
>  		ITERATE_RDEV(mddev,rdev,tmp) {
>  			sector_t avail;
> -			int fit = (info->size == 0);
>  			if (rdev->sb_offset > rdev->data_offset)
>  				avail = (rdev->sb_offset*2) - rdev->data_offset;
>  			else
