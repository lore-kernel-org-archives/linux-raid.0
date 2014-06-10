From: NeilBrown <neilb@suse.de>
Subject: Re: md kernel thread hung in raid1_add_disk
Date: Wed, 11 Jun 2014 09:45:16 +1000
Message-ID: <20140611094516.6a310ba8@notabene.brown>
References: <CAKbOo_+414WYYfwEqRnhgdxp-GJGq0_koVaN89RvEydHZ3QZ=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0dSFnXTL8HYoCk.mY.vM=lc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKbOo_+414WYYfwEqRnhgdxp-GJGq0_koVaN89RvEydHZ3QZ=w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Eble <psychotrahe@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0dSFnXTL8HYoCk.mY.vM=lc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Jun 2014 22:32:42 +0200 Matthias Eble <psychotrahe@gmail.com>
wrote:

>    * OS is Rhel6, kernel is 2.6.32-358.6.2.el6.x86_64

Presumably you are running such an ancient kernel because you have a support
contract with Redhat?  In that case it would be best to ask them.

If you have problems with a recent kernel this is certainly the best place =
to
ask...

NeilBrown


>    * no write intent bitmap is used
>=20
> Now the questions:
>    * does anybody have an idea what the problem could be?
>    * or some ideas what I could do to narrow down problem, or find a work=
around?
>=20
> Any help is appreciated.
>=20
> Thanks in advance
> Matthias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/0dSFnXTL8HYoCk.mY.vM=lc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU5eYjDnsnt1WYoG5AQKkBA//XWPJJWDuQDr5rieNgKZ0UVm+J24ZFvdi
9dQ+q5RG9LfVe5H8DfEtClAsjGfouzb4QiMDjlllQscxrwmO5mhSsGqwG+1eZ4f5
mBVylS/UdXy7fLaM1hBGXGWCGQXtUGWoDFbcAHjHfveklJ4gw9fdOyU3ftjfbRnb
eRRhOgiq9pp3+BkEtzG2d6vHBrP5633KlXD5+JHQ3qKsMdXbY9YEfJvEkDjvziLM
2bEOo+AO8WVHEmhfRFTmgne7E7VdZe45V6RBfGeADs3bRTNbVi5TIX8M5XUA+oq/
vWA5kZ+tbK/BvVJT2LhVfZNdmH1XN0WMgN+tEdklkt6BeHjbVPWHXZbFR/AbH0r5
r4hDatdwBxY4EvAefAh42ASbkA7fXYxCl1/5aXWj5C0nvJBd2I37LX2qsOgJS9RX
JT2dcAUjAmsDlGT4NSXh2BuKQYuhRuXHE0PTuyMHnsd6b562IiIWosruOf7EXscw
iyQ7VyhGfcsVu5XcojbeufiDtkcCwhEtq3GSCUIH/qQqbXNiOtQILE4j50a2WvzK
/R5PoFdNzVmWqJ3bJueS2F3bolIM0Y4fcHApzIRGJp4KZeRnKAusY8Kw+7JXdHXA
EhZR/+EBXjREZyeXLjbWgRn/DfPhMEUekvGM6fyi99DohX4ruS82RkDvVdTnCOOw
+2cFSvEmgMU=
=mikX
-----END PGP SIGNATURE-----

--Sig_/0dSFnXTL8HYoCk.mY.vM=lc--
