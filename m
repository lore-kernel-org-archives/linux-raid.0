From: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Subject: "failed" vs "removed" or "locked-out" state and --incremental auto-re-adding
Date: Fri, 23 Apr 2010 12:20:40 +0000 (UTC)
Message-ID: <loom.20100423T140059-877@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi all,

I hope you can help in sorting out the different states unused
devices can be in, and the commands used to change states.

It seems we don't have an obvious way to manually
remove a member from an array so that it does not get auto-assembled
later on (i.e. by udev/--incremental) without completely zeroing the
superblock or moving it into an own array. Maybe a --lock-out
option would make sense here? (Recognizable maybe by a superblock marking itself
as "removed"?)
Locking-out members would be handy to keep snapshots without the need to unplug
the drives to make sure they don't get re-added. And we would need such a
lock-out possibility if someone would like to implement automatically locking
out segments with conflicting changes/alternative versions (after incidences
when they are both connected).


Another thing is that trying to --remove without prior --failing gives a rather
unintuitive "device busy":
Is there a reason that --remove (and --lock-out)
shouldn't just automatically "fail" a device?
Or the other way around when would one want to
manually --fail a member without subsequently --removing it?

Kind Regards,
Christian

