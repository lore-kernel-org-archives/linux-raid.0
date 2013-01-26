From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: fsync() on read-only RAID triggers BUG
Date: Sat, 26 Jan 2013 19:44:40 +0000
Message-ID: <1359229480.2894.21.camel@deadeye.wl.decadent.org.uk>
References: <1358707492.24121.210.camel@deadeye.wl.decadent.org.uk>
	 <5102A01B.7000407@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UuX4Ov1BFgf8BMxJyugK"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5102A01B.7000407@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, 696650@bugs.debian.org
List-Id: linux-raid.ids


--=-UuX4Ov1BFgf8BMxJyugK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-01-25 at 16:09 +0100, Sebastian Riemer wrote:
> On 20.01.2013 19:44, Ben Hutchings wrote:
> > # Call fsync()
> > python -c "import os; os.fsync(os.open('/dev/md0', os.O_RDWR))"
> > --- END ---
> >=20
> > I assume that the sync request should be filtered out at some point
> > before this assertion is made, since there can be nothing to sync.
> >=20
>=20
> I wrote a test case in C. It gets SIGSEGV upon fsync. When making the
> rdevs below also read-only the MD device can't be stopped anymore as it
> thinks that there is still active IO.
>=20
> The attached patch should fix it. Please confirm.

I applied this on top of 3.2.37 and it certainly fixes the crash.
However I wonder whether fsync() should fail or should immediately
succeed.  I don't know whether the installer expects it to succeed.

Ben.

> We have to return a
> completion without incrementing the active IO count. Error code -EROFS
> seems to be suited best.
>=20
> But the libc fsync gets -EIO anyway:
> Input/output error
>=20
> Any objection?
>=20
> Cheers,
> Sebastian

--=20
Ben Hutchings
Any smoothly functioning technology is indistinguishable from a rigged demo=
.

--=-UuX4Ov1BFgf8BMxJyugK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUQQyKOe/yOyVhhEJAQpPzA//ZD5MfUSolMc4VjbAyy7/yskDaDM6fymK
Cnvu0Sjl0JqTTyBMIlF4TcVIMokQBRFnMYoTHYRDYQ5rYaFMFEWZ96DGZKanLI5U
604+gWyBk1d/wIiEeUUndlChxn3u2TnR5NiVQ3MOxkXw4zTc7Eq+c8hZMM8K7JQu
rAP80W8Q9xUYq3cQGYHJsBb+KuI7XhZKZ4CbWEffknXACLXQGPV4AQ42fF1yHu0a
mnsLAooBfJ6GEAEuQ29oP3SdDwn411K1tkItR/uD2/0cym3Q3pObtHBUZ6SLhe9E
XvGi+RqHGzvUXbGakZk0LAQE2rS8oMoJ+GbaOcxXPRv+g9os/WBJlfrDhhCzwEIl
3sXTRqXyIpjFX8ra26YJs3kLDAdjZu5pPv+/EGTb73D9DGI60sMYLEkCvLBgDP3i
fx4jHOc5tOyWPknKoMUJhGABWAJlrmi/2MOYLLO42nreFu7fO8gClR8pCCCiSa3k
2i7Q1C3laE9pFb0kifSwBPp8JwmWjNH/L4ISBslZkG4ldT/5maTps8p9zT5V39do
H2pG9reHyL4L6+TxVoj98sDSjDOcWXQ7aqU2iSlKU1isNm06OGURki4NT45XYcOh
U+YDX93ijuqssdk87ryB8xqWczV5EeFtR+JPQuvm4g58VPoEYFxnPW1fD7LXETya
6sG8S2TpKzg=
=0TVz
-----END PGP SIGNATURE-----

--=-UuX4Ov1BFgf8BMxJyugK--
