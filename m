From: Neil Brown <neilb@suse.de>
Subject: Re: Is shrinking raid5 possible?
Date: Fri, 23 Jun 2006 11:26:32 +1000
Message-ID: <17563.17224.85968.572754@cse.unsw.edu.au>
References: <44960C45.9050407@anu.edu.au>
	<17558.10906.59066.196870@cse.unsw.edu.au>
	<449B3A80.4070602@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Thursday June 22
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Paul Davidson <Paul.Davidson@anu.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 22, davidsen@tmr.com wrote:
> Neil Brown wrote:
> 
> >On Monday June 19, Paul.Davidson@anu.edu.au wrote:
> >  
> >
> >>Hi,
> >>
> >>I'd like to shrink the size of a RAID5 array - is this
> >>possible? My first attempt shrinking 1.4Tb to 600Gb,
> >>
> >>mdadm --grow /dev/md5 --size=629145600
> >>
> >>gives
> >>
> >>mdadm: Cannot set device size/shape for /dev/md5: No space left on device
> >>    
> >>
> >
> >Yep.
> >The '--size' option refers to:
> >              Amount  (in  Kibibytes)  of  space  to  use  from  each drive in
> >              RAID1/4/5/6.  This must be a multiple of  the  chunk  size,  and
> >              must  leave about 128Kb of space at the end of the drive for the
> >              RAID superblock.  
> >(from the man page).
> >
> >So you were telling md to use the first 600GB of each device in the
> >array, and it told you there wasn't that much room.
> >If your array has N drives, you need to divide the target array size
> >by N-1 to find the target device size.
> >So if you have a 5 drive array, then you want
> >  --size=157286400
> >
> 
> May I say in all honesty that making people do that math instead of the 
> computer is a really bad user interface? Good, consider it said. An 
> means to just set the target size of the resulting raid device would be 
> a LOT less likely to cause bad user input, and while I'm complaining it 
> should inderstand suffices 'k', 'm', and 'g'.

Let me put another perspective on this.

Why would you ever want to reduce the size of a raid5 in this way?
The only reason that I can think of is that you want to repartition
each device to use a smaller partition for the raid5, and free up some
space for something else.  If that is what you are doing, you will
have already done the math and you will know what size you want your
final partitions to be, so setting the device size is just as easy as
setting the array size.

If you really are interested in array size and have no interest in
recouping the wasted space on the drives, then there would be no point
in shrinking the array (that I can think of).
Just 'mkfs' a filesystem to the desired size and ignore the rest of
the array.


In short, reducing a raid5 to a particular size isn't something that
really makes sense to me.  Reducing the amount of each device that is
used does - though I would much more expect people to want to increase
that size.

If Paul really has a reason to reduce the array to a particular size
then fine.  I'm mildly curious, but it's his business and I'm happy
for mdadm to support it, though indirectly.  But I strongly suspect
that most people who want to resize their array will be thinking in
terms of the amount of each device that is used, so that is how mdadm
works.

> 
> Far easier to use for the case where you need, for instance, 10G of 
> storage for a database, tell mdadm what devices to use and what you need 
> (and the level of course) and let the computer figure out the details, 
> rounding up, leaving 128k, and phase of the moon if you decide to use it.
> 

mdadm is not intended to be a tool that manages your storage for you.  If
you want that, then I suspect EVMS is what you want (though I am only
guessing - I've never used it).  mdadm it a tool that enables YOU to
manage your storage.

NeilBrown



> Sorry, I think the current approach is baaad human interface.
> 
> -- 
> bill davidsen <davidsen@tmr.com>
>   CTO TMR Associates, Inc
>   Doing interesting things with small computers since 1979
