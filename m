From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: Quick question about parted/fdisk for 2TB disks.
Date: Fri, 14 Jan 2011 22:19:05 -0500
Message-ID: <AANLkTik0kPm=kLL2-koPZLwSsK3RdAwHrXjcYyYxSnOH@mail.gmail.com>
References: <alpine.DEB.2.00.1101142052080.18371@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1101142052080.18371@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The problem with fdisk is probably that you have DOS compatibility
mode (when not using -c), it should also be set in sector mode (-u
option) which will eliminate those useless warning.

You could always use gdisk for GPT partition table instead, which
above 2TB is a most anyway.

On Fri, Jan 14, 2011 at 8:52 PM, Justin Piszcz <jpiszcz@lucidpixels.com=
> wrote:
> Hi,
>
>
> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
> /dev/sda1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A03891 =A0 =A031=
250000 =A0 fd =A0Linux raid
> autodetect
> Partition 1 does not end on cylinder boundary.
> /dev/sda2 =A0 * =A0 =A0 =A0 =A03891 =A0 =A0 =A0 =A03907 =A0 =A0 =A013=
1072 =A0 fd =A0Linux raid
> autodetect
> Partition 2 does not end on cylinder boundary.
> /dev/sda3 =A0 =A0 =A0 =A0 =A0 =A03907 =A0 =A0 =A0243202 =A01922132488=
 =A0 fd =A0Linux raid
> autodetect
> Partition 3 does not end on cylinder boundary.
>
> But with parted, no issues:
>
> (parted) print Model: ATA WDC WD2001FASS-0 (scsi)
> Disk /dev/sda: 2000GB
> Sector size (logical/physical): 512B/512B
> Partition Table: msdos
>
> Number =A0Start =A0 End =A0 =A0 Size =A0 =A0Type =A0 =A0 File system =
=A0 =A0 Flags
> =A01 =A0 =A0 =A01049kB =A032.0GB =A032.0GB =A0primary =A0linux-swap(v=
1) =A0raid
> =A02 =A0 =A0 =A032.0GB =A032.1GB =A0134MB =A0 primary =A0ext3 =A0 =A0=
 =A0 =A0 =A0 =A0boot, raid
> =A03 =A0 =A0 =A032.1GB =A02000GB =A01968GB =A0primary =A0ext4 =A0 =A0=
 =A0 =A0 =A0 =A0raid
>
> (parted)
>
> Only use parted for 2TB+?
>
> Justin.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
