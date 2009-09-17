From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: Re: recommended 4port SATA controller ?
Date: Thu, 17 Sep 2009 16:47:24 +0200
Message-ID: <4AB24BFC.6070800@kaneda.iguw.tuwien.ac.at>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at> <87f94c370909170549v156f9b23ie19f7204e21819f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370909170549v156f9b23ie19f7204e21819f1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greg Freemyer wrote:

> The support chips are not always available in all flavors of PCI, so
> you need to specify which flavor PCI slots your mother board has.
the board is an intel D945GSEJT with one PCI express mini card slot (no 
use looking for a 4port controller for this slot I guess) and one 
standard PCI slot (therefore, 2*2ports are not an option).

strangely, the official site doesn't mention the PCI slot ...
http://www.intel.com/products/desktop/motherboards/D945GSEJT/D945GSEJT-overview.htm

... but the manual does:
http://download.intel.com/support/motherboards/desktop/d945gsejt/sb/e5941302us.pdf

the plan is to replace this board with a more power-saving one as soon 
as the new intel atom plattfrom (pinewood? pinetrail?) comes out in 
2010/Q1 (hard to tell which  expansion slots the boards will have then, 
but I bet on PCI).
speed isn't an issue, but low power consumption would be nice (but not 
easy to find in datasheets etc.) since the server is supposed to be 
powered by photovoltaic panels.

thanks for all the hints so far, guys!

cu

> I don't recall seeing a non-raid 4-port "legacy PCI" controller, but I
> can't say I've looked very hard.  Hopefully your motherboard has a
> "PCI express" slot available.
> 
> If PCI is all you have, I would go with a pair of SiiG controllers.
> 2-ports each, but they only cost $30 or so.  I have a dozen machines
> at least with the 2-port SiiG PCI controllers in them and have had no
> issues with linus drivers, etc.
> 
> Greg
> 

