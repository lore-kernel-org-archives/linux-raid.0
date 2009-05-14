From: Neil Brown <neilb@suse.de>
Subject: Re: Requesting replace mode for changing a disk
Date: Thu, 14 May 2009 22:00:09 +1000
Message-ID: <18956.1993.913926.331043@notabene.brown>
References: <20090513012112681.IEFQ19662@cdptpa-omta02.mail.rr.com>
	<87zldhvg0v.fsf@frosties.localdomain>
	<18954.20061.109627.591832@notabene.brown>
	<4A0BF5F1.7040804@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Thursday May 14
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, lrhorer@satx.rr.com, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday May 14, david@dgreaves.com wrote:
> Neil Brown wrote:
> > The one problem with this approach is that if there is a read error on
> > /dev/suspect while data is being copied to /dev/new, you lose.
> > 
> > Hence the requested functionality which I do hope to implement for
> > raid456 and raid10 (it adds no value to raid1).
> > Maybe by the end of this year... it is on the roadmap.
> 
> Neil,
> If you have ideas about how this should be accomplished then outlining them may
> provide a reasonable starting point for those new to the code; especially  if
> there are any steps that you may clearly see that would help others to make a start.

As I said in some other email recently, I think an important precursor
to this hot-replace functionality is to support a per-device bad-block
list.  This allows a device to remain in an array even if a few blocks
have failed - only individual stripes will be degraded.
Then the hot-replace function can be used on only on drives that are
threatening bad blocks, but also on drives that have actually
delivered bad blocks.

The procedure for effecting a hot-replace would then be:
 - swap the suspect device for a no-metadata raid1 containing just
   the suspect device (it's not clear to me yet exactly how this
   will be managed but I have some ideas)
 - add the new device to the raid1
 - enable an in-memory bad-block list for the raid1
 - allow a recovery that just recovers the data part of the
   suspect device, not the metadata.  Any read errors will simply add
   to the bad block list
 - For each entry in this suspect drive's bad-block-list, trigger
   a resync of just that block in the top-level array.  This involves
   setting up 'low' and 'high' values via sysfs and writing 'repair'
   to sync_action.
   This should clear the entry from the bad block list.
 - once the bad block list is clear ... sort out the metadata some
   how, and swap the new device in place of the raid1.

Getting the metadata right is the awkward bit.  When the main array
writes metadata to the raid1, I don't want it to go the new drive
until the new drive actually have fully up-to-date data.
The only way I can think at the moment to make it work is to build a 
raid1 from just the data parts of the two devices, and use a linear
array to combine that with the metadata parts of the suspect device
and give the linear array to the main device.  That would work, but it
seems rather ugly, so I'm not convinced

Anyway, the first step is getting a bad-block-list working.

Below are some notes I wrote a while ago when someone else was showing
interest in a bad block list.  Nothing has come of that yet.
It envisages the BBL being associated with an 'externally managed
metadata' array.  For this purpose, I would want it also to work for
"no metadata" array, and possible for 1.x arrays with the kernel
writing the BBL to the device (maybe).

-------------------
I envisage these changes to the kernel:
 1/ store a BBL with each rdev, and make it available for read/write
    through a sysfs file (or two).
    It would probably be stored as an RB-tree or similar,  The
    assumption is that the log would normally be very small and
    sparse. 

 2/ any READ request against a block that is listed in the BBL returns
    a failure (or is detected by read-balancing and causes a different
    device to be chosen).

 3/ any WRITE request against a block in the BBL is attempted and if
    it succeeds, the block is removed from the BBL.

 4/ When recovery gets a read failure, it adds the block to the BBL
    rather than trying to write it.
    Adding a block to the BBL causes the sysfs file to report as
    'urgent-readable' to 'poll' (POLLPRI) thus allowing userspace to
    find the new bad blocks and add them to the list on stable storage.

 5/ When a write error causes a drive to be marked as
    'failed/blocked', userspace can either unblock and remove it (as
    currently) or update the BBL with the offending blocks and
    re-enable the drive.

One difficulty is how to present the BBL through sysfs.
A sysfs file is limited to 4096 characters and we may want the BBL to
be large enough to exceed that.
I have an idea that entries in the BBL can be either 'acknowledged' or
'unacknowledged'.  Then the sysfs file lists the unacknowledged blocks
first.  userspace can write to the sysfs file to acknowledge blocks,
which then allows other blocks to appear in the file.

To read all the entries in the BBL, we could write a message that
means "mark all entries and unacknowledged", then read and acknowledge
until everything has been read.

Alternately we could have a second file into which we can write the
address of the smallest block that we want to read from the main file.
 
I'm assuming that the BBL would allow a granularity of 512 byte sectors.  
-----------------------------------------------

The 'bbl' would be a library of code that each raid personality can
choose to make use, much like the bitmap.c code.

I think that implementing bbl.c should be a reasonably manageable
project for someone with reasonable coding skills but minimal
knowledge of md.  It would involve
  - creating and maintaining the in-memory bbl
  - providing access to it via sysfs
  - providing appropriate interface routines for md/raidX to call.

We would then need to define a way to enable a bbl on a given device.
I imagine the one sysfs file would serve.
  The file '/sys/block/mdX/md/dev-foo/bbl'
  initially reads a 'none'
  If you write 'clear' to it, and empty bbl is created
  If you write "+sector address", that address is added to it.
    If it was already present, it gets 'acknowledged'.
  If you write "-sector address", that address is removed
  If you write "flush" (??) all entries get un-acknowleged
  If you read, you get all the un-acknowleged address, in order, then
   all the acknowledged addresses.

It would be important that this does not slow IO down.  So lookups
should be fast. 
In most cases the list will be empty.  In that case, the lookup must be
extremely fast (definitely no locking)

Is that enough to get you started :-)

NeilBrown
