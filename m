From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 0/6] md: Fine-tuning for some function implementations
Date: Wed, 03 May 2017 07:36:53 +1000
Message-ID: <87efw7q6tm.fsf@notabene.neil.brown.name>
References: <f05bfc4e-7935-7e87-cc85-f0d9c5e3846a@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f05bfc4e-7935-7e87-cc85-f0d9c5e3846a@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, May 02 2017, SF Markus Elfring wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 2 May 2017 16:12:34 +0200
>
> Some update suggestions were taken into account
> from static source code analysis.
>
> Markus Elfring (6):
>   Replace seven seq_printf() calls by seq_putc()
>   Replace 17 seq_printf() calls by seq_puts()

Why does anyone care whether printf or putc/puts is used?  Really it
doesn't matter *at* *all*.
I don't object to the patch but if it would up to me I probably wouldn't
bother applying it it either.
Sometimes I just want to "print" something and I don't want to care
whether it is a constant string or a single-byte constant string, or
something more general.
I see these changes as worse than white-space fixes.

NeilBrown


>   Adjust four function calls together with a variable assignment
>   Use seq_puts() in faulty_status()
>   Adjust six function calls together with a variable assignment in faulty=
_status()
>   Add some spaces for better code readability
>
>  drivers/md/faulty.c | 48 ++++++++++++++++++++++----------------
>  drivers/md/md.c     | 66 +++++++++++++++++++++++++++++------------------=
------
>  2 files changed, 64 insertions(+), 50 deletions(-)
>
> --=20
> 2.12.2

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkI+/UACgkQOeye3VZi
gbnbLxAAkkjeZiebNdGM26aBT2DIBxFUZN2lY7vIyCRCcANMoOmDKAUOARxcMXEz
yT7eC4qTJ5ivNaV0Xoljfa0oOv3eIht6g0T8xXVbWaOi4DN0UjXtFrFe6oCzsXDU
lNSs0u0piWQ/8x4wFPkTHeiV3fYTkHtLy3yhes5FIQwF5w5sD95i2SEZsNZFvJf9
z3YFLdwf6vOJ4ARs0j6hshDFSD5AS8AfFzxesYBtBmVozJuPKeEVEpQBzEIvC8vX
7pjJS6uEDq+CCo0jBWolNz5FqyCc1n2p8BuCDxgz7Hk+ptlkaaHiGhfILoSYsHch
pP7GdDo3xjv4zHPCd2mxyFxc9ZH6oR3LhOQ/01/cd7kh9v3+xr9MqFVwDRn10zqQ
V7+mtyIaSXFxKFaX7+I6sEZIMZtrvbcrdmpW2Qgx4RbOQSMyiinOZ2wJ0sp0k+Ur
MCVgyaODd1kIXgjPi4OQhy+HuJuQKdgAvaGVODuBVw35kBlCfJ8LuUpzovCgf3nA
gn3vUVv2/tkJ4VwusbxEhkUz3v0deJ07fmIU8SfB7BjemuZYaOf7CMww3DQj/L+l
Nys5RhIMtDhctYDY8/19q5JyYdsiHZKuU0s/9Cma9dHN/4ng0X24xIymHmJJsk6C
bF6TYloZEswjw+COoTT2WFCvG6tV5H0T/9PcifE6Fdc0gdozHS4=
=ypFA
-----END PGP SIGNATURE-----
--=-=-=--
