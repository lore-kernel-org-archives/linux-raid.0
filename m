From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Mon, 16 Jun 2014 10:28:44 -0400
Message-ID: <539EFF1C.3000009@turmel.org>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com> <539E5504.1080809@turmel.org> <CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TnVubyBNYWdhbGjDo2Vz?= <nunomagalhaes@eu.ipp.pt>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Nuno,

On 06/16/2014 08:36 AM, Nuno Magalh=C3=A3es wrote:
> Hi,
>=20
> On Mon, Jun 16, 2014 at 3:23 AM, Phil Turmel <philip@turmel.org> wrot=
e:
>> Before going any further, check the TLER/ERC support for these drive=
s.
>=20
> Both Seagate ST1000DM0003 don't have that:
> Warning: device does not support SCT Error Recovery Control command

Hunch confirmed.  Don't use these Seagates in a raid.

> The Toshiba DT01ACA100 seems to have, but disabled:
> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled
>=20
> I couldn't find any specs with specific details on this feature for
> the Toshiba, and i'm not sure if it's safe to issue smartctl -l
> scterc,70,70 on a drive thay may not support it. If it's disabled as
> an incentive to buy more expensive drives, will the drive just ignore
> this command or will it decide to roast?

No, you can issue the command to these drives, and they'll work
correctly.  They just need to be told this every time they power up.
You'll need to put the command in rc.local or wherever your distro
recommends.  Older consumer-grade drives are often like this.  The
drives have the support, but power up with it disabled.

As the industry moved to monetize raid capabilities, the support in
consumer drives was phased out.  Otherwise identical, but higher-priced
drives then appeared on the market to fill the gap.

> Are there any - recommended - consumer-grade drives out there that do
> support TLER? I was going for 1TB@7200, but that can change. I starte=
d
> disliking Seagate after a ST31000528AS died on me. They bought Maxtor
> a long time ago and recently bought Samsung's disk division. I've had
> no qualms with Toshiba. I'm not so sure on WD, they used to be less
> that good; and haven't tried Hitachi. What say you?

Modern consumer-grade drives that have it are listed as "NAS" duty
drives.  The WD Red are good examples, and what I've been buying lately=
=2E
 With the NAS labeling, they also power up with the support enabled.
Typically 7.0 seconds.

I haven't seen any reports of "green" drives that are suitable for raid
service.

HTH,

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
