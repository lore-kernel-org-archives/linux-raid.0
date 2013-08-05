From: NeilBrown <neilb@suse.de>
Subject: Re: question about mdmon --takeover
Date: Mon, 5 Aug 2013 16:59:08 +1000
Message-ID: <20130805165908.2d1e291b@notabene.brown>
References: <CAC9WiBgFPSeKGBYxYCkw8DHk4dS6=aBhCeiMGgkj2eNgtY0asw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EpohVwq.5_1c4OydGbGE0Jy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBgFPSeKGBYxYCkw8DHk4dS6=aBhCeiMGgkj2eNgtY0asw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/EpohVwq.5_1c4OydGbGE0Jy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 31 Jul 2013 16:30:34 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hello list,
>=20
> I thought that using "--takeover" would hint mdmon to replace existing
> mdmon process, and therefore the old one would exit somehow.
>=20
> However after several "mdmon --takeover" I can see this:
>  $ ps aux | grep dmon
> root       233  0.0  0.2  80388 10752 ?        SLsl 14:02   0:00 @dmon
> --offroot md127
> root      3326  0.0  0.2  14920 10820 ?        SLsl 15:16   0:00 mdmon
> --takeover md127
> root      3343  0.0  0.2  14920 10820 ?        SLsl 15:17   0:00 mdmon
> --takeover md127
>=20
> Is this expected ?
>=20
> Thanks.

Nope.  That's not expected.

mdmon should send SIGTERM to the old mdmon and then wait for it to exit.

If the new and old mdmon were compiled different and look for the pid file =
in
different directories that might explain what you see.

If you compile mdadm from source it will use /run/mdadm.  However if your
distro doesn't have /run the the distro-provided mdadm will be compiled
differently.

It is safe to kill the old mdmons once a new one is running, but you should
probably find out what the incompatibility is...

NeilBrown

--Sig_/EpohVwq.5_1c4OydGbGE0Jy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUf9NPDnsnt1WYoG5AQLzMw//exctyyZynihqkp9GSx2XkspyNsMsOnTd
P5j9Ubi0DmYrD8nK5w3GcQqBnprdFuANeMlItkYfDERKMkkDfNHWkhgEjGNC/vIW
hTctAnWlzZRfXfVxYjpWNkqaDO08tkz6XZW0uS2GvJjW3cWoeJsvWrgTOKwFKLr1
hcCWq5ilg3HodKP2GHv0VbNV/jsInkio3Ci/pWjWZwaPdclzeXFchqq5NlUMiBKR
4mMmtezXkjEo1yOOttQ9anTEb9p5+WHas7PcHVtRLz2E32PRm5ZkwRACPVYWOpKe
nTwxlGu7eG7fmzwrwUO7DQXlIUazIdz1vnGeGarMxenkAYQ0A7U5rSE6gtmPhKUT
B7eqe0qtmN7eoIjpTluQC2o1S+TqGPdslRWX6pGOkOgga33DJ2AS2vf9ORZ3DZst
Qw5H/URzTabceUT+vDEST3Bx8TXnXaKJtuwRtPG7O9gRP1rt63oHWtsjq3JQqflF
MVE5ZCtIbYeV77lqksnw2LEl9aDMBk0osDc6cF+4nwBwis7o+/TomwMx+w2WKAF6
oMVHQjh+iYN6+1vNr+Ow4d9M4JaPckRzXGMrQa5f+fcJe+S+yWLos7mmXMHOCasS
pZDXRCNlMX7z0uXJ2XcNc0ASKhQGcjYYpItQc0zzEPAhNQiHAqGSZhj5Ia0KkQ1b
lNSm9mTGpp4=
=GVq6
-----END PGP SIGNATURE-----

--Sig_/EpohVwq.5_1c4OydGbGE0Jy--
