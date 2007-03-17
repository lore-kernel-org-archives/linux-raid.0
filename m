From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm file system type check
Date: Sat, 17 Mar 2007 12:30:11 +1100
Message-ID: <17915.17571.333717.668140@notabene.brown>
References: <1174089424.22511.26.camel@wlt.obsidian-studios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from William L. Thomson Jr. on Friday March 16
Sender: linux-raid-owner@vger.kernel.org
To: "William L. Thomson Jr." <wltjr@gentoo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday March 16, wltjr@gentoo.org wrote:
> To whom it may concern,
> 
> 	It seems mdadm does not check, warn, abort, or etc if a partition has
> an incorrect file system type. This has come up for me on a few
> occasions while building servers with software raid. On one occasion I
> had a machine fully up and running on raid partitions that were ext3 not
> linux auto raid/fd.

It would be very awkward for mdadm to get at the partition type
information. 
And there is very little software that actually cares.  mdadm
certainly doesn't care what the partition type is.

> 
> 	If possible would really be nice if it could do a check for that. Since
> one usually has to start over when they discover the problem and go to
> correct it. Since raidtools is not deprecated, others migrating from it
> on Gentoo are running into it at as well. At the present time mostly
> developers. Really would not want users running into it :)

I don't understand why you would have to 'start over'.  If you
discover that the partition type isn't what you want for some reason,
just change it.

(and if raidtools isn't deprecated, it should be.  raidstart certainly
is deprecated).

> 
> 	Anyway if that could be addressed that would be great. Not sure if this
> is the right place for this or not. If not please advise, thank you.

This is the right place, thanks.
But maybe I don't really understand what the problem is.
Could you give more details?  Exactly what didn't work the way you
expected it to?

Thanks,
NeilBrown
