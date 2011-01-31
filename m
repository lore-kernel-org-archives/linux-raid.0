From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid over ethernet
Date: Mon, 31 Jan 2011 15:37:32 -0200
Message-ID: <AANLkTimZs2Ghz-UCzo0oQiRqta+YJXWBhZsmsfeo7RNd@mail.gmail.com>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com>
	<alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se>
	<AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com>
	<20110129133457.GB15784@mordor.angband.thangorodrim.de>
	<AANLkTi=6ridRPnHpfdOC=f2_ESndSARmQRkvT_shYO3s@mail.gmail.com>
	<20110129210815.GC15784@mordor.angband.thangorodrim.de>
	<AANLkTi=E_f2XYd432rpM2-hzXMAA2ntjYv2nS_SGu0OF@mail.gmail.com>
	<20110131130350.GB13251@mordor.angband.thangorodrim.de>
	<AANLkTim1qO5JmLoLihqHnq-EGJ8_n_=73ss1=kh215Nu@mail.gmail.com>
	<20110131161526.GD13251@mordor.angband.thangorodrim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131161526.GD13251@mordor.angband.thangorodrim.de>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Schreiber <als@thangorodrim.de>
Cc: Denis <denismpa@gmail.com>, Mikael Abrahamsson <swmike@swm.pp.se>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

nice, you don=B4t have two writers.

2011/1/31 Alexander Schreiber <als@thangorodrim.de>:
> On Mon, Jan 31, 2011 at 12:45:31PM -0200, Roberto Spadim wrote:
>> i think filesystem is a problem...
>> you can't have two writers over a filesystem that allow only one, or
>> you will have filesystem crash (a lot of fsck repair... local cache
>> and other's features), maybe a gfs ocfs or another is a better
>> solution...
>
> No, for _our_ use case (replicated disks for VMs running under Xen
> with live migration) the fileystem just _does_ _not_ _matter_ _at_
> _all_. Due to the way Xen live migration works, there is only one
> writer at any one time: the VM "owning" the virtual disk provided
> by drbd.
>
> To illustrate the point, a very short summary of what happens during
> Xen live migration in our setup:
> =A0- VM is to be migrated from host A to host B, with the virtual blo=
ck
> =A0 device for the instance being provided by a drbd pair running on
> =A0 those hosts
> =A0- host A/B are configured primary/secondary
> =A0- we reconfigure drbd to primary/primary
> =A0- start Xen live migration
> =A0- Xen creates a target VM on host B, this VM is not yet running
> =A0- Xen syncs live VM memory from host A to host B
> =A0- when most of the memory is synced over, Xen suspends execution o=
f
> =A0 the VM on host A
> =A0- Xen copies the remaining dirty VM memory from host A to host B
> =A0- Xen resumes VM execution on host B, destroys the source VM
> =A0 on host A, Xen live migration is completed
> =A0- we reconfigure drbd on hosts A/B to secondary/primary
>
> There is no concurrent access to the virtual block device here anywhe=
re.
> And the only reason we go primary/primary during live migration is th=
at
> for Xen to attach the disks to the target VM, they have to be availab=
le
> and accessible on the target node - as well as on the source node whe=
re
> they are currently attached to the source VM.
>
> Now, if you were doing things like, say, use an primary/primary drbd
> setup for NFS servers serving in parallel from two hosts, then yes,
> you'd have to take special steps with a proper parallel filesystem
> to avoid corruption. But this is a completely different problem.
>
> Kidn regards,
> =A0 =A0 =A0 =A0 =A0Alex.
>>
>> 2011/1/31 Alexander Schreiber <als@thangorodrim.de>:
>> > On Mon, Jan 31, 2011 at 06:42:44AM -0200, Denis wrote:
>> >> 2011/1/29 Alexander Schreiber <als@thangorodrim.de>:
>> >> > On Sat, Jan 29, 2011 at 12:23:14PM -0200, Denis wrote:
>> >> >> 2011/1/29 Alexander Schreiber <als@thangorodrim.de>
>> >> >>
>> >> >> >
>> >> >> > plain disk performance for writes, while reads should be rea=
sonably
>> >> >> > close to the plain disk performance - drbd optimizes reads b=
y just reading
>> >> >> > from the local disk if it can.
>> >> >> >
>> >> >> >
>> >> >> =A0However, I have not used it with active-active fashion. Hav=
e you? if yes,
>> >> >> what is your overall experience?
>> >> >
>> >> > We are using drbd to provide mirrored disks for virtual machine=
s running
>> >> > under Xen. 99% of the time, the drbd devices run in primary/sec=
ondary
>> >> > mode (aka active/passive), but they are switched to primary/pri=
mary
>> >> > (aka active/active) for live migrations of domains, as that nee=
ds the
>> >> > disks to be available on both nodes. From our experience, if th=
e drbd
>> >> > device is healthy, this is very reliable. No experience with ru=
nning
>> >> > drbd in primary/primary config for any extended period of time,=
 though
>> >> > (the live migrations are usually over after a few seconds to a =
minute at
>> >> > most, then the drbd devices go back to primary/secondary).
>> >>
>> >> What filesystem are you using to enable the primary-primary mode?=
 Have
>> >> you evaluated it against any other available option?
>> >
>> > The filesystem is whatever the VM is using, usually ext3. But the
>> > filesystem doesn't matter in our use case at all, because:
>> > =A0- the backing store for drbd =A0are logical volumes
>> > =A0- the drbd block devices are directly exported as block devices
>> > =A0 to the VMs
>> > The filesystem is only active inside the VM - and the VM is not aw=
are of
>> > the drbd primary/secondary -> primary/primary -> primary/secondary=
 dance
>> > that happens "outside" to enable live migration.
>
> --
> "Opportunity is missed by most people because it is dressed in overal=
ls and
> =A0looks like work." =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0-- Thomas A. Edison
>
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
