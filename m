From: Bob Hillegas <bobhillegas@houston.rr.com>
Subject: Scsi adapters and software raid...
Date: Thu, 19 Feb 2004 16:04:22 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1077228261.30431.5.camel@south.rosestar.lan>
References: <Pine.GSO.4.33.0402191508420.28488-100000@sweetums.bluetronic.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.33.0402191508420.28488-100000@sweetums.bluetronic.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It's been interesting reading these comments about adapters to avoid. 

My question is... what SCSI adapter works WELL with software raid
(mdadm) and doesn't get in the way?

Thanks, BobH

On Thu, 2004-02-19 at 14:18, Ricky Beam wrote:
> On Thu, 19 Feb 2004, Michael wrote:
> >Bear in mind that what you are calling "true hardware raid" is really
> >a microprocessor programmed to do the raid algorithims.
> 
> 3ware has custom designed matrix switch chips to handle each IDE drive.
> This *alone* is worth the cost of the card.  The RAID parity calculations
> are also done in hardware (not a bunch of CPU xor's.)  You'd be surprised how
> much data a small "slow" processor can move when properly programmed.
> 
> >These turkeys have micro-code bugs that cause a
> >variety of problem for which there is no workaround or solution other
> >than trashing the cards.
> 
> Exactly what bugs?  I've used a number of hardware SCSI RAID cards (none
> by Adaptec however -- some that are now owned by Adapatec) and all of them
> work properly -- as long as they aren't physically damaged (I had one with
> a bad DIMM)
> 
> --Ricky
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Bob Hillegas <bobh@south.rosestar.lan>
