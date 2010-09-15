From: Andre Noll <maan@systemlinux.org>
Subject: Re: raid6 and parity calculations
Date: Wed, 15 Sep 2010 18:07:14 +0200
Message-ID: <20100915160714.GD7644@skl-net.de>
References: <20100915155524.31380.qmail@s217.sureserver.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Il7n/DHsA0sMLmDu"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100915155524.31380.qmail@s217.sureserver.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Sallaway <michael@sallaway.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Il7n/DHsA0sMLmDu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 15, 15:55, Michael Sallaway wrote:
> As a sort-of follow up question, would anyone know if the data size of
> a Q calculation affects the result at all? eg. if I do a 64kb Q
> calculation on 10 drives of data, would that be the same as doing 16x
> 4kb Q calculations on sequential blocks of the same data, then
> concatenating it together? (I can't remember what that operation
> property is called....?)

Yes, the result would be the same. In fact, byte n of Q depends only
on byte n of the 10/16 data drives.

> I've been reading the maths of RAID6 PDF
> (http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf), but I'm a
> bit too rusty to understand Galois fields, and if the data size
> matters. I presume the data ordering is also critical for a Q
> calculation, correct? (eg. drives have to be d0 -> d10 in order, not
> just random).

Right, order matters.

> And, in contrast, for the P calculations, data size and input order
> makes no difference, correct? (since it's just a simple bitwise XOR of
> all the inputs).

Also correct.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Il7n/DHsA0sMLmDu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFMkO8yWto1QDEAkw8RAs2+AJ0RIXPjfpqWyWoyoUOzy+//0yZ7FgCgh7eX
4TerRbwaRmvlnrqJvILGS6E=
=ko8I
-----END PGP SIGNATURE-----

--Il7n/DHsA0sMLmDu--
