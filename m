From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: partitions
Date: Fri, 28 Jan 2011 19:45:33 -0200
Message-ID: <AANLkTinjmGobHBtZxsz3Tv9US1-VKr32ODy4h=-9V1cO@mail.gmail.com>
References: <AANLkTimGHtECH2oFdcWWmjXjzrFeRmDsXhfwg4FMR2a8@mail.gmail.com>
	<AANLkTim_16xzRaQJLd1QGd5Dx2LScNX-VUjxrN5uXZng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim_16xzRaQJLd1QGd5Dx2LScNX-VUjxrN5uXZng@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i read about lvm (not a lot), it work with grub and lilo right?

2011/1/28 Doug Dumitru <doug@easyco.com>:
> This functionality already exists with two different solutions.
>
> The "normal" solution is to use LVM on top of /dev/md0.=C2=A0 LVM is =
usually
> considered "better" than partitions because it is a more flexible app=
roach.
>
> If you have to have partitions, you can do this with:
>
> =C2=A0=C2=A0=C2=A0 ... create partitions 1,2,3,4
> =C2=A0=C2=A0=C2=A0 kpartx -a /dev/md0
> =C2=A0=C2=A0=C2=A0 mkfs.ext4 /dev/mapper/md0p1
> =C2=A0=C2=A0=C2=A0 mkfs.ext4 /dev/mapper/md0p2
> =C2=A0=C2=A0=C2=A0 mkfs.ext4 /dev/mapper/md0p3
> =C2=A0=C2=A0=C2=A0 mkfs.ext4 /dev/mapper/md0p4
>
> This is not really a "linux-raid" issue, but just how to apply block =
device
> mapping tools.
>
> Doug Dumitru
> EasyCo LLC
>
> On Fri, Jan 28, 2011 at 1:24 PM, Roberto Spadim <roberto@spadim.com.b=
r>
> wrote:
>>
>> hi guys, could we implement raid partitions?
>> for example:
>> mdadm --create /dev/md0 --level=3D1 --devices /dev/sda /dev/sdb
>> fdisk /dev/md0
>> create pratition 1,2,3,4
>>
>> mkfs.ext4 /dev/md0p1
>> mkfs.ext4 /dev/md0p2
>> mkfs.ext4 /dev/md0p3
>> mkfs.ext4 /dev/md0p4
>>
>> ?? any idea? could we implement it?
>> there=E6=84=80 a TODO list for linux software raid?
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
>
>
> --
> Doug Dumitru
> EasyCo LLC
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
