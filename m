From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 05/27] DDF: Implement store_super_ddf
Date: Mon, 15 Jul 2013 15:31:41 +1000
Message-ID: <20130715153141.4ac1cef9@notabene.brown>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
	<1372883287-8859-6-git-send-email-mwilck@arcor.de>
	<20130708154810.561ba2a2@notabene.brown>
	<51DD9BD4.1090208@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MWmL1Odx1.6tERcm.XNtdcx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51DD9BD4.1090208@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/MWmL1Odx1.6tERcm.XNtdcx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Jul 2013 19:37:24 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hi Neil,
>=20
> >> This patch implements the previously unsupported case where
> >> store_super_ddf is called with a non-empty superblock.
> >>
> >> For DDF, writing meta data to just one disk makes no sense.
> >> We would run the risk of writing inconsistent meta data
> >> to the devices. So just call __write_init_super_ddf and
> >> write to all devices, including the one passed by the caller.
> >>
> >> This patch assumes that the device to store the superblock on
> >> has already been added to the DDF structure. Otherwise, an
> >> error message will be emitted.
> >>
> >> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> >=20
> > I'm not sure I really like this.  If mdadm is calling ->store_super, th=
en it
> > wants to write to just one device.  It will quite possibly call
> > ->store_super on all devices, and with your change that will write to a=
ll
> > devices multiple times.
> > So maybe a different interface is needed?
>=20
> The point is the sequence number handling. If the sequence number
> increases, it would be dangerous to write only one superblock.

->store_super should not change the sequence number (I think).  Its purpose
is to fix up the metadata in some way, typically so that a failed array
doesn't look like it is failed any more, so it can be assembled.
It should really just write back exactly the same superblock except for
whatever changes were explicitly requested via "update_super" (plus checksu=
ms
of course).

>=20
> But perhaps it can be done otherwise, I need to examine that further.
> First I need a clear understanding what this API is used for.
>=20
> > What is the big-picture effect of this patch?  What mdadm function now =
works
> > that didn't work before?
>=20
> To be honest, I don't know. I came up with this patch when scanning
> through the code looking for possible problems. This is not necessary to
> make mdadm -e ddf -C -l10 work.

I've reverted it then - I really don't think it is wanted.

Thanks,
NeilBrown


>=20
> Martin
>=20
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >=20
> >=20
> >> ---
> >>  super-ddf.c |   41 +++++++++++++++++++++++++++++++++++------
> >>  1 files changed, 35 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/super-ddf.c b/super-ddf.c
> >> index b806949..b3c846d 100644
> >> --- a/super-ddf.c
> >> +++ b/super-ddf.c
> >> @@ -3471,15 +3471,44 @@ static int store_super_ddf(struct supertype *s=
t, int fd)
> >>  	if (!ddf)
> >>  		return 1;
> >> =20
> >> -	/* ->dlist and ->conflist will be set for updates, currently not
> >> -	 * supported
> >> -	 */
> >> -	if (ddf->dlist || ddf->conflist)
> >> -		return 1;
> >> -
> >>  	if (!get_dev_size(fd, NULL, &dsize))
> >>  		return 1;
> >> =20
> >> +	if (ddf->dlist || ddf->conflist) {
> >> +		struct stat sta;
> >> +		struct dl *dl;
> >> +		int ofd, ret;
> >> +
> >> +		if (fstat(fd, &sta) =3D=3D -1 || !S_ISBLK(sta.st_mode)) {
> >> +			pr_err("%s: file descriptor for invalid device\n",
> >> +			       __func__);
> >> +			return 1;
> >> +		}
> >> +		for (dl =3D ddf->dlist; dl; dl =3D dl->next)
> >> +			if (dl->major =3D=3D (int)major(sta.st_rdev) &&
> >> +			    dl->minor =3D=3D (int)minor(sta.st_rdev))
> >> +				break;
> >> +		if (!dl) {
> >> +			pr_err("%s: couldn't find disk %d/%d\n", __func__,
> >> +			       (int)major(sta.st_rdev),
> >> +			       (int)minor(sta.st_rdev));
> >> +			return 1;
> >> +		}
> >> +		/*
> >> +		   For DDF, writing to just one disk makes no sense.
> >> +		   We would run the risk of writing inconsistent meta data
> >> +		   to the devices. So just call __write_init_super_ddf and
> >> +		   write to all devices, including this one.
> >> +		   Use the fd passed to this function, just in case dl->fd
> >> +		   is invalid.
> >> +		 */
> >> +		ofd =3D dl->fd;
> >> +		dl->fd =3D fd;
> >> +		ret =3D  __write_init_super_ddf(st);
> >> +		dl->fd =3D ofd;
> >> +		return ret;
> >> +	}
> >> +
> >>  	if (posix_memalign(&buf, 512, 512) !=3D 0)
> >>  		return 1;
> >>  	memset(buf, 0, 512);
> >=20


--Sig_/MWmL1Odx1.6tERcm.XNtdcx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUeOJPTnsnt1WYoG5AQLSKw//Usk+KCzUQENC1cNQp4OhlZDJHF9KYIWS
XpycPJlUJThEzPZvqj3oXB2MstH2kcw6v9SNk2jlRNAjQNXUzUgtS4vAo7Q1qqUD
Bp2+fZZ28QpAYHUrB3U8kiiXqTfB14QtmRbqiIzrWtTvIBur7sXzP5sn0X0PW/iw
Q30L2eywsMYsbDCembmbbMjntB/gtczigYE6oUPeE+z9URNqre7aFl2b5EfvaYz2
j5H6Tpqd95iRdq/V8KcA8E0g2sotoTB1xeDyZpwGG7RfJUtxzpwAptvHcY7/+IBL
RaX5WCfa/ycfh7lKoM2VaSGXsUXwORqHAWIQr5MXKa+3aGPrFEu+DbE1tu1vJ1KQ
GDkmcE1PgYe7+wjhq3cBLWovrYEx2cC+T6iCEuxDuI8jFnZgDQiVc3NxunpPu3PN
fqmR/hYKi+Q38M/N4dX5MITOIuR5sC/Q4a4dXEdZ1dYEfPZiTiaLCUVkWuNlNfC5
wsg+EKEDXZV5WNR4P23iv3ltVT4wmEwTVGafr6mpU6yf6jodJv4Yn923ZEt2CoZk
gkJ3Gv7GSZvkcSjTwHhIf4pB8SgUZvxBpcJPM9Rrz23hmRCyKl3SPEeS8nIIbSVp
ot+qctqzEd5K0hRoSpOj/IBWsE7AwqIJ9eUwk/KlGR+yxICa0Syx6kbTsJ3ykWKh
l3eu5pFy78g=
=mLbU
-----END PGP SIGNATURE-----

--Sig_/MWmL1Odx1.6tERcm.XNtdcx--
