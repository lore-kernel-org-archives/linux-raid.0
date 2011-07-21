From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Thu, 21 Jul 2011 07:57:14 +0100
Message-ID: <CADNH=7Hy+ww5UoDPznV6PCqn7F98_YvWgMuwJFzqinB0uqW+Vw@mail.gmail.com>
References: <201107181403.49563.raid1@fuckaround.org>
	<4E26CAA7.8030201@hardwarefreak.com>
	<c5a1a83b370a0ddb063cfc828f124e6d.squirrel@fuckaround.org>
	<CADNH=7HR7euaWem0tpLxJfRe0hYnRP5fwxJ6MC5vJeNf=T=PzA@mail.gmail.com>
	<4E276C7C.9050103@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E276C7C.9050103@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Pol Hallen <raid1@fuckaround.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yes, sorry. 5 WD20EARS and 2 Samsung 2TB

On Thursday, 21 July 2011, Stan Hoeppner <stan@hardwarefreak.com> wrote=
:
> On 7/20/2011 3:17 PM, Mathias Bur=C3=A9n wrote:
>
>> FWIW this is my RAID6 setup:
>>
>> $ sudo fdisk -l /dev/sd[b,c,d,e,f,g,h]
>> Password:
>
> Are these indeed advanced format drives? =C2=A0You didn't provide mod=
el#s or
> manufacturer product line. =C2=A0The only clue we have that they migh=
t be AF
> drives is the 2048 offset you created. =C2=A0Unless I simply missed i=
t.
>
>> Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
>> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 secto=
rs
>> Units =3D sectors of 1 * 512 =3D 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x0e5b3a7a
>>
>> =C2=A0 =C2=A0Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
>> /dev/sdb1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02048 =C2=A0390702=
9167 =C2=A01953513560 =C2=A0 fd =C2=A0Linux raid
>> autodetect
>>
>> Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
>> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 secto=
rs
>> Units =3D sectors of 1 * 512 =3D 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x4fc36d54
>>
>> =C2=A0 =C2=A0Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
>> /dev/sdc1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02048 =C2=A0390702=
9167 =C2=A01953513560 =C2=A0 fd =C2=A0Linux raid
>> autodetect
>>
>> Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
>> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 secto=
rs
>> Units =3D sectors of 1 * 512 =3D 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x9e716ecb
>>
>> =C2=A0 =C2=A0Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
>> /dev/sdd1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02048 =C2=A0390702=
9167 =C2=A01953513560 =C2=A0 fd =C2=A0Linux raid
>> autodetect
>>
>> Disk /dev/sde: 2000.4 GB, 2000398934016 bytes
>> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 secto=
rs
>> Units =3D sectors of 1 * 512 =3D 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x629ab77f
>>
>> =C2=A0 =C2=A0Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
>> /dev/sde1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02048 =C2=A0390702=
9167 =C2=A01953513560 =C2=A0 fd =C2=A0Linux raid
>> autodetect
>>
>> Disk /dev/sdf: 2000.4 GB, 2000398934016 bytes
>> 123 heads, 18 sectors/track, 1764692 cylinders, total 3907029168 sec=
tors
>> Units =3D sectors of 1 * 512 =3D 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x3d454f20
>>
>> =C2=A0 =C2=A0Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
>> /dev/sdf1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02048 =C2=A0390702=
9167 =C2=A01953513560 =C2=A0 fd =C2=A0Linux raid
>> autodetect
>>
>> Disk /dev/sdg: 2000.4 GB, 2000398934016 bytes
>> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 secto=
rs
>> Units =3D sectors of 1 * 512 =3D 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x918fae9f
>>
>> =C2=A0 =C2=A0Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
>> /dev/sdg1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02048 =C2=A0390702=
9167 =C2=A01953513560 =C2=A0 fd =C2=A0Linux raid
>> autodetect
>>
>> Disk /dev/sdh: 2000.4 GB, 2000398934016 bytes
>> 123 heads, 18 sectors/track, 1764692 cylinders, total 3907029168 sec=
tors
>> Units =3D sectors of 1 * 512 =3D 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x0ac81a1b
>>
>> =C2=A0 =C2=A0Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
>> /dev/sdh1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02048 =C2=A0390702=
9167 =C2=A01953513560 =C2=A0 fd =C2=A0Linux raid
>> autodetect
>
> --
> Stan
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
