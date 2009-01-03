From: Redeeman <redeeman@metanurb.dk>
Subject: Re: Corrupt data - RAID sata_sil 3114 chip
Date: Sat, 03 Jan 2009 03:31:57 +0100
Message-ID: <1230949917.21115.4.camel@localhost>
References: <495E01E3.9060903@sm7jqb.se>
	 <alpine.DEB.1.10.0901020741200.11852@p34.internal.lan>
	 <20090102213007.GA4349@lanczos.q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090102213007.GA4349@lanczos.q-leap.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, bengt@sm7jqb.se, debian-user@lists.debian.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2009-01-02 at 22:30 +0100, Bernd Schubert wrote:
> Hello Bengt,
>=20
> sil3114 is known to cause data corruption with some disks. So far I o=
nly know
> about Seagate, but maybe there issues with newer Samsungs as well?
>=20
> http://lkml.indiana.edu/hypermail/linux/kernel/0710.2/2035.html
>=20
> Unfortuntely this issue has been simply ignored by the SATA developer=
s :(
> So if you want to be on the safe side, go an get another controller.=20

Are you sure? is this not the "15" or "slow_down" thing mentioned here:
http://ata.wiki.kernel.org/index.php/Sata_sil ?
>=20
> I hope I won't frighten you too much, but it also might be possible o=
ne of=20
> your disks has a problem,  I have also seen a few broken disks, which=
 don't=20
> return what you write to it...
>=20
>=20
> Cheers,
> Bernd
>=20
>=20
> On Fri, Jan 02, 2009 at 07:42:30AM -0500, Justin Piszcz wrote:
> >
> >
> > On Fri, 2 Jan 2009, Bengt Samuelsson wrote:
> >
> >>
> >> Hi,
> >>
> >> I need some support for this soft-raid system.
> >>
> >> I am running it as RAID5 with 4 samsung spinpoint 500G SATA300 tot=
 1.3T byte
> >>
> >> And it runs in http://sm7jqb.dnsalias.com
> >> I use mdadm sytem in a Debian Linux
> >> CPU 1.2Mhz 1G memory ( my older 433Mhz / 512M dont work at all )
> >>
> >> I have 'some courrupt' data. And I don't understand whay and how t=
o fix it.
> >> Mybee slow it down more, but how slow it down?
> >>
> >> Any with experents from this cheep way of RAID systems.
> >>
> >> Ask for more information and I can get it, logs, setup files and w=
hat=20
> >> you want
> >> to know.
> >>
> >> --=20
> >> Bengt Samuelsson
> >> Nydalav=E4gen 30 A
> >> 352 48 V=E4xj=F6
> >>
> >> +46(0)703686441
> >>
> >> http://sm7jqb.se
> >>
> >>
> >> --=20
> >> To UNSUBSCRIBE, email to debian-user-REQUEST@lists.debian.org with=
 a=20
> >> subject of "unsubscribe". Trouble? Contact listmaster@lists.debian=
=2Eorg
> >>
> >
> > If this is an mdadm-related raid (not dmraid) please show all relev=
ant md=20
> > info, mdadm -D /dev/md0, I have cc'd linux-raid on this thread for =
you.
> >
> > You'll want to read md.txt in /usr/src/linux/Documentation and read=
 on=20
> > the check and repair commands.
> >
> > In addition, have you run memtest86 on your system first to make su=
re its=20
> > not memory related?
> >
> > Justin.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
