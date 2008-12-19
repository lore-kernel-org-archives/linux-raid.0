From: Neil Brown <neilb@suse.de>
Subject: Re: Growing RAID1 array with bitmaps enabled
Date: Fri, 19 Dec 2008 15:54:33 +1100
Message-ID: <18763.10505.701483.494901@notabene.brown>
References: <20081219040730.GA6402@atlantis.cc.ndsu.NoDak.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bryan Mesich on Thursday December 18
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Mesich <bryan.mesich@ndsu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 18, bryan.mesich@ndsu.edu wrote:
> Good evening to all,
> 
> I'm looking at growing a RAID1 array from 40GB to 100GB.  The
> array has a write-intent bitmap enabled, but an email from Neil 
> in August suggests that I should disable the bitmap when 
> growing the array. Here's a bit of the email Neil sent to the 
> list:
> 
> >We cannot currently change the size of a write-intent bitmap.
> >So if we change the size of an array which has such a bitmap, it
> >tries to set bits beyond the end of the bitmap.
> >
> >For now, simply reject any request to change the size of an array
> >which has a bitmap.  mdadm can remove the bitmap and add a new
> >one after the array has changed size.
> >
> [snip...]
> 
> A couple questions I have:
> 
> 1) Does the superblock increase in size when the array is grown 
> to make room for a larger bitmap?  (This doesn't seem possible 
> to me, particularly if using a v1.1 or v1.2 superblock).

The bitmap does not live in the superblock.  It lives near the
superblock.
For 0.90, the superblock is 4K in size, and lives at least 60K from
the end of the device.  The bitmap lives in that 60K.

For 1.0, the superblock is 1K in size and lives between 8K and 12K
from the end of the device.  There is usually some space reserved
before the superblock which is not used for data.  The bitmap lives in
one of these spaces.

For 1.1 and 1.2, the superblock is 1K in size and lives near the start
of the device.  There is usually some space reserved after the
superblock and before the data.  The bitmap is stored there.


> 
> or...
> 
> 2) Is the problem mentioned in Neil's email in regard to a
> "restructuring" of the bitmap to accommodate a larger array (i.e. 
> We only have "x" amount of room on the superblock, so re-divide 
> the array into chucks that we can fit into the superblock)?

Yes.  Sometimes.

When you add a bitmap to an array, mdadm has a look to see what space
is available and uses the space the best it can.  So when you grow an
array, the bitmap that gets added afterwards might use a different
chunk-size than the bitmap that you had before.

So the size of the bitmap will probably change and the chunksize of
the bitmap will possibly change.

> 
> In my use case, the block devices that compose the RAID1 array
> are fibre channel SAN volumes.  When I grow them to 100GB on the 
> FC target, the additional 60GB is appended to the end of the
> exported block device.  My out-of-sync data will still be present 
> on the first 40GB.
> 
> With this in mind (and the adage that patches are welcome), has there 
> been any interest in being able to use a write-intent bitmap for this 
> kind of use case?  The benefit of this functionality would keep me 
> from eating two _full_ re-syncs on the array when growing the block 
> devices.

I think you misunderstand.  There is no need for a full resync.
You simply

  mdadm --grow /dev/md0 --bitmap none
  mdadm --grow /dev/md0 --size max
  mdadm --wait /dev/md0
  mdadm --grow /dev/md0 --bitmap internal

The "--wait" will wait while the array syncs the data from 40GB to
100GB.

This does leave you with a window when there is no bitmap, so a crash
will require a resync.  So it is not ideal.
But it certainly isn't as bad as two full resyncs.

NeilBrown

> 
> 
> Thanks in advance,
> 
> Bryan
