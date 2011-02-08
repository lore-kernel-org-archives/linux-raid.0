From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 with rotating offsite disks for backup
Date: Tue, 8 Feb 2011 12:19:23 +1100
Message-ID: <20110208121923.5908630d@notabene.brown>
References: <1ADCC31C-C4BD-4D43-829F-9341D3663185@stanford.edu>
	<20110208111743.1479308d@notabene.brown>
	<CD05E25F-0580-4BDE-B4C7-041D15B9C73F@stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CD05E25F-0580-4BDE-B4C7-041D15B9C73F@stanford.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Klingner <klingner@stanford.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 7 Feb 2011 17:03:55 -0800 Jeff Klingner <klingner@stanford.edu> wrote:

> 
> On Feb 7, 2011, at 4:17 PM, NeilBrown wrote:
> 
> > On Mon, 7 Feb 2011 15:53:46 -0800 Jeff Klingner <klingner@stanford.edu> wrote:
> > 
> >> I'm planning a backup system for my home server and have run into a question I can't find answered in the mailing list archives or the wiki.  Here's the plan:
> >> 
> >> 1. Install system and valuable data on a 3-disk raid1 array (call the disks A, B, and C).
> >> 2. Remove disk C, put it offsite.  ("offsite" is moderately time-consuming to get to.)
> >> 3a. Periodically, remove disk B, take it offsite, and retrieve disk C
> >> 3b. Insert disk C, which will be re-synced to gain any changes made since it was removed.
> >> 4. Repeat steps 3a and 3b indefinitely, alternating the roles of disks B and C.
> >> 
> >> Thus I hope to get continuous protection against a single drive failure and protection back to the last offsite swap for corrupted or deleted data.
> >> 
> >> I saw in another list message the advice to use two stacked raid1s for this application: http://marc.info/?l=linux-raid&m=126761399008775&w=2
> >>> Also, if you want two rotating backups I would create two stacked raid1s.
> >>> 
> >>> mdadm -C /dev/md0 -l1 -n2 -b internal  /dev/main-device /dev/first-backup
> >>> mdadm -C /dev/md1 -l1 -n2 -b internal /dev/md0 /dev/second-backup
> >>> mkfs -j /dev/md1
> >> 
> >> 
> >> Are there important differences between the single 3-disk raid1 array I'm planning to use and this stacked configuration?
> > 
> > Yes.  The single 3-disk RAID1 array won't work, the stacked configuration
> > will.
> > 
> 
> Goodness, I'm glad I asked!  Thank you!  I've already done step 1.  Do you know if I can transition to the stacked configuration without erasing the disks?  That is, generally speaking, can I change the logical arrangement of the devices in raid1 array(s), then re-sync and keep the current (lvm) storage system built on top of the raid intact?
> 
> Jeff
> 
> 

I'm surprised that you found the correct advise, and chose not to follow
it .....


The array you will end up installing on is (slightly) smaller than than the
array you have created.  So no: you cannot re-arrange things - you have to
start again.


(well, to be honest, it is possible that you could resize whatever is on the
array and then build the secondary array and make it work.  But that path is
error-prone and this margin is not large enough to properly describe the
process).

NeilBrown
