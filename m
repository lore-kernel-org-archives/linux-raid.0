From: Andre Noll <maan@systemlinux.org>
Subject: Re: Proposal: make RAID6 code optional
Date: Wed, 22 Apr 2009 20:57:03 +0200
Message-ID: <20090422185703.GF13280@skl-net.de>
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de> <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net> <20090418145850.GD28512@mea-ext.zmailer.org> <49EDD11E.2030309@tmr.com> <49EE00F9.6090000@zytor.com> <20090422180051.GD13280@skl-net.de> <49EF6457.90505@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OzxllxdKGCiKxUZM"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49EF6457.90505@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Matti Aarnio <matti.aarnio@zmailer.org>, Jesper Juhl <jj@chaosbits.net>, Prakash Punnoor <prakash@punnoor.de>, Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


--OzxllxdKGCiKxUZM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:39, H. Peter Anvin wrote:
> Yes, I believe it would be easier than having dynamically allocated=20
> arrays.  Dynamically generated arrays using static memory allocations=20
> (bss) is one thing, but that would only reduce size of the module on=20
> disk, which I don't think anyone considers a problem.

We would save 64K of RAM in the raid5-only case if we'd defer the
allocation of the multiplication table until the first raid6 array
is about to be started.


Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--OzxllxdKGCiKxUZM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJ72h/Wto1QDEAkw8RAr8pAJ4yz2/mn1Dv+c8mTYTOGvXtanDCLwCeJv4t
dPX7eZLkM40f+U7/HokpY/M=
=9it3
-----END PGP SIGNATURE-----

--OzxllxdKGCiKxUZM--
