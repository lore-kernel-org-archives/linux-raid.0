From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH] md: improve io stats accounting
Date: Mon, 8 Jun 2020 16:37:27 +0200
Message-ID: <d09aefa9-00ed-ef94-f5c4-50be91828170@cloud.ionos.com>
References: <20200601161256.27718-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200601161256.27718-1-artur.paszkiewicz@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/1/20 6:12 PM, Artur Paszkiewicz wrote:
> Use generic io accounting functions to manage io stats. There was an
> attempt to do this earlier in commit 18c0b223cf990172 ("md: use generic
> io stats accounting functions to simplify io stat accounting"), but it
> did not include a call to generic_end_io_acct() and caused issues with
> tracking in-flight IOs, so it was later removed in commit
> 74672d069b298b03 ("md: fix md io stats accounting broken").
>
> This patch attempts to fix this by using both generic_start_io_acct()
> and generic_end_io_acct(). To make it possible, in md_make_request() a
> bio is cloned with additional data - struct md_io, which includes the io
> start_time. A new bioset is introduced for this purpose. We call
> generic_start_io_acct() and pass the clone instead of the original to
> md_handle_request(). When it completes, we call generic_end_io_acct()
> and complete the original bio.
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
>   drivers/md/md.c | 65 +++++++++++++++++++++++++++++++++++++++----------
>   drivers/md/md.h |  1 +
>   2 files changed, 53 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f567f536b529..5a9f167ef5b9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -463,12 +463,32 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
>   }
>   EXPORT_SYMBOL(md_handle_request);
>   
> +struct md_io {
> +	struct mddev *mddev;
> +	struct bio *orig_bio;
> +	unsigned long start_time;
> +	struct bio orig_bio_clone;
> +};
> +
> +static void md_end_request(struct bio *bio)
> +{
> +	struct md_io *md_io = bio->bi_private;
> +	struct mddev *mddev = md_io->mddev;
> +	struct bio *orig_bio = md_io->orig_bio;
> +
> +	orig_bio->bi_status = bio->bi_status;
> +
> +	generic_end_io_acct(mddev->queue, bio_op(orig_bio),
> +			    &mddev->gendisk->part0, md_io->start_time);

[...]

> +		generic_start_io_acct(mddev->queue, bio_op(bio),
> +				      bio_sectors(bio), &mddev->gendisk->part0);
> +	}
> +

Now, you need to switch to call bio_{start,end}_io_acct instead of
generic_{start,end}_io_acct after the changes from Christoph.

Thanks,
Guoqing
