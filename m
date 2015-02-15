From: Chris <email.bug@arcor.de>
Subject: Re: re-add POLICY: conflict detection?
Date: Sun, 15 Feb 2015 19:03:37 +0000 (UTC)
Message-ID: <loom.20150215T193008-470@post.gmane.org>
References: <loom.20150214T222329-324@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


thinking about the "invalid argument" message...

with "action=re-add":
# mdadm --incremental /dev/loop2

 mdadm: can only add /dev/loop2 to /dev/md0 as a spare, and force-spare is
 not set.
 mdadm: failed to add /dev/loop2 to existing array /dev/md0: Invalid argument.


My guess is that mdadm may not be adding back the failed disk, because it is
unsure wether it may have run separately, and may have newer data on it?

I thought it may be possible to clearly distinguish between clean re-adds
and conflicts, by doing something like this:

* If a member fails (or is missing when starting degraded) write this info
into some failed_at_event_count field belonging to the failed member in the
superblock of every remaining raid member device in the array.

Now, if an array part that got unplugged reappears and still has the event
count that matches the failed_at_event_count that was recorded in the
superblocks of the still running disks, and the reappearing part's
superblock has no failed_at_event_count values for any member of the running
array, the reappearing part is ok to be automatically re-synced.

But if the reappearing disk claims a member of the already running array has
failed, or it reappeared with a different event count than its
faile_at_event_count field in the superblocks of the running array says, a
conflict has arisen and a sync may only be done with manual --force.

Cheers,
Chris






