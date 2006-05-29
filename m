From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 kicks non-fresh drives
Date: Mon, 29 May 2006 15:20:32 +1000
Message-ID: <17530.33952.344812.34659@cse.unsw.edu.au>
References: <1148571503.2772.35.camel@hendrix.hollabaugh.com>
	<17526.7947.129968.287311@cse.unsw.edu.au>
	<1148596237.4957.4.camel@hendrix.hollabaugh.com>
	<Pine.LNX.4.62.0605260956120.20178@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mikael Abrahamsson on Friday May 26
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Craig Hollabaugh <craig@hollabaugh.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 26, swmike@swm.pp.se wrote:
> On Thu, 25 May 2006, Craig Hollabaugh wrote:
> 
> > That did it! I set the partition FS Types from 'Linux' to 'Linux raid 
> > autodetect' after my last re-sync completed. Manually stopped and 
> > started the array. Things looked good, so I crossed my fingers and 
> > rebooted. The kernel found all the drives and all is happy here in 
> > Colorado.
> 
> Would it make sense for the raid code to somehow warn in the log when a 
> device in a raid set doesn't have "Linux raid autodetect" partition type? 
> If this was in "dmesg", would you have spotted the problem before?

Maybe.  Unfortunately md doesn't really have direct access to
information on partition types.  The way it gets access for
auto-detect is an ugly hack which I would rather not make any further
use of.

Maybe mdadm could be more helpful here.
e.g. when you create, assemble, or 'detail' an array it could report
any inconsistencies in the partition types, and when you --add
a device which is isn't a Raid-autodetect partition to an
array the currently comprises such partitions it could give a warning.

I had thought that 'libblkid' would help with that, but having looked
at the doco, it appears not
Maybe I use libparted... or maybe borrow code out of kpartx.
There don't seem to be any easy options ;-(

Thanks for the suggestion (and if anyone has some good partition
hacking code...)

NeilBrown

