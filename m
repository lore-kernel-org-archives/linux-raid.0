From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Which physical device failed?
Date: Wed, 27 May 2015 17:27:01 +0500
Message-ID: <20150527172701.1090e525@natsu>
References: <5565B2BB.5090701@gmail.com>
	<5565B41B.8040104@aei.mpg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Qcry9j.EzddTusyvimPddv6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5565B41B.8040104@aei.mpg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Cc: Michael Munger <michael.munger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Qcry9j.EzddTusyvimPddv6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 May 2015 14:10:03 +0200
Carsten Aulbert <Carsten.Aulbert@aei.mpg.de> wrote:

> On 05/27/2015 02:04 PM, Michael Munger wrote:
> > Or, does the OS have access to serial numbers, etc...?
> >=20
> > I have to guide someone through a drive replacement on the phone, and it
> > would be great if I could tell them exactly which drive to swap out...
>=20
> If you have direct knowledge, which serial number is where, you could
> use hdparm -I /dev/sdX or smartctl -a /dev/sdX against the still
> reachable drives.

If /dev/sdc is still present in the system (even if not responding correctl=
y to
hdparm or smartctl anymore), you should be able to find its serial number f=
rom
the udev symlink that was registered earlier, by running e.g.:

  ls -la /dev/disk/by-id/ | grep sdc$

Serial number is typically the last piece of the ID, after the manufacturer
name and model number.

--=20
With respect,
Roman

--Sig_/Qcry9j.EzddTusyvimPddv6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlVluBUACgkQTLKSvz+PZwg49gCfaUMiW9OgB1oZFSCStozrEeGT
nbUAn30LFvXRKRW7ZL7VSegMyXItbsSj
=CIN5
-----END PGP SIGNATURE-----

--Sig_/Qcry9j.EzddTusyvimPddv6--
