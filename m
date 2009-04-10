From: Neil Brown <neilb@suse.de>
Subject: Re: Any benefity to write intent bitmaps on Raid1
Date: Fri, 10 Apr 2009 19:04:19 +1000
Message-ID: <18911.2963.478861.845896@notabene.brown>
References: <45635.60.234.49.2.1239236645.squirrel@webmail.stevencherie.net>
	<18909.36541.447308.778177@notabene.brown>
	<87myaqfily.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Goswin von Brederlow on Thursday April 9
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Steven Ellis <steven@openmedia.co.nz>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday April 9, goswin-v-b@web.de wrote:
> Neil Brown <neilb@suse.de> writes:
> 
> > (*) I've been wondering about adding another bitmap which would record
> > which sections of the array have valid data.  Initially nothing would
> > be valid and so wouldn't need recovery.  Every time we write to a new
> > section we add that section to the 'valid' sections and make sure that
> > section is in-sync.
> > When a device was replaced, we would only need to recover the parts of
> > the array that are known to be invalid.
> > As filesystem start using the new "invalidate" command for block
> > devices, we could clear bits for sections that the filesystem says are
> > not needed any more...
> > But currently it is just a vague idea.
> >
> > NeilBrown
> 
> If you are up for experimenting I would go for a completly new
> approach. Instead of working with physical blocks and marking where
> blocks are used and out of sync how about adding a mapping layer on
> the device and using virtual blocks. You reduce the reported disk size
> by maybe 1% to always have some spare blocks and initialy all blocks
> will be unmapped (unused). Then whenever there is a write you pick out
> an unused block, write to it and change the in memory mapping of the
> logical to physical block. Every X seconds, on a barrier or an sync
> you commit the mapping from memory to disk in such a way that it is
> synchronized between all disks in the raid. So every commited mapping
> represents a valid raid set. After the commit of the mapping all
> blocks changed between the mapping and the last can be marked as free
> again. Better use the second last so there are always 2 valid mappings
> to choose from after a crash.
> 
> This would obviously need a lot more space than a bitmap but space is
> (relatively) cheap. One benefit imho should be that sync/barrier would
> not have to stop all activity on the raid to wait for the sync/barrier
> to finish. It just has to finalize the mapping for the commit and then
> can start a new in memory mapping while the finalized one writes to
> disk.

While there is obviously real value in this functionality, I can't
help thinking that it belongs in the file system, not the block
device.

But then I've always seen logical volume management as an interim hack
until filesystems were able to span multiple volumes in a sensible
way.  As time goes on it seems less and less 'interim'.

I may well implement a filesystem that has this sort of
functionality.  I'm very unlikely to implement it in the md layer.
But you never know what will happen...

Thanks for the thoughts.

NeilBrown
