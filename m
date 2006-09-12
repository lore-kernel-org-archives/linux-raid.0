From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 00/19] Hardware Accelerated MD RAID5: Introduction
Date: Mon, 11 Sep 2006 22:41:39 -0400
Message-ID: <45061E63.6010901@garzik.org>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com>	 <4505F358.3040204@garzik.org> <e9c3a7c20609111653v29cd4609hd0584ae300b735b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20609111653v29cd4609hd0584ae300b735b7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com
List-Id: linux-raid.ids

Dan Williams wrote:
> This is a frequently asked question, Alan Cox had the same one at OLS.
> The answer is "probably."  The only complication I currently see is
> where/how the stripe cache is maintained.  With the IOPs its easy
> because the DMA engines operate directly on kernel memory.  With the
> Promise card I believe they have memory on the card and it's not clear
> to me if the XOR engines on the card can deal with host memory.  Also,
> MD would need to be modified to handle a stripe cache located on a
> device, or somehow synchronize its local cache with card in a manner
> that is still able to beat software only MD.

sata_sx4 operates through [standard PC] memory on the card, and you use 
a DMA engine to copy memory to/from the card.

[select chipsets supported by] sata_promise operates directly on host 
memory.

So, while sata_sx4 is farther away from your direct-host-memory model, 
it also has much more potential for RAID acceleration:  ideally, RAID1 
just copies data to the card once, then copies the data to multiple 
drives from there.  Similarly with RAID5, you can eliminate copies and 
offload XOR, presuming the drives are all connected to the same card.

	Jeff


