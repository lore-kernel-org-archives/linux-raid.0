From: Nicolas Jungers <nicolas@jungers.net>
Subject: Re: RAID5 disk failure during rebuild of spare, any chance of recovery
 when one of the failed devices is suspected to be intact?
Date: Mon, 16 Aug 2010 18:37:56 +0200
Message-ID: <4C696964.7030205@jungers.net>
References: <AANLkTimiGhkzSBgt73fLZmoOcGf5Yyui-1WjkPLVVR6v@mail.gmail.com>	<AANLkTi=ryOfsBO0cVJbTT++P-Rh_jnEx+h5gSm_wXP5d@mail.gmail.com>	<AANLkTimEOFMh=TvQ2VqbPME+S2hNuiR3RNEbOGepBoH4@mail.gmail.com>	<4C68CCC9.2050604@jungers.net>	<AANLkTim9gUa95AR1KZcyBp7qM8_PeO1O7Bh99R2P8ON9@mail.gmail.com>	<4C68D6D3.6070906@jungers.net>	<4C68FA1D.7040105@seoss.co.uk> <AANLkTinaGGH6H2cj3tXR8m0yef9YE65R4cHrQGoxwJfY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinaGGH6H2cj3tXR8m0yef9YE65R4cHrQGoxwJfY@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?VG9yIEFybmUgVmVzdGLDuA==?= <torarnv@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/16/2010 06:27 PM, Tor Arne Vestb=C3=B8 wrote:
> On Mon, Aug 16, 2010 at 10:43 AM, Tim Small<tim@seoss.co.uk>  wrote:
>> On 16/08/10 07:12, Nicolas Jungers wrote:
>>>
>>> On 08/16/2010 07:54 AM, Tor Arne Vestb=C3=B8 wrote:
>>>>
>>>> You mean you sdc and sde plus either sdb or sdd, depending on whic=
h
>>>> one I think is more sane a this point?
>>>
>>> I'd try both.  Do a ddrescue of the failing one and try that (with =
copy of
>>> the others) and check what's coming out.
>>
>> As an alternative to using ddrescue, you could quickly prototype var=
ious
>> arrangements (without writing anything to the drives) using a device=
-mapper
>> copy-on-write mapping - I posted some details to the list a while ba=
ck when
>> I was trying to use this to reconstruct a hw raid array...  Check th=
e list
>> archives for details.
>
> Cool, here's what I tried:
>
> Created spares files for each of the devices
>
>    dd if=3D/dev/zero of=3Dsdb_cow bs=3D1 count=3D0 seek=3D2GB
>
> Mapped that to a loop device
>
>    losetup /dev/loop1 sdb_cow
>
> Then ran the following for each device:
>
>    cow_size=3D`blockdev --getsize /dev/sdb1`
>    chunk_size=3D64
>    echo "0 $cow_size snapshot /dev/sdb1 /dev/loop1 p $chunk_size" |
> dmsetup create sdb1_cow
>
> After these were created I tried the following:
>
> # mdadm -v -C /dev/md0 -l5 -n4 /dev/mapper/sdb1_cow
> /dev/mapper/sdc1_cow missing /dev/mapper/sde1_cow
> mdadm: layout defaults to left-symmetric
> mdadm: chunk size defaults to 64K
> mdadm: /dev/mapper/sdb1_cow appears to be part of a raid array:
>      level=3Draid5 devices=3D4 ctime=3DSun Mar  2 22:52:53 2008
> mdadm: /dev/mapper/sdc1_cow appears to be part of a raid array:
>      level=3Draid5 devices=3D4 ctime=3DSun Mar  2 22:52:53 2008
> mdadm: /dev/mapper/sde1_cow appears to be part of a raid array:
>      level=3Draid5 devices=3D4 ctime=3DSun Mar  2 22:52:53 2008
> mdadm: size set to 732571904K
> Continue creating array? Y
> mdadm: array /dev/md0 started.
>
> # mdadm --detail /dev/md0
> /dev/md0:
>          Version : 00.90
>    Creation Time : Mon Aug 16 18:20:06 2010
>       Raid Level : raid5
>       Array Size : 2197715712 (2095.91 GiB 2250.46 GB)
>    Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
>     Raid Devices : 4
>    Total Devices : 3
> Preferred Minor : 0
>      Persistence : Superblock is persistent
>
>      Update Time : Mon Aug 16 18:20:06 2010
>            State : clean, degraded
>   Active Devices : 3
> Working Devices : 3
>   Failed Devices : 0
>    Spare Devices : 0
>
>           Layout : left-symmetric
>       Chunk Size : 64K
>
>             UUID : 916ceaa2:b877a3cc:3973abef:31f2d600 (local to host=
 monstre)
>           Events : 0.1
>
>      Number   Major   Minor   RaidDevice State
>         0     251        9        0      active sync   /dev/block/251=
:9
>         1     251       10        1      active sync   /dev/block/251=
:10
>         2       0        0        2      removed
>         3     251       12        3      active sync   /dev/block/251=
:12
>
> And I can now mount /dev/mapper/raid-home !
>
> The question now is, what next? Should I start copying things off to =
a
> backup, or run fsck first or something else to try to repair errors?
> Or perhaps are the 2GB sparse files to small for anything like that?

=46or me: first, copy everything.  You have an unreliable disk in the=20
middle of your data.

N.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
