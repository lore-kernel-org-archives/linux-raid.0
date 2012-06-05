From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID5 with two drive sizes question
Date: Wed, 6 Jun 2012 01:59:50 +0600
Message-ID: <20120606015950.585d5454@natsu>
References: <4FCE4199.7030705@gmx.net>
	<20120605233953.2086cc4c@natsu>
	<4FCE60F3.4040606@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UcDvXQSRFYhldpstcLKfFVe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FCE60F3.4040606@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Joachim Otahal (privat)" <Jou@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/UcDvXQSRFYhldpstcLKfFVe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 05 Jun 2012 21:41:39 +0200
"Joachim Otahal (privat)" <Jou@gmx.net> wrote:

> Use only 750GB partitions, use the 3*250 GB loss at the end of each 1 TB=
=20
> drive for the fourth 750 GB, and RAID6 those 8*750. Result is 4.5 TB=20
> with a one-drive-loss tolerance and really bad performance.
> I spare you the 500 GB partitions example which result in 4.5 TB with a=20
> one-drive-loss tolerance and really bad performance.

Except this would not make any sense even as a thought experiment. You don't
want a configuration where two or more areas of the same physical disk need=
 to
be accessed in parallel for any read or write to the volume. And it's pretty
easy to avoid that.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/UcDvXQSRFYhldpstcLKfFVe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/OZTYACgkQTLKSvz+PZwibxwCglEQgWxF1kvc5x4eq1YFBZmJe
LHUAniRueXLbbz0oy2P1tKI71+FUHXAY
=Mbfk
-----END PGP SIGNATURE-----

--Sig_/UcDvXQSRFYhldpstcLKfFVe--
