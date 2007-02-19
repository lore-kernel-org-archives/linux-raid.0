From: "John Stilson" <john9601@gmail.com>
Subject: Re: RAID 10 resync leading to attempt to access beyond end of device
Date: Mon, 19 Feb 2007 12:16:39 -0500
Message-ID: <e1e9d81a0702190916o3c1511d4q376a25fc4caa6cab@mail.gmail.com>
References: <e1e9d81a0702141408k4f42887by4d4c4c9aa9d536c0@mail.gmail.com>
	 <17875.40267.951634.476979@notabene.brown>
	 <e1e9d81a0702141606r7dea6288qea942cee2d978ee2@mail.gmail.com>
	 <17875.57273.543122.581106@notabene.brown>
	 <e1e9d81a0702142051v152c4c8dme2b20e1c53e1f4b2@mail.gmail.com>
	 <e1e9d81a0702151002t2b5b7e43v84ceedb7b6eed2b5@mail.gmail.com>
	 <17877.5679.419453.554504@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17877.5679.419453.554504@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey Neil,

I tested this new patch and it seems to work! I'm going to do some
more vigorous testing, and I'll let you know if any more issues bubble
out. Thanks!

-John

On 2/15/07, Neil Brown <neilb@suse.de> wrote:
> On Thursday February 15, john9601@gmail.com wrote:
> > Ok tried the patch and got a kernel BUG this time (BUG_ON(k == conf->copies)?)
>
> Thanks.... obviously I missed some subtlety.   I think I have it right
> now.
> I've tested this against a setup which I think is sufficiently
> identical to yours this time (now that I know what the important
> parameters are: device size), but if you could test it too, that would
> be great.
>
> This patch is in place of the previous patch.
>
> Thanks,
> NeilBrown
>
>
> Signed-off-by: Neil Brown <neilb@suse.de>
>
> ### Diffstat output
>  ./drivers/md/raid10.c |   39 +++++++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 18 deletions(-)
>
> diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
> --- .prev/drivers/md/raid10.c   2007-02-15 13:57:34.000000000 +1100
> +++ ./drivers/md/raid10.c       2007-02-16 13:23:55.000000000 +1100
> @@ -420,7 +420,7 @@ static sector_t raid10_find_virt(conf_t
>                 if (dev < 0)
>                         dev += conf->raid_disks;
>         } else {
> -               while (sector > conf->stride) {
> +               while (sector >= conf->stride) {
>                         sector -= conf->stride;
>                         if (dev < conf->near_copies)
>                                 dev += conf->raid_disks - conf->near_copies;
> @@ -1747,6 +1747,8 @@ static sector_t sync_request(mddev_t *md
>                                                 for (k=0; k<conf->copies; k++)
>                                                         if (r10_bio->devs[k].devnum == i)
>                                                                 break;
> +
> +                                               BUG_ON(k == conf->copies);
>                                                 bio = r10_bio->devs[1].bio;
>                                                 bio->bi_next = biolist;
>                                                 biolist = bio;
> @@ -1967,19 +1969,30 @@ static int run(mddev_t *mddev)
>         if (!conf->tmppage)
>                 goto out_free_conf;
>
> +       conf->mddev = mddev;
> +       conf->raid_disks = mddev->raid_disks;
>         conf->near_copies = nc;
>         conf->far_copies = fc;
>         conf->copies = nc*fc;
>         conf->far_offset = fo;
>         conf->chunk_mask = (sector_t)(mddev->chunk_size>>9)-1;
>         conf->chunk_shift = ffz(~mddev->chunk_size) - 9;
> +       size = mddev->size >> (conf->chunk_shift-1);
> +       sector_div(size, fc);
> +       size = size * conf->raid_disks;
> +       sector_div(size, nc);
> +       /* 'size' is now the number of chunks in the array */
> +       /* calculate "used chunks per device" in 'stride' */
> +       stride = size * conf->copies;
> +       sector_div(stride, conf->raid_disks);
> +       mddev->size = stride  << (conf->chunk_shift-1);
> +
>         if (fo)
> -               conf->stride = 1 << conf->chunk_shift;
> -       else {
> -               stride = mddev->size >> (conf->chunk_shift-1);
> +               stride = 1;
> +       else
>                 sector_div(stride, fc);
> -               conf->stride = stride << conf->chunk_shift;
> -       }
> +       conf->stride = stride << conf->chunk_shift;
> +
>         conf->r10bio_pool = mempool_create(NR_RAID10_BIOS, r10bio_pool_alloc,
>                                                 r10bio_pool_free, conf);
>         if (!conf->r10bio_pool) {
> @@ -2009,8 +2022,6 @@ static int run(mddev_t *mddev)
>
>                 disk->head_position = 0;
>         }
> -       conf->raid_disks = mddev->raid_disks;
> -       conf->mddev = mddev;
>         spin_lock_init(&conf->device_lock);
>         INIT_LIST_HEAD(&conf->retry_list);
>
> @@ -2052,16 +2063,8 @@ static int run(mddev_t *mddev)
>         /*
>          * Ok, everything is just fine now
>          */
> -       if (conf->far_offset) {
> -               size = mddev->size >> (conf->chunk_shift-1);
> -               size *= conf->raid_disks;
> -               size <<= conf->chunk_shift;
> -               sector_div(size, conf->far_copies);
> -       } else
> -               size = conf->stride * conf->raid_disks;
> -       sector_div(size, conf->near_copies);
> -       mddev->array_size = size/2;
> -       mddev->resync_max_sectors = size;
> +       mddev->array_size = size << (conf->chunk_shift-1);
> +       mddev->resync_max_sectors = size << conf->chunk_shift;
>
>         mddev->queue->issue_flush_fn = raid10_issue_flush;
>         mddev->queue->backing_dev_info.congested_fn = raid10_congested;
>
