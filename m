From: Gregory Leblanc <gleblanc@linuxweasel.com>
Subject: Re: 3ware 7500-8 confusion
Date: 24 Feb 2003 09:58:16 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1046109496.2019.5.camel@gregdell>
References: <Pine.LNX.4.44.0302240937520.2586-100000@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rxAjjCyCOdxKU7xGNoTy"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0302240937520.2586-100000@chaos.egr.duke.edu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-rxAjjCyCOdxKU7xGNoTy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2003-02-24 at 06:41, Joshua Baker-LePain wrote:
> On 23 Feb 2003 at 12:53am, Maurice Hilarius wrote
>=20
> > Actually it makes tons of sense.
> *snip*
> > 2) If you lose a disk at a later date, you don;t have to worry about=20
> > getting the same exact drive to replace it with.
>=20
> Don't most hardware RAIDs (including the 3ware) deal just fine with=20
> dissimilar new disks, as long as their block count is >=3D that of the=20
> original disks?  My external IDE-SCSI unit does this, and I know my 3ware=
s=20

Yes, generally.  This isn't the only potential problem, though.=20
Sometimes if a drive fails and you receive a warranty replacement form
the manufacturer, it may be rated at the same capacity, but may actually
have less blocks available.  The 3ware cards work around this by making
RAID array pieces slightly smaller than the size of the smallest drive,
I believe.  However, it appears that they aren't capable of using all of
the available capacity when you try to use different size drives.

> deal with disks with different rotation speeds.

Rotation speeds don't come in to play here.  I doubt that the 3ware card
does anything "intelligent" about drives with markedly different
transfer rates.  I'm not sure I'd care to figure out the logic of how to
do that, either.
	Greg


--=-rxAjjCyCOdxKU7xGNoTy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQA+Wl03nAkVXO6fw4sRAvU8AJsHI57QlP8rojr7m2XJuuBH9rwP3ACfZPRi
gfEpr8TWM9PZ5iYZk68eLoM=
=H8dz
-----END PGP SIGNATURE-----

--=-rxAjjCyCOdxKU7xGNoTy--

