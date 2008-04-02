From: Mike Snitzer <snitzer@gmail.com>
Subject: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
Date: Wed,  2 Apr 2008 18:09:15 -0400
Message-ID: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763229AbYDBWJj@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paul.clements@steeleye.com, neilb@suse.de
List-Id: linux-raid.ids

resync via bitmap if faulty's events+1 == bitmap's events_cleared

For more background please see:
http://marc.info/?l=linux-raid&m=120703208715865&w=2

Without this change validate_super() will prevent the previously faulty
member from recovering via bitmap, e.g.:

 md: nbd0 rdev's ev1 (30080) < mddev->bitmap->events_cleared (30081)... rdev->raid_disk=-1
 md: nbd1 rdev's ev1 (30342) < mddev->bitmap->events_cleared (30343)... rdev->raid_disk=-1
 md: nbd0 rdev's ev1 (30186) < mddev->bitmap->events_cleared (30187)... rdev->raid_disk=-1
 md: nbd0 rdev's ev1 (30286) < mddev->bitmap->events_cleared (30287)... rdev->raid_disk=-1
 md: nbd1 rdev's ev1 (30476) < mddev->bitmap->events_cleared (30477)... rdev->raid_disk=-1
 md: nbd0 rdev's ev1 (30488) < mddev->bitmap->events_cleared (30489)... rdev->raid_disk=-1
 md: nbd1 rdev's ev1 (30680) < mddev->bitmap->events_cleared (30681)... rdev->raid_disk=-1
 md: nbd0 rdev's ev1 (31082) < mddev->bitmap->events_cleared (31083)... rdev->raid_disk=-1
 md: nbd1 rdev's ev1 (31264) < mddev->bitmap->events_cleared (31265)... rdev->raid_disk=-1
 md: nbd0 rdev's ev1 (31108) < mddev->bitmap->events_cleared (31109)... rdev->raid_disk=-1
 md: nbd0 rdev's ev1 (31126) < mddev->bitmap->events_cleared (31127)... rdev->raid_disk=-1
 md: nbd1 rdev's ev1 (31416) < mddev->bitmap->events_cleared (31417)... rdev->raid_disk=-1
 md: nbd1 rdev's ev1 (31432) < mddev->bitmap->events_cleared (31433)... rdev->raid_disk=-1
 md: nbd0 rdev's ev1 (31274) < mddev->bitmap->events_cleared (31275)... rdev->raid_disk=-1
 md: nbd1 rdev's ev1 (31448) < mddev->bitmap->events_cleared (31449)... rdev->raid_disk=-1
 md: nbd1 rdev's ev1 (31494) < mddev->bitmap->events_cleared (31495)... rdev->raid_disk=-1
 md: nbd1 rdev's ev1 (31512) < mddev->bitmap->events_cleared (31513)... rdev->raid_disk=-1

Note that 'mddev->bitmap->events_cleared' is _always_ odd and the
previously faulty member's 'ev1' (aka events) is _always_ even.  The
current validate_super() logic is blind to clean-to-dirty events
transitions and as such it imposes, potentially expensive, full resyncs.

This change makes the bitmap's 'events_cleared' logic more nuanced than
that which is documented in include/linux/raid/bitmap.h:

 * (2) This event counter [events_cleared] is updated when the other one
 *    [events] is *if*and*only*if* the array is not degraded.  As bits are
 *    not cleared when the array is degraded, this represents the last
 *    time that any bits were cleared.  If a device is being added that
 *    has an event count with this value or higher, it is accepted as
 *    conforming to the bitmap.

But the question becomes: is the proposed change safe?

Considerable testing seems to indicate that it is.  But I welcome any
other suggestions for how to prevent such unnecessary full resyncs.
---
 drivers/md/md.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 61ccbd2..43425e4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -839,8 +839,16 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 	} else if (mddev->bitmap) {
 		/* if adding to array with a bitmap, then we can accept an
 		 * older device ... but not too old.
+		 *
+		 * if 'mddev->bitmap->events_cleared' is odd it implies a clean-to-dirty
+		 * transition occurred just before the array became degraded
+		 * - if rdev's on-disk 'events' is just one less (aka even) this
+		 *   dirty transition wasn't recorded; allow use of the bitmap to
+		 *   efficiently resync to this member
 		 */
-		if (ev1 < mddev->bitmap->events_cleared)
+		if (ev1 < mddev->bitmap->events_cleared &&
+		    !(mddev->degraded && (mddev->bitmap->events_cleared & 1) &&
+		      (ev1+1 == mddev->bitmap->events_cleared)))
 			return 0;
 	} else {
 		if (ev1 < mddev->events)
@@ -1214,8 +1222,16 @@ static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 	} else if (mddev->bitmap) {
 		/* If adding to array with a bitmap, then we can accept an
 		 * older device, but not too old.
+		 *
+		 * if 'mddev->bitmap->events_cleared' is odd it implies a clean-to-dirty
+		 * transition likely occurred just before the array became degraded
+		 * - if rdev's on-disk 'events' is just one less (aka even) this
+		 *   dirty transition wasn't recorded; allow use of the bitmap to
+		 *   efficiently resync to this member
 		 */
-		if (ev1 < mddev->bitmap->events_cleared)
+		if (ev1 < mddev->bitmap->events_cleared &&
+		    !(mddev->degraded && (mddev->bitmap->events_cleared & 1) &&
+		      (ev1+1 == mddev->bitmap->events_cleared)))
 			return 0;
 	} else {
 		if (ev1 < mddev->events)
-- 
1.5.3.5
