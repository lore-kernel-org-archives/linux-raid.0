From: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@kth.se>
Subject: Re: SATA chipset recomendations
Date: Wed, 09 Jun 2004 09:08:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1xise1tdif.fsf@kth.se>
References: <200406082012.58968.linux_mail@rozpooh.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

chris <linux_mail@rozpooh.com> writes:

> I want to setup a Linux software RAID 1 / Mirror array in the 2.6
> kernel.  I am looking for feedback regarding the best supported SATA
> chipsets.  Do any of these cards stick out as having better driver
> support?  Can you reccommend another card I have not mentioned?
>
> (I am not wanting to spend the big bucks on hardware RAID, so I am no=
t much=20
> interested the expensive 3Ware or Adaptec cards)
>
> Promise SATA150 TX4 ~ $65
> (I don't really need 4 ports, but, I would not mind having them for f=
uture=20
> use)
>
> Highpoint Rocket 1520 ~ $35

I'm using a Highpoint RocketRAID 1540 without any problems.  There
have been reports on this list from others having strange problems
with Rocket 1540 (no fakeraid) cards.  FWIW, my card is in a slightly
aging Alpha machine, which means that the BIOS on the card is pretty
much ignored.

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
