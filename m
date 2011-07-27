From: keld@keldix.com
Subject: Re: Using the new bad-block-log in md for Linux 3.1
Date: Wed, 27 Jul 2011 08:21:10 +0200
Message-ID: <20110727062110.GA9801@www5.open-std.org>
References: <20110727141652.7511fc51@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110727141652.7511fc51@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 27, 2011 at 02:16:52PM +1000, NeilBrown wrote:
> 
> As mentioned earlier, Linux 3.1 will contain support for recording and
> avoiding bad blocks on devices in md arrays.
> 
> These patches are currently in -next and I expect to send them to Linus
> tomorrow.
> 
> Using this funcitonality requires support in mdadm.  When an array is created
> some space needs to be reserved to store the bad block list.
> 
> I have just created an mdadm branch called devel-3.3 which provides initial
> functionality.  The main patch is included inline below.
> 
> This only supports creating new arrays with badblock support.  It also only
> supports 1.x metadata.
> 
> I hope to add support to add a bad block list to an existing 1.x array at
> some stage, but support for 0.90 metadata is not expected to ever be added.
> 
> If you create an array with this mdadm it will add a bad block log - you
> cannot turn it off (it is only 4K long so why would you want to).  Then as
> errors occur they will cause the faulty block to be added to the log rather
> than the device to be remove from the array.
> If writing the new bad block list fails, then the device as a whole will fail.
> 
> I would very much appreciate any reports of success of failure when using
> this new feature.  If you can make a test array using a known-faulty device
> and can experiment with that I would particularly like to hear about any
> experiences.
> 
> Thanks,
> NeilBrown
> 
>  git://neil.brown.name/mdadm devel-3.3
> 
> http://neil.brown.name/git?p=mdadm;a=shortlog;h=refs/heads/devel-3.3

How is it implemented? Does the bad block get duplicated in a reserve area?
Or are also corresponding good blocks on other sound devices also excluded?

How big a device can it handle?

If a device fails totally and the remaining devices contain devices with
bad blocks, will there then be lost data?

Best regrads
keld
