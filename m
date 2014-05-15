From: NeilBrown <neilb@suse.de>
Subject: Re: Data offset
Date: Fri, 16 May 2014 08:07:46 +1000
Message-ID: <20140516080746.74daa4ca@notabene.brown>
References: <CAAOsTSmQUzup9Oy1EZstEi-bqZPgYhuhT6upQsoEc7TXq7n3kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/y=FvvZZT2.9ZZfSqQ17lyGr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSmQUzup9Oy1EZstEi-bqZPgYhuhT6upQsoEc7TXq7n3kg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: patrik@dsl.sk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/y=FvvZZT2.9ZZfSqQ17lyGr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 15 May 2014 16:11:46 +0200 Patrik Horn=C3=ADk <patrik@dsl.sk> wrote:

> Hello,
>=20
> I have couple of questions regarding data offset:
>=20
> - Current mdadm sets 128 MiB offset apparently for reshaping backup
> file. Is it really used by reshape? From which kernel / mdadm version?

Yes.  Linux 3.5 or there abouts.  mdadm 3.3
>=20
> - Is there any other good reason for such big offset?

No.  But when you typically have a terabyte of more per disc, 128MB isn't
very much.

>=20
> - Is there a support for specifying data offset when creating array?
> In which version of mdadm? What are recommended lower values?

Yes. mdadm-3.3.  Recommended value is the default.  Lowest usable value is
the lowest value it will let you use.

Why does a 128MB offset bother you?

NeilBrown

>=20
> Thanks.
>=20
> Patrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/y=FvvZZT2.9ZZfSqQ17lyGr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU3U6sjnsnt1WYoG5AQImVg/8Da32juVydM6fSKI5Xf5ZI2+AdaqHmVgi
RzuQOw0dhmiu3N4hB4DCxJr8deTYE5qHO39TkqtBzhPGgSRR+WK0b0F7C13r5mNu
0DQKTjsC4SPnNNCh8ajWKzs3g3DkRR5sxICkbCfFeos7UKeTfzg9CAxSQriusCSZ
MkkJZ21RW5TTTqe/4ZZ/zeFA9i9teryNato9IAYBG90lvuXrhYnPZ8MO9mnkSKR6
XeGwfAkBPrWBc9RKUrng1n7V6cWFqhZ8CGLX2n8zhhuKjRK1ZHEcNDRg118R0uOs
FGcdJj0+FjBG7KRIK9Wu/ddEUOkKzXTMIW3DzLUjuTFlqCIXgKo0iAejkAStMK/O
Pw58FSoBJuDhIyZKCEPpfnfQEHkCYqr6MOV8AXu6jSM//LQMqC7FCQATPDxSREmD
tRq93tOaxIEI990BscDzIfA9NS9TbRQUj7u6G5/jADu4fxd4TVavlDWs7rXCHlQM
3Q8Aw8JMN3EFgwo0GyTOHVR4+lsjpBtR6GKre8tdbX1jmhhxiO3D5qTlnCsnw3Po
tDxlUIQX1+Ckf2kFRvE6u35VGp0DiZKJi5W9IKdPNU10XqMbVV/gtoSEZSw+srK9
dMaZ9+JqXfjwHyel0HUIUJdcBI89HS4FbILesMdLQGgiAVsBbMnr4CfMUjPa2iae
j9eHuBPRcJM=
=kfD3
-----END PGP SIGNATURE-----

--Sig_/y=FvvZZT2.9ZZfSqQ17lyGr--
