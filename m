From: mru@kth.se (=?iso-8859-1?q?M=E5ns_Rullg=E5rd?=)
Subject: Re: RAID5 over Serial-ATA success stories?
Date: Wed, 07 Jan 2004 22:56:32 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1xn08z8ltb.fsf@ford.guide>
References: <20040107223657.A5315@nettis.grimsta>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Daniel Brahneborg <daniel.com@wtnord.net> writes:

> Hi,
>
> I'd like to hear some success stories for RAID5 on Serial-ATA disks.
> Which Serial-ATA card are you using?  Do you get decent performance?
> Is it stable with DMA enabled?  Do you use the 2.4 or 2.6 kernel?
>
> I know this much:
>
> It doesn't work with Silicon Image.

What doesn't work?  There are drivers, at least in 2.6.  Raid should
care about what sort of disks you use.

> It doesn't work with VIA (yet, anyway).
> It might work with HighPoint.

I've run RAID5 on a Highpoint RocketRAID 1540.  I used ATA disks with
SATA converters, though.  Works with both 2.4 and 2.6.

> It probably works with Promise.
> I don't know if there's a driver for Adaptec.

Which Adaptec card?  The 12xx cards are fakeraid, but are supported as
normal cards.  The 24xx cards are true hardware RAID cards.  Linux
drivers exist for these, too.

> In case I have to replace my Silicon Image card, what should I replac=
e
> it with?  I'm currently leaning towards Promise TX4 (or TX2 if the VI=
A
> driver is completed).

I stay as far away as I can from Promise and VIA.  Anything is usually
better than those two.

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
