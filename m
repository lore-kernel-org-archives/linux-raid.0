From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] drivers/md: raid10: Fix null pointer dereference in
 fix_read_error()
Date: Tue, 22 Jun 2010 08:55:41 +1000
Message-ID: <20100622085541.38c145ec@notabene.brown>
References: <1277158475-11397-1-git-send-email-prasanna.panchamukhi@riverbed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1277158475-11397-1-git-send-email-prasanna.panchamukhi@riverbed.com>
Sender: linux-raid-owner@vger.kernel.org
To: prasanna.panchamukhi@riverbed.com
Cc: linux-raid@vger.kernel.org, rbecker@riverbed.com
List-Id: linux-raid.ids

On Mon, 21 Jun 2010 15:14:35 -0700
prasanna.panchamukhi@riverbed.com wrote:

> From: Prasanna S. Panchamukhi <prasanna.panchamukhi@riverbed.com>
> 
> Such NULL pointer dereference can occur when the driver was fixing the
> read errors/bad blocks and the disk was physically removed
> causing a system crash. This patch check if the
> rcu_dereference() returns valid rdev before accessing it in fix_read_error().
> 
> Signed-off-by: Prasanna S. Panchamukhi <prasanna.panchamukhi@riverbed.com>
> Signed-off-by: Rob Becker <rbecker@riverbed.com>

Thanks for the patch.
However all that extra indenting is rather painful - and we already have more
than we should.

How about this instead?

Thanks,
NeilBrown

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index aa9f7b6..0334655 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1482,14 +1482,14 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 	int sectors = r10_bio->sectors;
 	mdk_rdev_t*rdev;
 	int max_read_errors = atomic_read(&mddev->max_corr_read_errors);
+	int d = r10_bio->devs[r10_bio->read_slot].devnum;
 
 	rcu_read_lock();
-	{
-		int d = r10_bio->devs[r10_bio->read_slot].devnum;
+	rdev = rcu_dereference(conf->mirrors[d].rdev);
+	if (rdev) {
 		char b[BDEVNAME_SIZE];
 		int cur_read_error_count = 0;
 
-		rdev = rcu_dereference(conf->mirrors[d].rdev);
 		bdevname(rdev->bdev, b);
 
 		if (test_bit(Faulty, &rdev->flags)) {
@@ -1530,7 +1530,7 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 
 		rcu_read_lock();
 		do {
-			int d = r10_bio->devs[sl].devnum;
+			d = r10_bio->devs[sl].devnum;
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (rdev &&
 			    test_bit(In_sync, &rdev->flags)) {
@@ -1601,7 +1601,7 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 		}
 		sl = start;
 		while (sl != r10_bio->read_slot) {
-			int d;
+
 			if (sl==0)
 				sl = conf->copies;
 			sl--;

> ---
>  drivers/md/raid10.c |   51 +++++++++++++++++++++++++++------------------------
>  1 files changed, 27 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0372499..9556faa 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1490,31 +1490,34 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
>  		int cur_read_error_count = 0;
>  
>  		rdev = rcu_dereference(conf->mirrors[d].rdev);
> -		bdevname(rdev->bdev, b);
> +		if (rdev) { /* Check if the mirror raid device is not NULL*/
> +			bdevname(rdev->bdev, b);
>  
> -		if (test_bit(Faulty, &rdev->flags)) {
> -			rcu_read_unlock();
> -			/* drive has already been failed, just ignore any
> -			   more fix_read_error() attempts */
> -			return;
> -		}
> +			if (test_bit(Faulty, &rdev->flags)) {
> +				rcu_read_unlock();
> +				/* drive has already been failed, just ignore
> +				   any more fix_read_error() attempts */
> +				return;
> +			}
>  
> -		check_decay_read_errors(mddev, rdev);
> -		atomic_inc(&rdev->read_errors);
> -		cur_read_error_count = atomic_read(&rdev->read_errors);
> -		if (cur_read_error_count > max_read_errors) {
> -			rcu_read_unlock();
> -			printk(KERN_NOTICE
> -			       "md/raid10:%s: %s: Raid device exceeded "
> -			       "read_error threshold "
> -			       "[cur %d:max %d]\n",
> -			       mdname(mddev),
> -			       b, cur_read_error_count, max_read_errors);
> -			printk(KERN_NOTICE
> -			       "md/raid10:%s: %s: Failing raid "
> -			       "device\n", mdname(mddev), b);
> -			md_error(mddev, conf->mirrors[d].rdev);
> -			return;
> +			check_decay_read_errors(mddev, rdev);
> +			atomic_inc(&rdev->read_errors);
> +			cur_read_error_count = atomic_read(&rdev->read_errors);
> +			if (cur_read_error_count > max_read_errors) {
> +				rcu_read_unlock();
> +				printk(KERN_NOTICE
> +				       "md/raid10:%s: %s: Raid device exceeded "
> +				       "read_error threshold "
> +				       "[cur %d:max %d]\n",
> +				       mdname(mddev),
> +				       b, cur_read_error_count,
> +				       max_read_errors);
> +				printk(KERN_NOTICE
> +				       "md/raid10:%s: %s: Failing raid "
> +				       "device\n", mdname(mddev), b);
> +				md_error(mddev, conf->mirrors[d].rdev);
> +				return;
> +			}
>  		}
>  	}
>  	rcu_read_unlock();

