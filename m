From: Andy Smith <andy@lug.org.uk>
Subject: Re: block level vs. file level
Date: Mon, 13 Feb 2006 12:01:55 +0000
Message-ID: <20060213120155.GZ32687@strugglers.net>
References: <43EF8CFB.5080403@kfa.org> <op.s4wlfngxcigqcu@apollo13>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pz1T4b43L2Pv13IG"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <op.s4wlfngxcigqcu@apollo13>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--pz1T4b43L2Pv13IG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2006 at 09:48:49AM +0100, PFC wrote:
> 	I suggest, when using software raid, to create partitions that are,=20
> 	say,  100 megabytes or even a gigabyte smaller than the size of the driv=
e.=20
> You  lose a bit of space, but if you ever need to change one, you won't=
=20
> feel  stupid with a brand new drive that you can't use because it's a few=
 =20
> sectors too short.

After my previous experience what I tend to do now is set aside
about 2GB on each disk to use as components of a RAID-0 that I use
for scratch space (/tmp or whatever, anything that I don't care
about losing) while the machine is running.

That way if I end up by bad luck getting a slightly smaller
replacement drive then I can just do away with or shrink its RAID-0
component while keeping the other partitions the same, yet the space
is not *totally* wasted.

--=20
http://strugglers.net/wiki/Xen_hosting -- A Xen VPS hosting hobby
Encrypted mail welcome - keyid 0x604DE5DB

--pz1T4b43L2Pv13IG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFD8HUzIJm2TL8VSQsRAlNhAJ43E1JQP8ojnmfUPThN7ruregKILACeK+d6
bHxpV3k2bKKOVOE7031jVyU=
=4lK/
-----END PGP SIGNATURE-----

--pz1T4b43L2Pv13IG--
