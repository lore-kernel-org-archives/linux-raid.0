From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: 3ware escalade vs software raid, from a different jeff
Date: Thu, 19 Feb 2004 15:18:13 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0402191508420.28488-100000@sweetums.bluetronic.net>
References: <200402191958.i1JJwP225623@bzs.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200402191958.i1JJwP225623@bzs.org>
To: Michael <michael@insulin-pumpers.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 19 Feb 2004, Michael wrote:
>Bear in mind that what you are calling "true hardware raid" is really
>a microprocessor programmed to do the raid algorithims.

3ware has custom designed matrix switch chips to handle each IDE drive.
This *alone* is worth the cost of the card.  The RAID parity calculations
are also done in hardware (not a bunch of CPU xor's.)  You'd be surprised how
much data a small "slow" processor can move when properly programmed.

>These turkeys have micro-code bugs that cause a
>variety of problem for which there is no workaround or solution other
>than trashing the cards.

Exactly what bugs?  I've used a number of hardware SCSI RAID cards (none
by Adaptec however -- some that are now owned by Adapatec) and all of them
work properly -- as long as they aren't physically damaged (I had one with
a bad DIMM)

--Ricky


