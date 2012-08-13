From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: Experience of LSI MegaRAID 9260CV?
Date: Mon, 13 Aug 2012 09:06:07 -0600
Message-ID: <CALFpzo75AD0ej-M=DUQxFMRztw6q39zBBun3nb0RN73FgFk85g@mail.gmail.com>
References: <20120813093015.GY3867@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120813093015.GY3867@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 It works. It has both a capacitor and flash memory, the idea being
that you won't have battery maintenance. The capacitor has enough
juice to dump the RAM cache to flash during an outage and is far more
heat resistant and more stable as far as reliably holding a charge.
Adaptec has been doing it longer with their Zero Maintenance flash
modules, I believe they introduced the technology to the market, but
at the moment LSI has the performance lead if you're using hardware
RAID. That might change in a month or two when Adaptec's quad-core 7
series comes out.

 LSI's MegaCli utility is a pain to work with compared to twcli, but
I've been told that they are on the verge of releasing a better
'megaware' cli that mimics twcli and is thus more user friendly.

On Mon, Aug 13, 2012 at 3:30 AM, Andy Smith <andy@strugglers.net> wrote:
> Hi,
>
> I'm fairly familiar with the 3ware range of SATA RAID controllers
> and their particular quirks. I'm finding them harder to get hold of
> however, and I've now repeatedly run into the situation where my
> suppliers are pushing LSI MegaRAID instead.
>
> Have any of you transitioned from 3Ware to LSI and how have you
> found it?
>
> Particularly the 9260CV controller is being suggested to me instead
> of the 3ware 9250SE-8LP. This appears to have a large capacitor
> instead of a Li-Ion battery in order to achieve its battery backup.
> Anyone got any experience with that?
>
> Cheers,
> Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
