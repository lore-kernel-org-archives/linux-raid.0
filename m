From: NeilBrown <neilb@suse.de>
Subject: Re: Raid 5 to Raid 1 (half of the data not required)
Date: Wed, 24 Aug 2011 18:42:35 +1000
Message-ID: <20110824184235.2a165066@notabene.brown>
References: <BAY148-W51F7F3A42E515F76BB76EFEF2E0@phx.gbl>
	<alpine.DEB.2.00.1108240851190.6833@unicorn.drogon.net>
	<alpine.DEB.2.00.1108241018180.4709@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1108241018180.4709@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 24 Aug 2011 10:21:32 +0200 (CEST) Mikael Abrahamsson
<swmike@swm.pp.se> wrote:

> On Wed, 24 Aug 2011, Gordon Henderson wrote:
> 
> > This isn't as "glamorous" as Neils method involving lots of mdadm 
> > commands, shrinks and grows, but sometimes it's good to keep things at a 
> > simpler level?
> 
> Another way would be to add the new raid1 with missing drive to the lv, 
> and pvmove all extents off of the existing raid5 md pv, then vgreduce away 
> from it, stop the raid5, zero-superblock, and add one drive to add 
> redundancy for the raid1.
> 
> But that has little to do with linux raid, and all to do with LVM. It also 
> means you can do everything online since pvmove doesn't require to offline 
> anything.
> 

There are certainly lots of approaches. :-)
But every approach will require either coping or shrinking the filesystem and
as extX doesn't support online shrinking the filesystem will have to be
effectively off-line while that shrink happens.
(if you shrink by coping, then it could be technically on-line but it had
better not be written to).

NeilBrown
