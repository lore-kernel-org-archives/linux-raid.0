From: "Scott E. Armitage" <launchpad@scott.armitage.name>
Subject: Re: SSD - TRIM command
Date: Wed, 9 Feb 2011 11:28:35 -0500
Message-ID: <AANLkTimQ+B2sXt0AZiUYW2QrWqpUvt7PLnkVCOwZqx0k@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<4D5245DF.4020401@hardwarefreak.com>
	<iiu4rc$9ju$1@dough.gmane.org>
	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
	<AANLkTik6D-r1ZbgxEACHZK9760pcUBB+3e7wVX3oqrKP@mail.gmail.com>
	<20110209161916.GB8632@bounceswoosh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110209161916.GB8632@bounceswoosh.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Eric D. Mudama" <edmudama@bounceswoosh.org>
Cc: Roberto Spadim <roberto@spadim.com.br>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Who sends this command? If md can assume that determinate mode is
always set, then RAID 1 at least would remain consistent. For RAID 5,
consistency of the parity information depends on the determinate
pattern used and the number of disks. If you used determinate
all-zero, then parity information would always be consistent, but this
is probably not preferable since every TRIM command would incur an
extra write for each bit in each page of the block.

-S

On Wed, Feb 9, 2011 at 11:19 AM, Eric D. Mudama
<edmudama@bounceswoosh.org> wrote:
> On Wed, Feb =A09 at 10:00, Scott E. Armitage wrote:
>>
>> I reiterate my previous reply that under the current md architecture=
,
>> where the complete device is considered to be in use, sending TRIM
>> commands makes little sense. AFAICT, reading back a trimmed page is
>> not defined, since the whole idea is that the host doesn't care abou=
t
>> what is on that page any more.
>>
>> The next time md comes around to corresponding trimmed pages on two
>> SSDs, their contents may differ, and all of a sudden our array is no
>> longer consistent.
>
> For SATA devices, ATA8-ACS2 addresses this through Deterministic Read
> After Trim in the DATA SET MANAGEMENT command. =A0Devices can be
> indeterminate, determinate with a non-zero pattern (often all-ones) o=
r
> determinate all-zero for sectors read after being trimmed.
>
> --eric
>
> --
> Eric D. Mudama
> edmudama@bounceswoosh.org
>
>



--=20
Scott Armitage, B.A.Sc., M.A.Sc. candidate
Space Flight Laboratory
University of Toronto Institute for Aerospace Studies
4925 Dufferin Street, Toronto, Ontario, Canada, M3H 5T6
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
