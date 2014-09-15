From: NeilBrown <neilb@suse.de>
Subject: Re: Speeding up reading with RAID1 and --write-mostly
Date: Mon, 15 Sep 2014 14:11:33 +1000
Message-ID: <20140915141133.0a4da9ad@notabene.brown>
References: <20140913060143.GA15849@fishbowl.rw.madduck.net>
	<CAH3kUhGEaon77fpNm2mjRwPbNMZe9BLK3eA6LTB4xQeg0hMF-Q@mail.gmail.com>
	<20140913162301.GB14969@fishbowl.rw.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+895=fZ5o1Ilp.B.z8G0xp0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140913162301.GB14969@fishbowl.rw.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/+895=fZ5o1Ilp.B.z8G0xp0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 13 Sep 2014 18:23:01 +0200 martin f krafft <madduck@madduck.net>
wrote:

> also sprach Roberto Spadim <roberto@spadim.com.br> [2014-09-13 13:56 +020=
0]:
> > Try a bcache or something like it
>=20
> The problem with a cache is that the data have to be read once from
> the slow disk anyway, whereas I am proposing to keep a shadow copy
> on rotational disk, really, just in case the MMC may need to be
> removed at some point.
>=20

It is a persistent cache though.  So it only needs to be read once.
If the cache SD is the same sizes as the main device then it should never
ever need to read again.

But I suspect you will find that SD cards aren't really fast enough for your
needs.  It wouldn't hurt to experiment on just an SD card and see how it
performs.

NeilBrown

--Sig_/+895=fZ5o1Ilp.B.z8G0xp0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBZm9Tnsnt1WYoG5AQK1XxAAurFNdP2lgdwwtzqOmkvs8n5EGzZ95Aa+
H9Iuw9TTkPg7yXxVKvagRMU+fA4zO9azYMqQ0I3iTHH9wTTMonYyXCPgOaKMoBFx
ZlHKSRxFT7+uBHUvsVqiSic3ALvW+MAavmE4C2XlJqH+9cThdBlPxX8eWuT7Vkrs
MIfKdXkthFGgd0wLI9U+68kpN821gLNNimx8Snd6HYq1uvuBDpGoKLPnyoumoqbD
I96sFJncxjueNv2kO+ta59lde7z/Ii1ZH4comoRStoi5al6Wj7gkR7CSpXnCmjUV
53c3qPEyzO2dsre1c7i/xesSZuEQDfDWjGCLevt7AjNvU328dzMTBwptz895qY+C
1DwMdItnO5rpSzPnbXkIBroGIGANlh1vuelj50A9P8sbwtqASHwMD86mUpzyHF08
KeBYZLLFE4p38rXO2cuVmCKurhUeVFbKRajnL7HzpY/6/dxgYvbhDhXzJLtaR5t5
gGt7XwmTYEUg1ACNDze7ICD7QNUGZU76X5t4a6Gy6z6S9FfU2jzrceYcGkpnk9Zb
Lueji2mJOoqwNuTTQ2JAQUB+giJX6qEC3bNU+aLRMqWc7QBUOcFR4N0AgNaHp+ji
k49XSOjfLoEF83Zwhc5SDdApW8cwDARyVnixxSP5TAtbTQufF0xugUl7DOVwJ7ez
/vUESYpFNk0=
=Ee05
-----END PGP SIGNATURE-----

--Sig_/+895=fZ5o1Ilp.B.z8G0xp0--
