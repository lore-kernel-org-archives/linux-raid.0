From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: Multi-channel ATA controller cards
Date: Mon, 10 May 2004 12:08:28 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0405101204470.14297-100000@sweetums.bluetronic.net>
References: <S263851AbUEHXGM/20040508230612Z+21001@vger.kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <S263851AbUEHXGM/20040508230612Z+21001@vger.kernel.org>
To: robin-lists@robinbowes.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 9 May 2004 robin-lists@robinbowes.com wrote:
>One other possibility is to use three two-channel controllers (two disks on
>each one). Does anyone know if this is feasible?

It'll work, but you may have various problems.  The HighPoint controller
BIOS doesn't officially support more than one or two controllers per
system.  However, you can put more in there... you just won't be able to
configure any raid settings.

>Finally, does anyone know of any other 4-channel (or 6-channel) ATA
>controllers that would be worth my checking out?

3ware.  They aren't exactly cheap, but they more than make up for it in
performance, support, and reliability.

--Ricky

PS: SATA is not that much more expensive.  The savings in cabling headaches
    is well worth the added cost.


