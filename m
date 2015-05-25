From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v4 06/11] md/raid5: get rid of bio_fits_rdev()
Date: Mon, 25 May 2015 17:54:14 +1000
Message-ID: <20150525175414.6a1fc33d@notabene.brown>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-7-git-send-email-mlin@kernel.org>
	<20150525154829.4330f149@notabene.brown>
	<CAF1ivSY+ky5PD=m34KXU4z9gE_v4uztaFT=MuU4g69DtXD9vWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/WZ0g4/NCdMk4xFKmLqdZW.v"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSY+ky5PD=m34KXU4z9gE_v4uztaFT=MuU4g69DtXD9vWA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WZ0g4/NCdMk4xFKmLqdZW.v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 May 2015 00:03:20 -0700 Ming Lin <mlin@kernel.org> wrote:

> On Sun, May 24, 2015 at 10:48 PM, NeilBrown <neilb@suse.de> wrote:
> > On Fri, 22 May 2015 11:18:38 -0700 Ming Lin <mlin@kernel.org> wrote:
> >
> >> From: Kent Overstreet <kent.overstreet@gmail.com>
> >>
> >> Remove bio_fits_rdev() completely, because ->merge_bvec_fn() has now
> >> gone. There's no point in calling bio_fits_rdev() only for ensuring
> >> aligned read from rdev.
> >
> > Surely this patch should come *before*
> >   [PATCH v4 07/11] md/raid5: split bio for chunk_aligned_read
>=20
> PATCH 6, then PATCH 7, isn't it already *before*?

Did I write that?  I guess I did :-(
I meant *after*.   Don't get rid of bio_fits_rdev until split_bio is in
chunk_aligned_read().

Sorry.

>=20
> >
> > and the comment says ->merge_bvec_fn() has gone, but that isn't until
> >   [PATCH v4 08/11] block: kill merge_bvec_fn() completely
> >
> >
> > If those issues are resolved, then
>=20
> How about this?
>=20
> PATCH 6: md/raid5: split bio for chunk_aligned_read
> PATCH 7: block: kill merge_bvec_fn() completely
> PATCH 8: md/raid5: get rid of bio_fits_rdev()

Yes for "get rid of bio_fits_rdev()" after "split bio for chunk_aligned_rea=
d".

For the other issue, you could do was you suggest, or you could just change
the comment.
  Remove bio_fits_rdev() as sufficient merge_bvec_fn() handling is now
  performed by blk_queue_split() in md_make_request().

Up to you.

Thanks,
NeilBrown


>=20
> Thanks.
>=20
> >
> >   Acked-by: NeilBrown <neilb@suse.de>
> >
> > Thanks,
> > NeilBrown
> >
> >
> >>
> >> Cc: Neil Brown <neilb@suse.de>
> >> Cc: linux-raid@vger.kernel.org
> >> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> >> [dpark: add more description in commit message]
> >> Signed-off-by: Dongsu Park <dpark@posteo.net>
> >> Signed-off-by: Ming Lin <mlin@kernel.org>
> >> ---
> >>  drivers/md/raid5.c | 23 +----------------------
> >>  1 file changed, 1 insertion(+), 22 deletions(-)
> >>
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index 1ba97fd..b303ded 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -4743,25 +4743,6 @@ static void raid5_align_endio(struct bio *bi, i=
nt error)
> >>       add_bio_to_retry(raid_bi, conf);
> >>  }
> >>
> >> -static int bio_fits_rdev(struct bio *bi)
> >> -{
> >> -     struct request_queue *q =3D bdev_get_queue(bi->bi_bdev);
> >> -
> >> -     if (bio_sectors(bi) > queue_max_sectors(q))
> >> -             return 0;
> >> -     blk_recount_segments(q, bi);
> >> -     if (bi->bi_phys_segments > queue_max_segments(q))
> >> -             return 0;
> >> -
> >> -     if (q->merge_bvec_fn)
> >> -             /* it's too hard to apply the merge_bvec_fn at this stag=
e,
> >> -              * just just give up
> >> -              */
> >> -             return 0;
> >> -
> >> -     return 1;
> >> -}
> >> -
> >>  static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_=
bio)
> >>  {
> >>       struct r5conf *conf =3D mddev->private;
> >> @@ -4815,11 +4796,9 @@ static int chunk_aligned_read(struct mddev *mdd=
ev, struct bio * raid_bio)
> >>               align_bi->bi_bdev =3D  rdev->bdev;
> >>               __clear_bit(BIO_SEG_VALID, &align_bi->bi_flags);
> >>
> >> -             if (!bio_fits_rdev(align_bi) ||
> >> -                 is_badblock(rdev, align_bi->bi_iter.bi_sector,
> >> +             if (is_badblock(rdev, align_bi->bi_iter.bi_sector,
> >>                               bio_sectors(align_bi),
> >>                               &first_bad, &bad_sectors)) {
> >> -                     /* too big in some way, or has a known bad block=
 */
> >>                       bio_put(align_bi);
> >>                       rdev_dec_pending(rdev, mddev);
> >>                       return 0;
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--Sig_/WZ0g4/NCdMk4xFKmLqdZW.v
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWLVJznsnt1WYoG5AQITShAAuCdKJpqfhNJsA9gi3XAF5n4u/0c2eWGV
ZesKvfy1Nj+iKUDGg7I6oZhrAslFEmm92sTvkVciQ8mqkVyy3W64HF4IfzCuUfCa
gmL2tAuWhyNHrd9GeXBnuwzO2Kou3yZbA1Pl9UYBAx9iZNtFWZeGcEvMj3zDytEc
hNxyFliEBrFNwWGCqGNO+ohptoIoixU9w3EZgaQCoIbbnT0MG54yphRnTFgLGNY2
4N5wUKfwh2o2F2qPPYUuQaiYuRa83v92dGwVjFBtoRRL+AcPnRBc2MhfoMsriKo5
Apg7T7FMdWUy7sTlIbHQ+7+xi4fbG35CsT3WibLForJO8LISrF7TbqYN5f9nyti7
X/hlsdi/P9UFDwBPPymdy3TdphzTHx5wsmFp8astT1uVMoOTpTYuvCf42HCFieJr
dAftzaD81C7wpt4z5XwkV+/zLD/SskQY7UAgFJ4mhQ2SdwKN0A1kU1sMpwSSIuVm
UEG8Ng6Rzjl4Jrp73POgYXkcqj2XVqoMQKp2leAUZ09yj9PZ9vUv1wKpaTuqxl3S
DSgijE1SbmnlA0IXm4Q39CN15jZRlxTFhQNfQyaUmD0aCLLN7T8fQhl4T/FkZeKk
hr0heR1jUvmvoUqLXkFP94irM+jZDCOJoPxOdqN5873i1sXmStac9Vvqz0Uww3yS
Hj9Jf9ZE92Q=
=5FZv
-----END PGP SIGNATURE-----

--Sig_/WZ0g4/NCdMk4xFKmLqdZW.v--
