From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 17:15:33 +0500
Message-ID: <20110130171533.4c9e236b@natsu>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<AANLkTi=SbAM3BXxjH6Mvcn-Tw4b0FYyLjLFqSGuxY1fk@mail.gmail.com>
	<AANLkTik4MGS7V7ePBgbk+KW-FcBBV7MuYgB7n29RRXF=@mail.gmail.com>
	<20110130094444.68288b0e@natsu>
	<AANLkTi=jXwcEgRquKgsf5HQUA+AQdt8nHeHCUJYqdSbX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0nfrZggSu1Z/NTmlEuQ9RUi"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=jXwcEgRquKgsf5HQUA+AQdt8nHeHCUJYqdSbX@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>
Cc: CoolCold <coolthecold@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/0nfrZggSu1Z/NTmlEuQ9RUi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 30 Jan 2011 12:09:02 +0000
Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:

> Right, it's just that I don't want to destroy my data. I've ran a few
> bonnie++ benchmarks with different mount options though. You can find
> them here: http://stuff.dyndns.org/logs/bonnie_results.html
> It actually looks like stripe=3D384 helped performance a bit. Currently
> retrying the same mount options but with 32MB stripe cache instead of
> 8MB.

Be aware that it's not just 32MB of RAM, it's
 =20
  "stripe_cache_size * 4096 (page size) * number of disks".

In other words on 6 disks this stripe cache will consume 768 MB of RAM.

--=20
With respect,
Roman

--Sig_/0nfrZggSu1Z/NTmlEuQ9RUi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1FVmUACgkQTLKSvz+PZwjLqQCcCG1k2pJP5dBxc7QMb8skmKSf
S1kAmweHTyf9pbjFhSZf81RHpEwCllFG
=lNFz
-----END PGP SIGNATURE-----

--Sig_/0nfrZggSu1Z/NTmlEuQ9RUi--
