From: John Lange <john.lange@bighostbox.com>
Subject: Re: Multi-channel ATA controller cards
Date: Mon, 10 May 2004 16:59:43 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1084226382.9691.150.camel@ws101.darkcore.net>
References: <S263851AbUEHXGM/20040508230612Z+21001@vger.kernel.org>
	 <11d001c43584$438fcfb0$cf01a8c0@internal.kbs.net.au>
	 <2089.192.168.1.2.1084224288.squirrel@192.168.1.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2089.192.168.1.2.1084224288.squirrel@192.168.1.2>
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Robin.

Just in case you are not all ready aware of this site:

"Serial ATA chipsets =E2=80=94 Linux support status"
http://www.linuxmafia.com/faq/Hardware/sata.html

I would check it before making any purchases. It seems to be quite up t=
o
date with regard to the status of Serial ATA on Linux. Short of looking
in the kernel source (another great idea) it might be the best place to
look to see if the cards you are looking at purchasing are supported.

On a related topic, I did some benchmarking with bonnie++ over the
weekend and I discovered that linux 2.6.5 was almost twice as fast at
software raid than the 2.4.22 kernel that comes with slackware-current.
I was quite stunned.

I'm curious if anyone else has done benching on 2.4 and 2.6 kernels and
come up with similar results?

Hopefully I'll have time to do up a little
software-raid-slackware-how-to and I'll include the bench results.

Regards,

John Lange

On Mon, 2004-05-10 at 16:24, Robin Bowes wrote:
> On Sun, May 9, 2004 6:11, Paul said:
> >
> > The best cost effective given speed and storage size is promise fas=
t track
> > tx4 and 250gb sata disks.
> > Use one or two controllers and have upto 1terrabyte. Then you can s=
tripe,
> > span or jbod them.
> > 2.4.26 with 2.4.27-pre1 patch update and libata patch works awesome=
=2E we
> > have
> > it running on several test boxes.
> > fast and economical solution. ata is old technology. cost of ata vs=
 sata
> > isn't much, $20 per controller or disk difference.
>=20
> Then, on Sun, May 9, 2004 6:12, Paul said:
> >
> > I've got an adaptec 1200 at home with 4 x 120GB raid5 and I find it=
 slow
> > and disk access is hampered.
> > They're all segate 8mb cache drives. The controller has a 128mb ecc=
 ram
> > chip also. Go for sata
>=20
> And a little later, on Sun, May 9, 2004 6:49, Mark Hahn said:
> >> I'm putting together a (relatively) large capacity Raid 5 storage
> >> solution
> >
> > large raid with pata is often a cabling nightmare.  I wouldn't cons=
ider
> > going larger than 6-8 disks without a custom case (and I'd call 8x2=
50G
> > pretty small-medium today.)
> >
> >> drives. I've been looking into various controller options, both PA=
TA and
> >> SATA, and have decided that PATA will give me best price/capacity.
> >
> > why?  I prefer 4-port promise sata controllers ($60).  disk prices =
are
> > not much different per GB.
> >
> >> So far, the most likely candidate (on a cost basis) is the Acard
> >> AEC6885S
> >> (http://www.acard.com/eng/product/adapter/pc/ide/aec-6885.html) wh=
ich is
> >> a
> >
> > ugh, choosing a non-mainstream card is usually a mistake.
> >
> >> Finally, does anyone know of any other 4-channel (or 6-channel) AT=
A
> >> controllers that would be worth my checking out?
> >
> > 3ware is the natural conservative choice
>=20
> Thanks for these replies guys.
>=20
> The reason I was considering the PATA controller was cost - both of t=
he
> controller and the disks. I have since found the Promise SATA150 TX4 =
for
> less than the ACard controller. The SATA version of the Maxtor MaxLin=
e II
> Plus 250GB drive is =C2=A3146.88 compared to =C2=A3134.76 for the PAT=
A version. For
> a six-disk system, that's a premium of =C2=A372.12 for SATA over PATA=
=2E
>=20
> I think I'll be going the SATA route.
>=20
> Next job, work out how to install it all - but that's a separate topi=
c!
>=20
> R.


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
