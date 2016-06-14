From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: [PATCH 1/4] raid1: Add a filed array_frozen to indicate whether
 raid in freeze state.
Date: Tue, 14 Jun 2016 12:33:50 +0300
Message-ID: <CAGRgLy4H7opRJm_oHYRiTms3KLmj8k_ZmnuyCfGCuNtmWB-MMA@mail.gmail.com>
References: <201308281940120331425@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201308281940120331425@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
Cc: Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids

Hello Jianpeng Ma, Neil,

This commit seems to introduce a severe regression, leading to IO
getting stuck on the whole array.

Previously, the condition of wait_barrier() was:
                wait_event_lock_irq(conf->wait_barrier,
                                    !conf->barrier ||
                                    (conf->nr_pending &&
                                     current->bio_list &&
                                     !bio_list_empty(current->bio_list)),
                                    conf->resync_lock);
This means that if current->bio_list is not empty, we will not wait
for the barrier to drop.

But right now the condition is:
                wait_event_lock_irq(conf->wait_barrier,
                                    !conf->array_frozen &&
                                    (!conf->barrier ||
                                    (conf->nr_pending &&
                                     current->bio_list &&
                                     !bio_list_empty(current->bio_list))),
                                    conf->resync_lock);

This means that if somebody calls freeze_array (for example,
md_do_sync), then freeze_array unconditionally sets:
 conf->array_frozen = 1;

And then if somebody calls wait_barrier and its current->bio_list is
not empty, it will still wait, because array_frozen=1. But
freeze_array is waiting for the bio complete, but this bio sits in
current->bio_list and will never get submitted, because we are waiting
in wait_barrier. DEADLOCK.

For me it happens on kernel 3.18, when raid1.c::make_request() submits
a READ bio, which has raid1_end_read_request completion routine. But
this completion routine never gets called, and I also confirmed that
no IO is stuck on lower levels.

Additional notes:
# Please see my email titled "RAID1: deadlock between freeze_array and
blk plug?" in http://permalink.gmane.org/gmane.linux.raid/52693. The
problem described there also stems from the fact that now
freeze_array() sets array_frozen=1 unconditionally. And wait_barrier()
will always wait if array_frozen!=0.

# Also now freeze_array() is non-reentrant. Meaning that if two
threads call freeze_array in parallel, it will not work, because
array_frozen can only be 1 or 0. Example, when freeze_array can be
called by two threads:
- We have 3-way RAID1 with one drive missing. We want to recover this drive.
- we have an in-flight READ request
- md_do_sync starts recovery and calls mddev->pers->quiesce(mddev, 1),
which waits for the in-flight READ to complete
- meanwhile the READ bio fails
- so raid1d calls handle_read_error, which calls freeze_array
Result: we have two freeze_array calls in parallel. But we don't know
to account for them properly, because array_frozen can only be 1 or 0.

Please advise how to fix this problem. Please kindly note that the fix
should apply to kernel 3.18; which is a longterm kernel that we use.

Thanks,
Alex.


On Wed, Aug 28, 2013 at 2:40 PM, majianpeng <majianpeng@gmail.com> wrote:
> Because the following patch will rewrite the contend between nornal IO
> and resync IO. So we used a parameter to indicate whether raid is in freeze
> array.
>
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c | 15 +++++++--------
>  drivers/md/raid1.h |  1 +
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d60412c..92a6d29 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -829,6 +829,7 @@ static void raise_barrier(struct r1conf *conf)
>
>         /* Now wait for all pending IO to complete */
>         wait_event_lock_irq(conf->wait_barrier,
> +                           !conf->array_frozen &&
>                             !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
>                             conf->resync_lock);
>
> @@ -860,10 +861,11 @@ static void wait_barrier(struct r1conf *conf)
>                  * count down.
>                  */
>                 wait_event_lock_irq(conf->wait_barrier,
> -                                   !conf->barrier ||
> +                                   !conf->array_frozen &&
> +                                   (!conf->barrier ||
>                                     (conf->nr_pending &&
>                                      current->bio_list &&
> -                                    !bio_list_empty(current->bio_list)),
> +                                    !bio_list_empty(current->bio_list))),
>                                     conf->resync_lock);
>                 conf->nr_waiting--;
>         }
> @@ -884,8 +886,7 @@ static void freeze_array(struct r1conf *conf, int extra)
>  {
>         /* stop syncio and normal IO and wait for everything to
>          * go quite.
> -        * We increment barrier and nr_waiting, and then
> -        * wait until nr_pending match nr_queued+extra
> +        * We wait until nr_pending match nr_queued+extra
>          * This is called in the context of one normal IO request
>          * that has failed. Thus any sync request that might be pending
>          * will be blocked by nr_pending, and we need to wait for
> @@ -895,8 +896,7 @@ static void freeze_array(struct r1conf *conf, int extra)
>          * we continue.
>          */
>         spin_lock_irq(&conf->resync_lock);
> -       conf->barrier++;
> -       conf->nr_waiting++;
> +       conf->array_frozen = 1;
>         wait_event_lock_irq_cmd(conf->wait_barrier,
>                                 conf->nr_pending == conf->nr_queued+extra,
>                                 conf->resync_lock,
> @@ -907,8 +907,7 @@ static void unfreeze_array(struct r1conf *conf)
>  {
>         /* reverse the effect of the freeze */
>         spin_lock_irq(&conf->resync_lock);
> -       conf->barrier--;
> -       conf->nr_waiting--;
> +       conf->array_frozen = 0;
>         wake_up(&conf->wait_barrier);
>         spin_unlock_irq(&conf->resync_lock);
>  }
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index 0ff3715..331a98a 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -65,6 +65,7 @@ struct r1conf {
>         int                     nr_waiting;
>         int                     nr_queued;
>         int                     barrier;
> +       int                     array_frozen;
>
>         /* Set to 1 if a full sync is needed, (fresh device added).
>          * Cleared when a sync completes.
> --
> 1.8.1.2
