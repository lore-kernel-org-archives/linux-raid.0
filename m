From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH] raid5: Add R5_ReadNoMerge flag which prevent bio
 from merging at block layer
Date: Wed, 4 Jul 2012 12:30:06 +1000
Message-ID: <20120704123006.031f8b5d@notabene.brown>
References: <201207031423377650880@gmail.com>
	<20120703163810.531a000c@notabene.brown>
	<201207031652444687381@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/q4y_WBxP=lDJ1tyY5hl3RAA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201207031652444687381@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, axboe <axboe@kernel.dk>
List-Id: linux-raid.ids

--Sig_/q4y_WBxP=lDJ1tyY5hl3RAA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jul 2012 16:52:49 +0800 majianpeng <majianpeng@gmail.com> wrote:

> On 2012-07-03 14:38 NeilBrown <neilb@suse.de> Wrote:
> >On Tue, 3 Jul 2012 14:23:41 +0800 majianpeng <majianpeng@gmail.com> wrot=
e:
> >
> >> Because bios will merge at block-layer,so bios-error may caused by oth=
er
> >> bio which be merged into to the same request.
> >> Using this flag,it will find exactly error-sector and not do redundant
> >> operation like re-write and re-read.
> >>=20
> >> Signed-off-by: majianpeng <majianpeng@gmail.com>
> >
> >Hi,
> > I think this patch needs a more detailed explanation.
> >
> >What exactly is the situation that causes a problem, and what exactly is=
 the
> >problem that it causes?
> >
> >Pretend that I don't know anything about what happens below the md level=
..
> >
> >Thanks,
> >NeilBrown
> >
> >
> >> ---
> >>  block/blk-core.c   |    8 ++++++++
> >>  drivers/md/raid5.c |   16 +++++++++++++---
> >>  drivers/md/raid5.h |    1 +
> >>  3 files changed, 22 insertions(+), 3 deletions(-)
> >>=20
> >> diff --git a/block/blk-core.c b/block/blk-core.c
> >> index 3c923a7..ee04bfc 100644
> >> --- a/block/blk-core.c
> >> +++ b/block/blk-core.c
> >> @@ -1401,6 +1401,9 @@ void init_request_from_bio(struct request *req, =
struct bio *bio)
> >>  	if (bio->bi_rw & REQ_RAHEAD)
> >>  		req->cmd_flags |=3D REQ_FAILFAST_MASK;
> >> =20
> >> +	if (unlikely(bio->bi_rw & REQ_NOMERGE))
> >> +		req->cmd_flags |=3D REQ_NOMERGE;
> >> +
> >>  	req->errors =3D 0;
> >>  	req->__sector =3D bio->bi_sector;
> >>  	req->ioprio =3D bio_prio(bio);
> >> @@ -1428,6 +1431,11 @@ void blk_queue_bio(struct request_queue *q, str=
uct bio *bio)
> >>  		goto get_rq;
> >>  	}
> >> =20
> >> +	if (unlikely(bio->bi_rw & REQ_NOMERGE)) {
> >> +		spin_lock_irq(q->queue_lock);
> >> +		where =3D ELEVATOR_INSERT_BACK;
> >> +		goto get_rq;
> >> +	}
> >>  	/*
> >>  	 * Check if we can merge with the plugged list before grabbing
> >>  	 * any locks.
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index d267672..04f78d2 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -632,6 +632,9 @@ static void ops_run_io(struct stripe_head *sh, str=
uct stripe_head_state *s)
> >>  			else
> >>  				bi->bi_sector =3D (sh->sector
> >>  						 + rdev->data_offset);
> >> +			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> >> +				bi->bi_rw |=3D REQ_NOMERGE;
> >> +
> >>  			bi->bi_flags =3D 1 << BIO_UPTODATE;
> >>  			bi->bi_idx =3D 0;
> >>  			bi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;
> >> @@ -1731,7 +1734,9 @@ static void raid5_end_read_request(struct bio * =
bi, int error)
> >>  			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
> >>  			clear_bit(R5_ReadError, &sh->dev[i].flags);
> >>  			clear_bit(R5_ReWrite, &sh->dev[i].flags);
> >> -		}
> >> +		} else if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> >> +			clear_bit(R5_ReadNoMerge, &sh->dev[i].flags);
> >> +
> >>  		if (atomic_read(&rdev->read_errors))
> >>  			atomic_set(&rdev->read_errors, 0);
> >>  	} else {
> >> @@ -1773,7 +1778,11 @@ static void raid5_end_read_request(struct bio *=
 bi, int error)
> >>  		else
> >>  			retry =3D 1;
> >>  		if (retry)
> >> -			set_bit(R5_ReadError, &sh->dev[i].flags);
> >> +			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags)) {
> >> +				set_bit(R5_ReadError, &sh->dev[i].flags);
> >> +				clear_bit(R5_ReadNoMerge, &sh->dev[i].flags);
> >> +			} else
> >> +				set_bit(R5_ReadNoMerge, &sh->dev[i].flags);
> >>  		else {
> >>  			clear_bit(R5_ReadError, &sh->dev[i].flags);
> >>  			clear_bit(R5_ReWrite, &sh->dev[i].flags);
> >> @@ -4481,7 +4490,8 @@ static int  retry_aligned_read(struct r5conf *co=
nf, struct bio *raid_bio)
> >>  			conf->retry_read_aligned =3D raid_bio;
> >>  			return handled;
> >>  		}
> >> -
> >> +		if (likely(raid_bio->bi_size >> 9) > STRIPE_SECTORS)
> >> +			set_bit(R5_ReadNoMerge, &sh->dev[dd_idx].flags);
> >>  		handle_stripe(sh);
> >>  		release_stripe(sh);
> >>  		handled++;
> >> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> >> index 2164021..6767d07 100644
> >> --- a/drivers/md/raid5.h
> >> +++ b/drivers/md/raid5.h
> >> @@ -273,6 +273,7 @@ enum r5dev_flags {
> >>  	R5_Wantwrite,
> >>  	R5_Overlap,	/* There is a pending overlapping request
> >>  			 * on this block */
> >> +	R5_ReadNoMerge, /* prevent bio from merging in block-layer */
> >>  	R5_ReadError,	/* seen a read error here recently */
> >>  	R5_ReWrite,	/* have tried to over-write the readerror */
> >> =20
> >
> >
> How about the below explanation:
>=20
> Because bio will be merged at block-layer,so bios-error may caused by oth=
er
> bio which be merged into to the same request.
> For example: if chunk_aligned_read failed, it will add bio to some stipe.
> But because the bio-merge function,those bios at most be merged.It will l=
ike
> the chunk_aligned_read and returen error.Then it will re-write and re-rea=
d.
> Suppose RAID5 created by n disk and chunk-size is 512K.
> If read 512k chunk_aligned and met error(sector 0 is media error),=20
> then add 512/4=3D128 stipe.If those bios merged and must be error.The rew=
rite operation
> will read (n-1) * 128 and computer 128 stripe.But using this flag,we only=
 exec one rewrite.
> This occur in resync/repair situation and chunk-aligned-read.
>=20
> May be using this flag,we can find exact bad-sector.Not recorded the whol=
e request bios=20
> as bad-sector

Thanks.  That make some sense.

I wonder if we can just use REQ_FUA to stop requests being merged, rather
than create a new flag.  In general we should probably be using REQ_FUA in
all the cases where we are checking for, and trying to fix, read errors.

Thanks,
NeilBrown


--Sig_/q4y_WBxP=lDJ1tyY5hl3RAA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/Oqrjnsnt1WYoG5AQI00w//Tsr3MIaN8CLCcS8D6de1x0is3U9x+paA
k9wwZLHGZpS5KnsLSwjShdXxlWPf/m5Qeidj9UoTDyPwz5/0iWlQCXAdSUdfUbtr
9v25FHPbIwMMzdsEReWV+ZkywqLt8RWbLhnTw/Zu7T5YgShZBOrZHAj+Nc/Rsk7a
kPyuK5py0mb3Daip9RqTuGAOAapIb3fhTC/KEn0X5u5bTBPSDmZnktOvw19X5cYW
Qh8y44FGaTuVzhashp+8vo5huSdk2kvHHJPcb33DZJJAq620qTFT+uoUv9Swys2h
F4LTNLBeB5ZMBKRYlWRBiXgLjvUC6m6uoVEX4fIkc2+RXrt0Ye0SjI4A2HV1QDn2
qjOg9ki8eWJKaW8yBOgikDs+LnUgjy+6Hf/l1Lrcg2OHHNO9WDY22lNnnW1kR0UF
aJ3d2uQZPlsNLf3SeDxWLQdeB36SHqO+hFxecoNMob5+i2m/dPxgX4yg272WENYr
LJHfme99YOOwv6AXLUpD3A4nAF4jJGKd9rxEbpK9aoze72GbR4kw3Rch58htKjxx
0pjwo/GQjS0w6ISskw/uBzYuxkAvOuXYX7Pc56M95W5mAsLSXEp+so6lRDoQ0knu
OVr/v88n8RPqHjWGkHhqAWFmZ/liEUI5OqABQ/Q7Ttq34FTpoApdZNOj/NFqPr7u
joICd/fgvx0=
=pIFc
-----END PGP SIGNATURE-----

--Sig_/q4y_WBxP=lDJ1tyY5hl3RAA--
