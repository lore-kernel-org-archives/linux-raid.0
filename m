From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: HBA Adaptor advice
Date: Thu, 19 May 2011 13:43:21 +0100
Message-ID: <BANLkTikjU=Hm6SS6LMkE0CFYvuQi83tZzg@mail.gmail.com>
References: <4DD50C89.8060006@wildgooses.com>
	<20110519183608.2c377538@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110519183608.2c377538@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Ed W <lists@wildgooses.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19 May 2011 13:36, Roman Mamedov <rm@romanrm.ru> wrote:
> On Thu, 19 May 2011 13:26:49 +0100
> Ed W <lists@wildgooses.com> wrote:
>
>> Hi, following on from a recent thread, can folks with decent multi-port
>> HBA adaptors please chime in with some model numbers of known decent
>> adaptors please?
>
> Here is a useful link for you: http://blog.zorinaq.com/?e=10
>
>> And to avoid:
>> - Marvel controllers?
>
> There are two kinds (families?) of Marvell SATA chips, and those using the
> "sata_mv" module do work fine. It seems like all the complaints are directed
> at the other kind, supported via "mvsas".
>
> --
> With respect,
> Roman
>

I have to chime in; I do have this one:

05:00.0 SCSI storage controller: HighPoint Technologies, Inc.
RocketRAID 230x 4 Port SATA-II Controller (rev 02)

Which uses the sata_mv module. From dmesg:

[    1.062151] sata_mv: Highpoint RocketRAID BIOS CORRUPTS DATA on all
attached drives, regardless of if/how they are configured. BEWARE!
[    1.062156] sata_mv: For data safety, do not use sectors 8-9 on
"Legacy" drives, and avoid the final two gigabytes on all RocketRAID
BIOS initialized drives.

So stay away from RocketRAID  :-) (I only use it as a HBA)

Cheers,
/M
