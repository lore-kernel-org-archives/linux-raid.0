From: Iustin Pop <iusty@k1024.org>
Subject: Re: new bottleneck section in wiki
Date: Wed, 2 Jul 2008 19:33:31 +0200
Message-ID: <20080702173331.GA2533@teal.hq.k1024.org>
References: <20080702155603.GA11156@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080702155603.GA11156@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?utf-8?B?SsO4cm4=?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 02, 2008 at 05:56:03PM +0200, Keld J=C3=B8rn Simonsen wrote=
:
> I should have done something else this afternoon, but anyway, I was
> inspired to write up this text for the wiki. Comments welcome.
>=20
> Keld
> [...]
> Many SATA controllers are on-board and do not use the PCI bus. Anyway
> bandwidth is limited, but it is probably different from motherboard t=
o
> motherboard. On board disk controllers most likely have a bigger
> bandwidth than IO controllers on a 32-bit PCI 33 MHz, 64-bit PCI 66 M=
Hz,
> or PCI-E x1 bus.

Sorry to ask... are you sure the on-board controllers are *not* on the
PCI bus?

They are not physically over the PCI bus, but still connected via the
same upstream-controller, I think, and still limited.

I'm not familiar in this area, but the mainboard diagrams (the ones wit=
h
pretty pictures, not electric ones) show that the on-board controllers
'hang' on the same PCI or PCI-E bus as the physical slots.

> RAM sppec may be a bottleneck. Using 32 bit RAM - or using a 32 bit
> operating system may double time spent reading and writing RAM.
>=20
> CPU usage may be a bottleneck, also combined with slow RAM or only us=
ing
> RAM in 32-bit mode.

Sorry, what is "32 bit RAM"? I never heard of this. Do you mean
dual-channel versus single-channel?

thanks!
iustin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
