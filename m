From: Andy Smith <andy@lug.org.uk>
Subject: Re: RAID 16?
Date: Thu, 2 Feb 2006 21:29:30 +0000
Message-ID: <20060202212930.GA7017@strugglers.net>
References: <43E19FAB.4000603@cogweb.net> <pan.2006.02.02.16.17.03.859560@smurf.noris.de> <Pine.GSO.4.62.0602021726010.14030@shaka.acc.umu.se> <Pine.LNX.4.56.0602021651370.19057@lion.drogon.net> <43E27716.10506@dynaconnections.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n83m4gEp0LancY77"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43E27716.10506@dynaconnections.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--n83m4gEp0LancY77
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 02, 2006 at 03:18:14PM -0600, J. Ryan Earl wrote:
> Gordon Henderson wrote:
>=20
> >I've actually had very good results hot swapping  SCSI drives on a live
> >linux system though.
> >
> >Anyone tried SATA drives yet?
> >
> Yes, and it does NOT work yet.  libata does not support hotplugging of=20
> harddrives yet: http://linux.yyz.us/sata/features.html=20
>=20
> It supports hotplugging of the PCI controller itself, but not harddrives.

Hotplugging of SATA II drives works with 3ware raid controllers
*when installed in a chassis that supports it*.  I believe pretty
much any chassis that says it supports SATA hotplug will do.
Personally I have had success with Chenbro 1U chassis.

--=20
http://strugglers.net/wiki/Xen_hosting -- A Xen VPS hosting hobby
Encrypted mail welcome - keyid 0x604DE5DB

--n83m4gEp0LancY77
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFD4nm6IJm2TL8VSQsRAsqkAJ0fMzroHxHnikAPvCVibLYPYeXFggCfUuuj
mKbIfqkSSQcnVVdPYKApPyg=
=ENoU
-----END PGP SIGNATURE-----

--n83m4gEp0LancY77--
