From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Raid 5 - not clean and then a failure.
Date: Tue, 25 Aug 2009 07:11:40 -0700 (PDT)
Message-ID: <936259.53228.qm@web51302.mail.re2.yahoo.com>
References: <4A93EB59.3060408@anonymous.org.uk>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A93EB59.3060408@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Tue, 25/8/09, John Robinson <john.robinson@anonymous.org.uk> wro=
te:

> From: John Robinson <john.robinson@anonymous.org.uk>
> Subject: Re: Raid 5 - not clean and then a failure.
> To: Jon@eHardcastle.com
> Cc: linux-raid@vger.kernel.org
> Date: Tuesday, 25 August, 2009, 2:47 PM
> On 25/08/2009 09:40, Jon Hardcastle
> wrote:
> > --- On Tue, 25/8/09, Robin Hill <robin@robinhill.me.uk>
> wrote:
> >> On Tue Aug 25, 2009 at 12:54:49AM -0700, Jon
> Hardcastle wrote:
> >>> I have been having some problems with my
> arrays that I think i have
> >>> nailed down to a pci controller (well I say
> that - it is always the
> >>> drives connected to *a* controller but I have
> tried 2!) anyway the
> >>> latest saga is i was trying some new kernel
> options last night - which
> >>> didn't work.
> >>=20
> >> Did they have the same chipset?=A0 I had
> problems with PCI controllers on
> >> one of my systems, which turned out to be some
> sort of conflict between
> >> the onboard chipset and the chipset on the
> controllers.=A0 I found a PCI
> >> card with a different chipset and have had no
> issues since.
> >=20
> > They are/were cheapy little via ones
>=20
> That's your problem right there. Well, in my experience and
> therefore opinion, VIA stuff is all too often junk, or at
> least iffy enough never to be trusted with anything
> professional or important.
>=20
> [...]
> > I have a pci express controller but my kernel doesnt
> (yet!) support pci express.
>=20
> *How old* is your kernel?
>=20
> Cheers,
>=20
> John.
> --

This is what I am finding.. i plugged in a second controller and it see=
ms to have nagered the first one such that I am getting  'port to slow =
to respond' from the drives connected now.

I am looking at my options. Once i get PCI-Express working I have optio=
ns. I am also looking at port multipliers.

(ps support is IN my kernel code.. I just ran down a trimmed kernel. Di=
dn't need PCI express  so i didn't enable it. now i do :) )

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its ow=
n.'
-----------------------


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
