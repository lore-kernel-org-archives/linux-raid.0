From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: RAID 5 performance problems
Date: Thu, 3 Apr 2003 13:47:56 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030403184756.GA7971@willow.seitz.com>
References: <73300040777B0F44B8CE29C87A0782E101FA97B2@exchange.explainerdc.com> <Pine.GSO.4.30.0304030858080.20118-100000@multivac.sdsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.30.0304030858080.20118-100000@multivac.sdsc.edu>
To: "Peter L. Ashford" <ashford@sdsc.edu>
Cc: Jonathan Vardy <jonathan@explainerdc.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

[CC list trimmed]

On Thu, Apr 03, 2003 at 10:05:27AM -0800, Peter L. Ashford wrote:
> > 4 of the raid HD's are connected to the Promise controller and the other
> > raid HD is master on the second onboard IDE channel (udma2/ATA33)
> 
> I've NEVER heard that the FastTrak runs fast (I have been told that they
> run VERY slowly).

The FastTrack cards are identical to the UltraDMA cards from promise -
you can turn one into the other with a resistor and a firmware flash.

> I've benchmarked RAW disk speeds with an Ultra-100 and
> WD1200JB drives, and gotten 50MB/S from each disk, as opposed to your
> 26MB/S (there should be almost no difference for the BB drives).

Makes perfect sense - he's getting 50M/s to each channel, but it's split
over two drives, so drive throughput is about halved.

> Use one disk per channel
> (Master only), and move the system disk onto one of the Promise cards.

Absolutely correct - you should *never* run IDE RAID on a channel that
has both a master and slave.  When one disk on an IDE channel has an
error, the whole channel is reset - this makes both disks inaccessible,
and RAID5 now has two failed disks => you data is gone!  *ALWAYS* use
separate IDE channels.


-- 
Ross Vandegrift
ross@willow.seitz.com

A Pope has a Water Cannon.                               It is a Water Cannon.
He fires Holy-Water from it.                        It is a Holy-Water Cannon.
He Blesses it.                                 It is a Holy Holy-Water Cannon.
He Blesses the Hell out of it.          It is a Wholly Holy Holy-Water Cannon.
He has it pierced.                It is a Holey Wholly Holy Holy-Water Cannon.
He makes it official.       It is a Canon Holey Wholly Holy Holy-Water Cannon.
Batman and Robin arrive.                                       He shoots them.
