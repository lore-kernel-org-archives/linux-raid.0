From: Roman Mamedov <rm@romanrm.net>
Subject: Re: mismatch_cnt constantly goes up on ssd+hdd raid1
Date: Thu, 25 Jun 2015 20:50:26 +0500
Message-ID: <20150625205026.42f41a81@natsu>
References: <3700381434301996@web21o.yandex.ru>
	<20150625113335.7bf72b0b@noble>
	<20150625101959.23981c72@natsu>
	<20150625172530.5c5338b6@noble>
	<2762371435246396@web9o.yandex.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FgnkKYZQUTQULnFx51Vj7=l"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2762371435246396@web9o.yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: tlknv <tlknv@yandex.ru>
Cc: NeilBrown <neilb@suse.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/FgnkKYZQUTQULnFx51Vj7=l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Jun 2015 18:33:16 +0300
tlknv <tlknv@yandex.ru> wrote:

> I have just discovered that I had 'discard' mount option even though I th=
ough it wasn't there :-(
> After removing 'discard' and forcing 'repair' mismatch_cnt stays 0 even a=
fter a bunch of writes and deletes (the most importantly) to the partition.

I wouldn't recommend disabling discard 'for good' though, from your experim=
ent
we can probably conclude the mismatch_cnt numbers you had previously are in=
deed
harmless. If you had no other issues due to discard being active, then what=
 you
did now is disable a working and useful feature to fix what's only a cosmet=
ic
problem.

--=20
With respect,
Roman

--Sig_/FgnkKYZQUTQULnFx51Vj7=l
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlWMI0IACgkQTLKSvz+PZwjwvgCeMAvjBK+jVX2wWMXpTaHY9HnJ
a4cAnR39F8rLsp+o2PRuHVgMG8ASLZXZ
=2lh2
-----END PGP SIGNATURE-----

--Sig_/FgnkKYZQUTQULnFx51Vj7=l--
