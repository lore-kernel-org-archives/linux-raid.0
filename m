From: Michael-John Turner <mj@mjturner.net>
Subject: Re: Help - power failure during RAID6 grow
Date: Fri, 26 Aug 2011 22:24:47 +0100
Message-ID: <20110826212446.GA10265@majestic.pimp.org.za>
References: <20110826151803.GA7595@majestic.pimp.org.za>
 <20110826161746.GB7595@majestic.pimp.org.za>
 <20110827065151.03b2d930@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110827065151.03b2d930@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Aug 27, 2011 at 06:51:51AM +1000, NeilBrown wrote:
> Assemble the array with the rest of the devices and give the "--force" flag
> so it will update the event counts to all be in sync.
> And do this with MDADM_GROW_ALLOW_OLD=1 set.

Thanks - that's exactly what I've done and it's rebuilding as we speak. I
did toy with recreating the array (to get sda1 back in place as a
non-spare) but wasn't sure if re-writing the RAID superblock would affect
the resizing that was in progress?

> Then add sda1 back in and it will recover and the array will be optimal.

Will do. Having to do a sync twice is a bit painful, but at least I've got
the array back :)

Once again, thanks - the assistance is much appreciated.

-mj
-- 
 Michael-John Turner
 mj@mjturner.net      <>     http://mjturner.net/
