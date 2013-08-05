From: NeilBrown <neilb@suse.de>
Subject: Re: Bugreport ddf rebuild problems
Date: Mon, 5 Aug 2013 16:21:25 +1000
Message-ID: <20130805162125.73d4ab90@notabene.brown>
References: <CAGkViCHPvbmcehFvACBKVFFCw+DdnjqvK2uNGmvKrFki+n9n-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7kQiiKdm=rLhQJCmdpqbwSi"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGkViCHPvbmcehFvACBKVFFCw+DdnjqvK2uNGmvKrFki+n9n-Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/7kQiiKdm=rLhQJCmdpqbwSi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Aug 2013 21:22:44 +0200 Albert Pauw <albert.pauw@gmail.com> wrote:

> Now I've got it working, I checked a simple rebuild test with a ddf
> container, containing two raidsets (raid 1 and raid 5).
>=20
> Having 6 loopback devices of 512 MB each I opened in a separate screen th=
is
> to monitor what happens:
>=20
> while true; do clear; cat /proc/mdstat ; sleep 1; done
>=20

For future reference:
   watch cat /proc/mdstat

works very nicely for this sort of task.

I believe the bug you described is fixed in the current git tree.  If you
could confirm I would appreciate it.

Thanks,
NeilBrown

--Sig_/7kQiiKdm=rLhQJCmdpqbwSi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUf9EZTnsnt1WYoG5AQIrmg//XrIv5Vridn9Rt9lFLigDzrZmwJzAGL0O
LU+Hx6eL25zv9BdSeaJcoUWV5DvFdgl27HTrCPlH3q+vb5zgP0cxpzlumraPQXmD
jLX1TptSyQggxLfIByI8nlLopENqYx5uq4Uwtc/M2ZvGm8YBh6jz8OpxO4Fz1Vfd
FsR1qUVYw5jUm+UgW1kLb2vtIt9JMh3zMcQZEFrIDWof0f6WrT10A5yXEIn/sYUV
wzCY42vaOdZx+4/Gl7aB+ini3IQxPwr+WbNPMuyFYgE5H6BbRUJjLH5Q6KvV+BfA
6J7wIqnAQe1QwLu+5pCDDVnn0R1ahPDLq4ioapM13AWatCrs54uVvzTxhzUy4iZo
RmLiS2EkxUM2gpRmlGYMJ/8iwY6T/gZOHGrxgxF1MI1skSg6LvjpaTqmkPJyi9KF
/n5sm9s8bVA/KtG/QN3angcdru8rbdWhUrN4lKGk9WFr/4zrxFGTOT+6hv9xo1YW
QHG6Fjya16et8O+u0/A0IWnL0yrQNhdB2UfD7ayf/IDjY8eW9IzIdthyZnBISpfh
ikGBUJlAoU+JqnTb5X3mvW+lZ+d5Cm7to9+w5ltVLO54Fu18QgV2U/7yAtbfdxUv
CnC7rmqWH2VoP8OIXjkRxMJ3Yx1fXA0I+jJdXe1Eory02lZn7mWScrh2mKOEBxV4
sL234b+HjPg=
=ZzzK
-----END PGP SIGNATURE-----

--Sig_/7kQiiKdm=rLhQJCmdpqbwSi--
