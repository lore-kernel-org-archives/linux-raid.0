From: viro@parcelfarce.linux.theplanet.co.uk
Subject: Re: [RFCI] How best to partition MD/raid devices in 2.6
Date: Fri, 14 Nov 2003 05:09:34 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031114050934.GI24159@parcelfarce.linux.theplanet.co.uk>
References: <16308.18387.142415.469027@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16308.18387.142415.469027@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 14, 2003 at 02:11:15PM +1100, Neil Brown wrote:
>  This patch declares a new major number and uses it to address upto 15
>  partitions on each of the first 16 md arrays.
>  Not only does this limit you do only partitioning 16 md arrays, but
>  it means that there are two separate devices (major+minor) that
>  access the same device.  In 2.4 this is just untidy.  In 2.6 it would
>  also subvert the exclusive access provided by bd_claim, and that
>  isn't a good thing. 
 
It breaks all sorts of exclusions common for 2.4 and 2.6.

>  2/ new major number which uses 6 bits for partitioning and provide
>    some sort of interlock so that you cannot access the same raid
>    array from both the old and the new major at the same time.
>    I'm not sure how easy the interlock would be, but it is probably
>    do-able.  The problem is that I would like a well-defined major

Very painful.

>    number and Linus doesn't seem keen on any more of those (though I
>    realise that isn't unanimous).
>    There was once talk of a 'disk' major number and all the things
>    that looked like discs would come under that somehow, but that
>    doesn't seem to have eventuated.  Maybe it should, but there would
>    still be the interlock problem

Yup.  And it won't be easy (if at all feasible).

>  3/ define minor numbers of block-major-9 that are larger than 255 to
>    have 6 bits of partitioning information. i.e.
>      9,0 -> md0
>      9,1 -> md1
>       ...
>      9,255 -> md255
>      9,256 -> md256
>      9,257 -> md256p1
>      9,257 -> md256p2
>       ...
>      9,320 -> md257
>      9,321 -> md257p1
>       ...
>    This has least impact on other system and is in some ways simplest,
>    but it has the problem of lack of uniformity.  You wouldn't be able
>    to partition md0, but that isn't a big problem as long as you can
>    partition some md arrays.

That works and is trivial to implement.
 
>  4/ just use 'dm', or write a new 'md' module that can present a
>     partition of a device.  Then leave the setup to user-space.
>     This is least impact on the kernel, but most impact on
>     user-space.  It would not be too hard to create a userspace tool
>     that made most of this fairly transparent.
>     Particularly if it was a new 'md' personality, userspace could
>     then effectively decide how the minor numbers of block-major-9
>     were used with respect to partitioning.

Maybe...

> 
> There are probably other options and I would be happy to hear them.
> My personal preference is wavering between 4 (using md) and 2.
> Possibly I should learn more about how 'dm' could handle it for me..

(2) is going to be very nasty.  Keep in mind that there is locking
based on having unique struct block_device.  And entire area is not
too nice to start with - we still have lots of cleanup to do in 2.7.
Try it if you really want to, but I'd expect a lot of hard-to-plug
holes.

(3) is absolutely trivial - will take 10--30 lines in md.c.

No comments on (4).
