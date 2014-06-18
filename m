From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Wed, 18 Jun 2014 20:16:16 +0800
Message-ID: <53A18310.6020900@fnarfbargle.com>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>	<539E5504.1080809@turmel.org>	<CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>	<2036850.atdiKx507N@eseries.newtech.fi> <CADNH=7E+xTPoM4LL_DJrpWxJjsw0aV_w7fVEosu1uc=1dsh16A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7E+xTPoM4LL_DJrpWxJjsw0aV_w7fVEosu1uc=1dsh16A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, dag@newtech.fi
Cc: =?UTF-8?B?TnVubyBNYWdhbGjDo2Vz?= <nunomagalhaes@eu.ipp.pt>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18/06/14 19:58, Mathias Bur=C3=A9n wrote:
> On 18 June 2014 11:19, Dag Nygren <dag@newtech.fi> wrote:

>> Just love my HGST 4 TB drives. The first ones that haven't
>> developed any pending/remapped sectors during the 9 months
>> they have been in 24/7 use. Previously tried different Seagates, wit=
h
>> constant problems (And yes - Had the SCT turned on). Also tested a W=
D red,
>> but saw similar symptoms developing and so degraded that to a storag=
e
>> disk for my boy...
>> HGST was some 20=E2=82=AC more expensive and hard to get here but de=
finitely
>> worth it.
>>
>
>
> If we're comparing drives, my 8x WD20EARS / EARX have been spinning
> for years. 2 drives just failed after ~3.4 years uptime (24/7) and
> over 400,000 head parkings. They had weekly SMART self-test and
> monthly RAID6 scrubs, and a few unexpected power losses. Good value.
> But YMMV.

My experience has been almost any drive, no matter how naff can be made=
=20
to last well by simply keeping them spinning and at a roughly constant=20
temperature. I generally replace my bulk storage drives at about 4=20
years. My first lot were Maxtor 250G cheapies and all 12 of them went=20
for over 4.5 years. My current batch are WD Green 2TB and they all have=
=20
~26,000 hours on them. One of my SAS drives has over 49,000 hours on it=
=2E=20
Even a set of cheap Maxtor DiamondMAX 22 1TB drives lasted near enough=20
to 25,000 hours before I relegated them to an off-line backup machine.

The constant has been keeping them running 24/7 and doing a pretty=20
thorough burn in to weed out the early life failures.

=46or example the random WD Green 2T I picked has 26,917 hours and 60=20
power cycles. Most of those would have been caused over a 12 week perio=
d=20
when I had power issues with the UPS and none would have been off long=20
enough to noticeably let the drive cool down.

Keep 'em spinning and warm.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
