From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: Problems with multiple Promise SATA150 TX4 cards
Date: Wed, 25 Jan 2006 06:33:12 +0100 (MET)
Message-ID: <Pine.GSO.4.62.0601250623520.14030@shaka.acc.umu.se>
References: <Pine.LNX.4.44.0601240132560.32305-100000@coffee.psychology.mcmaster.ca>
 <43D5EF58.9010807@wasp.net.au> <43D62B4F.1080505@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D62B4F.1080505@nighthawkrad.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: Brad Campbell <brad@wasp.net.au>, Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 25 Jan 2006, Christopher Smith wrote:

> Something else I tried was some crappy dual-port SIL-based SATA card 
> with two of the Promise TX4s, and that worked without a problem.  While 
> I'm waiting to find out what this is, I might buy another one and use 
> the two of them temporarily so I can build my RAID array, at least.

This suddenly sounds familiar from my experiences with Promise cards, but 
during the PATA days. Two cards worked fine, but adding a third made lots 
of strange problems appear.  So my experience matches yours, max 2 promise 
cards in one machine.

This experience of strange and not strictly reproducable problems when it 
comes to both stability and drive detection made me stay away from buying 
more Promise cards in favour of "crappy" SIL-based SATA cards in the 
latest upgrade.

Unfortunately, this did not help stability that much, I'm currently 
hunting down a reproducable hard hang when doing raid action on the 
drives. So far reads with dd from the individual disk devices are fine 
(even from all at the same time), but dd from the raid5 over the disks 
hangs the system in an hour or so. But more regarding this in a separate 
thread when I have enough info to be useful and I'm sure the numbers are 
repeatable (unless someone finds preliminary findings really interesting).

/Mattias Wadenstein
