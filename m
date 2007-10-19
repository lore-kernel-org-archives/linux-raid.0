From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 19 Oct 2007 13:11:17 -0400
Message-ID: <1192813877.1666.79.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YV1w6lzYGb6HAPrR9TAj"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18200.56684.14194.630264@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-YV1w6lzYGb6HAPrR9TAj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-19 at 12:38 -0400, John Stoffel wrote:


>     1, 1.0, 1.1, 1.2
>=20
>       Use the new version-1 format superblock.  This has few restrictions=
.
>       The different sub-versions store the superblock at different locati=
ons
>       on the device, either at the end (for 1.0), at the start (for 1.1) =
or
>       4K from the start (for 1.2).
>=20
>=20
> It looks to me that the 1.1, combined with the 1.0 should be what we
> use, with the 1.2 format nuked.  Maybe call it 1.3?  *grin*

You're somewhat misreading the man page.  You *can't* combine 1.0 with
1.1.  All of the above options: 1, 1.0, 1.1, 1.2; specifically mean to
use a version 1 superblock.  1.0 means use a version 1 superblock at the
end of the disk.  1.1 means version 1 superblock at beginning of disk.
`1.2 means version 1 at 4k offset from beginning of the disk.  There
really is no actual version 1.1, or 1.2, the .0, .1, and .2 part of the
version *only* means where to put the version 1 superblock on the disk.
If you just say version 1, then it goes to the default location for
version 1 superblocks, and last I checked that was the end of disk (aka,
1.0).

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-YV1w6lzYGb6HAPrR9TAj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHGOU1TzP9PM7pjw8RAponAJ0b3bLg89bJOfdXJWkkEe2oL+5o3ACfc+xm
A99AcUV79uBav4Xru8W1ib8=
=QeOu
-----END PGP SIGNATURE-----

--=-YV1w6lzYGb6HAPrR9TAj--

