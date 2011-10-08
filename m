From: Wakko Warner <wakko@animx.eu.org>
Subject: Thought about delayed sync
Date: Sat, 8 Oct 2011 14:03:10 -0400
Message-ID: <20111008180309.GA14979@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A few days ago, I thought about creating raid arrays w/o syncing.  I
understand why sync is needed.  Please correct me if I'm wrong in any of my
statements.

Currently, if someone uses large disks (1tb or larger), the initial sync can
take a long time and until it has completed, the array isn't fully
protected.  I noted on a raid1 of a pair of 1tb disks took hours to complete
when there was no activity.

Here is my thought.  There is already a bitmap to indicate which blocks are
dirty.  Thus by using that, a drop of a disk (accidental or intentional), a
resync only syncs those blocks that the bitmap knows were dirtied.

What if another bitmap could be utilized.  This would be an "in use" bitmap. 
The purpose of this could be that there would never be an initial sync. 
When data is written to an area that has not been synced, a sync will happen
of that region.  Once the sync is complete, that region will be marked as
synced in the bitmap.  Only the parts that have been written to will be
synced.  The other data is of no consequence.  As with the current bitmap,
this would have to be asked for.

Lets say someone has been using this array for some time and a disk dropped
out and had to be replaced.  Lets also say that the actual usage was about
25-30% of the array (of course, that would be wasted space).  With the "in
use" bitmap, they would replace the disk and only the areas that had been
written to would be resynced over to the new disk.  The rest, since it had
not been used, would not need to be.

A side effect of this would be that a check or a resync could use this to
check the real data (IE on a weekly basis) and take less time.

Over all, depending on the usage, this can keep the wear and tear on a disk
down.  I'm speaking of personal experience with my systems.  I have arrays
that are not 100% or even 80% used.  I have some production servers that
have extra space for expansion and not fully used.

I'm sure this would take some time to implement if someone does this.  As I
mentioned at the beginning, this was just a thought, but I think it could
benefit people if it were implemented.

I am on the list, but feel free to keep me in the CC.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
