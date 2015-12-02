From: Roman Mamedov <rm@romanrm.net>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Wed, 2 Dec 2015 10:22:37 +0500
Message-ID: <20151202102237.2adb17d4@natsu>
References: <CAE9DZURyZKmnUmnn5ELAhLUq8nhXD1eBx4g8hDmCzS-MYLrT+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ln61ddCo0AAd1vRcRQn4eZz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZURyZKmnUmnn5ELAhLUq8nhXD1eBx4g8hDmCzS-MYLrT+Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ln61ddCo0AAd1vRcRQn4eZz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 1 Dec 2015 17:02:27 -0600
Dallas Clement <dallas.a.clement@gmail.com> wrote:

> I am frankly surprised at these results.  Perhaps there is some
> configuration or tunable settings that have changed since the 2.6
> kernel that I am unaware of that affect RAID 5, 6 performance.  Please
> comment if you have any ideas which might explain what I am seeing.

Do you use a write intent bitmap (internal?), what is your bitmap chunk siz=
e?

What is your stripe_cache_size set to?

--=20
With respect,
Roman

--Sig_/ln61ddCo0AAd1vRcRQn4eZz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlZegB0ACgkQTLKSvz+PZwjt2wCgl8H2VrDyoHfuI3OuPDZPVstp
sp4AnjGFk/u+bUjyJA6/67xpkcxLATd9
=WVsW
-----END PGP SIGNATURE-----

--Sig_/ln61ddCo0AAd1vRcRQn4eZz--
