From: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Fri, 28 Apr 2017 09:30:44 +0200
Message-ID: <3662808.assHz4yi0z@matkor-lenovo>
References: <590117CD.1000009@tesco.net> <22786.16524.435313.304834@quad.stoffel.home> <b74c3cae-a55d-9306-16fe-5b811c20ec89@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b74c3cae-a55d-9306-16fe-5b811c20ec89@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: John Stoffel <john@stoffel.org>, Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 27 of April 2017 21:42:27 Reindl Harald wrote:
> > Just create a single MD device across the entire disk (...)
>=20
> but you can't boot from a RAID5/RAID6/RAID10

Since some time you can boot from LVM LV having PV(s) on RAID10 with gr=
ub2.


--=20
Mateusz Korniak
"(...) mam brata - powa=C5=BCny, domator, liczykrupa, hipokryta, pobo=C5=
=BCni=C5=9B,
 =09kr=C3=B3tko m=C3=B3wi=C4=85c - podpora spo=C5=82ecze=C5=84stwa."
=09=09=09=09Nikos Kazantzakis - "Grek Zorba"

