From: Jeff Klingner <klingner@stanford.edu>
Subject: raid1 with rotating offsite disks for backup
Date: Mon, 7 Feb 2011 15:53:46 -0800
Message-ID: <1ADCC31C-C4BD-4D43-829F-9341D3663185@stanford.edu>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm planning a backup system for my home server and have run into a question I can't find answered in the mailing list archives or the wiki.  Here's the plan:

1. Install system and valuable data on a 3-disk raid1 array (call the disks A, B, and C).
2. Remove disk C, put it offsite.  ("offsite" is moderately time-consuming to get to.)
3a. Periodically, remove disk B, take it offsite, and retrieve disk C
3b. Insert disk C, which will be re-synced to gain any changes made since it was removed.
4. Repeat steps 3a and 3b indefinitely, alternating the roles of disks B and C.

Thus I hope to get continuous protection against a single drive failure and protection back to the last offsite swap for corrupted or deleted data.

My questions are:

In step 3b, when a disk that was a member of the array in the past but has been removed for a while is re-inserted into the 3-disk array, how does the raid system know to update C with A's contents and not A with C's contents?  Is there a timestamp involved, and if so, how can I examine it before syncing?

Is it important to always rotate disks B and C, leaving one that never leaves the computer, or does it make no difference which of the two live disks I pluck out to swap with the offsite disk when I make the trip?  Can all three disks take turns offsite, so that they all have the same duty cycle?

I saw in another list message the advice to use two stacked raid1s for this application: http://marc.info/?l=linux-raid&m=126761399008775&w=2
> Also, if you want two rotating backups I would create two stacked raid1s.
> 
> mdadm -C /dev/md0 -l1 -n2 -b internal  /dev/main-device /dev/first-backup
> mdadm -C /dev/md1 -l1 -n2 -b internal /dev/md0 /dev/second-backup
> mkfs -j /dev/md1


Are there important differences between the single 3-disk raid1 array I'm planning to use and this stacked configuration?

Thanks for any help you can offer.

Jeff


