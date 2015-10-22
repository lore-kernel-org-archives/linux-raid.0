From: Neil Brown <neilb@suse.com>
Subject: Re: Remove inactive array created by open
Date: Fri, 23 Oct 2015 10:38:37 +1100
Message-ID: <87fv12zd6q.fsf@notabene.neil.brown.name>
References: <20151022162445.GA11904@kw.sim.vm.gnt> <87vb9yzjfp.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vb9yzjfp.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Guinot <simon.guinot@sequanux.org>
Cc: linux-raid@vger.kernel.org, Remi Reroller <remi.rerolle@seagate.com>, Vincent Donnefort <vdonnefort@gmail.com>, Yoann Sculo <yoann@printk.fr>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Neil Brown <neilb@suse.com> writes:
> To create these you
>    echo whatever-you-like >  /sys/module/md_mod/parameters/new_array

correction.  It should be

    echo md_whatever-you-like >  /sys/module/md_mod/parameters/new_array

strings must start with "md_" and length must not exceed 31.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWKXN9AAoJEDnsnt1WYoG5wGQQAItsqWCuhMEuHty3OP3PL9WY
k4wggmMeopgVk2GDqzSUiMepRYYHjP2w1k8RdRbS8NuGvlwB+9WD9oaNAowouAY4
uAs1gb2Du3AOWlo0s7LIGpdEnEy6eg3bzNva8VsDI6wP/ZXaF+ZFmaCfb0jkv0ok
/cO/5XALcdn05Uh+635r0DAMTx72HcQzwU3wRw+FPMISVUpdShGFcKeREu0PLQz0
Qs4vf2iQFGx1UAL/QrwKxh9QLOvADMfEBmuIKE8J0w0MTfQNn2oCPqzKDs6qDeW/
Gds6/dX4aGTnoB/S4WVkmd7SXhVSqS4AYmHURk/4XZTfGPJSRw6QV1mG70xSGsQR
hxHGQMdIi1ZQK2cOTeCOjY3uh0K5JOPzTJ8niVPSWD3fJJrejWux266vI7gPLLFm
sHg/usfeAj8NBJrEeA9knuHaJ0GD/zf4bEzclKACK4g5k9cNs62noZtw9xUXXYXO
eadFA8Pkrq3BoyTROUUpJTokx13wZyWe1OCbLFLSzQctShFdNMq6lA/Uwf3yt1+D
7VN6GyWUkS3nAgW47OU3fq4dsfq4/x060k21igdyMl/ekX/FGsYDuduVnMMPk57r
oLthirQAH4sWaJBiSPWEhQLjkHJI3BM3rxxhPdN4Bqle8P/aDkt6EfvlveYQacFo
LxXg1vAjI4fh4r4nyiL5
=3/Tw
-----END PGP SIGNATURE-----
--=-=-=--
