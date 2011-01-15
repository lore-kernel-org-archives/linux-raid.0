From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Quick question about parted/fdisk for 2TB disks.
Date: Sat, 15 Jan 2011 04:52:59 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1101150452320.8724@p34.internal.lan>
References: <alpine.DEB.2.00.1101142052080.18371@p34.internal.lan> <AANLkTik0kPm=kLL2-koPZLwSsK3RdAwHrXjcYyYxSnOH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-790399016-1295085179=:8724"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik0kPm=kLL2-koPZLwSsK3RdAwHrXjcYyYxSnOH@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-790399016-1295085179=:8724
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 14 Jan 2011, J=E9r=F4me Poulin wrote:

> The problem with fdisk is probably that you have DOS compatibility
> mode (when not using -c), it should also be set in sector mode (-u
> option) which will eliminate those useless warning.
>
> You could always use gdisk for GPT partition table instead, which
> above 2TB is a most anyway.
>
> On Fri, Jan 14, 2011 at 8:52 PM, Justin Piszcz <jpiszcz@lucidpixels.com> =
wrote:
>> Hi,
>>
>>
>> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Blocks =
=A0 Id =A0System
>> /dev/sda1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A03891 =A0 =A031250=
000 =A0 fd =A0Linux raid
>> autodetect
>> Partition 1 does not end on cylinder boundary.
>> /dev/sda2 =A0 * =A0 =A0 =A0 =A03891 =A0 =A0 =A0 =A03907 =A0 =A0 =A013107=
2 =A0 fd =A0Linux raid
>> autodetect
>> Partition 2 does not end on cylinder boundary.
>> /dev/sda3 =A0 =A0 =A0 =A0 =A0 =A03907 =A0 =A0 =A0243202 =A01922132488 =
=A0 fd =A0Linux raid
>> autodetect
>> Partition 3 does not end on cylinder boundary.
>>
>> But with parted, no issues:
>>
>> (parted) print Model: ATA WDC WD2001FASS-0 (scsi)
>> Disk /dev/sda: 2000GB
>> Sector size (logical/physical): 512B/512B
>> Partition Table: msdos
>>
>> Number =A0Start =A0 End =A0 =A0 Size =A0 =A0Type =A0 =A0 File system =A0=
 =A0 Flags
>> =A01 =A0 =A0 =A01049kB =A032.0GB =A032.0GB =A0primary =A0linux-swap(v1) =
=A0raid
>> =A02 =A0 =A0 =A032.0GB =A032.1GB =A0134MB =A0 primary =A0ext3 =A0 =A0 =
=A0 =A0 =A0 =A0boot, raid
>> =A03 =A0 =A0 =A032.1GB =A02000GB =A01968GB =A0primary =A0ext4 =A0 =A0 =
=A0 =A0 =A0 =A0raid
>>
>> (parted)
>>
>> Only use parted for 2TB+?
>>
>> Justin.

Hi,

It looks good!

# fdisk -l /dev/sda -c

Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x50b2166c

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1        3891    31250000   fd  Linux raid autodete=
ct
/dev/sda2   *        3891        3907      131072   fd  Linux raid autodete=
ct
/dev/sda3            3907      243202  1922132488   fd  Linux raid autodete=
ct

Thanks!

Justin.

--655872-790399016-1295085179=:8724--
