From: Neil Brown <neilb@suse.de>
Subject: Re: Journal-guided Resynchronization for Software RAID
Date: Mon, 5 Dec 2005 09:23:16 +1100
Message-ID: <17299.27732.251785.345960@cse.unsw.edu.au>
References: <Pine.LNX.4.58.0511301015520.14240@macduff.cs.wisc.edu>
	<17294.34794.477608.760700@cse.unsw.edu.au>
	<Pine.LNX.4.63.0512022211460.4248@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from dean gaudet on Friday December 2
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean-list-linux-raid@arctic.org>
Cc: "Timothy E. Denehy" <tedenehy@cs.wisc.edu>, linux-raid@vger.kernel.org, ext2-devel@lists.sourceforge.net, tytso@mit.edu, akpm@osdl.org
List-Id: linux-raid.ids

On Friday December 2, dean-list-linux-raid@arctic.org wrote:
> On Thu, 1 Dec 2005, Neil Brown wrote:
> 
> > What I would really like is a cheap (Well, not too expensive) board
> > that had at least 100Meg of NVRAM which was addressable on the PCI
> > buss, and an XOR and RAID-6 engine connected to the DMA engine.
> 
> there's the mythical giga-byte i-ram ... i say mythical because i've seen
> lots of reviews but haven't been able to find it for sale:
> 
> http://www.giga-byte.com/Peripherals/Products/Products_GC-RAMDISK%20(Rev%201.1).htm
> 
> the only problem with the i-ram is the lack of ecc (it could be 
> implemented in a software layer though).

The lack of ECC is a real killer for any sort of raid/journalling
application.  You want your journal to be more-resilient to failure
than your main array, not less.
And the fact that the board presents like an IDE controller (if I read
that right) means it is meant as fast-disk.  Not as a generally useful
board to do interesting things with :-(

The idea of just providing memory slots that you plug your own memory
into is certainly interesting.  It would mean making just one board
and the custom could choose how much memory they wanted to buy. (umem
below may several different sizes).  I wonder if it affects
reliability at all... 

> 
> umem.com have what look like excellent boards but they seem unwilling to 
> sell in small quantities...
> 
> http://umem.com/Umem_NVRAM_Cards.html

I have two of these in two different servers... I must have got them
at a time when small quantities weren't so unpalatable.   They have
full ECC, and even have a driver in kernel.org kernels (I had to
convince them that GPL wasn't bad, but that wasn't too hard).
The boards I got only presented a 64M (I think) window to the PCI
buss, though I believe they have versions that present to whole of
memory instead of just one window.

One of these with built in xor and raid6 would be nice, but I'm not
sure I could guarantee a big enough market for them to try convincing
them to make one...

NeilBrown 
