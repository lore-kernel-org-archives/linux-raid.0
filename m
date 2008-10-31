From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Adaptec raid congtrollers for SATA disks under software raid
Date: Fri, 31 Oct 2008 08:22:46 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0810310821570.468@p34.internal.lan>
References: <47751.64665.qm@web30802.mail.mud.yahoo.com> <20081031105050.3B27281122D2@gemini.denx.de> <alpine.DEB.1.10.0810310813240.468@p34.internal.lan> <20081031121946.7C15D81122D2@gemini.denx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081031121946.7C15D81122D2@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Mike Myers <mikesm559@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 31 Oct 2008, Wolfgang Denk wrote:

> Dear Justin Piszcz,
>
> In message <alpine.DEB.1.10.0810310813240.468@p34.internal.lan> you wrote:
>>
>>> We made really good experience with the Supermicro AOC-SAT2-MV8 cards.
> ...
>> Lets be frank- almost all(?) RAID controllers you must export the disks
>> via JBOD and they cost hundreds to thousands of dollars.  Doing SW RAID
>> via JBOD IMO is not a great idea-- I'd use individual 2 or 4 port SATA
>> controllers on PCI-e.
>
> Right. The AOC-SAT2-MV8 is a 8 port PCI-X controller without any RAID
> support - and costs just around $ 100. That's why I like it.

Yes, very nice, I wish there was an 8-port PCI-e controller non-raid..
I've contacted StarTech about this they said they currently do not offer 
such a product but would look into it.

Justin.
