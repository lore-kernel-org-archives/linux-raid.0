From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] raid5: For write performance, remove REQ_SYNC when
 write was odirect.
Date: Mon, 16 Jul 2012 17:07:17 +1000
Message-ID: <20120716170717.5d5ee04c@notabene.brown>
References: <201207160931507187344@gmail.com>
	<20120716154010.0ef12c57@notabene.brown>
	<201207161442513597497@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TAGwzc=FOzdROsCm=f.O3B."; protocol="application/pgp-signature"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201207161442513597497@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: viro <viro@ZenIV.linux.org.uk>, linux-raid <linux-raid@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/TAGwzc=FOzdROsCm=f.O3B.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jul 2012 14:42:54 +0800 majianpeng <majianpeng@gmail.com> wrote:

> On 2012-07-16 13:40 NeilBrown <neilb@suse.de> Wrote:
> >On Mon, 16 Jul 2012 09:31:55 +0800 majianpeng <majianpeng@gmail.com> wro=
te:
> >
> >> In commit e9c7469bb4f502dafc092166201bea1ad5fc0fbf:
> >> Tejun Heo introduced "implment REQ_FLUSH/FUA support".
> >> But for direct-write-blocks, it maybe for other purpose which like the
> >> regular file.
> >> And this flag will set STRIPE_PREREAD_ACTIVE which decreaed the change
> >> to full write.
> >>=20
> >> But this patch remove REQ_SYNC only judging the WRITE_ODIRECT,it will
> >> contail regular file.So it maybe not correctly.
> >> How can difference odriect_write between regular file or block file?
> >
> >Hi,
> > I think you are saying the when REQ_SYNC is used with O_DIRECT writes i=
t is
> > having a negative effect on throughput because it allows the stripe to =
be
> > processed immediately without waiting for more requests to be added to =
the
> > stripe.
> >
> > Normal 'sync' requests use WRITE_SYNC which includes "REQ_NOIDLE" which=
 means
> >   /* don't anticipate more IO after this one */
> > O_DIRECT request use WRITE_ODIRECT which does not include this flag.
> >

> Using REQ_NOIDEL to difference odirect and sync.Why not using:
>  +	if (bi->bi_rw & WRITE_ODIRECT)
>  +		bi->bi_rw &=3D ~REQ_SYNC;

Because that code is wrong.  WRITE_ODIRECT is not one flag, it is two flags
'or'ed together.  So this code does not do what you expect.


>=20
> The flag WRITE_ODIRECT is only used in odirect-write.
>=20
> > So maybe we should simply change raid5 to only set STRIPE_PREREAD_ACTIV=
E if
> > REQ_NOIDLE is set on the bio.  I think this would have the same effect =
as
> > what you are trying to achieve.
> >
> > Could you please try that and see if it has the desired effect on
> > performance?
> >
> I tested and the performance is the same.

"The same" as what?  The same are your original patch, or the same as witho=
ut
any patch?

NeilBrown



> >Thanks,
> >NeilBrown
> >
> >i.e. something like this:
> >
> >diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >index d56d74d..2d72a57 100644
> >--- a/drivers/md/raid5.c
> >+++ b/drivers/md/raid5.c
> >@@ -4178,7 +4178,7 @@ static void make_request(struct mddev *mddev, stru=
ct bio * bi)
> > 			finish_wait(&conf->wait_for_overlap, &w);
> > 			set_bit(STRIPE_HANDLE, &sh->state);
> > 			clear_bit(STRIPE_DELAYED, &sh->state);
> >-			if ((bi->bi_rw & REQ_SYNC) &&
> >+			if ((bi->bi_rw & REQ_NOIDLE) &&
> > 			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> > 				atomic_inc(&conf->preread_active_stripes);
> > 			release_stripe_plug(mddev, sh);
> >
> >
> >>=20
> >> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> >> ---
> >>  drivers/md/raid5.c |    3 +++
> >>  1 files changed, 3 insertions(+), 0 deletions(-)
> >>=20
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index 04348d7..8d2d4d1 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -4010,6 +4010,9 @@ static void make_request(struct mddev *mddev, st=
ruct bio * bi)
> >>  	     chunk_aligned_read(mddev,bi))
> >>  		return;
> >> =20
> >> +	if (bi->bi_rw & WRITE_ODIRECT)
> >> +		bi->bi_rw &=3D ~REQ_SYNC;
> >> +
> >>  	logical_sector =3D bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
> >>  	last_sector =3D bi->bi_sector + (bi->bi_size>>9);
> >>  	bi->bi_next =3D NULL;
> >
> >

--Sig_/TAGwzc=FOzdROsCm=f.O3B.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAO9pTnsnt1WYoG5AQJ9jA/+KikYKrD+qr2Pn50v5LUp0aCXxjPvHoN5
vCW+xFi++eV7h/xn2ncLJ8wr1sjX3EEWKs6itDsRld4YqfVc1kgoKdazaDUbfC6L
hgWXLOVnOczVW04GvpaUYX/GtiLBlcijgtjo6kcXImP6luT57C6bMqV6FYhYiTtr
t2RXzSKZ8qrEXfybmRBLDmlTWxV9zvt70qxKpaEp8oKJhZg14zGHD+SDnqXoLA/W
gfcdixQQ9SJ4NYQnMx3a/LapzYUHwtnOYEka8SpyOse6Y/fddD0E4MTnGLKRJ+qz
bTgBLWQW8Ag1zPva0Ixc4hZVWXIGxWPz5p2No7FZw3zW/1IWn8vairAOI4WD7ajP
0tnOaZduENkEZk6FDvvQga3OStK+VV+HmKdjOw789IgVRTFyAVZtp/eiiA1bwAb0
AaFuzpxorNmsyfGymmEzxLW6E0cLtcBpSfl6s1K9Tv8k37KbErvtAEqDVTg2CeGL
hEyzT+7Vql29TAh5GilYmmtRz3TsBcZrlfKdklZfcA5liDb4Lzom0kVtG+gEk53Z
MeaW+au4syx8TLlgQRmLvUQNxXJ/+Ay8iAcKP1XZWYuml4AM8dOTqGJvEA5aPVBK
Z3hUPhgzDd4h/cP4MtHGGFi+xF2ne5AlGnAWWSR5qhRAhgqFCuGTd3o79HDkmmCM
Z8aFNd45oWA=
=LUxK
-----END PGP SIGNATURE-----

--Sig_/TAGwzc=FOzdROsCm=f.O3B.--
