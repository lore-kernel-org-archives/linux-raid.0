From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 11:25:55 +0600
Message-ID: <20110526112555.7d2d7fdf@natsu>
References: <4DDDC301.7090608@turmel.org>
	<BANLkTiky1L9fisPnxMKsceG19LbhxcF0ag@mail.gmail.com>
	<4DDDC750.6040600@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GLf020wENWlQ8bPA_0j1Bky"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDDC750.6040600@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>, linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

--Sig_/GLf020wENWlQ8bPA_0j1Bky
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 May 2011 23:21:52 -0400
Phil Turmel <philip@turmel.org> wrote:

> Yeah, should have thought of that first.
>=20
> http://www.turmel.org/other/lsdrv

Traceback (most recent call last):
  File "/r/scripts/lsdrv", line 198, in <module>
    dev.phy =3D probe_device(sysclassblock+x+'/device', nodestr)
  File "/r/scripts/lsdrv", line 170, in probe_device
    vendor=3Dio.FileIO(devpath+'/vendor').read().split("\n",1)[0].strip(),
  File "/usr/lib/python2.6/io.py", line 631, in __init__
    _fileio._FileIO.__init__(self, name, mode, closefd)
IOError: [Errno 2] No such file or directory:
'/sys/devices/platform/floppy.0/vendor'

--=20
With respect,
Roman

--Sig_/GLf020wENWlQ8bPA_0j1Bky
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3d5GMACgkQTLKSvz+PZwhGJgCeLOErEoSVz7Pj5nmoAbDSzecq
sXIAnju7CfbDxdF62Gnfza7E9VmCslhC
=WDJP
-----END PGP SIGNATURE-----

--Sig_/GLf020wENWlQ8bPA_0j1Bky--
