From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH] raid5: Add R5_ReadNoMerge flag which prevent bio
 from merging at block layer
Date: Tue, 3 Jul 2012 16:38:10 +1000
Message-ID: <20120703163810.531a000c@notabene.brown>
References: <201207031423377650880@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0bGb9at4zO8lflMAOY1kowI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201207031423377650880@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, axboe <axboe@kernel.dk>
List-Id: linux-raid.ids

--Sig_/0bGb9at4zO8lflMAOY1kowI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jul 2012 14:23:41 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Because bios will merge at block-layer,so bios-error may caused by other
> bio which be merged into to the same request.
> Using this flag,it will find exactly error-sector and not do redundant
> operation like re-write and re-read.
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>

Hi,
 I think this patch needs a more detailed explanation.

What exactly is the situation that causes a problem, and what exactly is the
problem that it causes?

Pretend that I don't know anything about what happens below the md level..

Thanks,
NeilBrown


> ---
>  block/blk-core.c   |    8 ++++++++
>  drivers/md/raid5.c |   16 +++++++++++++---
>  drivers/md/raid5.h |    1 +
>  3 files changed, 22 insertions(+), 3 deletions(-)
>=20
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3c923a7..ee04bfc 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1401,6 +1401,9 @@ void init_request_from_bio(struct request *req, str=
uct bio *bio)
>  	if (bio->bi_rw & REQ_RAHEAD)
>  		req->cmd_flags |=3D REQ_FAILFAST_MASK;
> =20
> +	if (unlikely(bio->bi_rw & REQ_NOMERGE))
> +		req->cmd_flags |=3D REQ_NOMERGE;
> +
>  	req->errors =3D 0;
>  	req->__sector =3D bio->bi_sector;
>  	req->ioprio =3D bio_prio(bio);
> @@ -1428,6 +1431,11 @@ void blk_queue_bio(struct request_queue *q, struct=
 bio *bio)
>  		goto get_rq;
>  	}
> =20
> +	if (unlikely(bio->bi_rw & REQ_NOMERGE)) {
> +		spin_lock_irq(q->queue_lock);
> +		where =3D ELEVATOR_INSERT_BACK;
> +		goto get_rq;
> +	}
>  	/*
>  	 * Check if we can merge with the plugged list before grabbing
>  	 * any locks.
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d267672..04f78d2 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -632,6 +632,9 @@ static void ops_run_io(struct stripe_head *sh, struct=
 stripe_head_state *s)
>  			else
>  				bi->bi_sector =3D (sh->sector
>  						 + rdev->data_offset);
> +			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> +				bi->bi_rw |=3D REQ_NOMERGE;
> +
>  			bi->bi_flags =3D 1 << BIO_UPTODATE;
>  			bi->bi_idx =3D 0;
>  			bi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;
> @@ -1731,7 +1734,9 @@ static void raid5_end_read_request(struct bio * bi,=
 int error)
>  			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
>  			clear_bit(R5_ReadError, &sh->dev[i].flags);
>  			clear_bit(R5_ReWrite, &sh->dev[i].flags);
> -		}
> +		} else if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> +			clear_bit(R5_ReadNoMerge, &sh->dev[i].flags);
> +
>  		if (atomic_read(&rdev->read_errors))
>  			atomic_set(&rdev->read_errors, 0);
>  	} else {
> @@ -1773,7 +1778,11 @@ static void raid5_end_read_request(struct bio * bi=
, int error)
>  		else
>  			retry =3D 1;
>  		if (retry)
> -			set_bit(R5_ReadError, &sh->dev[i].flags);
> +			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags)) {
> +				set_bit(R5_ReadError, &sh->dev[i].flags);
> +				clear_bit(R5_ReadNoMerge, &sh->dev[i].flags);
> +			} else
> +				set_bit(R5_ReadNoMerge, &sh->dev[i].flags);
>  		else {
>  			clear_bit(R5_ReadError, &sh->dev[i].flags);
>  			clear_bit(R5_ReWrite, &sh->dev[i].flags);
> @@ -4481,7 +4490,8 @@ static int  retry_aligned_read(struct r5conf *conf,=
 struct bio *raid_bio)
>  			conf->retry_read_aligned =3D raid_bio;
>  			return handled;
>  		}
> -
> +		if (likely(raid_bio->bi_size >> 9) > STRIPE_SECTORS)
> +			set_bit(R5_ReadNoMerge, &sh->dev[dd_idx].flags);
>  		handle_stripe(sh);
>  		release_stripe(sh);
>  		handled++;
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 2164021..6767d07 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -273,6 +273,7 @@ enum r5dev_flags {
>  	R5_Wantwrite,
>  	R5_Overlap,	/* There is a pending overlapping request
>  			 * on this block */
> +	R5_ReadNoMerge, /* prevent bio from merging in block-layer */
>  	R5_ReadError,	/* seen a read error here recently */
>  	R5_ReWrite,	/* have tried to over-write the readerror */
> =20


--Sig_/0bGb9at4zO8lflMAOY1kowI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/KTUjnsnt1WYoG5AQL/kw//TxdUYfx7W4VkAHcMDACDwiEwyBIlfAiw
9AC0kmHqbim2PdvyYpSe5BG6A2CfN8EG2w6Q0VqgfP/rH4WPcnTggZdccmZ4kkTM
NV/a7aePJmy0CMZg1z5YTaN1Ds/Q2pL6ukyA5QXPBTb4/wuU/+pGuIQD6+Q3A/iq
hbK3g9Ym8/0GMmgacog3mAyOfXYBQnMi01m7iSItrsImgmgbNA3v0Z8LUg2noyR4
SNrp0eZMBtD24ccPvq8dgqz7+11f3TVKfVGlbhuWhgqxAGPgg9SuyrLp6lhEaPfS
gjh1B2ijOGcU9UtyTNwvZVWSRiGzy9HTG9OpWpoRirCetPc0443itYSkBdhzGR7Z
GPW+5VeM2N0hn/wWLT2kO2Xyn8HRPQzxuMahPRIjS+317U4BdGFK8CrXMBw305K8
5sxj3KeLQM5E2aCIHn9LIrR+U3BJokvi3sE/RY9knXRMP0XMjcEF3BmMnyRAZGpF
Zx9XtBnu27SC8S8ra8mzVRVEVlNFw5qbnBOhvDYW4YMV9FLq8Vt8h7W+1KJ5SHvA
punt2PLwodJmYkTXuP4UFednLokR5i1jj3P0cn9+uSKfxASyWAO8OsirPlsWZAU1
U0fpo5/YK4g8wuI1N/1j5977gwZOayQhK/b3E/NSpaKfqQB3TjOv+e4qhuIZBbic
mkiKoAv8ysQ=
=oVpy
-----END PGP SIGNATURE-----

--Sig_/0bGb9at4zO8lflMAOY1kowI--
