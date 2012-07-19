From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Need to remove failed disk from RAID5 array
Date: Thu, 19 Jul 2012 20:35:57 +0600
Message-ID: <20120719203557.62a12bcd@natsu>
References: <CAB1R3shxBWebm13ie5gR0h++-GBTyfZrranHr8tjGkbPipV32w@mail.gmail.com>
	<50071C0A.8080307@tmr.com>
	<CAB1R3sjhES1+0XB43oXLomgH7Q6LPiTm11tPSoDJ91RRrfNy=A@mail.gmail.com>
	<20120719091611.22e16100@natsu>
	<500818D5.4080208@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wTkMLzxL8zojRppAQ3ba1f3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <500818D5.4080208@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Alex <mysqlstudent@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

--Sig_/wTkMLzxL8zojRppAQ3ba1f3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Jul 2012 10:25:25 -0400
Bill Davidsen <davidsen@tmr.com> wrote:

> That's a good argument for not using "whole disk" array members, a partit=
ion can=20
> be started at a good offset and may perform better.

Not really, at least with the modern metadata versions this is not a proble=
m,
as the whole-disk array members will start the actual data at an offset tha=
t is
suitably aligned for the AF drives.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/wTkMLzxL8zojRppAQ3ba1f3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAIG00ACgkQTLKSvz+PZwjqjQCcDH4WdyoW7HNLhOExRHvaEF34
1EoAn0kIPzlvMd4XvTFpZuY9ZRg1u3LI
=613v
-----END PGP SIGNATURE-----

--Sig_/wTkMLzxL8zojRppAQ3ba1f3--
