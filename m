From: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@kth.se>
Subject: Re: HighPoint Rocket 1540 hang driver load
Date: Wed, 21 Apr 2004 14:03:58 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1x4qrd5yhd.fsf@kth.se>
References: <40865AEC.8040604@online.no> <40865EA2.80504@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell <brad@wasp.net.au> writes:

> Lars Gaarden wrote:
>
>> IANA driver programmer, so I can't comment on the quality. But using
>> that v111 from above compiled with NON_RAID=3D1 and some boot tricke=
ry
>> (boot with no drives connected to the controller, so the BIOS on the
>> card isn't loaded. Then connect drives before loading driver) seems =
to
>> be the only way for me to make the card work properly.
>> Using the same trick with the hpt366 driver cause slow data rates
>> and drive_cmd: status=3D0x58 { DriveReady SeekComplete DataRequest }
>> status error: status=3D0x58 { DriveReady SeekComplete DataRequest }
>> errors,
>
> Just my .02c worth. I was using 7 Maxtor SATA drives with 2
> RocketRaid 1540's.  I tried all the available in-kernel drivers with
> many 2.4 and 2.6 kernels and resorted to using the hpt supplied
> drivers compiled from source with NON_RAID=3D1. I was using md raid-5
> and with this combo and it was rock solid for months (Before I
> upgraded to Promise TX4 controllers). With the in-kernel hpt drivers
> I never managed more than 15mb/s to or from the disks. Slow as a wet
> week in may (In the southern hemisphere anyway).

I have been told that the hpt366 driver attempts to probe for an
80-wire cable and fails, falling back to UDMA2.  Obviously, this cable
probe is nonsensical with SATA, and removing it from the driver fixed
things.  This happened to a friend using Maxtor disks.  I have not had
the same problem with my Seagate disks.

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
