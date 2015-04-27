From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Paranoid mode for RAID-1 ?
Date: Mon, 27 Apr 2015 14:15:08 +0500
Message-ID: <20150427141508.7917846a@natsu>
References: <972437107.22507366.1430116679975.JavaMail.zimbra@laposte.net>
	<553DDBB3.2010306@websitemanagers.com.au>
	<553DE20E.2020605@hesbynett.no>
	<alpine.DEB.2.02.1504270925480.16871@uplift.swm.pp.se>
	<553DF0F1.8060608@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/E8u6aucPa6krUo_ZXdqoGfM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <553DF0F1.8060608@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/E8u6aucPa6krUo_ZXdqoGfM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Apr 2015 18:18:57 +1000
Adam Goryachev <mailinglists@websitemanagers.com.au> wrote:

> Speaking of which, I'm not convinced that we should spend that developer=
=20
> time on each and every FS (eg, duplicated effort for btrfs, zfs, and any=
=20
> others that do the same)

There isn't "each and every" FS, depending on whom you ask there's just one=
 FS
that you should use. :) The filesystem can also do checksums in a smarter w=
ay,
e.g. not checksum the free space. And developers of those filesystems aren't
going to abandon their checksum support or plans to add that just because t=
he
underlying block device MIGHT be an MD RAID array of a new weird type.

However one place where adding corruption resilience to MD can be extremely
interesting and possible almost "for free" (with no disk format change, for
example), is a constant full verification and corruption-healing RAID6.

--=20
With respect,
Roman

--Sig_/E8u6aucPa6krUo_ZXdqoGfM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlU9/hwACgkQTLKSvz+PZwjnLQCfbuWf51rj7uH/AX2YKoM+v/WF
zeYAni5yD4Abs8XNSLv+2sGX/TiVoPt3
=oxcA
-----END PGP SIGNATURE-----

--Sig_/E8u6aucPa6krUo_ZXdqoGfM--
