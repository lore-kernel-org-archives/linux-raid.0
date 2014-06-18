From: Dag Nygren <dag@newtech.fi>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Wed, 18 Jun 2014 13:19:46 +0300
Message-ID: <2036850.atdiKx507N@eseries.newtech.fi>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com> <539E5504.1080809@turmel.org> <CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>
Reply-To: dag@newtech.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nuno =?ISO-8859-1?Q?Magalh=E3es?= <nunomagalhaes@eu.ipp.pt>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 16 June 2014 13:36:44 Nuno Magalh=C3=A3es wrote:
> Hi,
>=20
> On Mon, Jun 16, 2014 at 3:23 AM, Phil Turmel <philip@turmel.org> wrot=
e:
> > Before going any further, check the TLER/ERC support for these driv=
es.
>=20
> Both Seagate ST1000DM0003 don't have that:
> Warning: device does not support SCT Error Recovery Control command
>=20
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
>=20
> Are there any - recommended - consumer-grade drives out there that do
> support TLER? I was going for 1TB@7200, but that can change. I starte=
d
> disliking Seagate after a ST31000528AS died on me. They bought Maxtor
> a long time ago and recently bought Samsung's disk division. I've had
> no qualms with Toshiba. I'm not so sure on WD, they used to be less
> that good; and haven't tried Hitachi. What say you?

Just love my HGST 4 TB drives. The first ones that haven't
developed any pending/remapped sectors during the 9 months
they have been in 24/7 use. Previously tried different Seagates, with
constant problems (And yes - Had the SCT turned on). Also tested a WD r=
ed,
but saw similar symptoms developing and so degraded that to a storage
disk for my boy...
HGST was some 20=E2=82=AC more expensive and hard to get here but defin=
itely
worth it.

YMMV

Dag

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
