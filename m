From: Wolfgang Denk <wd@denx.de>
Subject: Re: Supermicro AOC-SAT2-MV8
Date: Sat, 20 Dec 2008 00:07:40 +0100
Message-ID: <20081219230740.B8742834B04E@gemini.denx.de>
References: <494C12A3.6070904@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <494C12A3.6070904@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear Max,

In message <494C12A3.6070904@fastmail.co.uk> you wrote:
> 
> So, I'm looking at a PCI card for SATA and went back to look at that 
> Supermicro AOC-SAT2-MV8 card - I've had my eye on it for a few years, or 
> perhaps it was a previous version of the same thing, I'm not sure.
> 
> Anyway, I'm worried that it isn't the correct bus type for my computer. 
> I'm confused by the PCI-X and PCIe types, and I don't have access to my 
> computer over Christmas.

The Supermicro AOC-SAT2-MV8 is a PCI-X card (64 bit, 133 MHz).

> My motherboard is some consumer level MSI board, and I just added an 
> nVidia graphics card on the same bus (it used one of the two longer slots).

The controller would probably go into the other of the "two longer
slots", assuming these are 64 bit PCI-X slots

BTW: I'm running a few such cards in some soervers; they are good.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
He who hesitates is not only lost, but miles from the next exit.
