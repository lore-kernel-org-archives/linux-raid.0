From: Neil Brown <neilb@suse.de>
Subject: Re: Replacing a drive in RAID 0
Date: Tue, 3 Aug 2010 16:14:56 +1000
Message-ID: <20100803161456.31d0f69b@notabene>
References: <1c7fae50481e2f053798107bf2ad2737@localhost>
	<alpine.DEB.1.10.1008030720540.19930@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1008030720540.19930@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Ben Nemec <lists@nemebean.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 3 Aug 2010 07:22:01 +0200 (CEST)
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> On Mon, 2 Aug 2010, Ben Nemec wrote:
> 
> > enough to do that, of course).  Can I just dd the entire drive over and
> > replace the bad drive?  Can the md tools do it somehow?  Maybe it's
> 
> Yes, you can binary copy the drive like that, that's what I usually do.

Of course you need to be sure that the old and new devices are exactly the
same size.  Normally they will but it is worth double checking that the
number of sectors (blockdev --getsize) is exactly the same.

NeilBrown

> 
> Use dd_rescue (or ddrescue, they are two different utils) instead of dd in 
> case you have any bad blocks.
> 

