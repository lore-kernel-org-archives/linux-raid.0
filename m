From: Sebastian Utz <su@rotamente.com>
Subject: Re: Software RAID-5 attempt to access beyond end of device...
Date: Mon, 30 Aug 2004 11:49:41 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1093859380.13971.166.camel@slurp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Tim Moore <linux-raid@nsr500.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for that!
I haven't have enough time to consider this..

greetings,
sebastian

> Two performance suggestions.
>
> 1. Consider two RAID-1 arrays: hde+hdg (41MB) and hdi+hdk (80MB) which 
> would give much better performance over RAID-5 and lower failure 
> probability without giving up any storage capacity.
>
> 2. Set the P2B BIOS to have both promise controllers on IRQ 14 which is 
> unused in your system (remember to disable the primary motherboard IDE and 
> you may have to rearrange PCI slot positions).  This will give much better 
> interrupt performance than having the controllers sharing USB and mouse 
> interrupt cycles.
>
> Rgds,
> tim


