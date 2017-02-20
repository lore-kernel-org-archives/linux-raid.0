From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [md PATCH 10/14] md/raid1: stop using bi_phys_segment
Date: Mon, 20 Feb 2017 18:57:38 +0800
Message-ID: <CACVXFVMZqivgG39HBAjPKE+CJ3=nXZ3fD0XfujeUbe+_3J9HLg@mail.gmail.com>
References: <148721992248.7521.17160361058957519076.stgit@noble> <148721994272.7521.4656357457037580183.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148721994272.7521.4656357457037580183.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-raid.ids

On Thu, Feb 16, 2017 at 12:39 PM, NeilBrown <neilb@suse.com> wrote:
> Change to use bio->__bi_remaining to count number of r1bio attached
> to a bio.
> See precious raid10 patch for more details.
>
> inc_pending is a little more complicated in raid1 as we need to adjust
> next_window_requests or current_window_requests.
>
> The wait_event() call if start_next_window is no longer needed as each
> r1_bio is completed separately.
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/raid1.c |   99 ++++++++++++++++++----------------------------------
>  1 file changed, 34 insertions(+), 65 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index c1d0675880fb..5a57111c7bc9 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -241,36 +241,19 @@ static void reschedule_retry(struct r1bio *r1_bio)
>  static void call_bio_endio(struct r1bio *r1_bio)
>  {
>         struct bio *bio = r1_bio->master_bio;
> -       int done;
>         struct r1conf *conf = r1_bio->mddev->private;
>         sector_t start_next_window = r1_bio->start_next_window;
>         sector_t bi_sector = bio->bi_iter.bi_sector;
>
> -       if (bio->bi_phys_segments) {
> -               unsigned long flags;
> -               spin_lock_irqsave(&conf->device_lock, flags);
> -               bio->bi_phys_segments--;
> -               done = (bio->bi_phys_segments == 0);
> -               spin_unlock_irqrestore(&conf->device_lock, flags);
> -               /*
> -                * make_request() might be waiting for
> -                * bi_phys_segments to decrease
> -                */
> -               wake_up(&conf->wait_barrier);
> -       } else
> -               done = 1;
> -
>         if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>                 bio->bi_error = -EIO;
>
> -       if (done) {
> -               bio_endio(bio);
> -               /*
> -                * Wake up any possible resync thread that waits for the device
> -                * to go idle.
> -                */
> -               allow_barrier(conf, start_next_window, bi_sector);
> -       }
> +       bio_endio(bio);
> +       /*
> +        * Wake up any possible resync thread that waits for the device
> +        * to go idle.
> +        */
> +       allow_barrier(conf, start_next_window, bi_sector);
>  }
>
>  static void raid_end_bio_io(struct r1bio *r1_bio)
> @@ -923,6 +906,26 @@ static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
>         return sector;
>  }
>
> +static void inc_pending(struct r1conf *conf, sector_t start_next_window,
> +                       sector_t bi_sector)
> +{
> +       /* The current request requires multiple r1_bio, so
> +        * we need to increment the pending count, and the corresponding
> +        * window count.
> +        */
> +       spin_lock(&conf->resync_lock);
> +       conf->nr_pending++;

Just be curious, in current code 'nr_pending' is increased in wait_barrier(),
and looks this patch introduces inc_pending() to do that on each r10_bio, but
not see any change in wait_barrier(), so that means there might be issue in
current implementation about operating on this counter?

> +       if (start_next_window == conf->start_next_window) {
> +               if (conf->start_next_window + NEXT_NORMALIO_DISTANCE
> +                   <= bi_sector)
> +                       conf->next_window_requests++;
> +               else
> +                       conf->current_window_requests++;
> +       } else
> +               conf->current_window_requests++;
> +       spin_unlock(&conf->resync_lock);
> +}
> +
>  static void allow_barrier(struct r1conf *conf, sector_t start_next_window,
>                           sector_t bi_sector)
>  {
> @@ -1137,12 +1140,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>                 sectors_handled = (r1_bio->sector + max_sectors
>                                    - bio->bi_iter.bi_sector);
>                 r1_bio->sectors = max_sectors;
> -               spin_lock_irq(&conf->device_lock);
> -               if (bio->bi_phys_segments == 0)
> -                       bio->bi_phys_segments = 2;
> -               else
> -                       bio->bi_phys_segments++;
> -               spin_unlock_irq(&conf->device_lock);
> +               bio_inc_remaining(bio);
>
>                 /*
>                  * Cannot call generic_make_request directly as that will be
> @@ -1304,7 +1302,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>         if (unlikely(blocked_rdev)) {
>                 /* Wait for this device to become unblocked */
>                 int j;
> -               sector_t old = start_next_window;
>
>                 for (j = 0; j < i; j++)
>                         if (r1_bio->bios[j])
> @@ -1314,15 +1311,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>                 raid1_log(mddev, "wait rdev %d blocked", blocked_rdev->raid_disk);
>                 md_wait_for_blocked_rdev(blocked_rdev, mddev);
>                 start_next_window = wait_barrier(conf, bio);
> -               /*
> -                * We must make sure the multi r1bios of bio have
> -                * the same value of bi_phys_segments
> -                */
> -               if (bio->bi_phys_segments && old &&
> -                   old != start_next_window)
> -                       /* Wait for the former r1bio(s) to complete */
> -                       wait_event(conf->wait_barrier,
> -                                  bio->bi_phys_segments == 1);
>                 goto retry_write;
>         }
>
> @@ -1417,22 +1405,18 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>          * as it could result in the bio being freed.
>          */
>         if (sectors_handled < bio_sectors(bio)) {
> -               /* We need another r1_bio, which must be accounted
> -                * in bio->bi_phys_segments
> -                */
> -               spin_lock_irq(&conf->device_lock);
> -               if (bio->bi_phys_segments == 0)
> -                       bio->bi_phys_segments = 2;
> -               else
> -                       bio->bi_phys_segments++;
> -               spin_unlock_irq(&conf->device_lock);
> +               /* We need another r1_bio, which must be counted */
> +               sector_t sect = bio->bi_iter.bi_sector + sectors_handled;
> +
> +               inc_pending(conf, start_next_window, sect);
> +               bio_inc_remaining(bio);
>                 r1_bio_write_done(r1_bio);
>                 r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
>                 r1_bio->master_bio = bio;
>                 r1_bio->sectors = bio_sectors(bio) - sectors_handled;
>                 r1_bio->state = 0;
>                 r1_bio->mddev = mddev;
> -               r1_bio->sector = bio->bi_iter.bi_sector + sectors_handled;
> +               r1_bio->sector = sect;
>                 goto retry_write;
>         }
>
> @@ -1460,16 +1444,6 @@ static void raid1_make_request(struct mddev *mddev, struct bio *bio)
>         r1_bio->mddev = mddev;
>         r1_bio->sector = bio->bi_iter.bi_sector;
>
> -       /*
> -        * We might need to issue multiple reads to different devices if there
> -        * are bad blocks around, so we keep track of the number of reads in
> -        * bio->bi_phys_segments.  If this is 0, there is only one r1_bio and
> -        * no locking will be needed when requests complete.  If it is
> -        * non-zero, then it is the number of not-completed requests.
> -        */
> -       bio->bi_phys_segments = 0;
> -       bio_clear_flag(bio, BIO_SEG_VALID);
> -
>         if (bio_data_dir(bio) == READ)
>                 raid1_read_request(mddev, bio, r1_bio);
>         else
> @@ -2434,12 +2408,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>                         int sectors_handled = (r1_bio->sector + max_sectors
>                                                - mbio->bi_iter.bi_sector);
>                         r1_bio->sectors = max_sectors;
> -                       spin_lock_irq(&conf->device_lock);
> -                       if (mbio->bi_phys_segments == 0)
> -                               mbio->bi_phys_segments = 2;
> -                       else
> -                               mbio->bi_phys_segments++;
> -                       spin_unlock_irq(&conf->device_lock);
> +                       bio_inc_remaining(mbio);
>                         trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
>                                               bio, bio_dev, bio_sector);
>                         generic_make_request(bio);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Ming Lei
