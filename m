From: Roman Mamedov <rm@romanrm.net>
Subject: Re: md-raid paranoia mode?
Date: Thu, 12 Jun 2014 14:53:57 +0600
Message-ID: <20140612145357.5be5656c@natsu>
References: <5397FBCE.3060009@bartk.us>
	<53990D44.300@fnarfbargle.com>
	<20140612122814.2db74377@natsu>
	<5399561A.4030405@hesbynett.no>
	<20140612140644.352e8c69@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9MGIMRf4xsNFO7ac.Fs2NuY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140612140644.352e8c69@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: David Brown <david.brown@hesbynett.no>, Brad Campbell <lists2009@fnarfbargle.com>, Bart Kus <me@bartk.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/9MGIMRf4xsNFO7ac.Fs2NuY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jun 2014 14:06:44 +0600
Roman Mamedov <rm@romanrm.net> wrote:

> Which is sad, since MD (on RAID6) *has* all the parity information needed=
 to
> recover a read error, and there isn't even any need for a special filesys=
tem
> on top of it, but it's like it just won't help you, almost out of princip=
le.

s/error/corruption/

--=20
With respect,
Roman

--Sig_/9MGIMRf4xsNFO7ac.Fs2NuY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOZaqUACgkQTLKSvz+PZwgzdQCeKWfZmDs/0e0mcIvrScZg61TD
zHIAn3Qq3JLem14s5JQH05tL8rsRjy55
=jFIX
-----END PGP SIGNATURE-----

--Sig_/9MGIMRf4xsNFO7ac.Fs2NuY--
