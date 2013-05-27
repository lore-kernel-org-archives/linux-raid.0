From: Matt Garman <matthew.garman@gmail.com>
Subject: mdadm vs zfs for home server?
Date: Mon, 27 May 2013 13:09:12 -0500
Message-ID: <20130527180912.GA6068@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Anyone out there have a home (or maybe small office) file server
that where they thought about native Linux software RAID (mdadm)
versus ZFS on Linux?

I currently have a raid6 array built from five low power (5400 rpm)
3TB drives.  I put an ext4 filesystem right on top of the md device
(no lvm).  This array used to be comprised of 2TB drives; I've been
slowly replacing drives with 3TB versions as they went on sale.

I run a weekly check on the array ("raid-check" script on CentOS,
which is basically a fancy wrapper for "echo check >>
/sys/block/mdX/md/sync_action").  I shouldn't be surprised, but I've
noticed that this check now takes substantially longer (than it did
with the 2TB drives).

I got to thinking about the chances of data loss.  First off: I do
have backups.  But I want to take every "reasonable" precaution
against having to use the backups.  Initially I started thinking
about zfs's raid-z3 (basically, triple-parity raid, the next logical
step in the raid5, raid6 progression).  But then I decided that,
based on the check speed of my current raid6, maybe I want to get
away from parity-based raid all together.

Now I've got another 3TB drive on the way (rounding out the total to
six) and am leaning towards RAID-10.  I don't need the performance,
but it should be more performant than raid6.  And I assume (though I
could be very wrong) that the weekly "check" action ought to be much
faster than it is with raid6.  Is this correct?

But after all that zfs reading, I'm wondering if that might not be
the way to go.  I don't know how necessary it is, but I like the
idea of having the in-filesystem checksums to prevent "silent" data
corruption.

I went through a zfs tutorial, building a little raid10 pool out of
files (just to play with).  Seems pretty straightforward.  But I'm
still much more familiar with mdadm (not an expert by any means, but
quite comfortable with typical uses).  So, does my lack of
experience with zfs offset it's data integrity checks?  And
furthermore, zfs on linux has only recently been marked stable.
Although there is plenty of anecdotal comments that it's been stable
much longer (the zfs on linux guys are just ultra-conservative).
Still, doesn't mdadm have the considerable edge in terms of
"longtime stability"?

As I said initially, I'm in the thinking-it-through stage, just
looking to maybe get a discussion going as to why I should go one
way or the other.

Thanks,
Matt

