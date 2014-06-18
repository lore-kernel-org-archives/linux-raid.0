From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Wed, 18 Jun 2014 12:58:59 +0100
Message-ID: <CADNH=7E+xTPoM4LL_DJrpWxJjsw0aV_w7fVEosu1uc=1dsh16A@mail.gmail.com>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
	<539E5504.1080809@turmel.org>
	<CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>
	<2036850.atdiKx507N@eseries.newtech.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2036850.atdiKx507N@eseries.newtech.fi>
Sender: linux-raid-owner@vger.kernel.org
To: dag@newtech.fi
Cc: =?UTF-8?Q?Nuno_Magalh=C3=A3es?= <nunomagalhaes@eu.ipp.pt>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18 June 2014 11:19, Dag Nygren <dag@newtech.fi> wrote:
> On Monday 16 June 2014 13:36:44 Nuno Magalh=C3=A3es wrote:
>> Hi,
>>
>> On Mon, Jun 16, 2014 at 3:23 AM, Phil Turmel <philip@turmel.org> wro=
te:
>> > Before going any further, check the TLER/ERC support for these dri=
ves.
>>
>> Both Seagate ST1000DM0003 don't have that:
>> Warning: device does not support SCT Error Recovery Control command
>>
>> The Toshiba DT01ACA100 seems to have, but disabled:
>> SCT Error Recovery Control:
>>            Read: Disabled
>>           Write: Disabled
>>
>> I couldn't find any specs with specific details on this feature for
>> the Toshiba, and i'm not sure if it's safe to issue smartctl -l
>> scterc,70,70 on a drive thay may not support it. If it's disabled as
>> an incentive to buy more expensive drives, will the drive just ignor=
e
>> this command or will it decide to roast?
>>
>> Are there any - recommended - consumer-grade drives out there that d=
o
>> support TLER? I was going for 1TB@7200, but that can change. I start=
ed
>> disliking Seagate after a ST31000528AS died on me. They bought Maxto=
r
>> a long time ago and recently bought Samsung's disk division. I've ha=
d
>> no qualms with Toshiba. I'm not so sure on WD, they used to be less
>> that good; and haven't tried Hitachi. What say you?
>
> Just love my HGST 4 TB drives. The first ones that haven't
> developed any pending/remapped sectors during the 9 months
> they have been in 24/7 use. Previously tried different Seagates, with
> constant problems (And yes - Had the SCT turned on). Also tested a WD=
 red,
> but saw similar symptoms developing and so degraded that to a storage
> disk for my boy...
> HGST was some 20=E2=82=AC more expensive and hard to get here but def=
initely
> worth it.
>
> YMMV
>
> Dag
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


If we're comparing drives, my 8x WD20EARS / EARX have been spinning
for years. 2 drives just failed after ~3.4 years uptime (24/7) and
over 400,000 head parkings. They had weekly SMART self-test and
monthly RAID6 scrubs, and a few unexpected power losses. Good value.
But YMMV.

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
