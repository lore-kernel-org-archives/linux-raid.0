From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Help with recovering a RAID5 array
Date: Thu, 2 May 2013 14:17:04 +0100
Message-ID: <CADNH=7EZFx1DPAiXMWav5S6FN+0Tb1JxNxrHVczfaDAEwW-oVA@mail.gmail.com>
References: <34199580.p6EyCyMeIZ@chablis>
	<CADNH=7Gfx-HV7j-kwLOwQydcGRoXyt-1f4JjoYg1NoiTLO4p=w@mail.gmail.com>
	<2322111.Fd18rzrueQ@chablis>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2322111.Fd18rzrueQ@chablis>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Borggraefe <stefan@spybot.info>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2 May 2013 14:14, Stefan Borggraefe <stefan@spybot.info> wrote:
> Am Donnerstag, 2. Mai 2013, 13:30:22 schrieb Mathias Bur=C3=A9n:
>> I won't scold you for using RAID5 instead of RAID6 with this number =
of
>> if drives and especially the size of the drives.
>>
>> Could you please post the output of smartctl -a for each device? (fr=
om
>> smartmontools)
>>
>> That way we can verify which HDDs are broken, before proceeding.
>>
>> Mathias
>
> Hello Mathias,
>
> RAID6 would have been the safer option clearly, but we needed the
> extra-space and only had this number of drives available.
>
> Here the requested output:
>
> smartctl -a /dev/sdc
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
> Local Time is:        Thu May  2 15:09:16 2013 CEST
> Device supports SMART and is Enabled
> Temperature Warning Disabled or Not Supported
> SMART Health Status: OK
>
> Current Drive Temperature:     <not available>
>
> Error Counter logging not supported
> Device does not support Self Test logging
>
> smartctl -a /dev/sdd
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
> Logical Unit id:      0x5000cca22bc3effb
> Serial number:              PK2331PAG8NHZT
> Device type:          disk
> Local Time is:        Thu May  2 15:09:19 2013 CEST
> Device supports SMART and is Enabled
> Temperature Warning Disabled or Not Supported
> SMART Health Status: OK
>
> Current Drive Temperature:     <not available>
>
> Error Counter logging not supported
> Device does not support Self Test logging
>
> smartctl -a /dev/sde
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
> Logical Unit id:      0x5000cca22bc3ff79
> Serial number:              PK2331PAG8TMXT
> Device type:          disk
> Local Time is:        Thu May  2 15:09:23 2013 CEST
> Device supports SMART and is Enabled
> Temperature Warning Disabled or Not Supported
> SMART Health Status: OK
>
> Current Drive Temperature:     <not available>
>
> Error Counter logging not supported
> Device does not support Self Test logging
>
> smartctl -a /dev/sdf
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
> ^[[3~Logical Unit id:      0x5000cca22bc419ef
> Serial number:              PK2331PAG90PET
> Device type:          disk
> Local Time is:        Thu May  2 15:09:25 2013 CEST
> Device supports SMART and is Enabled
> Temperature Warning Disabled or Not Supported
> SMART Health Status: OK
>
> Current Drive Temperature:     <not available>
>
> Error Counter logging not supported
> Device does not support Self Test logging
>
> smartctl -a /dev/sdg
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
> Logical Unit id:      0x5000cca22bc2fe51
> Serial number:              PK2331PAG6L49T
> Device type:          disk
> Local Time is:        Thu May  2 15:09:27 2013 CEST
> Device supports SMART and is Enabled
> Temperature Warning Disabled or Not Supported
> SMART Health Status: OK
>
> Current Drive Temperature:     <not available>
>
> Error Counter logging not supported
> Device does not support Self Test logging
>
> smartctl -a /dev/sdh
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
> Logical Unit id:      0x5000cca22bc2fe2d
> Serial number:              PK2331PAG6L34T
> Device type:          disk
> Local Time is:        Thu May  2 15:09:30 2013 CEST
> Device supports SMART and is Enabled
> Temperature Warning Disabled or Not Supported
> SMART Health Status: OK
>
> Current Drive Temperature:     <not available>
>
> Error Counter logging not supported
> Device does not support Self Test logging
> --
> Best regards,
> Stefan Borggraefe


Hm are these behind some controller of sorts? What about smartctl -x ?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
