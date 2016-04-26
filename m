From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] MD: make bio mergeable
Date: Tue, 26 Apr 2016 17:56:26 +0800
Message-ID: <CACVXFVMgKQmtKRQvkpyD5GMh0AN0i7uNyq8ecVvQQ5kmdLEm+A@mail.gmail.com>
References: <384a0e0c7d6f2700aadbcbdef003cece88fa7dd7.1461626533.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <384a0e0c7d6f2700aadbcbdef003cece88fa7dd7.1461626533.git.shli@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-block@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, qkrwngud825@gmail.com, FB Kernel Team <Kernel-team@fb.com>, "v4.3+" <stable@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Tue, Apr 26, 2016 at 7:52 AM, Shaohua Li <shli@fb.com> wrote:
> blk_queue_split marks bio unmergeable, which makes sense for normal bio.
> But if dispatching the bio to underlayer disk, the blk_queue_split
> checks are invalid, hence it's possible the bio becomes mergeable.

If the bio from md is splitted and marked as NOMERGE, it means some
queue limits are reached. So looks the raid's queue limit is set as not
big enough, could your find which limit causes the splitting and nomerge?

>
> In the reported bug, this bug causes trim against raid0 performance slash
> https://bugzilla.kernel.org/show_bug.cgi?id=117051
>
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
>          * go away inside make_request
>          */
>         sectors = bio_sectors(bio);
> +       /* bio could be mergeable after passing to underlayer */
> +       bio->bi_rw &= ~REQ_NOMERGE;

IMO it isn't a good fix, eigher we need to set a correct queue limit, or
we simply don't set nomerge for all stackable block device. But I prefer
to the former a bit.

Thanks,

>         mddev->pers->make_request(mddev, bio);
>
>         cpu = part_stat_lock();
> --
> 2.8.0.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
