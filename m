From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid1:If r1bio->sectors % 8 != 0,then the memcmp and
 latermemcpy will omit the last bio_vec.
Date: Thu, 5 Apr 2012 16:53:46 +1000
Message-ID: <20120405165346.2b21bdf8@notabene.brown>
References: <201203311544085318429@gmail.com>
	<201204051412225155656@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zwdN2febyFokB=FFXzxhbes"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201204051412225155656@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: majianpeng <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/zwdN2febyFokB=FFXzxhbes
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Apr 2012 14:12:25 +0800 "kedacomkernel" <kedacomkernel@gmail.com>
wrote:

> I readed your patch and found it wrong.My patch had two point
> 1:memcmp probem.You patch can correct it.
> 2:omit the last bio_vec.You patch did not correct it.
> If r1bio->sectors %8 !=3D 0,supposed sectors =3D 18,then bio cover three =
pages.=20
> But:
> 	>>int vcnt =3D r1_bio->sectors >> (PAGE_SHIFT- 9); vcnt=3D2
> then
>     >>for (j =3D vcnt; j-- ; ) =20
>       j =3D 1, 0
>=20

Ahhh, yes of course.
Thanks.

> > @@ -1711,7 +1711,7 @@ static int process_checks(struct r1bio *r1_bio)
> >  	struct mddev *mddev =3D r1_bio->mddev;
> >  	struct r1conf *conf =3D mddev->private;
> >  	int primary;
> > -	int i;
> > +	int i, vcnt;
> > =20
> >  	for (primary =3D 0; primary < conf->raid_disks * 2; primary++)
> >  		if (r1_bio->bios[primary]->bi_end_io =3D=3D end_sync_read &&
> > @@ -1721,9 +1721,9 @@ static int process_checks(struct r1bio *r1_bio)
> >  			break;
> >  		}
> >  	r1_bio->read_disk =3D primary;
> > +	vcnt =3D (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
> >  	for (i =3D 0; i < conf->raid_disks * 2; i++) {
> >  		int j;
> > -		int vcnt =3D r1_bio->sectors >> (PAGE_SHIFT- 9);
> >  		struct bio *pbio =3D r1_bio->bios[primary];
> >  		struct bio *sbio =3D r1_bio->bios[i];
> >  		int size;

This bit.

I'll make sure that gets applied.

Thanks,
NeilBrown



--Sig_/zwdN2febyFokB=FFXzxhbes
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT31Bejnsnt1WYoG5AQJRjxAAk7jln8+eNV6ePv8xFZP8JRRk78lENKdg
L8MbiMoA3ZRIb0UmzxXOAK8IYUF/qrFZIykLE6XTaILA+MU5LVa8+n6TC4qAQxr9
Hxz3Cx090iKmCotTF2JiokZXqvRrOcmNT3OOKui1h6fr1sZ57HLYeZSOaLdk46c2
h0qWR0seyT5idLrIzfgWL4tduysgKEqpWE5io3vr2t02Opec/4xfCNO/VjhIaQFh
IVp/MWJ01YRHuJcUnwM2Cil7xMGJxkCkEzqgM3F2My15TT8YG4UVwvnyfB7mqXrW
Y2QhL+bnkHz+pd6SNgNmrrQ+E6bHtxn905TGNMHsWD6PgTFiUZF7N/IgbROi4dfI
x9YWLmvjQERibWij188XFY+h08gxJaOidKj8duHWqXJPYey3zq98iMCt7UIL8vKf
ZDJzVE8Fm7iZs05zIpGrWQBczc7jNMqZnTQ919tQKd788u+Io4T1GdduUur6VqQ/
4P1GIZOMPHhES4NOf8ElWDfTUb9iCUbwDfrlTFzp+RkpxjnjDbhDmi2wBvW7zlRp
3/GLR4TksfiErTZ+RrWP9Gf0KVZDQygvVjQtVsT6ILhEjoJRiXgcIR346urnOYyL
sHje2l9eZTfer2l9RJUcHjXDdiIABkPz6mPIAtZQIjtwDe5JTyCgkWKOjd6smWah
sxQAaDdJGX4=
=+leh
-----END PGP SIGNATURE-----

--Sig_/zwdN2febyFokB=FFXzxhbes--
