From: Chris Dunlop <chris@onthe.net.au>
Subject: Safe disk replace
Date: Tue, 4 Sep 2012 14:14:47 +1000
Message-ID: <20120904041447.GB14445@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

G'day,

What is the best way to replace a fully-functional or minimally-failing
(e.g. occasional bad sectors) disk in a live array whilst maintaining as
much redundancy as possible during the process?

It seems the standard way to replace a disk is to fail out the unwanted
disk, add the new disk, then wait for the array to rebuild. However this
means during the rebuild you've lost some or all of your redundancy,
depending on the raid level of the array. This can be a significant issue,
e.g. if you're replacing a 4 TB disk it could mean 10 to 20 hours or much
more of heightened risk, depending on the rebuild bandwidth available.

Another way would be to add in the new disk and grow the array, wait for
the rebuild, then fail out and remove the old disk, shrink the array, and
again wait for the rebuild. However once again you lose (some of) your
redundancy from the time you've failed the old disk till the rebuild
completes; again, potentially many hours. Unless there's some way of
telling md to shrink the array off the unwanted device before removing it,
and md is smart enough to retain full redundancy during the process?

Another way might be to fail out the old drive, create a raid-1 between
the old and new drives whilst doing some dance with dd and the original
raid metadata and the new raid-1 metadata to make it appear the raid-1 was
the original raid member, "re-add" the raid-1 device to the original raid,
wait for the rebuild of both the raid-1 and the original raid, fail out
the raid-1, do a reverse dd dance to make the new disk look like a primary
member of the original raid, then "re-add" the new disk into the original
raid. This would mean you only lose redundancy for the windows where the
original raid has a failed-out member, i.e. seconds, if done properly.

Is this method possible and, if sufficient care is taken, sensible?

If it's possible, is this something that could or should be built into md
to automate the process and perhaps reduce or completely eliminate the
window of reduced redundancy?

...or, indeed, is this something that's already built into md and I need
to do some significant self-flagellation with the clue bat?

Cheers,

Chris.
