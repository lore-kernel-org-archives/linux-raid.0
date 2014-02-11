From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/1] md/raid5: allow resync-rebuild requests to run
 multi-threaded
Date: Tue, 11 Feb 2014 13:13:54 +1100
Message-ID: <20140211131354.4167812c@notabene.brown>
References: <7847F3C0-2B56-48E7-802C-0FBA937FD44F@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vYhCAjF/lJkL0oNAqxVu=RU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7847F3C0-2B56-48E7-802C-0FBA937FD44F@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eivind Sarto <eivindsarto@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/vYhCAjF/lJkL0oNAqxVu=RU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi,
 thanks for the patch.
 When you include a patch as an attachment, I find it easier to work with if
 it is "text/plain" rather than "application/octet-stream".

 As your patch is justified as a performance improvement, please include
 some measurements together with a rough description of the hardware (one or
 two sentences).

 Also, the performance improvement requires that multi-threading is enabled,
 which isn't the default.  Please measure the effect of the patch when
 multi-threading not enabled.
 Maybe we should make the change you suggest be conditional on threading
 being enabled, but we can't know without numbers.

Thanks,
NeilBrown

--Sig_/vYhCAjF/lJkL0oNAqxVu=RU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUvmHYjnsnt1WYoG5AQLYZw/+ImrMb0VhjqEX8BaQ+IZUSjUu75aaPfpZ
eEWzX2g8azplqincqpuAE1ng5r0GzKFzZxoSlqcZOog7mJEsQ38En0GsKNockGv6
nAJUt+H2ite53kCaUQYdOy9mzp+cleIqj2uWd9b8BlQaDFQxCQAmzmEI7pfMF5dB
r1nwP1vbY8QRVzaGhHdgx3hUggl1cGRUsoQUetNBgZD+u87h6xs7vcu5DDjFsMMR
8dF2O0TnWFP/cJs0E3xFMioZ07ekPqLcgC2XZen+G5fsD2gLRe+Ke7wJ+XjQjlwt
YMJaZr4vQvRe921Rzp4lRQsgF4ZMthzzAg5G8FZTZWLupjxBOvUV84kx8pzVK+Z7
Wzbv4D0RB9POHZRez32L9yFTIOVAIAV9/3B5l98odQlnhIVNDKjla4LprC+lSyxu
9ve2iE/18vSQdRCSy6NYZ/YZRXqzk4HhgfJmy0nkJrCC4fsPpwPxqG+P6ISOKXYG
unGXW9YZxBCTp3H4HJy3gbNp7dyf14gf4s6ekzP+m2saNAswaTG4HDANopT0heD0
EvAUFbgA1aUQIG9LvpiHwmOAhF51F0/SgWEQDPKdvpZp6bWlbRw6cKgW2soDW83S
hgFqSgtoKLeG7q+k6N+vjGhVG4jStWypduuMCwt//PE9aRkDVinFzH3F6KcRiYuX
NJsJCFwPKGA=
=OSkW
-----END PGP SIGNATURE-----

--Sig_/vYhCAjF/lJkL0oNAqxVu=RU--
