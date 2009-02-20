From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: 'size_limit' attribute
Date: Fri, 20 Feb 2009 15:07:01 +1100
Message-ID: <18846.11365.791397.94509@notabene.brown>
References: <1234549811.26769.7.camel@dwillia2-linux.ch.intel.com>
	<18838.14442.891790.33471@notabene.brown>
	<e9c3a7c20902171606g1ad719f6v812aecc06f20ac2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday February 17
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, ed.ciechanowski@intel.com, jacek.danecki@intel.com
List-Id: linux-raid.ids

On Tuesday February 17, dan.j.williams@intel.com wrote:
> On Fri, Feb 13, 2009 at 8:20 PM, Neil Brown <neilb@suse.de> wrote:
> > On Friday February 13, dan.j.williams@intel.com wrote:
> 
> > Can you give me a concrete example of an array where this will make a
> > required difference?  I just want to be sure I understand.
> 
> 1/ Array created in orom
> 2/ User assembles, partitions, and formats the array in Linux
> 3/ User reboots into Windows and sees data missing off the end of the volume

I was hoping for raid level devices size, chunk size, array size etc,
but it probably isn't important.  
> 
> > What would you think of renaming the attribute to 'array_size' with
> > the semantic of "once user-space sets it, the kernel will never change
> > it" ??
> 
> To be be sure I understand, the differences from the current patch:
> 1/ The kernel will set ->array_size at array start time unless
> userspace has modified it from zero.  If userspace has modified it we
> should probably refuse to run if ->array_size is > ->array_sectors?
> Upon successfully starting the array we record that userspace owns
> ->array_size.

I wasn't thinking of having two 'size' variables.  Just the one
"array_sectors" with a "externally modified" flag.

Yes, refuse to run if the specified size is larger that the array
provides. 

We record that user-space owns the size whenever they set it.

> 2/ At reshape time the kernel sets ->array_size = ->array_sectors
> unless userspace owns ->array_size at which point we don't touch
> ->array_size.  I assume we must then block attempts to reshape the
> array to a smaller than ->array_size size when userspace ->array_size
> is in effect?

Yes, I think that makes sense.

> 3/ While an array is active userspace can set ->array_size only if the
> kernel has recorded that ->array_size is under userspace control, and
> then it can only set a value that is <= ->array_sectors?
> 

I'm not sure about that restriction.  I want to be able to 'take over'
at any time.  I'd also like to be able to 'let go' as well.

You see I have come up with another use for this.
One of the reasons I have been reticent to add support for shaping a
RAID5 to have fewer devices is that it irreversibly destroys data.
The moment you trigger the reshape, it will start over-writing the
data at the end of the array.

But if I could explicitly set the size of the array to be smaller, or
conversely, set the 'used-space' per device to be more without making
the array larger, then it wouldn't be the shape that destroyed data.

If you are replacing the drives with fewer larger drives, then I never
want the array to appear larger.
If you really are shrinking the array, then I want that to be an
operation that is reversible.
If I could explicitly set the array size, then I would require that
you first make the array smaller.  If that causes your filesystem to
start spewing errors, you can set it larger again and minimal harm
done.

So: new attribute:  ../md/size  (or do we want array_size).
Measured in .... 
   sectors would be nice.
   K would be consistent with component_size
I suspect we should use K.

Write a number, and (if it isn't too big) the array size is pinned to
that number.
Write 'default' and the array size is allowed to float to whatever
is the available space.
Read always gives the current size.  It gives no indication on whether
the size is pinned or not. (Does it need to?)

I could probably live without the 'default' setting for now.  Any
version of 'mdadm' which ever sets /size would need to make sure to
set /size for any --grow which made a difference.

It might be good to allow writing 'max' to get the max size??

Thanks,
NeilBrown
