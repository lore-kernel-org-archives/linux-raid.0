From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Two system lockups, Magic SysKeys works, RAID6 resyncs on
 reboot
Date: Wed, 1 Apr 2015 01:30:32 +0500
Message-ID: <20150401013032.5c908e85@natsu>
References: <CAK2H+efDuxdjmWZiOiJw+EK3wohY6FxRWgsm8rJc1j1+fniWig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/s0iNtCkd3O9Do5MAvlnTk71"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+efDuxdjmWZiOiJw+EK3wohY6FxRWgsm8rJc1j1+fniWig@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/s0iNtCkd3O9Do5MAvlnTk71
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Mar 2015 08:00:27 -0700
Mark Knecht <markknecht@gmail.com> wrote:

> md3 : active raid6 sdc3[9] sdg3[5] sdf3[6] sde3[7] sdd3[8]
>       1452264480 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [=
UUUUU]
>       [=3D=3D=3D=3D>................]  resync =3D 22.8% (110608304/484088=
160)
> finish=3D78.5min speed=3D79206K/sec

Looks like you are running this without a write intent bitmap, why? It would
at least save you from a full resync each time.

--=20
With respect,
Roman

--Sig_/s0iNtCkd3O9Do5MAvlnTk71
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUbA+gACgkQTLKSvz+PZwiu5ACggNDsXWFn2043w+cu/e44kb2s
eZMAnjjKBOVQOPneEEas1uK2irwQKxtf
=ufbN
-----END PGP SIGNATURE-----

--Sig_/s0iNtCkd3O9Do5MAvlnTk71--
