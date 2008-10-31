From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Adaptec raid congtrollers for SATA disks under software raid
Date: Fri, 31 Oct 2008 08:14:28 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0810310813240.468@p34.internal.lan>
References: <47751.64665.qm@web30802.mail.mud.yahoo.com> <20081031105050.3B27281122D2@gemini.denx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081031105050.3B27281122D2@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Mike Myers <mikesm559@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 31 Oct 2008, Wolfgang Denk wrote:

> Dear Mike Myers,
>
> In message <47751.64665.qm@web30802.mail.mud.yahoo.com> you wrote:
>>
>> I'm curious as to what people think the best SATA controller is
>> these days that has 8 or 16 ports per card driving software raid?
>
> The "best" obviously depends on your set of requirements. If you don;t
> care about the price the result may be different than when you try to
> find a cost-effective solution.
>
> We made really good experience with the Supermicro AOC-SAT2-MV8 cards.
>
> Best regards,
>
> Wolfgang Denk

Lets be frank- almost all(?) RAID controllers you must export the disks 
via JBOD and they cost hundreds to thousands of dollars.  Doing SW RAID 
via JBOD IMO is not a great idea-- I'd use individual 2 or 4 port SATA 
controllers on PCI-e.

Justin.
