From: Martin Cracauer <cracauer@cons.org>
Subject: Re: raid1 with rotating offsite disks for backup
Date: Mon, 7 Feb 2011 22:04:17 -0500
Message-ID: <20110208030417.GA65865@cons.org>
References: <1ADCC31C-C4BD-4D43-829F-9341D3663185@stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1ADCC31C-C4BD-4D43-829F-9341D3663185@stanford.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Klingner <klingner@stanford.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Klingner wrote on Mon, Feb 07, 2011 at 03:53:46PM -0800: 
> I'm planning a backup system for my home server and have run into a question I can't find answered in the mailing list archives or the wiki.  Here's the plan:
> 
> 1. Install system and valuable data on a 3-disk raid1 array (call the disks A, B, and C).
> 2. Remove disk C, put it offsite.  ("offsite" is moderately time-consuming to get to.)
> 3a. Periodically, remove disk B, take it offsite, and retrieve disk C
> 3b. Insert disk C, which will be re-synced to gain any changes made since it was removed.
> 4. Repeat steps 3a and 3b indefinitely, alternating the roles of disks B and C.
> 
> Thus I hope to get continuous protection against a single drive failure and protection back to the last offsite swap for corrupted or deleted data.

You are aware that this will only work reliably if at the point of
time when you remove the disk the filesystem(s) on it are one of:
- mounted readonly
- unmounted
- machine is off

Linux doesn't really have a `umount -f`, so the first two options only
work if you can get rid of all processes that might want to hold on to
the filesystem at the time when you want to remove your disk.  A
possible hack is going through a NFS mount which does support forceful
operations on the filesystem in Linux.

As has been pointed out, you don't gain much from the added
complexity.  If you would just rsync to one of the spare drives you
would only copy over what actually changed, and not do a full re-sync
of all blocks.  And that works fine with the source filesystem being
mounted read-write.

Another problem is that you are temporarily screwed if disk A dies
while re-syncing B, since C isn't with you, A is hosed and B is
half-synced.

What you do lose is that the raid1 based solution would keep the new
disk up-to-date with then-new file disk writes.  But the problem with
filesystem status is hard to solve.  Overall going 4 disks with raid1
local and having two disks that are rsynced on demand is what I would
do.

Martin
-- 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Martin Cracauer <cracauer@cons.org>   http://www.cons.org/cracauer/
