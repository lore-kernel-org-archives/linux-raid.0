From: =?UTF-8?Q?Nuno_Magalh=C3=A3es?= <nunomagalhaes@eu.ipp.pt>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Mon, 16 Jun 2014 13:36:44 +0100
Message-ID: <CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
 <539E5504.1080809@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <539E5504.1080809@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Mon, Jun 16, 2014 at 3:23 AM, Phil Turmel <philip@turmel.org> wrote:
> Before going any further, check the TLER/ERC support for these drives.

Both Seagate ST1000DM0003 don't have that:
Warning: device does not support SCT Error Recovery Control command

The Toshiba DT01ACA100 seems to have, but disabled:
SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

I couldn't find any specs with specific details on this feature for
the Toshiba, and i'm not sure if it's safe to issue smartctl -l
scterc,70,70 on a drive thay may not support it. If it's disabled as
an incentive to buy more expensive drives, will the drive just ignore
this command or will it decide to roast?

Are there any - recommended - consumer-grade drives out there that do
support TLER? I was going for 1TB@7200, but that can change. I started
disliking Seagate after a ST31000528AS died on me. They bought Maxtor
a long time ago and recently bought Samsung's disk division. I've had
no qualms with Toshiba. I'm not so sure on WD, they used to be less
that good; and haven't tried Hitachi. What say you?

Thanks,
Nuno
