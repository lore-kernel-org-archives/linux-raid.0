From: mru@kth.se (=?iso-8859-1?q?M=E5ns_Rullg=E5rd?=)
Subject: Re: RAID5 over Serial-ATA success stories?
Date: Thu, 08 Jan 2004 09:06:46 +0100
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <yw1x65fm984p.fsf@ford.guide>
References: <20040107223657.A5315@nettis.grimsta>
	<yw1xn08z8ltb.fsf@ford.guide> <20040108085711.A2500@nettis.grimsta>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20040108085711.A2500@nettis.grimsta> (Daniel Brahneborg's
 message: 57:11 +0100")
To: Daniel Brahneborg <basic@wtnord.net>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Daniel Brahneborg <basic@wtnord.net> writes:

> Thanks for the feedback, it's very valuable to me.
>
> On Wed, Jan 07, 2004 at 10:56:32PM +0100, M=E5ns Rullg=E5rd wrote:
>> Daniel Brahneborg <daniel.com@wtnord.net> writes:
>>=20
>> > I'd like to hear some success stories for RAID5 on Serial-ATA disk=
s.
>> > Which Serial-ATA card are you using?  Do you get decent performanc=
e?
>> > Is it stable with DMA enabled?  Do you use the 2.4 or 2.6 kernel?
>> >
>> > I know this much:
>> >
>> > It doesn't work with Silicon Image.
>>=20
>> What doesn't work?  There are drivers, at least in 2.6.  Raid should
>> care about what sort of disks you use.
>
> When using it for normal disks e2fsck reports bad blocks all
> over the disk. When used for RAID, I get corrupted data.  Not
> much, maybe every second time for a file of 500MB.
> This is with the IDE driver.  With the SCSI driver, my computer
> completely freezes when I activate my second network card (as I
> reported earlier, unfortunately still without a solution).
> RAID might work with that driver, but unless the network card
> problem is solved, that doesn't help me.

That sounds rather odd.  Have you reported this to the appropriate
places?

>> > It doesn't work with VIA (yet, anyway).
>> > It might work with HighPoint.
>>=20
>> I've run RAID5 on a Highpoint RocketRAID 1540.  I used ATA disks wit=
h
>> SATA converters, though.  Works with both 2.4 and 2.6.
>
> Sounds good to hear.  It's the second cheapest card for me.

Beware that several people have reported some rather strange problems
with the Highpoint cards.  You should get a deal to take it back if it
doesn't work.

>> > It probably works with Promise.
>> > I don't know if there's a driver for Adaptec.
>>=20
>> Which Adaptec card?  The 12xx cards are fakeraid, but are supported =
as
>> normal cards.  The 24xx cards are true hardware RAID cards.  Linux
>> drivers exist for these, too.
>
> It's the 12xx cards that I'm looking at. I don't want hardware
> RAID, since hardware RAID5 costs an infinite amount of money.

Not really.  The Adaptec 24xx cards cost about the same as the disks
you attach to them.  I ordered one from a while ago, but the shop went
bankrupt before I got it, or at least their web site disappeared and
they stopped answering mail or phone calls.

>> > In case I have to replace my Silicon Image card, what should I rep=
lace
>> > it with?  I'm currently leaning towards Promise TX4 (or TX2 if the=
 VIA
>> > driver is completed).
>>=20
>> I stay as far away as I can from Promise and VIA.  Anything is usual=
ly
>> better than those two.
>
> Why the warning about Promise?

I've had some bad experience with them, that's all.  They appear to be
incompatible with Alpha machines, but probably work better in PCs.

> The reason I want the VIA driver to work is that I've got two VIA
> connectors on the motherboard, so I only need a 2 port SATA card.

=46rom what I've heard, VIA have improved a bit of late, but they used
to have a rather bad reputation.  I don't know anything about the
drivers, though.

--=20
M=E5ns Rullg=E5rd
mru@kth.se
