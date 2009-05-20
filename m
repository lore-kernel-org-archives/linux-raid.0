From: Andre Noll <maan@systemlinux.org>
Subject: Re: Subject [ raid0 PATCH 3/6] : Add support to chunk size of 4K*n instead of 4K*2^n
Date: Wed, 20 May 2009 10:03:58 +0200
Message-ID: <20090520080358.GR6403@skl-net.de>
References: <1242687904.21201.13.camel@raz> <18961.65310.282446.521193@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="562f9N4fbIs+fPrJ"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18961.65310.282446.521193@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: raz ben yehuda <raziebe@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--562f9N4fbIs+fPrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2009 at 10:36:46AM +1000, Neil Brown wrote:
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > index 80ac685..dc2671f 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -23,6 +23,9 @@
> >  #include "md.h"
> >  #include "raid0.h"
> > =20
> > +static int handle_split(struct request_queue *q,
> > +		unsigned int chunk_sects, struct bio *bio);
> > +
> >  static void raid0_unplug(struct request_queue *q)
> >  {
> >  	mddev_t *mddev =3D q->queuedata;
> > @@ -263,7 +266,12 @@ static int raid0_mergeable_bvec(struct request_que=
ue *q,
> >  	unsigned int chunk_sectors =3D mddev->chunk_size >> 9;
>=20
> Hmm... if someone wanted to globally replace mddev->chunk_size with
> chunk_sectors, I wouldn't complain (Hi Andre :-)

Obviously I missed this one. Currently, mddev->chunk_size is in bytes,
that's probably why I missed it. I'll send a patch ASAP.

Thanks
Andre

--562f9N4fbIs+fPrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKE7luWto1QDEAkw8RAomcAKCDMRtG0p9zFgAG40b+PbA++khtbACfbxeG
yZvyymgqFk/HAWR/ebAwGK0=
=0y65
-----END PGP SIGNATURE-----

--562f9N4fbIs+fPrJ--
