From: Iustin Pop <iusty@k1024.org>
Subject: Re: [PATCH 2.6.20-rc6] md: expose uuid and degraded attributes in sysfs
Date: Sat, 10 Feb 2007 22:50:41 +0100
Message-ID: <20070210215040.GA12830@teal.hq.k1024.org>
References: <20070127015948.GA24479@teal.hq.k1024.org> <20070210111836.GA7953@teal.hq.k1024.org> <45CE0A5D.6040409@tmr.com> <17870.13811.570367.617924@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17870.13811.570367.617924@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 11, 2007 at 08:15:31AM +1100, Neil Brown wrote:
> Resending after a suitable pause (1-2 weeks) is never a bad idea.
Ok, noted, thanks.

> Exposing the UUID isn't - and if it were it should be in
> "md_default_attrs" rather than "md_redundancy_attrs".
> 
> The UUID isn't an intrinsic aspect of the array.  It is simply part of
> the metadata that is used to match up different devices from the same
> array.
I see. Unfortunately, for now it's the only method of (more or less)
persistently identifying the array.

> I plan to add support for the 'DDF' metadata format (an 'industry
> standard') and that will be managed entirely in user-space.  The
> kernel won't know the uuid at all.
I've briefly looked over the spec, but this seems a non-trivial change,
away from current md superblocks to ddf... But the virtual disk GUIDs
seem nice. In the meantime, probably the solution you gave below is
best.

> So any solution for easy access to uuids should be done in user-space.
> Maybe mdadm could create a link
>    /dev/md/by-uuid/xxxxxxxx -> /dev/whatever.
> ??
That sounds like a good idea. mdadm (or udev or another userspace
solution) should work, given some safety measures against stale symlinks
and such. It seems to me that, since now it's possible to assemble
arrays without mdadm (by using sysfs), mdadm is not the best place to do
it. Probably relying on udev is a better option, however it right now it
seems that it gets only the block add events, and not the block remove
ones.

Thanks,
Iustin
