From: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@kth.se>
Subject: Re: HighPoint Rocket 1540 hang driver load
Date: Wed, 21 Apr 2004 18:55:07 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1xd66146fo.fsf@kth.se>
References: <40865AEC.8040604@online.no> <1082561078.40869236f3c14@www.tastycake.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nick Maynard <nick.maynard@alumni.doc.ic.ac.uk> writes:

> Thanks all for your replies.
>
> After having tried near everything (RocketRAID OSS driver with
> NON_RAID=3D1 (and a Makefile adjustment for brain errors from Highpoi=
nt)
> ), I still get the hangs you guys are talking about.  Not to mention
> hardware conflicts with my ancient mobo with onboard HPT366.
>
> I've come to the conclusion that the Rocket 1540 is quite frankly a
> useless card, and to get it to work with 2.6.x is probably asking too
> much.  I've managed to RMA the Rocket 1540 card, and I'm buying a
> Promise SATA150 TX4.
>
> So to repeat for future reference by the list, Rocket 1540 on Linux
> (esp 2.6) is a nono.  Buy a Promise card.

=46or it was the opposite.  I had no luck with a (PATA) Promise card, s=
o
I replaced it with a Rocketraid 1540 a year ago.  It's been running
smoothly ever since, with both 2.4 and 2.6 kernels.

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
