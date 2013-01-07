From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: raid1,10: Handle REQ_WRITE_SAME flag in write bios
Date: Mon, 7 Jan 2013 13:22:06 +1100
Message-ID: <20130107132206.7d25de89@notabene.brown>
References: <alpine.DEB.2.02.1212141406480.30895@jlaw-desktop.mno.stratus.com>
	<alpine.DEB.2.02.1301021039110.31163@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xwRWsiNethggh19Vw8zOsZ8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1301021039110.31163@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/xwRWsiNethggh19Vw8zOsZ8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Jan 2013 10:42:49 -0500 (EST) Joe Lawrence
<Joe.Lawrence@stratus.com> wrote:

> On Fri, 14 Dec 2012, Joe Lawrence wrote:
>=20
> > Submitting patch for review... This sets the max_write_same_sectors for=
=20
> > the mdev request queue to its chunk_sectors (before merging its member=
=20
> > disk limits).  I believe this should keep the write same LBA sector cou=
nt=20
> > inside the write intent bitmap granularity, but I'm not sure if the sec=
tor=20
> > range could cross bits and how could would be handled.  Any insight int=
o=20
> > the bitmap side of things would be appreciated.
> >=20
> > Thanks,
> >=20
> > -- Joe
> >=20
> > From d31c4569b3883475f293403fa4eed63f107616bb Mon Sep 17 00:00:00 2001
> > From: Joe Lawrence <joe.lawrence@stratus.com>
> > Date: Fri, 14 Dec 2012 11:25:27 -0500
> > Subject: [PATCH] md: raid1,10: Handle REQ_WRITE_SAME flag in write bios
> >=20
> > Set mddev queue's max_write_same_sectors to its chunk_sector value (bef=
ore
> > disk_stack_limits merges the underlying disk limits.)  With that in pla=
ce,
> > be sure to handle writes coming down from the block layer that have the
> > REQ_WRITE_SAME flag set.  That flag needs to be copied into any newly c=
loned
> > write bio.
> >=20
> > Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> > ---
> >  drivers/md/raid1.c  | 5 ++++-
> >  drivers/md/raid10.c | 8 ++++++--
> >  2 files changed, 10 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index a0f7309..c9ef213 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -1001,6 +1001,7 @@ static void make_request(struct mddev *mddev, str=
uct bio * bio)
> >  	const unsigned long do_flush_fua =3D (bio->bi_rw & (REQ_FLUSH | REQ_F=
UA));
> >  	const unsigned long do_discard =3D (bio->bi_rw
> >  					  & (REQ_DISCARD | REQ_SECURE));
> > +	const unsigned long do_same =3D (bio->bi_rw & REQ_WRITE_SAME);
> >  	struct md_rdev *blocked_rdev;
> >  	struct blk_plug_cb *cb;
> >  	struct raid1_plug_cb *plug =3D NULL;
> > @@ -1302,7 +1303,8 @@ read_again:
> >  				   conf->mirrors[i].rdev->data_offset);
> >  		mbio->bi_bdev =3D conf->mirrors[i].rdev->bdev;
> >  		mbio->bi_end_io	=3D raid1_end_write_request;
> > -		mbio->bi_rw =3D WRITE | do_flush_fua | do_sync | do_discard;
> > +		mbio->bi_rw =3D
> > +			WRITE | do_flush_fua | do_sync | do_discard | do_same;
> >  		mbio->bi_private =3D r1_bio;
> > =20
> >  		atomic_inc(&r1_bio->remaining);
> > @@ -2819,6 +2821,7 @@ static int run(struct mddev *mddev)
> >  	if (IS_ERR(conf))
> >  		return PTR_ERR(conf);
> > =20
> > +	blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
> >  	rdev_for_each(rdev, mddev) {
> >  		if (!mddev->gendisk)
> >  			continue;
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index c9acbd7..3d77a92 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -1106,6 +1106,7 @@ static void make_request(struct mddev *mddev, str=
uct bio * bio)
> >  	const unsigned long do_fua =3D (bio->bi_rw & REQ_FUA);
> >  	const unsigned long do_discard =3D (bio->bi_rw
> >  					  & (REQ_DISCARD | REQ_SECURE));
> > +	const unsigned long do_same =3D (bio->bi_rw & REQ_WRITE_SAME);
> >  	unsigned long flags;
> >  	struct md_rdev *blocked_rdev;
> >  	struct blk_plug_cb *cb;
> > @@ -1461,7 +1462,8 @@ retry_write:
> >  							      rdev));
> >  			mbio->bi_bdev =3D rdev->bdev;
> >  			mbio->bi_end_io	=3D raid10_end_write_request;
> > -			mbio->bi_rw =3D WRITE | do_sync | do_fua | do_discard;
> > +			mbio->bi_rw =3D
> > +				WRITE | do_sync | do_fua | do_discard | do_same;
> >  			mbio->bi_private =3D r10_bio;
> > =20
> >  			atomic_inc(&r10_bio->remaining);
> > @@ -1503,7 +1505,8 @@ retry_write:
> >  						   r10_bio, rdev));
> >  			mbio->bi_bdev =3D rdev->bdev;
> >  			mbio->bi_end_io	=3D raid10_end_write_request;
> > -			mbio->bi_rw =3D WRITE | do_sync | do_fua | do_discard;
> > +			mbio->bi_rw =3D
> > +				WRITE | do_sync | do_fua | do_discard | do_same;
> >  			mbio->bi_private =3D r10_bio;
> > =20
> >  			atomic_inc(&r10_bio->remaining);
> > @@ -3578,6 +3581,7 @@ static int run(struct mddev *mddev)
> >  					 (conf->geo.raid_disks / conf->geo.near_copies));
> >  	}
> > =20
> > +	blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
> >  	rdev_for_each(rdev, mddev) {
> >  		long long diff;
> >  		struct request_queue *q;
> > --=20
> > 1.7.11.7
> >=20
> >=20
>=20
> Hi Neil,
>=20
> Happy new year -- any comments on this bug / patch?  I can rebase and=20
> test against 3.8, though I don't believe any related code has changed yet.
>=20

Thanks.  I've added Martin's and and queue it up.

Assuming that a REQ_WRITE_SAME is just like a normal write except for the
iovec being shorter (is that right?) there should be no interesting issues
with bitmaps - it should just work.

NeilBrown


--Sig_/xwRWsiNethggh19Vw8zOsZ8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUOoxTjnsnt1WYoG5AQJe1A//UA2N7I7evibyFgI1LJqstIOG1hTIFXmM
xBhVHpQgB0h77wLusehhH9shlnFu5RDuRdBEzEBBgwithFkrBimvt8MyQ9A9J6HD
2huTWAi6ON+iE0tZh0vO0HGvuJHRFCARFcPDJ+FkTg/Paj/79ZAYEzD3Ody72BMw
16Ul7h6twTHHtUx2muO+FuG7O99dg6SRcMIOKTFm01awbbedcaq2mOuTH2IfV0sF
ReUgvunYw2jqTGCLiUVXkAoHQ0534dFzN1ry/wLKGNS9d75bYnCClabVRVvR8Bog
oBuHyiqmihECDu2DTds7HsEcBowuypkl4gQFyq+rcdRtFAHx/eCIbn8FukkeXmpt
Ti+NaSiplRy2bhG2HDB8y193/3Z7UYgZyfc7+4Jz3HA5+p40VBiBkQjycJ74PY6d
W4e5pzTqez1qWVj45AnL3SLH0ki7QQSkwIeHZbGfLTsvtzSxv2ME6bNniBVbUHOC
H25enSV4zQ7XmY0E/rgPMANBzjrjrJm5v82O/AdRvdTK4H70c7CY/U1xWNKoHEKb
NkqfcvLHfh8g3jqa+si+WbmQKOhu7z3SO1Fye2+LPqPCSq0N6PwI3bm4Bu3BQT71
aR64dJ18xV5EnMTjOW5jdZckicQiK8ueSswmUjzz8Huql7nMjiCQshPijl1dsCGC
1uUAA3Wbjh8=
=hG+0
-----END PGP SIGNATURE-----

--Sig_/xwRWsiNethggh19Vw8zOsZ8--
