From: Denis <denismpa@gmail.com>
Subject: raid over ethernet
Date: Sat, 29 Jan 2011 12:25:14 -0200
Message-ID: <AANLkTimUcQNKybbRkmx8V1OqpOvp7NpyCYqfXPMKHxg9@mail.gmail.com>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com>
 <alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se> <AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com>
 <20110129133457.GB15784@mordor.angband.thangorodrim.de> <AANLkTi=6ridRPnHpfdOC=f2_ESndSARmQRkvT_shYO3s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=6ridRPnHpfdOC=f2_ESndSARmQRkvT_shYO3s@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
Cc: Roberto Spadim <roberto@spadim.com.br>, Mikael Abrahamsson <swmike@swm.pp.se>, Alexander Schreiber <als@thangorodrim.de>
List-Id: linux-raid.ids

ouch, html. - my bad.

---------- Forwarded message ----------
=46rom: Denis <denismpa@gmail.com>
Date: 2011/1/29
Subject: Re: raid over ethernet
To: Alexander Schreiber <als@thangorodrim.de>
Cc: Roberto Spadim <roberto@spadim.com.br>, Mikael Abrahamsson
<swmike@swm.pp.se>, Linux-RAID <linux-raid@vger.kernel.org>




2011/1/29 Roberto Spadim=A0<roberto@spadim.com.br>
>
> Manging the combination of nbd and mdraid is complicated.
>
> complicated =3D drbd work?

I have been using drbd for a long time and it's quite easy to
implement, manage and use. The main purpose of all aplications I have
used it for, were high availibility and it works just fine. And it's
really cool to se it integrated with heartbeat, which will manage to
mount the partition on one or another node, according to your police
and nodes availibility.

2011/1/29 Alexander Schreiber <als@thangorodrim.de>
>
> plain disk performance for writes, while reads should be reasonably
> close to the plain disk performance - drbd optimizes reads by just re=
ading
> from the local disk if it can.
>

=A0However, I have not used it with active-active fashion. Have you? if
yes, what is your overall experience?

>
> Kind regards,
> =A0 =A0 =A0 =A0 =A0Alex.
> --
> "Opportunity is missed by most people because it is dressed in overal=
ls and
> =A0looks like work." =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0-- Thomas A. Edison
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

Cheers,

--
Denis Anjos,
www.versatushpc.com.br



--
Denis Anjos,
www.versatushpc.com.br
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
