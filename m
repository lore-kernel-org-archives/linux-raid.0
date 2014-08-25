From: NeilBrown <neilb@suse.de>
Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
Date: Mon, 25 Aug 2014 21:26:14 +1000
Message-ID: <20140825212614.5be558c9@notabene.brown>
References: <20140823163110.GE11855@bitfolk.com>
	<20140824130939.461501b4@notabene.brown>
	<20140824143944.GC19874@bitfolk.com>
	<20140825103234.GH11855@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/21=9DmRUOlCj16.Beh4chSS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140825103234.GH11855@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/21=9DmRUOlCj16.Beh4chSS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Aug 2014 10:32:34 +0000 Andy Smith <andy@strugglers.net> wrote:

> On Sun, Aug 24, 2014 at 02:39:44PM +0000, Andy Smith wrote:
> > $ sudo ./mdadm /dev/md2 --grow --raid-devices=3D4
> > mdadm: Cannot set new_data_offset: RAID10 reshape not
> >        supported on this kernel
>=20
> Grow.c from latest git:
>=20
> 2397                         err =3D sysfs_set_num(sra, sd, "new_offset",
> 2398                                             new_data_offset);
>=20
> For the first device in the for loop (sda3), the above line 2397 is
> returning -1.
>=20
> 2399                 }
> 2400                 if (err < 0) {
> 2401                         if (errno =3D=3D E2BIG && data_offset !=3D I=
NVALID_SECTORS) {
> 2402                                 pr_err("data-offset is too big for %=
s\n",
> 2403                                        dn);
> 2404                                 goto release;
> 2405                         }
> 2406                         if (sd =3D=3D sra->devs &&
> 2407                             (errno =3D=3D ENOENT || errno =3D=3D E2B=
IG))
> 2408                                 /* Early kernel, no 'new_offset' fil=
e,
> 2409                                  * or kernel doesn't like us.
> 2410                                  * For RAID5/6 this is not fatal
> 2411                                  */
> 2412                                 return 1;
>=20
> It reaches here line 2412 with errno =3D=3D E2BIG.
> /sys/block/md2/md/dev-sda3/new_offset exists.
>=20
> >From strace:
>=20
> open("/sys/block/md2/md/dev-sda3/new_offset", O_WRONLY) =3D 4
> write(4, "128", 3)                      =3D -1 E2BIG (Argument list too l=
ong)
> close(4)                                =3D 0
>=20
> Not sure where to debug next.

That comes from
	else if (new_offset > rdev->data_offset) {
		/* must not push array size beyond rdev_sectors */
		if (new_offset - rdev->data_offset
		    + mddev->dev_sectors > rdev->sectors)
				return -E2BIG;

in drivers/md/md.c in the kernel...

What does "mdadm --examine" on one of the devices report now that it is v1.=
0?

Particularly interested in the "Unused Space :" line.

NeilBrown

--Sig_/21=9DmRUOlCj16.Beh4chSS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/sdVjnsnt1WYoG5AQJQohAAvJKTfgamH89tqQ944l43E/JLdwWWLIjp
jA56fMzn0+lK3ViuuD5vw1Y3+nsa3gDaVIOKNgH7JRY3IMc2e/xgp1b2hiIQNoIZ
+PjdmjwN15/M7+znwfus3nEkOzEnprdmZuIM5WKsVGs4pfHscid8GiperUT611p0
BHbuPonosMGG9amI2PYKU7Qw3RQgx6ILf9kBu4Lxq4l2VFxGBcQlarXHNLFGPtaq
xNH0T8dIa/F5fSyZmZrTqDAHUZggxRBSjKEnqZaRCgmLuKQw2IRQ+/xCN6kGHA2I
Hzy7k35c6XBNHxbj1gdaa3I2woXTsZPqVjZgErFg44zcRFnY0LeWdhjXcV9XQ0ZB
apUTRZHUlTHfQyV01VuSn4GOhHJcABhJej2MmeS8m+HdSUXt6LQB9RJO5vrPrmed
FWkw8W2n3TJebscZBxNN/X19SwQ1WJ1TvCsM8E/LYlau3NNgEI07qH6xbvsuNKk4
PMQSCMSBwlKYxpycO9wei+30fVXqyl4I9ajmVMlg5hzCwITk4UUR2VC9jrhgrQuX
6n76WJaC0WiU3gj80+F8RwBZL7ZR8WE0Opifr34x371iqnyZmxLjcC6J67N4twv7
tVg8NRKUd41JOvuofY3cu9G6LzOCuldllPnp9d1xsgb1QANeSrrGeCD2DGTaXiQy
QejKQSqV0Ro=
=sMZn
-----END PGP SIGNATURE-----

--Sig_/21=9DmRUOlCj16.Beh4chSS--
