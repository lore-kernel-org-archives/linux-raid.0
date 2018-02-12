From: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Mon, 12 Feb 2018 11:43:12 +0100
Message-ID: <3275011.qXpCPUrKDu@matkor-lenovo>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org> <1934212.TzpEgCIeIR@matkor-lenovo> <fae4eb2a-59dc-9788-31ff-2b90d24328b9@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fae4eb2a-59dc-9788-31ff-2b90d24328b9@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Marc MERLIN <marc@merlins.org>, Kay Diederichs <kay.diederichs@uni-konstanz.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 11 of February 2018 12:13:45 Phil Turmel wrote:
> On 02/10/2018 04:43 PM, Mateusz Korniak wrote:
>
> > data is saved under different location when such write fails for
> > later reads?
>=20
> No. (...)

So having arrays having non-empty BBL members means that array is in fa=
ct=20
degraded (for tiny part, but still), right?

Is there any option for mdadm --monitor to send warning e-mail when bbl=
 entry=20
is added? (I can't see anything regarding bbl in mdadm --monitor sectio=
n) ?

--=20
Mateusz Korniak
"(...) mam brata - powa=C5=BCny, domator, liczykrupa, hipokryta, pobo=C5=
=BCni=C5=9B,
 =09kr=C3=B3tko m=C3=B3wi=C4=85c - podpora spo=C5=82ecze=C5=84stwa."
=09=09=09=09Nikos Kazantzakis - "Grek Zorba"

