From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] raid1d bugfix/2.4
Date: Mon, 14 Apr 2003 16:42:01 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16026.22585.118892.770239@notabene.cse.unsw.edu.au>
References: <200304090222_MC3-1-33A7-11C5@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chuck Ebbert on Wednesday April 9
To: Chuck Ebbert <76306.1226@compuserve.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday April 9, 76306.1226@compuserve.com wrote:
> Neil Brown wrote:
> >> 
> >>   This could only happen if a second disk failed during rebuild of a 3+
> >> disk array.
> >
> >True, but if a disk fails during a rebuild the rebuild is aborted, so
> >it doesn't really matter.
> 
> 
>  Even on a 3-disk mirror where there's a good data disk left to rebuild
> from?
> That sounds bad, and it looked to me like the code I quoted was looking for
> another working drive if one failed during rebuild/resync.

I'm faily sure that the resync is aborted.  I think it then restarts
if there is useful work to be done.
This is probably not a good thing and should be fixed.

Also it is quite possible that the code is inconsistant and tries to
cope with a situation that doesn't happen.


> 
> 
> >However there are more cosmetic changes than real content, making it
> >harder for me to find the significant change.  It is much easier to
> >read a patch if it just does one thing.
> 
> diff -u --exclude-from=/home/me/.exclude -r linux-2.4.21-pre6-ref/drivers/md/raid1.c pre6-raid1d-a/drivers/md/raid1.c
> --- linux-2.4.21-pre6-ref/drivers/md/raid1.c	Thu Apr  3 13:21:37 2003
> +++ pre6-raid1d-a/drivers/md/raid1.c	Wed Apr  9 01:24:06 2003
> @ -1188,7 +1188,7 @
>  				for (i = 0; i < disks ; i++) {
>  					if (!conf->mirrors[i].operational)
>  						continue;
> -					if (i==conf->last_used)
> +					if (conf->mirrors[i].dev == bh->b_dev)
>  						/* we read from here, no need to write */
>  						continue;
>  					if (i < conf->raid_disks
> 

Thanks.  I don't think there is much point in making this change in
2.4 without fixing the rest of the related problems.  However the
equivalent patch for 2.5:
--- ./drivers/md/raid1.c~current~	2003-04-14 16:39:48.000000000 +1000
+++ ./drivers/md/raid1.c	2003-04-14 16:40:33.000000000 +1000
@@ -826,7 +826,7 @@ static void sync_request_write(mddev_t *
 		if (!conf->mirrors[i].rdev || 
 		    conf->mirrors[i].rdev->faulty)
 			continue;
-		if (i == conf->last_used)
+		if (conf->mirrors[i].rdev->bdev == bio->bi_bdev)
 			/*
 			 * we read from here, no need to write
 			 */

is worth while and I will make sure it gets to Linus.

NeilBrown
