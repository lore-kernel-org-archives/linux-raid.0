From: Andre Noll <maan@systemlinux.org>
Subject: Re: raid0 hashing funtion
Date: Wed, 13 May 2009 15:18:54 +0200
Message-ID: <20090513131854.GE11504@skl-net.de>
References: <5d96567b0905030629s3e1ec55coa9f0fc5fb0a3ce2b@mail.gmail.com> <18953.62556.265428.572219@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M/SuVGWktc5uNpra"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18953.62556.265428.572219@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Raz <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--M/SuVGWktc5uNpra
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08:12, Neil Brown wrote:

> On reflection, I am not convinced that the hash really does add value.
> You cannot have more entries in the list than there are drives, and
> you usually have much fewer.  Given that consecutive entries in the
> list are likely to be in the same cache line, and the hash_table is in
> a totally different page, probing 3 or 4 locations in the list is
> probably faster than doing a lookup in the hash table.  And as we
> would be able to get rid of that sector_div, we would probably get
> even more saving.

Yup, that's exactly what I was thinking when I looked at the code.

> The only cost would be if someone had a raid0 with lots of devices all
> of very different sizes.  I suspect that case does not need to be
> optimised for.  So I would probably be happy to accept a patch which
> removed that hash table.

I'll see if I can come up with a patch that gets rid of the hash table
and that one sector_div. Killing all instances of sector_div in raid0,
while possible and probably desirable, would be more involved though.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--M/SuVGWktc5uNpra
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKCsi+Wto1QDEAkw8RAgjzAJ0eblH4GHNhzPWZhMbeSTMXPQPLegCgpAaD
FtCh71OQQQEUl9cqn2dG8wk=
=FF24
-----END PGP SIGNATURE-----

--M/SuVGWktc5uNpra--
