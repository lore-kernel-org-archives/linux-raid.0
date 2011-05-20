From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Software raid, booting and bios
Date: Fri, 20 May 2011 14:22:57 +0100 (BST)
Message-ID: <alpine.DEB.2.00.1105201412160.5319@unicorn.drogon.net>
References: <9067914580344941270@unknownmsgid> <ir58vs$9qp$1@dough.gmane.org> <20110520145623.749b4781@natsu> <ir5ci1$uc6$1@dough.gmane.org> <4DD65A66.5030904@turmel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD65A66.5030904@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 20 May 2011, Phil Turmel wrote:

> http://www.addonics.com/products/flash_memory_reader/adidecf.asp
>
> (Just to show what's out there.)  The embedded boards I use occasionally 
> have the equivalent of this soldered to their motherboards.
>
> The best DMA capable CF cards are usually found in markets that cater to 
> industrial designers or to professional photographers.

FWIW: I've built a few systems which boot off flash, then run from SATA 
drives - but it all depends on the motherboards. These days there are many 
IDE (and now SATA) drives - maybe the forerunner to SSD's... e.g. I use 
these sort of things:

   http://linitx.com/viewcategory.php?catid=129

It's easy to have root on a small flash IDE drive then the rest of the 
system on RAID'd SATA drives. (swap, /usr, /var, /home, etc.)

Is that good? I don't know - but I also build lots of small embedded 
systems (no drives) for other purposes which boot off these type of 
devices and I've not had an issue with one failling in 5+ years...

Motherboards are increasingly not coming with IDE ports though, but things 
move on!

Gordon
