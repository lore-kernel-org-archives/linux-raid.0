From: Alexander Schreiber <als@thangorodrim.de>
Subject: Re: raid over ethernet
Date: Mon, 31 Jan 2011 17:15:26 +0100
Message-ID: <20110131161526.GD13251@mordor.angband.thangorodrim.de>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com>
 <alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se>
 <AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com>
 <20110129133457.GB15784@mordor.angband.thangorodrim.de>
 <AANLkTi=6ridRPnHpfdOC=f2_ESndSARmQRkvT_shYO3s@mail.gmail.com>
 <20110129210815.GC15784@mordor.angband.thangorodrim.de>
 <AANLkTi=E_f2XYd432rpM2-hzXMAA2ntjYv2nS_SGu0OF@mail.gmail.com>
 <20110131130350.GB13251@mordor.angband.thangorodrim.de>
 <AANLkTim1qO5JmLoLihqHnq-EGJ8_n_=73ss1=kh215Nu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTim1qO5JmLoLihqHnq-EGJ8_n_=73ss1=kh215Nu@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Denis <denismpa@gmail.com>, Mikael Abrahamsson <swmike@swm.pp.se>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 31, 2011 at 12:45:31PM -0200, Roberto Spadim wrote:
> i think filesystem is a problem...
> you can't have two writers over a filesystem that allow only one, or
> you will have filesystem crash (a lot of fsck repair... local cache
> and other's features), maybe a gfs ocfs or another is a better
> solution...

No, for _our_ use case (replicated disks for VMs running under Xen
with live migration) the fileystem just _does_ _not_ _matter_ _at_
_all_. Due to the way Xen live migration works, there is only one
writer at any one time: the VM "owning" the virtual disk provided
by drbd.=20

To illustrate the point, a very short summary of what happens during
Xen live migration in our setup:
 - VM is to be migrated from host A to host B, with the virtual block
   device for the instance being provided by a drbd pair running on
   those hosts
 - host A/B are configured primary/secondary
 - we reconfigure drbd to primary/primary
 - start Xen live migration
 - Xen creates a target VM on host B, this VM is not yet running
 - Xen syncs live VM memory from host A to host B
 - when most of the memory is synced over, Xen suspends execution of
   the VM on host A
 - Xen copies the remaining dirty VM memory from host A to host B
 - Xen resumes VM execution on host B, destroys the source VM
   on host A, Xen live migration is completed
 - we reconfigure drbd on hosts A/B to secondary/primary

There is no concurrent access to the virtual block device here anywhere=
=2E
And the only reason we go primary/primary during live migration is that
for Xen to attach the disks to the target VM, they have to be available
and accessible on the target node - as well as on the source node where
they are currently attached to the source VM.

Now, if you were doing things like, say, use an primary/primary drbd
setup for NFS servers serving in parallel from two hosts, then yes,=20
you'd have to take special steps with a proper parallel filesystem
to avoid corruption. But this is a completely different problem.

Kidn regards,
          Alex.
>=20
> 2011/1/31 Alexander Schreiber <als@thangorodrim.de>:
> > On Mon, Jan 31, 2011 at 06:42:44AM -0200, Denis wrote:
> >> 2011/1/29 Alexander Schreiber <als@thangorodrim.de>:
> >> > On Sat, Jan 29, 2011 at 12:23:14PM -0200, Denis wrote:
> >> >> 2011/1/29 Alexander Schreiber <als@thangorodrim.de>
> >> >>
> >> >> >
> >> >> > plain disk performance for writes, while reads should be reas=
onably
> >> >> > close to the plain disk performance - drbd optimizes reads by=
 just reading
> >> >> > from the local disk if it can.
> >> >> >
> >> >> >
> >> >> =A0However, I have not used it with active-active fashion. Have=
 you? if yes,
> >> >> what is your overall experience?
> >> >
> >> > We are using drbd to provide mirrored disks for virtual machines=
 running
> >> > under Xen. 99% of the time, the drbd devices run in primary/seco=
ndary
> >> > mode (aka active/passive), but they are switched to primary/prim=
ary
> >> > (aka active/active) for live migrations of domains, as that need=
s the
> >> > disks to be available on both nodes. From our experience, if the=
 drbd
> >> > device is healthy, this is very reliable. No experience with run=
ning
> >> > drbd in primary/primary config for any extended period of time, =
though
> >> > (the live migrations are usually over after a few seconds to a m=
inute at
> >> > most, then the drbd devices go back to primary/secondary).
> >>
> >> What filesystem are you using to enable the primary-primary mode? =
Have
> >> you evaluated it against any other available option?
> >
> > The filesystem is whatever the VM is using, usually ext3. But the
> > filesystem doesn't matter in our use case at all, because:
> > =A0- the backing store for drbd =A0are logical volumes
> > =A0- the drbd block devices are directly exported as block devices
> > =A0 to the VMs
> > The filesystem is only active inside the VM - and the VM is not awa=
re of
> > the drbd primary/secondary -> primary/primary -> primary/secondary =
dance
> > that happens "outside" to enable live migration.

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
