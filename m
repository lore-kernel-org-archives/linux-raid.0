From: John Lange <john.lange@bighostbox.com>
Subject: Re: Multi-channel ATA controller cards
Date: Mon, 10 May 2004 12:48:04 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1084211283.9694.74.camel@ws101.darkcore.net>
References: <Pine.GSO.4.33.0405101204470.14297-100000@sweetums.bluetronic.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.33.0405101204470.14297-100000@sweetums.bluetronic.net>
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I would just like to second a couple things;

First, a local expert (who is not subscribed to this list) also
recommended the 3ware controllers. I have not personally tested it but I
know he builds quite a number of systems in his job and he highly
recommends them.

Personally I just purchased an Abit IC7-G Motherboard which has 4 SATA
connectors built in.

Second, even though you said price was more important than performance I
would still go with SATA. For a marginal price difference you will get
nearly double the performance. I have not had the opportunity to test
the performance difference between a PATA RAID and a SATA RAID but I can
tell you that, on my desktop, a single SATA drive has twice the
performance (according to hdparm). This is far from a true test but it
does give you some indication of the potential.

Regards,
-- 
John Lange


On Mon, 2004-05-10 at 11:08, Ricky Beam wrote:
> On Sun, 9 May 2004 robin-lists@robinbowes.com wrote:
> >One other possibility is to use three two-channel controllers (two disks on
> >each one). Does anyone know if this is feasible?
> 
> It'll work, but you may have various problems.  The HighPoint controller
> BIOS doesn't officially support more than one or two controllers per
> system.  However, you can put more in there... you just won't be able to
> configure any raid settings.
> 
> >Finally, does anyone know of any other 4-channel (or 6-channel) ATA
> >controllers that would be worth my checking out?
> 
> 3ware.  They aren't exactly cheap, but they more than make up for it in
> performance, support, and reliability.
> 
> --Ricky
> 
> PS: SATA is not that much more expensive.  The savings in cabling headaches
>     is well worth the added cost.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


