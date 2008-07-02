From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: new bottleneck section in wiki
Date: Wed, 2 Jul 2008 20:14:54 +0200
Message-ID: <20080702181454.GA12446@rap.rap.dk>
References: <20080702155603.GA11156@rap.rap.dk> <20080702173331.GA2533@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080702173331.GA2533@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 02, 2008 at 07:33:31PM +0200, Iustin Pop wrote:
> On Wed, Jul 02, 2008 at 05:56:03PM +0200, Keld J=F8rn Simonsen wrote:
> > I should have done something else this afternoon, but anyway, I was
> > inspired to write up this text for the wiki. Comments welcome.
> >=20
> > Keld
> > [...]
> > Many SATA controllers are on-board and do not use the PCI bus. Anyw=
ay
> > bandwidth is limited, but it is probably different from motherboard=
 to
> > motherboard. On board disk controllers most likely have a bigger
> > bandwidth than IO controllers on a 32-bit PCI 33 MHz, 64-bit PCI 66=
 MHz,
> > or PCI-E x1 bus.
>=20
> Sorry to ask... are you sure the on-board controllers are *not* on th=
e
> PCI bus?

My understanding is that they are not on the PCI or PCI-E bus, but on
the southbridge. The southbridge then handles the PCI and PCI-E busses,
the ISA bus, and other busses, and also the IO controller.
Then the southbridge is connected to the northbridge.

> They are not physically over the PCI bus, but still connected via the
> same upstream-controller, I think, and still limited.

Yes, and I do not know what speeds that are typical here.
I would like to know more, if somebody can enlighten me.

> I'm not familiar in this area, but the mainboard diagrams (the ones w=
ith
> pretty pictures, not electric ones) show that the on-board controller=
s
> 'hang' on the same PCI or PCI-E bus as the physical slots.

This has been the case previously, but my understanding is that
this is not the case any longer for current motherboards, even for the
cheapest current motherboards.

> > RAM sppec may be a bottleneck. Using 32 bit RAM - or using a 32 bit
> > operating system may double time spent reading and writing RAM.
> >=20
> > CPU usage may be a bottleneck, also combined with slow RAM or only =
using
> > RAM in 32-bit mode.
>=20
> Sorry, what is "32 bit RAM"? I never heard of this. Do you mean
> dual-channel versus single-channel?

My terminology may be wrong. But I understand that if you
are running an OS as a 32 bit OS, then your memcpy() function
operate on the memory in 32 bit quantities, taking double the time to
move a memory area as if it were done with 64-bit operations.=20
I may be wrong there, and I would be glad if anybody could clarify.
Maybe the 32-bit OS and C library does this with 64-bit loads and
stores, or maybe there is an instruction in use to move a whole string
in one instruction.

A number of people run a 32-bit OS on 64 bit machine, either because a =
64
bit version of the OS is not available, or that some parts of the
functionality, eg. codecs are only available in a 32-bit version, or fo=
r
reasons of ignorance, they did not know that a 64 bit OS would be
better. So this is my concern that there may be room for improvement in
these cases.

best regards
keld

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
