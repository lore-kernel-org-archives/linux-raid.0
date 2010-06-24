From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] drivers/md: raid10: Fix null pointer dereference in
 fix_read_error()
Date: Thu, 24 Jun 2010 10:16:11 +1000
Message-ID: <20100624101611.657992ec@notabene.brown>
References: <1277158475-11397-1-git-send-email-prasanna.panchamukhi@riverbed.com>
	<20100622085541.38c145ec@notabene.brown>
	<20100623024046.GA6270@ppanchamukhi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100623024046.GA6270@ppanchamukhi>
Sender: linux-raid-owner@vger.kernel.org
To: "Prasanna S. Panchamukhi" <prasanna.panchamukhi@riverbed.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Rob Becker <Rob.Becker@riverbed.com>
List-Id: linux-raid.ids

On Tue, 22 Jun 2010 19:40:47 -0700
"Prasanna S. Panchamukhi" <prasanna.panchamukhi@riverbed.com> wrote:

> On Mon, Jun 21, 2010 at 03:55:41PM -0700, Neil Brown wrote:
> > On Mon, 21 Jun 2010 15:14:35 -0700
> > prasanna.panchamukhi@riverbed.com wrote:
> > 
> > > From: Prasanna S. Panchamukhi <prasanna.panchamukhi@riverbed.com>
> > > 
> > > Such NULL pointer dereference can occur when the driver was fixing the
> > > read errors/bad blocks and the disk was physically removed
> > > causing a system crash. This patch check if the
> > > rcu_dereference() returns valid rdev before accessing it in fix_read_error().
> > > 
> > > Signed-off-by: Prasanna S. Panchamukhi <prasanna.panchamukhi@riverbed.com>
> > > Signed-off-by: Rob Becker <rbecker@riverbed.com>
> > 
> > Thanks for the patch.
> > However all that extra indenting is rather painful - and we already have more
> > than we should.
> > 
> > How about this instead?
> 
> Hi Neil,
> 
> Thanks for your review, Please find the updated patch as per your suggestion 
> below.

Thanks.  You even found a "int d;" to remove that I had missed.

I've added you patch you my queue.  It will go into -testing and then to
Linus in due course.
I have added "cc: stable@kernel.org" so that it gets included -stable
releases.

Thanks,
NeilBrown

> 
> Thanks
> Prasanna
> 
> >From c2bb6a02707335430d31dc901093108cc6046af2 Mon Sep 17 00:00:00 2001
> From: Prasanna S. Panchamukhi <prasanna.panchamukhi@riverbed.com>
> Date: Tue, 22 Jun 2010 18:59:33 -0700
> Subject: [PATCH] drivers/md: raid10: Fix null pointer dereference in fix_read_error()
> 
> Such NULL pointer dereference can occur when the driver was fixing the
> read errors/bad blocks and the disk was physically removed
> causing a system crash. This patch check if the
> rcu_dereference() returns valid rdev before accessing it in fix_read_error().
> 
> Signed-off-by: Prasanna S. Panchamukhi <prasanna.panchamukhi@riverbed.com>
> Signed-off-by: Rob Becker <rbecker@riverbed.com>
> ---
>  drivers/md/raid10.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0372499..6d420cb 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1482,14 +1482,14 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
>  	int sectors = r10_bio->sectors;
>  	mdk_rdev_t*rdev;
>  	int max_read_errors = atomic_read(&mddev->max_corr_read_errors);
> +	int d = r10_bio->devs[r10_bio->read_slot].devnum;
>  
>  	rcu_read_lock();
> -	{
> -		int d = r10_bio->devs[r10_bio->read_slot].devnum;
> +	rdev = rcu_dereference(conf->mirrors[d].rdev);
> +	if (rdev) { /* If rdev is not NULL */
>  		char b[BDEVNAME_SIZE];
>  		int cur_read_error_count = 0;
>  
> -		rdev = rcu_dereference(conf->mirrors[d].rdev);
>  		bdevname(rdev->bdev, b);
>  
>  		if (test_bit(Faulty, &rdev->flags)) {
> @@ -1530,7 +1530,7 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
>  
>  		rcu_read_lock();
>  		do {
> -			int d = r10_bio->devs[sl].devnum;
> +			d = r10_bio->devs[sl].devnum;
>  			rdev = rcu_dereference(conf->mirrors[d].rdev);
>  			if (rdev &&
>  			    test_bit(In_sync, &rdev->flags)) {
> @@ -1564,7 +1564,7 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
>  		rcu_read_lock();
>  		while (sl != r10_bio->read_slot) {
>  			char b[BDEVNAME_SIZE];
> -			int d;
> +
>  			if (sl==0)
>  				sl = conf->copies;
>  			sl--;
> @@ -1601,7 +1601,7 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
>  		}
>  		sl = start;
>  		while (sl != r10_bio->read_slot) {
> -			int d;
> +
>  			if (sl==0)
>  				sl = conf->copies;
>  			sl--;

