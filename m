From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/3] md/raid10: move rdev->corrected_errors counting
Date: Thu, 14 Jul 2011 15:54:57 +1000
Message-ID: <20110714155457.3fd45623@notabene.brown>
References: <1309279646-4950-1-git-send-email-namhyung@gmail.com>
	<1309279646-4950-4-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1309279646-4950-4-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Jun 2011 01:47:26 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> Read errors are considered to corrected if write-back and re-read
> cycle is finished without further problems. Thus moving the rdev->
> corrected_errors counting after the re-reading looks more reasonable
> IMHO.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
> For end_sync_read(), I'm not sure what should I do. But I think, at
> least, the counting should be moved to end_sync_write() and that
> might require additional field(s) in r10_bio. So I leave it as is
> for simplicity now. How do you think?

I don't think it really matters.
If the read error doesn't get corrected, then the device will be failed
and the 'corrected_errors' count won't mean anything any more...

Maybe we should just change the field to 'read_errors' and adjust it whenever
we get a read error.  If the device is still in the array, then the error
must have been corrected, if not, it count will be ignored.

There is a corner case where we don't evict the last mirror from an array due
to a read error - we would need to handle that some how.

But otherwise I don't think this is an issue.

I have applied all three patches because they do make the code a bit cleaner
and clear, but I don't think we really need to worry further about RAID10.

Thanks,

NeilBrown



> 
>  drivers/md/raid10.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 8628a62a02f0..0660bc9597d8 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1524,7 +1524,6 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
>  			    test_bit(In_sync, &rdev->flags)) {
>  				atomic_inc(&rdev->nr_pending);
>  				rcu_read_unlock();
> -				atomic_add(s, &rdev->corrected_errors);
>  				if (sync_page_io(rdev,
>  						 r10_bio->devs[sl].addr +
>  						 sect,
> @@ -1589,6 +1588,7 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
>  					       (unsigned long long)(
>  						       sect + rdev->data_offset),
>  					       bdevname(rdev->bdev, b));
> +					atomic_add(s, &rdev->corrected_errors);
>  				}
>  
>  				rdev_dec_pending(rdev, mddev);

