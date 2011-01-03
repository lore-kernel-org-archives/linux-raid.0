From: Neil Brown <neilb@suse.de>
Subject: Re: filesystem corruption
Date: Mon, 3 Jan 2011 15:56:30 +1100
Message-ID: <20110103155630.565341d0@notabene.brown>
References: <4D212D4A.3040003@feystorm.net>
	<20110103141603.632fdf3e@notabene.brown>
	<4D214B5C.3010103@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D214B5C.3010103@feystorm.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick H." <linux-raid@feystorm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 02 Jan 2011 21:06:52 -0700 "Patrick H." <linux-raid@feystorm.net>
wrote:


> That makes sense assuming that MD acknowleges the write once the data is 
> written to the data disks but not necessarily the parity disk, which is 
> what I gather you were saying is what happens. Is there any option that 
> can change the behavior so that md wont ack the write until its been 
> committed to all disks (I'm guessing no since you didnt mention it)?
> Also does raid6 suffer this problem? Is it smart enough to use both 
> parity disks when calculating replacement, or will it just use one?
> 

md/raid5 doesn't acknowledge the write until both the data and the parity
have been written.  But that doesn't make any difference.
If you schedule a number of interdependent writes (data and parity) and then
allow some to complete but not all, then you have inconsistency.
Recovery from losing a single device requires consistency of parity and data.

RAID6 suffers equally from this problem.  Even if it used both parity disks
to recover (which it doesn't) how would that help?  It would then have two
possible value for the data and no way to know which was correct, and every
possibility that both are incorrect.  This would happen if a single data
block was successfully written, but neither parity blocks were.

The only way you can avoid this 'write hole' is by journalling in multiples
of whole stripes.  No current filesystems that I know of can do this as they
journal in blocks, and the maximum block size is less than the minimum stripe
size.  So you would need journalling integrated with md/raid, or you would
need a filesystem which was designed to understand this problem and write
whole stripes at a time, always to an area of the device which did not
contain live data.

NeilBrown
