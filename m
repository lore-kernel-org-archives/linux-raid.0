From: dean gaudet <dean@arctic.org>
Subject: Re: proactive-raid-disk-replacement
Date: Fri, 8 Sep 2006 11:44:07 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0609081128130.32186@twinlark.arctic.org>
References: <45012E73.5040900@tls.msk.ru> <Pine.LNX.4.64.0609080215220.32186@twinlark.arctic.org>
 <45014A43.2020702@tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45014A43.2020702@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 8 Sep 2006, Michael Tokarev wrote:

> dean gaudet wrote:
> > On Fri, 8 Sep 2006, Michael Tokarev wrote:
> > 
> >> Recently Dean Gaudet, in thread titled 'Feature
> >> Request/Suggestion - "Drive Linking"', mentioned his
> >> document, http://arctic.org/~dean/proactive-raid5-disk-replacement.txt
> >>
> >> I've read it, and have some umm.. concerns.  Here's why:
> >>
> >> ....
> >>> mdadm -Gb internal --bitmap-chunk=1024 /dev/md4
> 
> By the way, don't specify bitmap-chunk for internal bitmap.
> It's needed for file-based (external) bitmap.  With internal
> bitmap, we have fixed size in superblock for it, so bitmap-chunk
> is determined by dividing that size by size of the array.

yeah sorry that was with an older version of mdadm which didn't calculate 
the chunksize correct for an internal bitmap on a large enough array... i 
should have mentioned that in the post.  it's fixed in newer mdadm.


> > my practice is to run regular SMART long self tests, which tend to find 
> > Current_Pending_Sectors (which are generally read errors waiting to 
> > happen) and then launch a "repair" sync action... that generally drops the 
> > Current_Pending_Sector back to zero.  either through a realloc or just 
> > simply rewriting the block.  if it's a realloc then i consider if there's 
> > enough of them to warrant replacing the disk...
> > 
> > so for me the chances of a read error while doing the raid1 thing aren't 
> > as high as they could be...
> 
> So the whole thing goes this way:
>   0) do a SMART selftest ;)
>   1) do repair for the whole array
>   2) copy data from failing to new drive
>     (using temporary superblock-less array)
>   2a) if step 2 failed still, probably due to new bad sectors,
>       go the "old way", removing the failing drive and adding
>       new one.
> 
> That's 2x or 3x (or 4x counting the selftest, but that should be
> done regardless) more work than just going the "old way" from the
> beginning, but still some chances to have it completed flawlessly
> in 2 steps, without losing redundancy.

well it's more "work" but i don't actually manually launch the SMART 
tests, smartd does that.  i just notice when i get mail indicating 
Current_Pending_Sectors has gone up.

but i'm starting to lean towards SMART short tests (in case they test 
something i can't test with a full surface read) and regular crontabbed 
rate-limited repair or check actions.


> 2)  The same, but not offlining the array.  Hot-remove a drive, make copy
>    of it to new drive, flip necessary bitmap bits, and re-add the new drive,
>    and let raid code to resync changed (during copy, while the array was
>    still active, something might has changed) and missing blocks.
> 
> This variant still loses redundancy, but not much of it, provided the bitmap
> code works correctly.


i like this method.  it yields the minimal disk copy time because there's
no competition with the live traffic... and you can recover if another
disk has errors while you're doing the copy.


> 3)  The same as your way, with the difference that we tell md to *skip* and
>   ignore possible errors during resync (which is also not possible currently).

maybe we could hand it a bitmap to record the errors in... so we could
merge it with the raid5 bitmap later.

still not really the best solution though, is it?

we really want a solution similar to raid10...

-dean
