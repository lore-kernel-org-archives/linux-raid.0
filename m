From: NeilBrown <neilb@suse.de>
Subject: Re: Using the new bad-block-log in md for Linux 3.1
Date: Wed, 27 Jul 2011 16:49:59 +1000
Message-ID: <20110727164959.3352c5a3@notabene.brown>
References: <20110727141652.7511fc51@notabene.brown>
	<20110727062110.GA9801@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110727062110.GA9801@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 27 Jul 2011 08:21:10 +0200 keld@keldix.com wrote:

> On Wed, Jul 27, 2011 at 02:16:52PM +1000, NeilBrown wrote:
> > 
> > As mentioned earlier, Linux 3.1 will contain support for recording and
> > avoiding bad blocks on devices in md arrays.
> > 
> > These patches are currently in -next and I expect to send them to Linus
> > tomorrow.
> > 
> > Using this funcitonality requires support in mdadm.  When an array is created
> > some space needs to be reserved to store the bad block list.
> > 
> > I have just created an mdadm branch called devel-3.3 which provides initial
> > functionality.  The main patch is included inline below.
> > 
> > This only supports creating new arrays with badblock support.  It also only
> > supports 1.x metadata.
> > 
> > I hope to add support to add a bad block list to an existing 1.x array at
> > some stage, but support for 0.90 metadata is not expected to ever be added.
> > 
> > If you create an array with this mdadm it will add a bad block log - you
> > cannot turn it off (it is only 4K long so why would you want to).  Then as
> > errors occur they will cause the faulty block to be added to the log rather
> > than the device to be remove from the array.
> > If writing the new bad block list fails, then the device as a whole will fail.
> > 
> > I would very much appreciate any reports of success of failure when using
> > this new feature.  If you can make a test array using a known-faulty device
> > and can experiment with that I would particularly like to hear about any
> > experiences.
> > 
> > Thanks,
> > NeilBrown
> > 
> >  git://neil.brown.name/mdadm devel-3.3
> > 
> > http://neil.brown.name/git?p=mdadm;a=shortlog;h=refs/heads/devel-3.3
> 
> How is it implemented? Does the bad block get duplicated in a reserve area?

No duplication - I expect the underlying device to be doing that, and doing
it again at another level seems pointless.

The easiest way to think about it is that the strip containing a bad block is
treated as 'degraded'.  You can have an array were only some strips are
degraded, and they are each missing different devices.

> Or are also corresponding good blocks on other sound devices also excluded?

Not sure what you mean.  A bad block is just on one device.  Each device has
its own independent table of bad blocks.

> 
> How big a device can it handle?

2^54 sectors which with 512byte sectors is 8 exbibytes.
With larger sectors, larger devices.

> 
> If a device fails totally and the remaining devices contain devices with
> bad blocks, will there then be lost data?

Yes.  You shouldn't aim to run an array with bad blocks any more than you
should run an array degraded.
The purpose of bad block management is to provide a more graceful failure
path, not to encourage you to run an array with bad drives (except for
testing).

In particular this lays the ground work to implement hot-replace.  If you
have a drive that is failing it can stay in the array and hobble along for a
bit longer.  Meanwhile you add a fresh new drive as a hot-replace and let it
rebuilt.  If there is a bad block elsewhere in the array the hot-replace
drive might still rebuild completely.  And even if there is a failure, you
will only lose some blocks, not the whole array.

This all makes is very hard to build confidence in the code - most of the
time it is not used at all and I would rather it that way.  But when things
start going wrong, you really want it to be 100% bug free.


Thanks for the questions,
NeilBrown



> 
> Best regrads
> keld

