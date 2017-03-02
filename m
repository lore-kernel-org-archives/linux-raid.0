From: =?UTF-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>
Subject: Re: [PATCH] md/raid1/10: fix potential deadlock
Date: Thu, 2 Mar 2017 18:04:59 +0100
Message-ID: <CAD9gYJKpxqR6RHpXS86WFciSZZ6ZsbD9Vmp39DBb7FMkuck7SA@mail.gmail.com>
References: <b5d7363c5bb03ee017d42f09cf16d9e41e0aa8eb.1488315832.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b5d7363c5bb03ee017d42f09cf16d9e41e0aa8eb.1488315832.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Coly Li <colyli@suse.de>, "v3.14+, only the raid10 part" <stable@vger.kernel.org>
List-Id: linux-raid.ids

2017-02-28 22:08 GMT+01:00 Shaohua Li <shli@fb.com>:
> Neil Brown pointed out a potential deadlock in raid 10 code with
> bio_split/chain. The raid1 code could have the same issue, but recent
> barrier rework makes it less likely to happen. The deadlock happens in
> below sequence:
>
> 1. generic_make_request(bio), this will set current->bio_list
> 2. raid10_make_request will split bio to bio1 and bio2
> 3. __make_request(bio1), wait_barrer, add underlayer disk bio to
> current->bio_list
> 4. __make_request(bio2), wait_barrer
>
> If raise_barrier happens between 3 & 4, since wait_barrier runs at 3,
> raise_barrier waits for IO completion from 3. And since raise_barrier
> sets barrier, 4 waits for raise_barrier. But IO from 3 can't be
> dispatched because raid10_make_request() doesn't finished yet.
>
> The solution is to adjust the IO ordering. Quotes from Neil:
> "
> It is much safer to:
>
>     if (need to split) {
>         split =3D bio_split(bio, ...)
>         bio_chain(...)
>         make_request_fn(split);
>         generic_make_request(bio);
>    } else
>         make_request_fn(mddev, bio);
>
> This way we first process the initial section of the bio (in 'split')
> which will queue some requests to the underlying devices.  These
> requests will be queued in generic_make_request.
> Then we queue the remainder of the bio, which will be added to the end
> of the generic_make_request queue.
> Then we return.
> generic_make_request() will pop the lower-level device requests off the
> queue and handle them first.  Then it will process the remainder
> of the original bio once the first section has been fully processed.
> "
>
> Cc: Coly Li <colyli@suse.de>
> Cc: =E7=8E=8B=E9=87=91=E6=B5=A6 <jinpuwang@gmail.com>
> Cc: stable@vger.kernel.org (v3.14+, only the raid10 part)
> Suggested-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid1.c  | 25 +++++++++++++++++++++++--
>  drivers/md/raid10.c | 18 ++++++++++++++++++
>  2 files changed, 41 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 551d654..3c5933b 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1584,9 +1584,30 @@ static void raid1_make_request(struct mddev *mddev=
, struct bio *bio)
>                         split =3D bio;
>                 }
>
> -               if (bio_data_dir(split) =3D=3D READ)
> +               if (bio_data_dir(split) =3D=3D READ) {
>                         raid1_read_request(mddev, split);
> -               else
> +
> +                       /*
> +                        * If a bio is splitted, the first part of bio wi=
ll
> +                        * pass barrier but the bio is queued in
> +                        * current->bio_list (see generic_make_request). =
If
> +                        * there is a raise_barrier() called here, the se=
cond
> +                        * part of bio can't pass barrier. But since the =
first
> +                        * part bio isn't dispatched to underlaying disks=
 yet,
> +                        * the barrier is never released, hence raise_bar=
rier
> +                        * will alays wait. We have a deadlock.
> +                        * Note, this only happens in read path. For writ=
e
> +                        * path, the first part of bio is dispatched in a
> +                        * schedule() call (because of blk plug) or offlo=
aded
> +                        * to raid10d.
> +                        * Quitting from the function immediately can cha=
nge
> +                        * the bio order queued in bio_list and avoid the=
 deadlock.
> +                        */
> +                       if (split !=3D bio) {
> +                               generic_make_request(bio);
> +                               break;
> +                       }
> +               } else
>                         raid1_write_request(mddev, split);
>         } while (split !=3D bio);
>  }
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index c4db6d1..b1b1f98 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1584,7 +1584,25 @@ static void raid10_make_request(struct mddev *mdde=
v, struct bio *bio)
>                         split =3D bio;
>                 }
>
> +               /*
> +                * If a bio is splitted, the first part of bio will pass
> +                * barrier but the bio is queued in current->bio_list (se=
e
> +                * generic_make_request). If there is a raise_barrier() c=
alled
> +                * here, the second part of bio can't pass barrier. But s=
ince
> +                * the first part bio isn't dispatched to underlaying dis=
ks
> +                * yet, the barrier is never released, hence raise_barrie=
r will
> +                * alays wait. We have a deadlock.
> +                * Note, this only happens in read path. For write path, =
the
> +                * first part of bio is dispatched in a schedule() call
> +                * (because of blk plug) or offloaded to raid10d.
> +                * Quitting from the function immediately can change the =
bio
> +                * order queued in bio_list and avoid the deadlock.
> +                */
>                 __make_request(mddev, split);
> +               if (split !=3D bio && bio_data_dir(bio) =3D=3D READ) {
> +                       generic_make_request(bio);
> +                       break;
> +               }
>         } while (split !=3D bio);
>
>         /* In case raid10d snuck in to freeze_array */
> --
> 2.9.3
>
Looks good to me!
Reviewed-by:  Jack Wang <jinpu.wang@profitbricks.com>

Thanks!
