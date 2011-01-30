From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 06:56:16 +0100
Message-ID: <20110130055616.GA13022@www2.open-std.org>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com> <20110130035352.1d72e8d1@natsu> <AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com> <20110130015231.GA1435@www2.open-std.org> <AANLkTimw6CTP66FZdbH07kjMmHoxoFRF6Eq9WDR_LYt8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimw6CTP66FZdbH07kjMmHoxoFRF6Eq9WDR_LYt8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jan 30, 2011 at 01:54:42AM +0000, Mathias Bur=E9n wrote:
> On 30 January 2011 01:52, Keld J=F8rn Simonsen <keld@keldix.com> wrot=
e:
> > On Sat, Jan 29, 2011 at 11:44:01PM +0000, Mathias Bur=E9n wrote:
> >> On 29 January 2011 22:53, Roman Mamedov <rm@romanrm.ru> wrote:
> >> > On Sat, 29 Jan 2011 22:48:06 +0000
> >> > Mathias Bur=E9n <mathias.buren@gmail.com> wrote:
> >> >
> >> >> Hi,
> >> >>
> >> >> I'm wondering if the performance I'm getting is OK or if there'=
s
> >> >> something I can do about it. Also, where the potential bottlene=
cks
> >> >> are.
> >> >
> >> > How are your disks plugged in? Which controller model(s), which =
bus.
> >> > But generally, on an Atom 1.6 Ghz those seem like good results.
> >> >
> >> > --
> >> > With respect,
> >> > Roman
> >> >
> >>
> >>
> >> Hi,
> >>
> >> Sorry, of course I should've included that. Here's the info:
> >>
> >> ~/bin $ sudo ./drivescan.sh
> >> Controller device @ pci0000:00/0000:00:0b.0 [ahci]
> >> =A0 SATA controller: nVidia Corporation MCP79 AHCI Controller (rev=
 b1)
> >> =A0 =A0 host0: /dev/sda ATA Corsair CSSD-F60 {SN: 1032650558000999=
0027}
> >> =A0 =A0 host1: /dev/sdb ATA WDC WD20EARS-00M {SN: WD-WCAZA1022443}
> >> =A0 =A0 host2: /dev/sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ20152590}
> >> =A0 =A0 host3: /dev/sdd ATA WDC WD20EARS-00M {SN: WD-WMAZ20188479}
> >> =A0 =A0 host4: [Empty]
> >> =A0 =A0 host5: [Empty]
> >
> >
> > Hmm, it seems like you have 2 empty slots on the on-board =A0SATA
> > controller. Try to move 2 of the disks from the other controller to=
 the
> > on-board controller.
> >
> > And I would also avoid LVM. I think LVM affects striping.
> >
> > best regards
> > Keld
> >
>=20
> Sadly the 2 empty slots are not to be found on the motherboard, I
> guess they're in the chipset only.

maybe then use the 5th drive on the sata on-board controller in the
raid5 - the sda drive. If the raid5 is where you want performance from.=
=20

what do you use sda for? Your OS? It is a lot of space to use just for
the OS. It could easily go into the raid5 too. And you culd use a raid
for the system too, to secure you from bad things happening to your
system.

Or you could have a few 5 to 10 GB partitions in the beginning of
each drive, for experimenting with raid layout and performance.=20
This should be outside any LVM to exclude LVM having an impact on=20
the tests.=20

Maybe your PCI-e cannot do more than 2.5 Gbit - then 2 of your disks
would be enough to fill that connection. You could try out
a raid0 on the 3 drives. If you cannot get more than about 300 MB/s, th=
en=20
the PCI-E is a bottleneck.=20

If that is so, then having 3 drives from the PCI-E could slow down the
whole raid5, and using only 2 drives could speed up the full raid5.

The on-board sata controller is normally much faster, having a direct
connection to the southbridge - and typically a speed in the neighbourh=
ood of
20 Gbit - or 2500 MB/s - which would be enough for many systems to not
be the bottleneck. It can often pay off to have a motherboard with two
on-board sata controllers with in total 8 SATA ports or more,
instead of bying an extra PCI-E controller.

Looking forward to hear what you find out.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
