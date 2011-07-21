From: Erwan Leroux <erwan.lerou@gmail.com>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Thu, 21 Jul 2011 17:42:12 +0200
Message-ID: <CAHX8RiTYpBJWGFEdemYqE9BwmqoQeoyehM77yrpTY3OkanyD+g@mail.gmail.com>
References: <201107181403.49563.raid1@fuckaround.org> <4E26CAA7.8030201@hardwarefreak.com>
 <c5a1a83b370a0ddb063cfc828f124e6d.squirrel@fuckaround.org>
 <CAHX8RiR0MV1iL_OfrVAKGjr0gj7zxtuxFSzMijSgNfKcs0Zz0Q@mail.gmail.com>
 <CACVpCE5mVBvqFBa7VNtGDiMKRn45Wh79gHqqnOu5vE6aeWEtgg@mail.gmail.com> <CAHX8RiR_7Bx_jGQijBb9rb=RW=hiFgyMqfn0QGif4mDC20FXfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHX8RiR_7Bx_jGQijBb9rb=RW=hiFgyMqfn0QGif4mDC20FXfA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-2?Q?Pawe=B3_Brodacki?= <pawel.brodacki@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I search my bookmarks to find the original source, which has some
benchmark to compare sector 63 and 64
http://linuxconfig.org/linux-wd-ears-advanced-format

2011/7/21 Erwan Leroux <erwan.lerou@gmail.com>:
> It's 64 because it's the lowest sector that is a multiple of 4kB.
> sector 63 is the lowest possible
> you can see the result of that choice, using sector 64, the
> corresponding cylinder is 1, so the drive is well aligned^^
> sudo fdisk -l /dev/sda
>
> WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util
> fdisk doesn
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 't support GP=
T. Use GNU Parted.
>
>
> Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>
> =C2=A0 Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
> /dev/sda1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=
=A0 =C2=A0243202 =C2=A01953514552 =C2=A0 fd =C2=A0Linux raid autodetect
>
> sudo fdisk -lu /dev/sda
>
> WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util
> fdisk doesn
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 't support GP=
T. Use GNU Parted.
>
>
> Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 secto=
rs
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>
> =C2=A0 Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
> /dev/sda1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A064 =C2=A039=
07029167 =C2=A01953514552 =C2=A0 fd =C2=A0Linux raid autodetect
>
> i think i found this setting on that page but not really sure
> http://ubuntuforums.org/showpost.php?p=3D9134230
>
>
> 2011/7/21 Pawe=C5=82 Brodacki <pawel.brodacki@googlemail.com>:
>> 2011/7/21 Erwan Leroux <erwan.lerou@gmail.com>:
>>> following is how i configured advanced format drives for raid 5
>>> i created one partition on each disk
>>>
>>> fdisk -u /dev/sdX
>>> # -u change the unit displayed by fdisk to sector instead of
>>> cylinders, this way it's easier to configure
>>>
>>> # the table partition isn't really modifier until you send the w
>>> command, so if you messed up use the q to quit and restart
>>>
>>> #delete first partition of the disk, repeat until you had cleared t=
he disk
>>> d
>>>
>>> # create a new partition
>>> n
>>>
>>> # select primary parition
>>> p
>>>
>>> #select number one (don't know if number is important, i guess it's
>>> means /dev/sdX1)
>>> 1
>>>
>>> #select first sector, here is the catch, to properly align the disk=
, select 64
>>> 64
>>>
>> Why do you choose 64? One physical sector (4KiB) is 8 logical sector=
s
>> (512 B). Would any number greater or equal to 8 and evenly divisible
>> by 8 work as well? Are you aiming to align partition start with RAID
>> chunk boundaries?
>>
>> Just curious.
>>
>> Pawe=C5=82
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
