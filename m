From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: Thought about delayed sync
Date: Sun, 9 Oct 2011 08:04:07 -0400
Message-ID: <20111009120407.GB25344@animx.eu.org>
References: <20111008180309.GA14979@animx.eu.org>
 <201110081600.44112.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201110081600.44112.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Fjellstrom wrote:
> On October 8, 2011, Wakko Warner wrote:
> > A few days ago, I thought about creating raid arrays w/o syncing.  I
> > understand why sync is needed.  Please correct me if I'm wrong in any of my
> > statements.
> > 
> > Currently, if someone uses large disks (1tb or larger), the initial sync
> > can take a long time and until it has completed, the array isn't fully
> > protected.  I noted on a raid1 of a pair of 1tb disks took hours to
> > complete when there was no activity.
> > 
> > Here is my thought.  There is already a bitmap to indicate which blocks are
> > dirty.  Thus by using that, a drop of a disk (accidental or intentional), a
> > resync only syncs those blocks that the bitmap knows were dirtied.
> > 
> > What if another bitmap could be utilized.  This would be an "in use"
> > bitmap. The purpose of this could be that there would never be an initial
> > sync. When data is written to an area that has not been synced, a sync
> > will happen of that region.  Once the sync is complete, that region will
> > be marked as synced in the bitmap.  Only the parts that have been written
> > to will be synced.  The other data is of no consequence.  As with the
> > current bitmap, this would have to be asked for.
> > 
> > Lets say someone has been using this array for some time and a disk dropped
> > out and had to be replaced.  Lets also say that the actual usage was about
> > 25-30% of the array (of course, that would be wasted space).  With the "in
> > use" bitmap, they would replace the disk and only the areas that had been
> > written to would be resynced over to the new disk.  The rest, since it had
> > not been used, would not need to be.
> > 
> > A side effect of this would be that a check or a resync could use this to
> > check the real data (IE on a weekly basis) and take less time.
> > 
> > Over all, depending on the usage, this can keep the wear and tear on a disk
> > down.  I'm speaking of personal experience with my systems.  I have arrays
> > that are not 100% or even 80% used.  I have some production servers that
> > have extra space for expansion and not fully used.
> > 
> > I'm sure this would take some time to implement if someone does this.  As I
> > mentioned at the beginning, this was just a thought, but I think it could
> > benefit people if it were implemented.
> > 
> > I am on the list, but feel free to keep me in the CC.
> 
> I think theres at least one, probably fatal problem with that idea. There is 
> currently no reliable way for md to tell which areas are actually in use. That 
> is, once a section is written to the first time, it will stay in use, even if 
> it isn't. "Now what about TRIM?" you ask? Not all file systems support it, and 
> I /think/ (based on a quick search of the list) mdraid doesn't fully support 
> TRIM either. LVM may not either. (a quick search also suggested lvm2 doesn't 
> pass on trim properly/at-all).

Actually, I was completely aware of this before I wrote my thought to the
list.  I don't know exactly how it could be told.  I thought about a program
that could read lvm data and tell MD what blocks are not in use.  It could
go further and attempt to read the filesystem.  TRIM is a nice idea, but as
you alread mentioned, not all filesystems support it and not all layers
support passing it.

> I've been using the current bitmap support on my raid5 array for some time, 
> and it has made the few resync's that were needed, very fast compared to a 
> full resync. Instead of 15+ hours, they finished in 20 minutes or less. I call 
> that a win.

Try this instead.  Create a raid5 (or 6) on 4 2tb drives.  Add about 100gb
of data to it and replace one of the disks with a fresh disk.  You'll notice
you have to resync the entire array.  The current bitmap only tells which
blocks have changed and a resync of an existing member is quick.  But a new
member has no known in sync blocks and has to resync the whole thing.  I
know, I already had this happen to me last month.

On another note, I used this feature to clean the dust out of my disk array
in another system.  Fail a drive, read the array to verify which drive I
physically failed, remove it, clean the dust off, add it back, wait for
resync to complete and then do another disk.  Resync on that was quick for
the 750gb member.  Without a bitmap, resync time on that system is 3 hours.

Thanks for your input though.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
