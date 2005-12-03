From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: Journal-guided Resynchronization for Software RAID
Date: Fri, 2 Dec 2005 22:17:05 -0800 (PST)
Message-ID: <Pine.LNX.4.63.0512022211460.4248@twinlark.arctic.org>
References: <Pine.LNX.4.58.0511301015520.14240@macduff.cs.wisc.edu>
 <17294.34794.477608.760700@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17294.34794.477608.760700@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Timothy E. Denehy" <tedenehy@cs.wisc.edu>, linux-raid@vger.kernel.org, ext2-devel@lists.sourceforge.net, tytso@mit.edu, akpm@osdl.org
List-Id: linux-raid.ids

On Thu, 1 Dec 2005, Neil Brown wrote:

> What I would really like is a cheap (Well, not too expensive) board
> that had at least 100Meg of NVRAM which was addressable on the PCI
> buss, and an XOR and RAID-6 engine connected to the DMA engine.

there's the mythical giga-byte i-ram ... i say mythical because i've seen
lots of reviews but haven't been able to find it for sale:

http://www.giga-byte.com/Peripherals/Products/Products_GC-RAMDISK%20(Rev%201.1).htm

the only problem with the i-ram is the lack of ecc (it could be 
implemented in a software layer though).

umem.com have what look like excellent boards but they seem unwilling to 
sell in small quantities...

http://umem.com/Umem_NVRAM_Cards.html

-dean
