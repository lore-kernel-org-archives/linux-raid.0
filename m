From: Dave Chinner <david@fromorbit.com>
Subject: Re: interesting MD-xfs bug
Date: Fri, 10 Apr 2015 08:53:22 +1000
Message-ID: <20150409225322.GH13731@dastard>
References: <5526E8E9.3030805@gmail.com>
 <20150409221846.GG13731@dastard>
 <5526FB2A.8060704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5526FB2A.8060704@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: xfs <xfs@oss.sgi.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Apr 09, 2015 at 06:20:26PM -0400, Joe Landman wrote:
> 
> 
> On 04/09/2015 06:18 PM, Dave Chinner wrote:
> >On Thu, Apr 09, 2015 at 05:02:33PM -0400, Joe Landman wrote:
> >>If I build an MD raid0 with a non power of 2 chunk size, it appears
> >>that I can mkfs.xfs a file system, but it doesn't show up in blkid
> >>and is not mountable.  Yet, using a power of 2 chunk size, this does
> >>work correctly.   This is kernel 3.18.9.
> >>
> 
> [...]
> 
> >That looks more like a blkid or udev problem. try using blkid -p so
> >that it doesn't look up the cache but directly probes devices for
> >the signatures. strace might tell you a bit more, too. And if the
> >filesystem mounts, then it definitely isn't an XFS problem ;)
> 
> Thats the thing, it didn't mount, even when I used the device name
> directly.

Ok, that's interesting. Let me see if I can reproduce it locally. If
you don't hear otherwise, tracing would still be useful. Thanks for
the bug report, Joe.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
