From: Neil Brown <neilb@suse.de>
Subject: Re: limits on raid
Date: Thu, 21 Jun 2007 12:56:44 +1000
Message-ID: <18041.59628.370832.633244@notabene.brown>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<467273AB.9010202@argo.co.il>
	<18035.3009.568832.785308@notabene.brown>
	<20070618045759.GD85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Chinner on Monday June 18
Sender: linux-raid-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: Avi Kivity <avi@argo.co.il>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 18, dgc@sgi.com wrote:
> On Sat, Jun 16, 2007 at 07:59:29AM +1000, Neil Brown wrote:
> > Combining these thoughts, it would make a lot of sense for the
> > filesystem to be able to say to the block device "That blocks looks
> > wrong - can you find me another copy to try?".  That is an example of
> > the sort of closer integration between filesystem and RAID that would
> > make sense.
> 
> I think that this would only be useful on devices that store
> discrete copies of the blocks on different devices i.e. mirrors. If
> it's an XOR based RAID, you don't have another copy you can
> retreive....

You could reconstruct the block in question from all the other blocks
(including parity) and see if that differs from the data block read
from disk...  For RAID6, there would be a number of different ways to
calculate alternate blocks.   Not convinced that it is actually
something we want to do, but it is a possibility.

I have that - apparently naive - idea that drives use strong checksum,
and will never return bad data, only good data or an error.  If this
isn't right, then it would really help to understand what the cause of
other failures are before working out how to handle them....

NeilBrown
