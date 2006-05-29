From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: problems with raid=noautodetect
Date: Mon, 29 May 2006 12:38:25 +0400
Message-ID: <447AB301.6050107@tls.msk.ru>
References: <4471B188.3060400@umit.at>	<17522.15774.526526.244768@cse.unsw.edu.au>	<20060526075308.GC8203@percy.comedia.it> <17530.30389.862288.268450@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17530.30389.862288.268450@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday May 26, bluca@comedia.it wrote:
[]
> If we assume there is a list of devices provided by a (possibly
> default) 'DEVICE' line, then 
> 
> DEVICEFILTER   !pattern1 !pattern2 pattern3 pattern4
> 
> could mean that any device in that list which matches pattern 1 or 2
> is immediately discarded, and remaining device that matches patterns 3
> or 4 are included, and the remainder are discard.
> 
> The rule could be that the default is to include any devices that
> don't match a !pattern, unless there is a pattern without a '!', in
> which case the default is to reject non-accepted patterns.
> Is that straight forward enough, or do I need an
>   order allow,deny
> like apache has?

I'd suggest the following.

"All the other devices" are included or excluded from the list of devices
to consider based on the last component in the DEVICE line.  Ie. if it
ends up at !dev, all the rest of devices are included.  If it ends up at
dev (w/o !), all the rest are excluded.  If memory serves me right, it's
how squid ACLs works.

There's no need to introduce new keyword.  Given this rule, a line

 DEVICE a b c

will do exactly as it does now.  Line

 DEVICE a b c !d

is somewhat redundant - it's the same as DEVICE !d
Ie, if the list ends up at !stuff, append `partitions' (or *) to it.

Ofcourse mixing !s and !!s is useful, like to say use all sda* but not
sda1:

 DEVICE !sda1 sda*

(and nothing else).

And the default is to have `DEVICE partitions'.

The only possible issue I see here is that with udev, it's possible to
use, say, /dev/disk/by-id/*-like stuff (don't remember exact directory
layout) -- symlinked to /dev/sd* according to the disk serial number or
something like that -- for this to work, mdadm needs to use glob()
internally.

/mjt
