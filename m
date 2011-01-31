From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid over ethernet
Date: Mon, 31 Jan 2011 12:45:31 -0200
Message-ID: <AANLkTim1qO5JmLoLihqHnq-EGJ8_n_=73ss1=kh215Nu@mail.gmail.com>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com>
	<alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se>
	<AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com>
	<20110129133457.GB15784@mordor.angband.thangorodrim.de>
	<AANLkTi=6ridRPnHpfdOC=f2_ESndSARmQRkvT_shYO3s@mail.gmail.com>
	<20110129210815.GC15784@mordor.angband.thangorodrim.de>
	<AANLkTi=E_f2XYd432rpM2-hzXMAA2ntjYv2nS_SGu0OF@mail.gmail.com>
	<20110131130350.GB13251@mordor.angband.thangorodrim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131130350.GB13251@mordor.angband.thangorodrim.de>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Schreiber <als@thangorodrim.de>
Cc: Denis <denismpa@gmail.com>, Mikael Abrahamsson <swmike@swm.pp.se>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i think filesystem is a problem...
you can't have two writers over a filesystem that allow only one, or
you will have filesystem crash (a lot of fsck repair... local cache
and other's features), maybe a gfs ocfs or another is a better
solution...

2011/1/31 Alexander Schreiber <als@thangorodrim.de>:
> On Mon, Jan 31, 2011 at 06:42:44AM -0200, Denis wrote:
>> 2011/1/29 Alexander Schreiber <als@thangorodrim.de>:
>> > On Sat, Jan 29, 2011 at 12:23:14PM -0200, Denis wrote:
>> >> 2011/1/29 Alexander Schreiber <als@thangorodrim.de>
>> >>
>> >> >
>> >> > plain disk performance for writes, while reads should be reason=
ably
>> >> > close to the plain disk performance - drbd optimizes reads by j=
ust reading
>> >> > from the local disk if it can.
>> >> >
>> >> >
>> >> =A0However, I have not used it with active-active fashion. Have y=
ou? if yes,
>> >> what is your overall experience?
>> >
>> > We are using drbd to provide mirrored disks for virtual machines r=
unning
>> > under Xen. 99% of the time, the drbd devices run in primary/second=
ary
>> > mode (aka active/passive), but they are switched to primary/primar=
y
>> > (aka active/active) for live migrations of domains, as that needs =
the
>> > disks to be available on both nodes. From our experience, if the d=
rbd
>> > device is healthy, this is very reliable. No experience with runni=
ng
>> > drbd in primary/primary config for any extended period of time, th=
ough
>> > (the live migrations are usually over after a few seconds to a min=
ute at
>> > most, then the drbd devices go back to primary/secondary).
>>
>> What filesystem are you using to enable the primary-primary mode? Ha=
ve
>> you evaluated it against any other available option?
>
> The filesystem is whatever the VM is using, usually ext3. But the
> filesystem doesn't matter in our use case at all, because:
> =A0- the backing store for drbd =A0are logical volumes
> =A0- the drbd block devices are directly exported as block devices
> =A0 to the VMs
> The filesystem is only active inside the VM - and the VM is not aware=
 of
> the drbd primary/secondary -> primary/primary -> primary/secondary da=
nce
> that happens "outside" to enable live migration.
>
> Kind regards,
> =A0 =A0 =A0 =A0 =A0 Alex.
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
