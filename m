From: Markus Hennig <mhennig@gmail.com>
Subject: Re: RAID5 crashed for unknown reason on old 2.6.16 kernel
Date: Thu, 15 Jul 2010 13:53:50 +0200
Message-ID: <AANLkTilC9tPAVS2UWcJDykDyvkCDZbZjFD-R-h6OxRxi@mail.gmail.com>
References: <AANLkTimTAvYM7p4sk8S5He4WOWT3FW6IRPQ0AfpFnIVR@mail.gmail.com>
	<AANLkTik3OIS0AKHZaBHEuqi9NNFKYQ7sWh_iZecirJgS@mail.gmail.com>
	<20100629165031.6c96a635@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100629165031.6c96a635@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi all,

I got all my data back from a degraded RAID5 array with 3 disks.
The only point which is worth to mention: XFS as underlying file
system is ineligible for small/cheap NAS because it is not edian safe.
I bought a powerpc driven MAC to replay the XFS journal...

That leads to my question to the list: does somebody know if BTRFS is
endian safe or what is an endian-safe alternative to ext3/ext ?

Regards,
Markus



On Tue, Jun 29, 2010 at 8:50 AM, Neil Brown <neilb@suse.de> wrote:
> On Mon, 28 Jun 2010 17:29:37 +0200
> Markus Hennig <mhennig@gmail.com> wrote:
>
>> Hi all,
>>
>> for the (unlikely) case somebody is interested in a last update:
>>
>> I learned in the meantime that the UUID as well as the mdadm version
>> is part of the checksum. And that that checksum is calculated on the
>> first 1kb of the 4kb ver0.0 superblock.
>> (https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#The_=
version-0.90_Superblock_Format)
>>
>> Via hexedit I set the UUID on HHD2 back to the correct value and als=
o
>> changed the version information from 0.91.00 (0x5B) to 90 (0x5A).
>> Done that the checksum was correct and equal the expect one.
>>
>> mdadm --assemble worked than like a charm and my RAID5 is back.
>
> Thanks for letting us know the resolution.
> I cannot imagine how all those '1's got into the metadata where they
> shouldn't be.
>
> Based on the update times and event counter, the HDD2 was slightly 'o=
lder'
> than the other devices. =A0Hopefully nothing had changed on the array=
 in the
> intervening time.
>
> You should have been able to assemble the array with just the 3 sane =
devices
> and had a degraded RAID5. =A0Then add the fourth device and let it re=
cover.
>
> However what you did seems to have worked, so if your data looks OK, =
you
> should be safe.
>
> NeilBrown
>
>
>>
>> That's it,
>> Markus
>>
>>
>> On Sat, Jun 26, 2010 at 11:22 PM, Markus Hennig <mhennig@gmail.com> =
wrote:
>> > Hi all,
>> >
>> > my RAID5 with 4 disks crashed on a Buffalo "NAS" box (big-endian!)=
 -
>> > no logs of course...
>> > I made immediately images of all disks and try to now gather my ve=
ry
>> > valuable content on a Linux box running GRML 4/10 (little-endian!)
>> > with 2.6.33 and mdadm - v3.1.1.
>> > Some blocks were not readable from HDD2, maybe that's the reason w=
hy
>> > the Buffalo box shut down.
>> >
>> >
>> > What I know already:
>> >
>> > - the RAID5 was created with a very old set of software:
>> > linux-2.6.16-tshtgl.tgz =A0 mdadm-2.5.2.tgz =A0 xfsprogs-2.5.6_arm=
=2Etgz
>> > - the Buffalo box blinked red on HDD2
>> > - the box run a rebuild on HDD4, I don't know if that was already =
finished
>> > - all disks are identically, 250GB
>> >
>>
>> > Open questions for which I wasn't able to find a answer myself :
>> >
>> > What triggers the event count? And why is the event counter on HDD=
2
>> > just 129, on all other 131?
>> > Can that cause problems while rescue my data and how can I work ar=
ound it?
>> >
>> >
>> > What is that "UUID : ffffffff:ffffffff:ffffffff:ffffffff" on HDD2?
>> > What does it mean?
>> >
>> > Its really in the superblock on the hard disk:
>> > =A0hexdump -s 488006273b -C hdd2_ddrescue
>> > =A03a2cc50200 =A0a9 2b 4e fc 00 00 00 00 =A000 00 00 5b 00 00 00 0=
0
>> > |.+N........[....|
>> > =A03a2cc50210 =A000 00 00 00 ff ff ff ff =A041 a0 de f0 00 00 00 0=
5
>> > |........A.......|
>> > =A03a2cc50220 =A00e 83 39 c0 00 00 00 04 =A000 00 00 04 00 00 00 0=
1
>> > |..9.............|
>> > =A03a2cc50230 =A000 00 00 00 ff ff ff ff =A0ff ff ff ff ff ff ff f=
f
>> > |................|
>> > =A03a2cc50240 =A000 00 00 00 00 00 00 00 =A000 00 00 00 00 00 00 0=
0
>> > |................|
>> > Would it help to rewrite the UUID via hexedit to the correct one?
>> >
>> >
>> > Can somebody explain the meaning of:
>> > =A0Reshape pos'n : 0
>> > =A0 =A0 =A0New Level : raid0
>> > =A0 =A0 New Layout : left-asymmetric
>> > =A0New Chunksize : 0
>> > on HDD2 ?
>> >
>> >
>> > What parameters are included in the checksum?
>> > And how critical in on HHD2 that "Checksum : b8d2c453 - expected 4=
5703820"?
>> >
>> >
>> > I have no explanation why "Version :" is on HDD2 on 0.91.00"...
>> > I see 0x5B in the partition 3 superblock on HDD2 (and on all other
>> > 0x5A), so its really on the disk... =A0Weird...
>> > Somebody any idea on that?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
