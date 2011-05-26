From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 23:54:15 +0600
Message-ID: <20110526235415.584ae2e2@natsu>
References: <4DDDC301.7090608@turmel.org>
	<1306403130.9437.109.camel@torbjorn>
	<4DDE3BF1.7030105@turmel.org>
	<4DDE9213.2070508@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/U8bc2agIIE4YwITjg6MrNXc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDE9213.2070508@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: =?UTF-8?B?VG9yYmrDuHJu?= Skagestad <torbjorn@itpas.no>, linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>, CoolCold <coolthecold@gmail.com>, Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>
List-Id: linux-raid.ids

--Sig_/U8bc2agIIE4YwITjg6MrNXc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 May 2011 13:46:59 -0400
Phil Turmel <philip@turmel.org> wrote:

> if you just want the latest script:
>=20
> https://github.com/pturmel/lsdrv/raw/HEAD/lsdrv

I already reported this earlier, but still in this version:

Traceback (most recent call last):
  File "./lsdrv", line 274, in <module>
    probe_block('/sys/block/'+x)
  File "./lsdrv", line 226, in probe_block
    dev.phy =3D probe_device(blkpath+'/device', nodestr)
  File "./lsdrv", line 193, in probe_device
    vendor=3Dfileline1(devpath+'/vendor'),
  File "./lsdrv", line 49, in fileline1
    fh =3D open(filename, 'r')
IOError: [Errno 2] No such file or directory:
'/sys/devices/platform/floppy.0/vendor'

--=20
With respect,
Roman

--Sig_/U8bc2agIIE4YwITjg6MrNXc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3ek8cACgkQTLKSvz+PZwhcZwCeOsZhUSC8JO+XtmJmkZqxLxQs
kXwAnic8BppA+UY62A9qakq+cV991EHk
=/FJd
-----END PGP SIGNATURE-----

--Sig_/U8bc2agIIE4YwITjg6MrNXc--
