From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: md: raid10: fix use-after-free of bio
Date: Sat, 28 Jul 2007 23:55:19 -0700
Message-ID: <20070728235519.1edc6ccb.akpm@linux-foundation.org>
References: <1185547583.2663.10.camel@c64>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1185547583.2663.10.camel@c64>
Sender: linux-raid-owner@vger.kernel.org
To: Maik Hampel <m.hampel@gmx.de>
Cc: Neil Brown <neilb@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 27 Jul 2007 16:46:23 +0200 Maik Hampel <m.hampel@gmx.de> wrote:

> In case of read errors raid10d tries to print a nice error message,
> unfortunately using data from an already put bio.
> 
> Signed-off-by: Maik Hampel <m.hampel@gmx.de>
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index f730a14..ea1b3e3 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1557,7 +1557,6 @@ static void raid10d(mddev_t *mddev)
>  			bio = r10_bio->devs[r10_bio->read_slot].bio;
>  			r10_bio->devs[r10_bio->read_slot].bio =
>  				mddev->ro ? IO_BLOCKED : NULL;
> -			bio_put(bio);
>  			mirror = read_balance(conf, r10_bio);
>  			if (mirror == -1) {
>  				printk(KERN_ALERT "raid10: %s: unrecoverable I/O"
> @@ -1567,6 +1566,7 @@ static void raid10d(mddev_t *mddev)
>  				raid_end_bio_io(r10_bio);
>  			} else {
>  				const int do_sync = bio_sync(r10_bio->master_bio);
> +				bio_put(bio);
>  				rdev = conf->mirrors[mirror].rdev;
>  				if (printk_ratelimit())
>  					printk(KERN_ERR "raid10: %s: redirecting sector %llu to"
> 
> 

Surely we just leaked that bio if (mirror == -1)?

better:

--- a/drivers/md/raid10.c~md-raid10-fix-use-after-free-of-bio
+++ a/drivers/md/raid10.c
@@ -1534,7 +1534,6 @@ static void raid10d(mddev_t *mddev)
 			bio = r10_bio->devs[r10_bio->read_slot].bio;
 			r10_bio->devs[r10_bio->read_slot].bio =
 				mddev->ro ? IO_BLOCKED : NULL;
-			bio_put(bio);
 			mirror = read_balance(conf, r10_bio);
 			if (mirror == -1) {
 				printk(KERN_ALERT "raid10: %s: unrecoverable I/O"
@@ -1542,8 +1541,10 @@ static void raid10d(mddev_t *mddev)
 				       bdevname(bio->bi_bdev,b),
 				       (unsigned long long)r10_bio->sector);
 				raid_end_bio_io(r10_bio);
+				bio_put(bio);
 			} else {
 				const int do_sync = bio_sync(r10_bio->master_bio);
+				bio_put(bio);
 				rdev = conf->mirrors[mirror].rdev;
 				if (printk_ratelimit())
 					printk(KERN_ERR "raid10: %s: redirecting sector %llu to"
_

