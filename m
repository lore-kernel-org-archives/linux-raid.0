From: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Thu, 27 Apr 2017 16:58:01 +0200
Message-ID: <5595439.7OflYnrvFF@matkor-lenovo>
References: <590117CD.1000009@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <590117CD.1000009@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ron Leach <ronleach@tesco.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 26 of April 2017 22:57:33 Ron Leach wrote:
> is resulting in a very-unusually slow recovery.

What is output of=20
 iostat -x 30 2 -m=20
during recovery ?

Regards,

--=20
Mateusz Korniak
"(...) mam brata - powa=C5=BCny, domator, liczykrupa, hipokryta, pobo=C5=
=BCni=C5=9B,
 =09kr=C3=B3tko m=C3=B3wi=C4=85c - podpora spo=C5=82ecze=C5=84stwa."
=09=09=09=09Nikos Kazantzakis - "Grek Zorba"

