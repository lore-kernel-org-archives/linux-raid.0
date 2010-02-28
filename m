From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Device role question
Date: Sat, 27 Feb 2010 19:34:33 -0800
Message-ID: <4877c76c1002271934m3db22c7ahc93d3d4129df7d22@mail.gmail.com>
References: <20100226142331.GA2328@lazy.lzy>
	 <4877c76c1002262156k6675877am79a7da9b63446dc7@mail.gmail.com>
	 <20100227080845.GA2287@lazy.lzy>
	 <4877c76c1002270055o2ebc038ag52e0b9a8f5b407d@mail.gmail.com>
	 <20100227091027.GA3510@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100227091027.GA3510@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Feb 27, 2010 at 1:10 AM, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
> Hi,
>
>> Ok, please run this for each disk in the array:
>>
>> mdadm --examine /dev/(DEVICE)
>>
>> The output would be most readable if you did each array's devices in
>> order, and you can list them on the same command (- - examine takes
>> multiple inputs)
>>
>> If you still think the situation isn't as I described above, post th=
e results.
>
> Well, here it is:
>
> $> mdadm -E /dev/sd[ab]2
> /dev/sda2:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 1.1
> =A0 =A0Feature Map : 0x1
> =A0 =A0 Array UUID : 54db81a7:b47e9253:7291055e:4953c163
> =A0 =A0 =A0 =A0 =A0 Name : lvm
> =A0Creation Time : Fri Feb =A06 20:17:13 2009
> =A0 =A0 Raid Level : raid10
> =A0 Raid Devices : 2
>
> =A0Avail Dev Size : 624928236 (297.99 GiB 319.96 GB)
> =A0 =A0 Array Size : 624928000 (297.99 GiB 319.96 GB)
> =A0Used Dev Size : 624928000 (297.99 GiB 319.96 GB)
> =A0 =A0Data Offset : 264 sectors
> =A0 Super Offset : 0 sectors
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0 =A0Device UUID : 8f6cd2c4:0efc8286:09ec91c6:bc5014bf
>
> Internal Bitmap : 8 sectors from superblock
> =A0 =A0Update Time : Sat Feb 27 10:08:22 2010
> =A0 =A0 =A0 Checksum : 1703ded0 - correct
> =A0 =A0 =A0 =A0 Events : 161646
>
> =A0 =A0 =A0 =A0 Layout : far=3D2
> =A0 =A0 Chunk Size : 64K
>
> =A0 Device Role : spare
> =A0 Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdb2:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 1.1
> =A0 =A0Feature Map : 0x1
> =A0 =A0 Array UUID : 54db81a7:b47e9253:7291055e:4953c163
> =A0 =A0 =A0 =A0 =A0 Name : lvm
> =A0Creation Time : Fri Feb =A06 20:17:13 2009
> =A0 =A0 Raid Level : raid10
> =A0 Raid Devices : 2
>
> =A0Avail Dev Size : 624928236 (297.99 GiB 319.96 GB)
> =A0 =A0 Array Size : 624928000 (297.99 GiB 319.96 GB)
> =A0Used Dev Size : 624928000 (297.99 GiB 319.96 GB)
> =A0 =A0Data Offset : 264 sectors
> =A0 Super Offset : 0 sectors
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0 =A0Device UUID : 6e2763b5:9415b181:e41a9964:b0c21ca6
>
> Internal Bitmap : 8 sectors from superblock
> =A0 =A0Update Time : Sat Feb 27 10:08:22 2010
> =A0 =A0 =A0 Checksum : 87d25401 - correct
> =A0 =A0 =A0 =A0 Events : 161646
>
> =A0 =A0 =A0 =A0 Layout : far=3D2
> =A0 =A0 Chunk Size : 64K
>
> =A0 Device Role : Active device 0
> =A0 Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
>
> And the details too:
>
> $> mdadm -D /dev/md1
> /dev/md1:
> =A0 =A0 =A0 =A0Version : 1.1
> =A0Creation Time : Fri Feb =A06 20:17:13 2009
> =A0 =A0 Raid Level : raid10
> =A0 =A0 Array Size : 312464000 (297.99 GiB 319.96 GB)
> =A0Used Dev Size : 312464000 (297.99 GiB 319.96 GB)
> =A0 Raid Devices : 2
> =A0Total Devices : 2
> =A0 =A0Persistence : Superblock is persistent
>
> =A0Intent Bitmap : Internal
>
> =A0 =A0Update Time : Sat Feb 27 10:09:24 2010
> =A0 =A0 =A0 =A0 =A0State : active
> =A0Active Devices : 2
> Working Devices : 2
> =A0Failed Devices : 0
> =A0Spare Devices : 0
>
> =A0 =A0 =A0 =A0 Layout : far=3D2
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0 =A0 =A0 Name : lvm
> =A0 =A0 =A0 =A0 =A0 UUID : 54db81a7:b47e9253:7291055e:4953c163
> =A0 =A0 =A0 =A0 Events : 161646
>
> =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> =A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
> =A0 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sda2
>
> bye,
>
> --
>
> piergiorgio
>

I've checked my arrays and my only RAID-10 array has a single spare
(hot spare) as part of the set with several other members.  All
current members storing DATA are listed as active members.


What's confusing is that /proc/mdadm lists it as an active member
(synced to data) but that the device does not match.  Maybe you can
stop/restart the array?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
