From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?Re=3A_RAID0_size_over_2_TB?=
Date: Mon, 08 Sep 2014 22:02:14 +0200
Message-ID: <20140908220214.DC2873CB@pobox.sk>
References: <20140906230928.BB645CEE@pobox.sk>, <20140908170037.451e2376@notabene.brown>, <20140908091811.1DD1140C@pobox.sk>, <20140908172832.7543b241@notabene.brown>, <20140908093351.382B7496@pobox.sk> <D920D060-0CEC-4B6E-B636-4671B6FDC156@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D920D060-0CEC-4B6E-B636-4671B6FDC156@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

______________________________________________________________
> Od: Chris Murphy <lists@colorremedies.com>
> Komu: azurIt <azurit@pobox.sk>
> D=C3=A1tum: 08.09.2014 20:27
> Predmet: Re: RAID0 size over 2 TB
>
> CC: linux-raid@vger.kernel.org
>On Sep 8, 2014, at 1:33 AM, azurIt <azurit@pobox.sk> wrote:
>>=20
>> This is really strange, here is what cgdisk is reporting:
>> http://imgur.com/U8VnAdM
>
>Does your kernel have CONFIG_EFI_PARTITION=3Dy ?
>
>Old versions of fdisk report the protective MBR, it does not show you =
GPT partition map. It's normal for the protective MBR to max out out 2T=
B because MBR encodes 32-bit 512 byte sectors on 512e devices. Your ker=
nel appears to think the disk is 2TB, which suggests to me it's looking=
 only at the MBR, meaning it doesn't have GPT support turned on.
>
>
>Chris Murphy--
>To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html



Ok so, problem is resolved. This is what happened:
 - i replaced 2x 2 TB drives with 2x 4 TB drives WITHOUT rebooting
 - i created 4 TB partition on every drive
 - kernel still thinks that partitions are 2 TB, probably because of so=
me kind of partition table cache
 - when i added these partitions to RAID array, kernel didn't know they=
 are 4 TB and, even, lightly corrupted them (cgdisk was reporting some =
kind of issues after i added partitions into RAID array, but everything=
 was working ok)

The solution was to call command 'partprobe' (which is part of 'parted'=
 package) after partitioning but BEFORE adding partitions into RAID arr=
ay.

Thanks to everyone involved!

azur
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
