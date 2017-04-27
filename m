From: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Thu, 27 Apr 2017 16:54:16 +0200
Message-ID: <5492628.c8B43Z4h0G@matkor-lenovo>
References: <590117CD.1000009@tesco.net> <22785.65375.947842.648174@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22785.65375.947842.648174@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 27 of April 2017 10:25:35 John Stoffel wrote:
> Ron> issued these commands one after the other:
>=20
> Ron> # mdadm --manage -a /dev/mdo /dev/sdb1
> Ron> # mdadm --manage -a /dev/md1 /dev/sdb2
> Ron> # mdadm --manage -a /dev/md2 /dev/sdb3
> Ron> # mdadm --manage -a /dev/md3 /dev/sdb5
> Ron> # mdadm --manage -a /dev/md4 /dev/sdb6
> Ron> # mdadm --manage -a /dev/md5 /dev/sdb7
> Ron> # mdadm --manage -a /dev/md6 /dev/sdb8
> Ron> # mdadm --manage -a /dev/md7 /dev/sdb9
>=20
> Ugh!  You're setting yourself up for a true seek storm here, and way
> too much pain down the road, IMHO.  Just mirror the entire disk and
> put LVM volumes on top. =20

Why having several md devices leads to "seek storm"?

They will be synced one by one, just like one big md device.

Regards,
--=20
Mateusz Korniak
"(...) mam brata - powa=C5=BCny, domator, liczykrupa, hipokryta, pobo=C5=
=BCni=C5=9B,
 =09kr=C3=B3tko m=C3=B3wi=C4=85c - podpora spo=C5=82ecze=C5=84stwa."
=09=09=09=09Nikos Kazantzakis - "Grek Zorba"

