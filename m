From: Daniel Brahneborg <basic@wtnord.net>
Subject: Re: RAID5 over Serial-ATA success stories?
Date: Thu, 8 Jan 2004 09:27:44 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040108092744.B2500@nettis.grimsta>
References: <20040107223657.A5315@nettis.grimsta> <yw1xn08z8ltb.fsf@ford.guide> <20040108085711.A2500@nettis.grimsta> <yw1x65fm984p.fsf@ford.guide>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yw1x65fm984p.fsf@ford.guide>; from mru@kth.se on Thu, Jan 08, 2004 at 09:06:46AM +0100
To: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mru@kth.se>
Cc: Daniel Brahneborg <basic@wtnord.net>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 08, 2004 at 09:06:46AM +0100, M=E5ns Rullg=E5rd wrote:
> Daniel Brahneborg <basic@wtnord.net> writes:
> >> > It doesn't work with Silicon Image.
> >>=20
> >> What doesn't work?  There are drivers, at least in 2.6.  Raid shou=
ld
> >> care about what sort of disks you use.
> >
> > When using it for normal disks e2fsck reports bad blocks all
> > over the disk. When used for RAID, I get corrupted data.  Not
> > much, maybe every second time for a file of 500MB.
> > This is with the IDE driver.  With the SCSI driver, my computer
> > completely freezes when I activate my second network card (as I
> > reported earlier, unfortunately still without a solution).
> > RAID might work with that driver, but unless the network card
> > problem is solved, that doesn't help me.
>=20
> That sounds rather odd.  Have you reported this to the appropriate
> places?

I emailed the persons in the MAINTAINERS file that seemed
relevant (Jeff Garzik, mainly).  I don't really know where
else to go, I'm afraid.

> >> > It doesn't work with VIA (yet, anyway).
> >> > It might work with HighPoint.
> >>=20
> >> I've run RAID5 on a Highpoint RocketRAID 1540.  I used ATA disks w=
ith
> >> SATA converters, though.  Works with both 2.4 and 2.6.
> >
> > Sounds good to hear.  It's the second cheapest card for me.
>=20
> Beware that several people have reported some rather strange problems
> with the Highpoint cards.  You should get a deal to take it back if i=
t
> doesn't work.

I buy most things from komplett.se, they're nice with returns.

> >> > I don't know if there's a driver for Adaptec.
> >>=20
> >> Which Adaptec card?  The 12xx cards are fakeraid, but are supporte=
d as
> >> normal cards.  The 24xx cards are true hardware RAID cards.  Linux
> >> drivers exist for these, too.
> >
> > It's the 12xx cards that I'm looking at. I don't want hardware
> > RAID, since hardware RAID5 costs an infinite amount of money.
>=20
> Not really.  The Adaptec 24xx cards cost about the same as the disks
> you attach to them.  I ordered one from a while ago, but the shop wen=
t
> bankrupt before I got it, or at least their web site disappeared and
> they stopped answering mail or phone calls.

The Adaptec card I found would cost $250, which is about $200
more than I can spend on it.  If I can't get RAID5 to work I'd
rather buy more disks and do RAID10.

> >> > In case I have to replace my Silicon Image card, what should I r=
eplace
> >> > it with?  I'm currently leaning towards Promise TX4 (or TX2 if t=
he VIA
> >> > driver is completed).
> >>=20
> >> I stay as far away as I can from Promise and VIA.  Anything is usu=
ally
> >> better than those two.
> >
> > Why the warning about Promise?
>=20
> I've had some bad experience with them, that's all.  They appear to b=
e
> incompatible with Alpha machines, but probably work better in PCs.

I have a PC, so I'm hoping for the best.  I'll still make sure
that I can return it if it fails.

/Basic

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
