From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: Recommendations for supported 4-port SATA PCI card ?
Date: Sat, 01 Apr 2006 22:51:05 +1100
Message-ID: <442E6929.9090802@nighthawkrad.net>
References: <442BFB2B.6090903@stams.strath.ac.uk> <442D22CD.3010602@nighthawkrad.net> <442DC92E.8080003@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442DC92E.8080003@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell wrote:
> I've been running 3 together in one box for about 18 months, and four in 
> another for a year now... the on board BIOS will only pickup 8 drives, 
> but they work just fine under Linux and recognise all connected drives.

What distro and kernel ?

I tried this about 2 - 3 months ago and had problems whenever more than 
two cards were in my system, even if only a single drive was installed. 
  I posted about it here (search for "multiple promise sata150 tx4 
cards" back in January).

The symptoms were ata timeouts:

ata3: status=0x51 { DriveReady SeekComplete Error }
ata3: error=0x0c { DriveStatusError }
ata3: status=0x51 { DriveReady SeekComplete Error }
ata3: error=0x0c { DriveStatusError }
ata2: status=0x51 { DriveReady SeekComplete Error }
ata2: error=0x0c { DriveStatusError }
ata2: status=0x51 { DriveReady SeekComplete Error }
ata2: error=0x0c { DriveStatusError }

This would happen consistently with three controllers in, never with 
two.  I tried every possible combination of controllers and drives I 
could think of, to eliminate any potential of broken hardware being the 
cause.

I should probably give it another go, given there have been a couple of 
minor kernel versions since then, but I'm surprised to hear you've had 
it working for so long - no-one was able to give me a solution to my 
problem at the time (I ended up getting a pair of two-channel SATA 
cards) and I assumed it was a driver bug of some description.  Promise, 
of course, were useless, saying more than a single controller was an 
unsupported configuration.

> I have 11 drives in one box (on promise.. 2 on the on-board VIA and 1 on 
> PATA) and 15 drives in another (all across 4 promise cards).. all on 
> SATA150-TX4 cards..
> 
> Performance sucks.. but then when you put 15 drives on a single PCI 
> 33Mhz bus what do you expect ?
> Great for streaming media though.. (and cheap, and very reliable). The 
> only media errors I get are on the VIA controller. The promise 
> controllers have not had a single media error since they were installed.

I have no complaints about the performance (relatively speaking, of 
course), but I've got the cards in a machine with multiple PCI-X busses, 
so it's not really bottlenecked there.

CS
