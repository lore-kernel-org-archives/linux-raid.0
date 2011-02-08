From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 with rotating offsite disks for backup
Date: Tue, 8 Feb 2011 11:17:43 +1100
Message-ID: <20110208111743.1479308d@notabene.brown>
References: <1ADCC31C-C4BD-4D43-829F-9341D3663185@stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1ADCC31C-C4BD-4D43-829F-9341D3663185@stanford.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Klingner <klingner@stanford.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 7 Feb 2011 15:53:46 -0800 Jeff Klingner <klingner@stanford.edu> wrote:

> I'm planning a backup system for my home server and have run into a question I can't find answered in the mailing list archives or the wiki.  Here's the plan:
> 
> 1. Install system and valuable data on a 3-disk raid1 array (call the disks A, B, and C).
> 2. Remove disk C, put it offsite.  ("offsite" is moderately time-consuming to get to.)
> 3a. Periodically, remove disk B, take it offsite, and retrieve disk C
> 3b. Insert disk C, which will be re-synced to gain any changes made since it was removed.
> 4. Repeat steps 3a and 3b indefinitely, alternating the roles of disks B and C.
> 
> Thus I hope to get continuous protection against a single drive failure and protection back to the last offsite swap for corrupted or deleted data.
> 
> My questions are:
> 
> In step 3b, when a disk that was a member of the array in the past but has been removed for a while is re-inserted into the 3-disk array, how does the raid system know to update C with A's contents and not A with C's contents?  Is there a timestamp involved, and if so, how can I examine it before syncing?
> 
> Is it important to always rotate disks B and C, leaving one that never leaves the computer, or does it make no difference which of the two live disks I pluck out to swap with the offsite disk when I make the trip?  Can all three disks take turns offsite, so that they all have the same duty cycle?
> 
> I saw in another list message the advice to use two stacked raid1s for this application: http://marc.info/?l=linux-raid&m=126761399008775&w=2
> > Also, if you want two rotating backups I would create two stacked raid1s.
> > 
> > mdadm -C /dev/md0 -l1 -n2 -b internal  /dev/main-device /dev/first-backup
> > mdadm -C /dev/md1 -l1 -n2 -b internal /dev/md0 /dev/second-backup
> > mkfs -j /dev/md1
> 
> 
> Are there important differences between the single 3-disk raid1 array I'm planning to use and this stacked configuration?

Yes.  The single 3-disk RAID1 array won't work, the stacked configuration
will.


md can resync 'just the changed blocks' by using the 'write intent bitmap'
and event counters.
However it only clears the bits in the bitmap when the array is not degraded.
In your suggestion the 3-drive RAID1 is always degraded so bits are never
cleared, so each resync is effectively a complete resync.

In the stacked configuration there are two bitmaps so md can track of
different differences on two different devices.

You can see the event counts on each device with

  mdadm --examine /dev/A

The bitmap knows whether a device is new enough to be safely recovered based
on the bitmap by storing the event count of the time a bit was cleared 
'Events Cleared'.

Hope that helps.

NeilBrown

