From: NeilBrown <neilb@suse.de>
Subject: Re: commit backport request
Date: Tue, 17 Jul 2012 13:43:37 +1000
Message-ID: <20120717134337.751cd3e4@notabene.brown>
References: <20120709140230.3cf926ec@notabene.brown>
	<1342065131.25597.352.camel@deadeye.wl.decadent.org.uk>
	<CA+sTkh6Nnfx3OAF0CN0CfRCUHUg2XEtivY-DmTXrRGwnPLgY2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JneGpl0y3JDqDdrA7fxzkFa"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh6Nnfx3OAF0CN0CfRCUHUg2XEtivY-DmTXrRGwnPLgY2Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org, Jose Manuel dos Santos Calhariz <jose.calhariz@netvisao.pt>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/JneGpl0y3JDqDdrA7fxzkFa
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jul 2012 11:26:41 +0800 Igor M Podlesny <for.poige+lsr@gmail.com>
wrote:

> On 12 July 2012 11:52, Ben Hutchings <ben@decadent.org.uk> wrote:
> > On Mon, 2012-07-09 at 14:02 +1000, NeilBrown wrote:
> [...]
> > Queued up for 3.2.y, thanks.
> >
> > Ben.
>=20
>    Hm, it looks like 3.2.23 misses it =E2=80=94 at least my during rebase=
 the
> cherry-picked fix applied again cleanly.
>=20
> --

Given that the date on:

commit 8432d2280bd7558fde3a0385d1b35c947197d754
Author: Ben Hutchings <ben@decadent.org.uk>
Date:   Thu Jul 12 04:32:21 2012 +0100

    Linux 3.2.23


is before the date on Ben's email (by a few hours), I suspect it is queued =
for
3.2.24.

NeilBrown

--Sig_/JneGpl0y3JDqDdrA7fxzkFa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUATfaTnsnt1WYoG5AQJwwhAAnUn0zPXYHEyS28fODxFEjDY9e5AV5iL6
xRk3dIUW1rdQ/z10QMtaj7KmZ5QROmfrRYWfOtXJL6/x6VZM52B9XBJoi3k6hX0N
EJgERFCNRymY4wWAM/MSUUzdenJhdh5LQXkwzE78E5pVFxPPckNhZvod/zvWyf1p
ujH24H3R/JD+R/U5rwhHnRb4qNxtG0rsAqMPkjuwqbd/se2+CHuRXQ0DdxE+a0Cj
vjwuA4IoQl0CkcaFQXeKXZPcoIpcbDgxOou4yYIL4ytur/z2c3IjaWJbn6epBDJc
PuDgN8Z+qIxndtViIKoH2Sf5zqAb9xEwly3gTexg4D1EfDcksju7kbOTSom7efw8
6WY4uUWxNbR8tW2nlGaWxdCbVF/IOB0x50mKbzAU68+iem2zgTe+k9Ge3HkLiIjm
gW3dODwLPzvtmY/wakKsbgQbzWwsZVgi61fj5Bm7K3vRv5N+j7r6uKkQVa/RsnEJ
uiAYjQESU9zFJEg6+G4aBajMQuSDDQNmDjoalIF9fI9uxgXUOQ5qRthSMKXfRob4
JAvEp1ENeykXVBrFT2/MdNB4HUX0l5JZFsxz5gbGS3MqIws5jM+VKP1JSdqqMMQw
OGGpF8EW0Mm0Fq1ZyQ3oJ/XEI/H9IORnhqqzCsrpPzFt3FExNgEi7dj+hdbyb4Fb
Ai0VBUF1cos=
=SyNF
-----END PGP SIGNATURE-----

--Sig_/JneGpl0y3JDqDdrA7fxzkFa--
