From: Neil Brown <neilb@suse.de>
Subject: Re: mismatch_cnt worries
Date: Tue, 3 Apr 2007 10:00:52 +1000
Message-ID: <17937.39220.736583.474597@notabene.brown>
References: <20070402144509.GB21405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gavin McCullagh on Monday April 2
Sender: linux-raid-owner@vger.kernel.org
To: Gavin McCullagh <gmccullagh@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday April 2, gmccullagh@gmail.com wrote:
> 
> Neil's post here suggests either this is all normal or I'm seriously up the
> creek.
> 	http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07349.html
> 
> My questions:
> 
> 1. Should I be worried or is this normal?  If so can you explain why the
>    number is non-zero?

Probably not too worried.
Is it normal?  I'm not really sure what 'normal' is.  I'm beginning to
think that it is 'normal' to get strange errors from disk drives, by
maybe I have a jaded perspective.
If you have a swap-partition or a swap-file on the device then you
should consider it normal.  If not, then it is much less likely but
still possible.

> 2. Should I repair, fsck, replace a disk, something else?

'repair' is probably a good idea.
'fsck' certainly wouldn't hurt and might show something, though I
suspect it will find the filesystem to be structurally sound.
I wouldn't replace the disk on the basis on a single difference report
from mismatch_cnt.  I don't know what the SMART message means so I
don't know if that suggests that the drive needs to be replaced.

> 3. Can someone explain how this quote can be true:
>        "Though it is less likely, a regular filesystem could still (I think)
>         genuinely write different data to difference devices in a raid1/10."
>    when I thought the point of RAID1 was that the data should be the same on
>    both disks.

Suppose I memory-map a file and often modify the mapped memory.
The system will at some point decide to write that block of the file
to the device.  It will send a request to raid1, which will send one
request each to two different devices.  They will each DMA the data
out of that memory to the controller at different times so they could
quite possibly get different data (if I changed the mapped memory
between those two DMA request).  So the data on the two drives in a
mirror can easily be different.  If a 'check' happens at exactly this
time it will notice.
Normally that block will be written out again (as it is still 'dirty')
and again and again if necessary as long as I keep writing to the
memory.  Once I stop writing to the memory (e.g. close the file,
unmount the filesystem) a final write will be made with the same data
going to both devices.  During this time we will never read that block
from the filesystem, so the filesystem will never be able to see any
difference between the two devices in a raid1.

So: if you are actively writing to a file while 'check' is running on
a raid1, it could show up as a difference in mismatch_cnt.  But you
have to get the timing just right (or wrong).

I think it is possible in the above scenario to truncate the file
while a write is underway but with new data in memory.  If you do
this, the system might not write out that last 'new' data, so the last
write to the particular block on storage may have written different
data to the two different drives, and this difference will not be
corrected by the filesystem e.g on unmount.  Note that the inconsistent
data will never be read by the filesystem (the file has been
truncated, remember) so there is no risk of data corruption.
In this case the difference could remain for some time until later
when a 'check' or 'repair' notices it.

Does that help explain the above quote?

It is still the case that:
  filesystem corruption won't happen in normal operation
  a small mismatch_cnt does not necessarily imply a problem.

NeilBrown
