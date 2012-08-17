From: NeilBrown <neilb@suse.de>
Subject: Re: md: raid 10 supports TRIM
Date: Sat, 18 Aug 2012 09:51:10 +1000
Message-ID: <20120818095110.125b3d3a@notabene.brown>
References: <20120816110237.GA4709@elgon.mountain>
	<502DAEB3.6080302@fusionio.com>
	<20120817040015.GA8644@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CVQw+F0F8jIngVanjcghY5a"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120817040015.GA8644@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, dan.carpenter@oracle.com
List-Id: linux-raid.ids

--Sig_/CVQw+F0F8jIngVanjcghY5a
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Aug 2012 12:00:15 +0800 Shaohua Li <shli@kernel.org> wrote:

> >=20
> > This is a semi-automatic email about new static checker warnings.
> >=20
> > The patch d61b764704ca: "md: raid 10 supports TRIM" from Aug 15,
> > 2012, leads to the following Smatch complaint:
> >=20
> > drivers/md/raid10.c:3510 run()
> > 	 warn: variable dereferenced before check 'mddev->queue' (see line 350=
8)
> >=20
> > drivers/md/raid10.c
> >   3507=09
> >   3508		blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sector=
s);
> >                                               ^^^^^^^^^^^^
> > New dereference.
> >=20
> >   3509		chunk_size =3D mddev->chunk_sectors<<  9;
> >   3510		if (mddev->queue) {
> >                     ^^^^^^^^^^^^
> > Old check.
> >=20
> >   3511			blk_queue_io_min(mddev->queue, chunk_size);
> >   3512			if (conf->geo.raid_disks % conf->geo.near_copies)
>=20
> Thanks! Neil, this is the updated patch. If you prefer a fix against orig=
inal
> patch, please let me know.=20
>=20
>=20
> Subject: md: raid 10 supports TRIM
>=20
> This makes md raid 10 support TRIM.
> If one disk supports discard and another not, or one has discard_zero_dat=
a and
> another not, there could be inconsistent between data from such disks. Bu=
t this
> should not matter, discarded data is useless. This will add extra copy in=
 rebuild
> though.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>


Applied, thanks.

NeilBrown

--Sig_/CVQw+F0F8jIngVanjcghY5a
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUC7Y7jnsnt1WYoG5AQIWFBAAlZb0n6tHmtDfw4mv6P/q+e8+AAYDg1hD
1P8ajKeUGfJZchXtDvf+qjXnV38FIJGbjsbKTvqwUeiYfKFxuQNCVTgAw9Wr6KIm
UsM+SmuYVgCoRw5svNbmRdBfe2yPXvucrwgREiC1Ry9XgKZx5JCJBhyHdoZBIp+2
UnmMTKLvkhSQOdJqo1elL5Fw+fF96z24ciFZOA4MRU2ETWj2OSxnh3cbteIlZ52j
5p59a5UQMf8tofkmkewdmxlHs4Wt6QsweQ38OqP0uNaOK6vKvv5AMVBKOHqC8Ns0
gj+H3QD0PrVaR0FzweCi04Imdz6yCziIgk85OcLKBWUecKhKKcAx/BP+UhgIomsK
B6p5W9uCxKqPfzK8nn1in03kwf4dqeK/0d5To5iSw+XghlB40C6PK5vldJY7Iy1H
oxtiyBgNt69PbAbJVvfb7xBHsXpJX/mB5vp7YNQqqPtPxSGdIB1tmSLsBWAFyovO
fROzCz4wfrWJPSExRSsfnpbNmWWI2MKp2x7RYRw8pInmLdZAa4W/GIlOBXuNNjuH
eIVvxKMyqYjd7XQCswOtstcSmULJOfYkZ1BUmW6hafErWm5jsioi6wUOINgi9qgK
Z9e5MsJ/7eWOcA7AtkOj/dUWcFK08JMvhpHmVKA8lI+RtIbTjjI9MFwAwW67ryC9
6GK+m9m9NbA=
=sQyr
-----END PGP SIGNATURE-----

--Sig_/CVQw+F0F8jIngVanjcghY5a--
