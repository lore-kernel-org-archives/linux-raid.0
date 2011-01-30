From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Performance question, RAID5
Date: Mon, 31 Jan 2011 00:54:44 +0500
Message-ID: <20110131005444.69a8e4d7@natsu>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<AANLkTi=SbAM3BXxjH6Mvcn-Tw4b0FYyLjLFqSGuxY1fk@mail.gmail.com>
	<AANLkTik4MGS7V7ePBgbk+KW-FcBBV7MuYgB7n29RRXF=@mail.gmail.com>
	<20110130094444.68288b0e@natsu>
	<AANLkTi=jXwcEgRquKgsf5HQUA+AQdt8nHeHCUJYqdSbX@mail.gmail.com>
	<20110130171533.4c9e236b@natsu>
	<AANLkTi=6UnGjDXdrM76-8_iW+1D6MC5fkGB-vhhYxUXu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/an2+EAEsNjDHswgHQGR3G6f"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=6UnGjDXdrM76-8_iW+1D6MC5fkGB-vhhYxUXu@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>
Cc: CoolCold <coolthecold@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/an2+EAEsNjDHswgHQGR3G6f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 30 Jan 2011 19:41:47 +0000
Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:

> I did find another PCI-E SATA controller that is generation 2.0, and
> looks like it may do the trick. This one:
> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816115053
> "HighPoint RocketRAID 2640x1 PCI-Express x1 Four-Port SATA and SAS
> RAID Controller Card".
>=20
> It's ~=E2=82=AC110 on eBay, a bit hefty. I might just save up and build a=
 NAS
> box from scratch, with some mainboard which has 8 SATA from the start
> etc.

This one is cheaper:
http://www.dealextreme.com/p/lsi-sas3041e-r-4-port-sas-sata-host-bus-adapte=
r-51317
Doesn't matter if it's v1.x or v2.0, since it's x4, it will have enough
bandwidth either way.

--=20
With respect,
Roman

--Sig_/an2+EAEsNjDHswgHQGR3G6f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1FwgQACgkQTLKSvz+PZwjVHQCfT9iRrk02DFgZmC7hVfN6JGee
2LEAn3jcE3nG40ei2I65OtUon/UxikIo
=eBfi
-----END PGP SIGNATURE-----

--Sig_/an2+EAEsNjDHswgHQGR3G6f--
