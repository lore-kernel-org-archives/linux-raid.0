From: Alexander Schreiber <als@thangorodrim.de>
Subject: Re: raid over ethernet
Date: Mon, 31 Jan 2011 14:03:50 +0100
Message-ID: <20110131130350.GB13251@mordor.angband.thangorodrim.de>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com>
 <alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se>
 <AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com>
 <20110129133457.GB15784@mordor.angband.thangorodrim.de>
 <AANLkTi=6ridRPnHpfdOC=f2_ESndSARmQRkvT_shYO3s@mail.gmail.com>
 <20110129210815.GC15784@mordor.angband.thangorodrim.de>
 <AANLkTi=E_f2XYd432rpM2-hzXMAA2ntjYv2nS_SGu0OF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=E_f2XYd432rpM2-hzXMAA2ntjYv2nS_SGu0OF@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Denis <denismpa@gmail.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, Mikael Abrahamsson <swmike@swm.pp.se>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 31, 2011 at 06:42:44AM -0200, Denis wrote:
> 2011/1/29 Alexander Schreiber <als@thangorodrim.de>:
> > On Sat, Jan 29, 2011 at 12:23:14PM -0200, Denis wrote:
> >> 2011/1/29 Alexander Schreiber <als@thangorodrim.de>
> >>
> >> >
> >> > plain disk performance for writes, while reads should be reasona=
bly
> >> > close to the plain disk performance - drbd optimizes reads by ju=
st reading
> >> > from the local disk if it can.
> >> >
> >> >
> >> =A0However, I have not used it with active-active fashion. Have yo=
u? if yes,
> >> what is your overall experience?
> >
> > We are using drbd to provide mirrored disks for virtual machines ru=
nning
> > under Xen. 99% of the time, the drbd devices run in primary/seconda=
ry
> > mode (aka active/passive), but they are switched to primary/primary
> > (aka active/active) for live migrations of domains, as that needs t=
he
> > disks to be available on both nodes. From our experience, if the dr=
bd
> > device is healthy, this is very reliable. No experience with runnin=
g
> > drbd in primary/primary config for any extended period of time, tho=
ugh
> > (the live migrations are usually over after a few seconds to a minu=
te at
> > most, then the drbd devices go back to primary/secondary).
>=20
> What filesystem are you using to enable the primary-primary mode? Hav=
e
> you evaluated it against any other available option?

The filesystem is whatever the VM is using, usually ext3. But the
filesystem doesn't matter in our use case at all, because:
 - the backing store for drbd  are logical volumes
 - the drbd block devices are directly exported as block devices
   to the VMs
The filesystem is only active inside the VM - and the VM is not aware o=
f
the drbd primary/secondary -> primary/primary -> primary/secondary danc=
e
that happens "outside" to enable live migration.

Kind regards,
           Alex.
--=20
"Opportunity is missed by most people because it is dressed in overalls=
 and
 looks like work."                                      -- Thomas A. Ed=
ison
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
