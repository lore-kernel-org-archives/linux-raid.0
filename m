From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: RAID-6
Date: Wed, 16 Nov 2005 12:39:51 -0800
Message-ID: <1132173592.23464.459.camel@seki.nac.uci.edu>
References: <437701DE.7060400@wasp.net.au>
	 <17271.4092.24066.572971@cse.unsw.edu.au>  <437B7264.50506@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <437B7264.50506@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, RAID Linux <linux-raid@vger.kernel.org>, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


My understanding is that RAID 5 -always- stripes parity.  If it didn't,
I believe it would be RAID 4.

You may find http://linux.cudeso.be/raid.php of interest.

I don't think RAID level 6 was in the original RAID paper, so vendors
may have decided on their own that it should mean what they're
selling.  :)

On Wed, 2005-11-16 at 12:54 -0500, Bill Davidsen wrote:
> Based on some google searching on RAID-6, I find that it seems to be 
> used to describe two different things. One is very similar to RAID-5, 
> but with two redundancy blocks per stripe, one XOR and one CRC (or at 
> any rate two methods are employed). The other sources define RAID-6 as 
> RAID-5 with a distributed hot spare, AKA RAID-5E, which spreads head 
> motion to all drives for performance.
> 
> Any clarification on this?
> 

