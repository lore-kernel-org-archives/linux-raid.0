From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: [PATCH] MD: make bio mergeable
Date: Thu, 28 Apr 2016 20:00:22 +0000 (UTC)
Message-ID: <alpine.LRH.2.20.1604281933200.31165@diagnostix.dwd.de>
References: <384a0e0c7d6f2700aadbcbdef003cece88fa7dd7.1461626533.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <384a0e0c7d6f2700aadbcbdef003cece88fa7dd7.1461626533.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-block@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, qkrwngud825@gmail.com, Kernel-team@fb.com, Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@fb.com>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hello,

On Mon, 25 Apr 2016, Shaohua Li wrote:

> blk_queue_split marks bio unmergeable, which makes sense for normal bio.
> But if dispatching the bio to underlayer disk, the blk_queue_split
> checks are invalid, hence it's possible the bio becomes mergeable.
> 
> In the reported bug, this bug causes trim against raid0 performance slash
> https://bugzilla.kernel.org/show_bug.cgi?id=117051
> 
This patch makes a huge difference. On a system with two Samsung 850 Pro
in a MD Raid0 setup the time for fstrim went down from ~30min to 18sec!

However, on another system with two Intel P3700 1.6TB NVMe PCIe SSD's
also setup as one big MD Raid0, the patch does not make any difference
at all. fstrim takes more then 4 hours!

Any idea what could be wrong?

Regards,
Holger


> Reported-by: Park Ju Hyung <qkrwngud825@gmail.com>
> Fixes: 6ac45aeb6bca(block: avoid to merge splitted bio)
> Cc: stable@vger.kernel.org (v4.3+)
> Cc: Ming Lei <ming.lei@canonical.com>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Neil Brown <neilb@suse.de>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 194580f..14d3b37 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -284,6 +284,8 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
>  	 * go away inside make_request
>  	 */
>  	sectors = bio_sectors(bio);
> +	/* bio could be mergeable after passing to underlayer */
> +	bio->bi_rw &= ~REQ_NOMERGE;
>  	mddev->pers->make_request(mddev, bio);
>  
>  	cpu = part_stat_lock();
> -- 
> 2.8.0.rc2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
