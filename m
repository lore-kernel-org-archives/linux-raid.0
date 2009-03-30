From: Andre Noll <maan@systemlinux.org>
Subject: Re: [md PATCH 4/6] md/raid5: change reshape-progress measurement to cope with reshaping backwards.
Date: Mon, 30 Mar 2009 11:20:55 +0200
Message-ID: <20090330092055.GU17185@skl-net.de>
References: <20090324084629.15383.10271.stgit@notabene.brown> <20090324085332.15383.94300.stgit@notabene.brown> <20090327161936.GQ17185@skl-net.de> <38a7f1dc05f8b3cedebd2e30a0288929.squirrel@neil.brown.name> <49CE1713.9070707@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t54s24TTWYm6oOX+"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49CE1713.9070707@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--t54s24TTWYm6oOX+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08:24, Bill Davidsen wrote:

> Let me say that (a) I find the existing code very readable, but (b) I
> find the suggested rewrite even more so, using (?:) notation. If you
> really want to use a macro, see the attached and preprocess with "cc
> -E" to expand the macro. I personally find the macro version really
> hard to read.

Yes, the macro is not much easier to read either. It's not only about
readability btw. Doing the check at only one place makes it easier to
change the code later, should that ever be necessary. It also reduces
the probability of getting it wrong at one location without noticing.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--t54s24TTWYm6oOX+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJ0I73Wto1QDEAkw8RAryuAKCrJ77SQBdIPw2FDQrtdkoQdMG/SgCgpjzq
UDB6J8uoYTvuN+bLUjcb9Gs=
=Ll0q
-----END PGP SIGNATURE-----

--t54s24TTWYm6oOX+--
