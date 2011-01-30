From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 02:52:31 +0100
Message-ID: <20110130015231.GA1435@www2.open-std.org>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com> <20110130035352.1d72e8d1@natsu> <AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: Roman Mamedov <rm@romanrm.ru>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jan 29, 2011 at 11:44:01PM +0000, Mathias Bur=E9n wrote:
> On 29 January 2011 22:53, Roman Mamedov <rm@romanrm.ru> wrote:
> > On Sat, 29 Jan 2011 22:48:06 +0000
> > Mathias Bur=E9n <mathias.buren@gmail.com> wrote:
> >
> >> Hi,
> >>
> >> I'm wondering if the performance I'm getting is OK or if there's
> >> something I can do about it. Also, where the potential bottlenecks
> >> are.
> >
> > How are your disks plugged in? Which controller model(s), which bus=
=2E
> > But generally, on an Atom 1.6 Ghz those seem like good results.
> >
> > --
> > With respect,
> > Roman
> >
>=20
>=20
> Hi,
>=20
> Sorry, of course I should've included that. Here's the info:
>=20
> ~/bin $ sudo ./drivescan.sh
> Controller device @ pci0000:00/0000:00:0b.0 [ahci]
>   SATA controller: nVidia Corporation MCP79 AHCI Controller (rev b1)
>     host0: /dev/sda ATA Corsair CSSD-F60 {SN: 10326505580009990027}
>     host1: /dev/sdb ATA WDC WD20EARS-00M {SN: WD-WCAZA1022443}
>     host2: /dev/sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ20152590}
>     host3: /dev/sdd ATA WDC WD20EARS-00M {SN: WD-WMAZ20188479}
>     host4: [Empty]
>     host5: [Empty]


Hmm, it seems like you have 2 empty slots on the on-board  SATA
controller. Try to move 2 of the disks from the other controller to the
on-board controller.

And I would also avoid LVM. I think LVM affects striping.

best regards
Keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
