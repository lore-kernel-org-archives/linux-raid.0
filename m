From: jlewis@lewis.org
Subject: Re: HighPoint 1820 (8pt sata pcix, $170)
Date: Fri, 28 Nov 2003 01:13:19 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311280110270.1140-100000@redhat1.mmaero.com>
References: <Pine.LNX.4.44.0311280100150.27273-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0311280100150.27273-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 28 Nov 2003, Mark Hahn wrote:

> 
> do you have any comment on the HighPoint 1820 card?  it's an 8-port SATA
> controller with PCI-X, and appears to list for about $US 170 (pricewatch).
> there's a driver (apparently binary-only, therefore of unknown quality)
> available from the vendor, but I suspect no real (kerne.org or libata)
> driver support...
> 
> comments on HighPoint in general?  I've seen a certain amount of traffic from
> people having trouble with their previous cards, but that's a very biased 
> sample, and who knows - maybe they've improved ;)

I'd be very hesitant.  I recently bought one of their cheaper cards 
(Rocket100) thinking "there's a driver in the kernel, it looks supported" 
only to find the current kernel driver does not work and neither do their 
binary drivers (driver disks) for Red Hat 8.0 or 9.

I ended up filing a bugzilla report with Red Hat and ordering a Promise 
Ultra100TX2 to replace the HPT.
  
----------------------------------------------------------------------
 Jon Lewis *jlewis@lewis.org*|  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |  
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________

