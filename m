From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Incorrect in-kernel bitmap on raid10
Date: Sun, 3 May 2009 15:22:30 +0200
Message-ID: <20090503132230.GA23302@darkside.22.kls.lan>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org> <18922.50050.860008.242658@notabene.brown> <slrnguupf4.911.Mario.Holbe@darkside.dyn.samba-tng.org> <slrngve39c.8a2.Mario.Holbe@darkside.dyn.samba-tng.org> <18938.23135.726382.733302@notabene.brown> <20090501175524.GA8163@darkside.22.kls.lan> <fb9dbbffc38b437042076747a41ddf9b.squirrel@neil.brown.name> <20090502195259.GA8499@darkside.22.kls.lan> <a960aae116852f769f6e223581fa6835.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a960aae116852f769f6e223581fa6835.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 03, 2009 at 08:41:49AM +1000, NeilBrown wrote:
> I managed to reproduce this thanks to all the detail you provided.
> The problem was caused by trying to add a device to the array while the
> array was readonly.

Okay, I understand. I was just trying to find a way to sync all the
spares simultaneously.

> Can you duplicated the problem without setting the array to readonly?

No, mdadm -A /dev/md7; mdadm --add /dev/md7 /dev/sd[fgh]1 seems to
respect the bitmap, but first adds the first spare only and the two
remaining spares when the first resync has been finished.

According to your previous mail, I will run into your case 3/ this way,
the bug where the bitmap is cleared too early, will I?
I'm very willing to test your announced patch :)

> Yes, it would be nice to be able to add multiple devices at once.
> Maybe I could just get the kernel to wait 100ms after an add before

This is probably the easiest way to work around this issue on the short
run. However, such kind of timeouts cry for race conditions. Perhaps,
allowing to add spares in read-only mode or some flag like "wait for
confirmation before starting to resync" would be a cleaner approach on
the long run.


Thank you very much for your help
   Mario
--=20
Gemuese schmeckt am besten, wenn man es kurz vor dem Verzehr durch ein
Schnitzel ersetzt!

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUBSf2alhS+e2HeSPbpAQIEbgf+Oq+QfPez1pCow/BpFixox1+9ixEP9KYW
Sw7G+zLImS5gnolQeg/rm0OpDkdOPcredbkX63fpjux6yqJYL/jT7H1KKnBH7PhX
WsVW7cBs/AkgUgoKJbzzf9xwIcGQbBlZyQtcIxl6TtA9vfhT2cTCtCT9sZ47va0N
x6+39LX1yhIYPUFPyPcsfTLA17pLWU2EMnbGTRgE7gLfeL8j45A+Xk8OF2XJYhoC
e/GRPIo2iAj4t9lLeMA9t/0VwuZTmmhCsOu7Gaj1aR2DZQ8Bjj1e8zjakEiWyDVV
pslGBw9EBAkEEvjw1KLUb10AGhGzKUmXoUr7c8ANDrv+WKlmHPY5tw==
=8Gpb
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
