From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid1: avoid reusing a resync bio after error
 handling.
Date: Mon, 10 Apr 2017 11:04:58 -0700
Message-ID: <20170410180458.5kco236g3gw2kcxm@kernel.org>
References: <87bmsaguhe.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87bmsaguhe.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Michael Wang <yun.wang@profitbricks.com>
List-Id: linux-raid.ids

On Thu, Apr 06, 2017 at 12:06:37PM +1000, Neil Brown wrote:
> 
> fix_sync_read_error() modifies a bio on a newly faulty
> device by setting bi_end_io to end_sync_write.
> This ensure that put_buf() will still call rdev_dec_pending()
> as required, but makes sure that subsequent code in
> fix_sync_read_error() doesn't try to read from the device.
> 
> Unfortunately this interacts badly with sync_request_write()
> which assumes that any bio with bi_end_io set to non-NULL
> other than end_sync_read is safe to write to.
> 
> As the device is now faulty it doesn't make sense to write.
> As the bio was recently used for a read, it is "dirty"
> and not suitable for immediate submission.
> In particular, ->bi_next might be non-NULL, which will cause
> generic_make_request() to complain.
> 
> Break this interaction by refusing to write to devices
> which are marked as Faulty.
> 
> Reported-and-tested-by: Michael Wang <yun.wang@profitbricks.com>
> Fixes: 2e52d449bcec ("md/raid1: add failfast handling for reads.")
> Cc: stable@vger.kernel.org (v4.10+)
> Signed-off-by: NeilBrown <neilb@suse.com>

Thanks, applied!

> ---
>  drivers/md/raid1.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index a70283753a35..9c1b2231d2db 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2185,6 +2185,8 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
>  		     (i == r1_bio->read_disk ||
>  		      !test_bit(MD_RECOVERY_SYNC, &mddev->recovery))))
>  			continue;
> +		if (test_bit(Faulty, &conf->mirrors[i].rdev->flags))
> +			continue;
>  
>  		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
>  		if (test_bit(FailFast, &conf->mirrors[i].rdev->flags))
> -- 
> 2.12.2
> 


