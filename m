From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH v2] md: improve io stats accounting
Date: Thu, 2 Jul 2020 15:55:22 +0200
Message-ID: <c2579e84-dc89-68fe-f6fc-81ad80d3f3ee@cloud.ionos.com>
References: <20200702105440.17097-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200702105440.17097-1-artur.paszkiewicz@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 7/2/20 12:54 PM, Artur Paszkiewicz wrote:
> Use generic io accounting functions to manage io stats. There was an
> attempt to do this earlier in commit 18c0b223cf99 ("md: use generic io
> stats accounting functions to simplify io stat accounting"), but it did
> not include a call to generic_end_io_acct() and caused issues with
> tracking in-flight IOs, so it was later removed in commit 74672d069b29
> ("md: fix md io stats accounting broken").
>
> This patch attempts to fix this by using both bio_start_io_acct() and
> bio_end_io_acct(). To make it possible, a struct md_io is allocated for
> every new md bio, which includes the io start_time. A new mempool is
> introduced for this purpose. We override bio->bi_end_io with our own
> callback and call bio_start_io_acct() before passing the bio to
> md_handle_request(). When it completes, we call bio_end_io_acct() and
> the original bi_end_io callback.
>
> This adds correct statistics about in-flight IOs and IO processing time,
> interpreted e.g. in iostat as await, svctm, aqu-sz and %util.
>
> It also fixes a situation where too many IOs where reported if a bio was
> re-submitted to the mddev, because io accounting is now performed only
> on newly arriving bios.
>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
> v2:
> - Just override the bi_end_io without having to clone the original bio.
> - Rebased onto latest md-next.
>
>   drivers/md/md.c | 56 ++++++++++++++++++++++++++++++++++++++-----------
>   drivers/md/md.h |  1 +
>   2 files changed, 45 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 8bb69c61afe0..25dd3f4116c3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -463,12 +463,33 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
>   }
>   EXPORT_SYMBOL(md_handle_request);
>   
> +struct md_io {
> +	struct mddev *mddev;
> +	bio_end_io_t *orig_bi_end_io;
> +	void *orig_bi_private;
> +	unsigned long start_time;
> +};
> +
> +static void md_end_io(struct bio *bio)
> +{
> +	struct md_io *md_io = bio->bi_private;
> +	struct mddev *mddev = md_io->mddev;
> +
> +	bio_end_io_acct(bio, md_io->start_time);
> +
> +	bio->bi_end_io = md_io->orig_bi_end_io;
> +	bio->bi_private = md_io->orig_bi_private;
> +
> +	mempool_free(md_io, &mddev->md_io_pool);
> +
> +	if (bio->bi_end_io)
> +		bio->bi_end_io(bio);
> +}
> +
>   static blk_qc_t md_submit_bio(struct bio *bio)
>   {
>   	const int rw = bio_data_dir(bio);
> -	const int sgrp = op_stat_group(bio_op(bio));
>   	struct mddev *mddev = bio->bi_disk->private_data;
> -	unsigned int sectors;
>   
>   	if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw == WRITE)) {
>   		bio_io_error(bio);
> @@ -488,21 +509,26 @@ static blk_qc_t md_submit_bio(struct bio *bio)
>   		return BLK_QC_T_NONE;
>   	}
>   
> -	/*
> -	 * save the sectors now since our bio can
> -	 * go away inside make_request
> -	 */
> -	sectors = bio_sectors(bio);
> +	if (bio->bi_end_io != md_end_io) {
> +		struct md_io *md_io;
> +
> +		md_io = mempool_alloc(&mddev->md_io_pool, GFP_NOIO);
> +		md_io->mddev = mddev;
> +		md_io->start_time = jiffies;
> +		md_io->orig_bi_end_io = bio->bi_end_io;
> +		md_io->orig_bi_private = bio->bi_private;
> +
> +		bio->bi_end_io = md_end_io;
> +		bio->bi_private = md_io;
> +
> +		bio_start_io_acct(bio);

It can just be "md_io->start_time = bio_start_io_acct(bio)", with that

Acked-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

Thanks,
Guoqing
