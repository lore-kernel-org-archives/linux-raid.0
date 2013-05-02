From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Help with recovering a RAID5 array
Date: Thu, 2 May 2013 14:49:39 +0100
Message-ID: <CADNH=7GNmLMZeAcueKmHP2QS=PKbgGBuR2GpM0yMGmDBDiijjQ@mail.gmail.com>
References: <34199580.p6EyCyMeIZ@chablis>
	<2322111.Fd18rzrueQ@chablis>
	<CADNH=7EZFx1DPAiXMWav5S6FN+0Tb1JxNxrHVczfaDAEwW-oVA@mail.gmail.com>
	<3800236.bN8bMq2WMZ@chablis>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3800236.bN8bMq2WMZ@chablis>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Borggraefe <stefan@spybot.info>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2 May 2013 14:29, Stefan Borggraefe <stefan@spybot.info> wrote:
> Am Donnerstag, 2. Mai 2013, 14:17:04 schrieb Mathias Bur=C3=A9n:
>> On 2 May 2013 14:14, Stefan Borggraefe <stefan@spybot.info> wrote:
>> > Am Donnerstag, 2. Mai 2013, 13:30:22 schrieb Mathias Bur=C3=A9n:
>> >> I won't scold you for using RAID5 instead of RAID6 with this numb=
er of
>> >> if drives and especially the size of the drives.
>> >>
>> >> Could you please post the output of smartctl -a for each device? =
(from
>> >> smartmontools)
>> >>
>> >> That way we can verify which HDDs are broken, before proceeding.
>> >>
>> >> Mathias
>> >
>> > Hello Mathias,
>> >
>> > RAID6 would have been the safer option clearly, but we needed the
>> > extra-space and only had this number of drives available.
>> >
>> > Here the requested output:
>> >
>> > smartctl -a /dev/sdc
>> > smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-37-generic] (lo=
cal
>> > build) Copyright (C) 2002-11 by Bruce Allen,
>> > http://smartmontools.sourceforge.net
>> >
>> > Vendor:               Hitachi
>> > Product:              HUS724040ALE640
>> > Revision:             MJAO
>> > User Capacity:        4.000.787.030.016 bytes [4,00 TB]
>> > Logical block size:   512 bytes
>> > Logical Unit id:      0x5000cca22bd08a85
>> > Serial number:              PK2331PAH5D0YT
>> > Device type:          disk
>> > Local Time is:        Thu May  2 15:09:16 2013 CEST
>> > Device supports SMART and is Enabled
>> > Temperature Warning Disabled or Not Supported
>> > SMART Health Status: OK
>> >
>> > [...]
>>
>> Hm are these behind some controller of sorts? What about smartctl -x=
 ?
>
> We use an Adaptec 71605 controller. smartctl -x does not provide any =
more
> useful information, I suppose. I only post the output of one drive as=
 an
> example this time. They all give a similar result.
>
> smartctl -x /dev/sdc
> smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-37-generic] (local=
 build)
> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforg=
e.net
>
> Vendor:               Hitachi
> Product:              HUS724040ALE640
> Revision:             MJAO
> User Capacity:        4.000.787.030.016 bytes [4,00 TB]
> Logical block size:   512 bytes
> Logical Unit id:      0x5000cca22bd08a85
> Serial number:              PK2331PAH5D0YT
> Device type:          disk
> Local Time is:        Thu May  2 15:20:55 2013 CEST
> Device supports SMART and is Enabled
> Temperature Warning Disabled or Not Supported
> SMART Health Status: OK
>
> Current Drive Temperature:     <not available>
>
> Error Counter logging not supported
> Device does not support Self Test logging
> Device does not support Background scan results logging
> scsiPrintSasPhy Log Sense Failed [unsupported field in scsi command]
>
> What about the state of the software RAID5? It would be great if I
> could bring it back to a state where the filesystem on it is fully
> working again without having to copy the 20 TB of data to it again
> (copying this amount of data takes some time :( ).
> --
> Best regards,
> Stefan Borggraefe


Ugh, Adaptec, not my favourite controller. Do you have arcconf
installed? You could to arcconf getconfig 1 (or whatever your
controller number is) to grab some information regarding your
controller and the HDDs connected to it.

Do you have /dev/sg? devices? If so, smartctl -a might work on them.
Re the software RAID, I would double check the health of your HDDs
before attempting anything.

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
