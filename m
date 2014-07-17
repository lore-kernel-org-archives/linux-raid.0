From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Parallel make bug in Makefile of mdadm-3.3.1 (corrupted
 udev rules and/or systemd services)
Date: Thu, 17 Jul 2014 18:25:17 +1000
Message-ID: <20140717182517.23bf37d3@notabene.brown>
References: <53C77B7D.2090907@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/FATqz7Z_gmGZuoqZRW2HuaO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53C77B7D.2090907@gentoo.org>
Sender: linux-raid-owner@vger.kernel.org
To: Samuli Suominen <ssuominen@gentoo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/FATqz7Z_gmGZuoqZRW2HuaO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Jul 2014 10:30:05 +0300 Samuli Suominen <ssuominen@gentoo.org>
wrote:

> If you run with:
>=20
> $ export MAKEFLAGS=3D"-j9"
> $ make install install-systemd
>=20
> As in, combine "install" and "install-systemd" in the same command using
> parallel make,
> the content of .service files could end up in .rules, or otherway around
> because GNU
> make fill run them in parallel and the commands might ran at the same
> time, and both
> use same variables $file and same temporary files .install.tmp
>=20
> This was reported at,
> https://bugs.gentoo.org/show_bug.cgi?id=3D517218
>=20
> The immediate workaround is,
>=20
> $ export MAKEFLAGS=3D"-j9"
> $ make install
> $ make install-systemd
>=20
> And the attach patch makes it full proof so they can be ran at the same
> line.
>=20
> Thanks,
> Samuli

Hi,
 thanks for the bug report and the patch!

I don't think it is necessary to change the name for the variable (file ->
file1, file2 or file3).  Just leave it as 'file'.
However changing the name is important.  Could you send a patch which just
does that, and I'll apply it.

Also if the patch could be included inline in the mail, rather than as an
attachment, that would be nice.

(But if you don't want to bother, I'll make the fix anyway and credit you).

Thanks,
NeilBrown

--Sig_/FATqz7Z_gmGZuoqZRW2HuaO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8eIbTnsnt1WYoG5AQJPpg/+LwVmmqcvdnALti07sYKBXaL/cON190o3
bM/aoXHdq5cC56/C0NG6XgRzGaOYPVThYGYEdkK5sluBj71/AEnsL25C+LWgEwA8
53tqi5AE80WrEI5zQV7YtQBEBvm3uP+cQk0M5Vl2QDyleitsAut51YmGGiV++OEw
T3A/4cUCQaWrKkFJMrpTxLEBUVd7e9V3ZvDhP8HzKcFxk4vFko6OlcP8GluqpamA
nijnfHHjfS571u2+hXXBdax0AnmTo/Sv7ejArzWVC9+ehUemmqDvBEm775Z8UvbN
PmRNRrDFKe1tOnmK7io2AJkAic5DcirwkQTSu0/BjdD72fQHx8EOyTijqReOXljD
/EBvCNDWkEciegF80xExb9GtVXvh+pDO7J78JeOSmADi1Kkt3tFoh834Rbxt3L8o
VTYe/j2hrISMdd7i22XEEQ2m+qSj/Yw7ciZwLF+ulTvgfxuNEIz0lhoTZlSlaM/z
abZ88eAl12LsC9XD5zbGBZgmreHuQCcY6/PsuKFUc5hrAGG7ZJgwaYZfM96T3wER
sVDuhX8HZ9rVI/K7hbIoOPrNPuvb1qIANe/RzK17A1XxEEiPQRatdQ/4TukNWc7T
QgHXVIGrwdUJW9kPNj5FzwkpJ6DuSFmnneI+pisHhBFWXxQM5px95eZzW0DuL14E
vZBGMl2J1Kw=
=9xA2
-----END PGP SIGNATURE-----

--Sig_/FATqz7Z_gmGZuoqZRW2HuaO--
