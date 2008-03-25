From: Neil Brown <neilb@suse.de>
Subject: Re: Redundancy check using "echo check > sync_action": error	reporting?
Date: Tue, 25 Mar 2008 15:24:59 +1100
Message-ID: <18408.32411.524644.940275@notabene.brown>
References: <47DD2CD7.2090802@tuxes.nl>
	<20080316161451.0d17fd22@szpak>
	<47E26775.3000500@tuxes.nl>
	<20080320134747.GA28114@cthulhu.home.robinhill.me.uk>
	<47E2725C.1020206@tuxes.nl>
	<20080320163551.GG13719@mit.edu>
	<47E2EE64.5080101@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter Rabbitson on Friday March 21
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Theodore Tso <tytso@MIT.EDU>, Bas van Schaik <bas@tuxes.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday March 21, rabbit+list@rabbit.us wrote:
> Theodore Tso wrote:
> > On Thu, Mar 20, 2008 at 03:19:08PM +0100, Bas van Schaik wrote:
> >>> There's no explicit message produced by the md module, no.  You need to
> >>> check the /sys/block/md{X}/md/mismatch_cnt entry to find out how many
> >>> mismatches there are.  Similarly, following a repair this will indicate
> >>> how many mismatches it thinks have been fixed (by updating the parity
> >>> block to match the data blocks).
> >>>   
> >> Marvellous! I naively assumed that the module would warn me, but that's
> >> not true. Wouldn't it be appropriate to print a message to dmesg if such
> >> a mismatch occurs during a check? Such a mismatch clearly means that
> >> there is something wrong with your hardware lying beneath md, doesn't it?
> > 
> > If a mismatch is detected in a RAID-6 configuration, it should be
> > possible to figure out what should be fixed (since with two hot spares
> > there should be enough redundancy not only to detect an error, but to
> > correct it.)  Out of curiosity, does md do this automatically, either
> > when reading from a stripe, or during a resync operation?
> > 
> 
> In my modest experience with root/high performance spool on various raid 
> levels I can pretty much conclude that the current check mechanism doesn't do 
> enough to give power to the user. We can debate all we want about what the MD 
> driver should do when it finds a mismatch, yet there is no way for the user to 
> figure out what the mismatch is and take appropriate action. This does not 
> apply only to RIAD5/6 - what about RAID1/10 with >2 chunk copies? What if the 
> only wrong value is taken and written all over the other good blocks?
> 
> I think that the solution is rather simple, and I would contribute a patch if 
> I had any C experience. The current check mechanism remains the same - 
> mismatch_cnt is incremented/reset just the same as before. However on every 
> mismatching chunk the system printks the following:
> 
> 1) the start offset of the chunk(md1/10) or stripe(md5/6) within the MD device
> 2) one line for every active disk containing:
> 	a) the offset of the chunk within the MD componnent
> 	b) a {md5|sha1}sum of the chunk

More logging probably would be appropriate.
I wouldn't emit too much detail from the kernel though.  Just enough
to identify the location.  Have the userspace tool do all the more
interesting stuff.

You would want to rate limit the message though, to that you don't get
piles of messages when initialising the array...

> 
> In a common case array this will take no more than 8 lines in dmesg. However 
> it will allow:
> 
> 1) For a human to determine at a glance which disk holds a mismatching chunk 
> in raid 1/10
> 2) Determine the same for raid 6 using a userspace tool which will calculate 
> the parity for every possible permutation of chunks
> 3) using some external tools to determine which file might have been affected 
> on the layered file system
> 
> 
> Now of course the problem remains how to repair the array using the 
> information obtained above. I think the best way would be to extend the syntax 
> of repair itself, so that:
> 
> echo repair > .../sync_action would use the old heuristics
> 
> echo repair <mdoffset> <component N> > .../sync_action will update the chunk 
> on drive N which corresponds to the chunk/stripe at mdoffset within the MD 
> device, using the information from the other drives, and not the other way 
> around as might happen with just a repair.

Suspend the array, update the raw devices, then re-enable the array.
All from user-space.
No magic parsing of 'sync_action' input.

NeilBrown
