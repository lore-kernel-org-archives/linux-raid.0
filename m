From: CoolCold <coolthecold@gmail.com>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sat, 14 May 2011 12:27:45 +0400
Message-ID: <BANLkTinpJQDR=0Qnu1tS-82T=OTi37aBMQ@mail.gmail.com>
References: <20110513202900.GA1926@apartia.fr>
	<20110514073347.15dae0b8@notabene.brown>
	<20110514082159.GA306@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110514082159.GA306@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 14, 2011 at 12:21 PM, Louis-David Mitterrand
<vindex+lists-linux-raid@apartia.org> wrote:
> On Sat, May 14, 2011 at 07:33:47AM +1000, NeilBrown wrote:
>> On Fri, 13 May 2011 22:29:01 +0200 Louis-David Mitterrand
>> <vindex+lists-linux-raid@apartia.org> wrote:
>> > Each disk is configured thus:
>> >
>> > =A0 =A0 Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
>> > =A0 =A0 255 heads, 63 sectors/track, 121601 cylinders
>> > =A0 =A0 Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>> > =A0 =A0 Sector size (logical/physical): 512 bytes / 512 bytes
>> > =A0 =A0 I/O size (minimum/optimal): 512 bytes / 512 bytes
>> > =A0 =A0 Disk identifier: 0x05022e04
>> >
>> > =A0 =A0 =A0 =A0Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0=
 =A0 =A0Blocks =A0 Id =A0System
>> > =A0 =A0 /dev/sda1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A0 =A0=
32 =A0 =A0 =A0257008+ =A0fd =A0Linux raid autodetect
>> > =A0 =A0 /dev/sda2 =A0 =A0 =A0 =A0 =A0 =A0 =A033 =A0 =A0 =A0 17500 =
=A0 140311710 =A0 fd =A0Linux raid autodetect
>> > =A0 =A0 /dev/sda3 =A0 =A0 =A0 =A0 =A0 17501 =A0 =A0 =A0121601 =A0 =
836191282+ =A0fd =A0Linux raid autodetect
>> >
>>
>> Is this the config reported with the old controller or with the new
>> controller?
>
> Sorry for the confusion, the above was with the old (LSI) controller.
> This is the disk geometry with the new (Adaptec) controller:
>
> =A0 =A0 =A0 =A0Disk /dev/sda: 1000.1 GB, 1000104157184 bytes
> =A0 =A0 =A0 =A0255 heads, 63 sectors/track, 121589 cylinders
> =A0 =A0 =A0 =A0Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> =A0 =A0 =A0 =A0Sector size (logical/physical): 512 bytes / 512 bytes
> =A0 =A0 =A0 =A0I/O size (minimum/optimal): 512 bytes / 512 bytes
> =A0 =A0 =A0 =A0Disk identifier: 0x6397e8f6
>
> =A0 =A0 =A0 =A0 =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =
=A0 =A0 =A0Blocks =A0 Id =A0System
> =A0 =A0 =A0 =A0/dev/sda1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A0=
 =A032 =A0 =A0 =A0257008+ =A0fd =A0Linux raid autodetect
> =A0 =A0 =A0 =A0/dev/sda2 =A0 =A0 =A0 =A0 =A0 =A0 =A033 =A0 =A0 =A0 17=
500 =A0 140311710 =A0 fd =A0Linux raid autodetect
> =A0 =A0 =A0 =A0/dev/sda3 =A0 =A0 =A0 =A0 =A0 17501 =A0 =A0 =A0121601 =
=A0 836191282+ =A0fd =A0Linux raid autodetect
>
> Ah! 121589 vs 121601 cylinders...
>
>> Because my guess is that the new controller makes the devices look a=
 little
>> bit smaller. =A0That would cause the kernel to reject them, but quit=
e possibly
>> allow mdadm to think they look OK.
>>
>> It would also explain why the first 2 partitions work fine and only =
the last
>> one is a problem.
>>
>> If this were the case I would expect a message like:
>> =A0 =A0 =A0 =A0 =A0"%s: p%d size %llu extends beyond EOD
>
> Spot on:
>
> =A0 =A0 =A0 =A0May 14 10:15:46 zenon kernel: sda: p3 size 1672382565 =
extends beyond EOD, trunca
> ted
>
> Is there any solution other than backuping my /dev/md2 somewhere with
> the old controller and re-creating a (slightly) smaller one with the =
new
> controller?
This is just one more live example for partitions vs disks setups.

>
> Thanks,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
