From: Neil Brown <neilb@suse.de>
Subject: Re: Spare drive won't spin down
Date: Tue, 18 May 2010 10:20:17 +1000
Message-ID: <20100518102017.51fef799@notabene.brown>
References: <922812.29139.qm@web31703.mail.mud.yahoo.com>
	<20100507162034.1370d645@notabene.brown>
	<717013.48748.qm@web31703.mail.mud.yahoo.com>
	<20100507194704.3ffcf17e@notabene.brown>
	<4BE83B75.8050709@tmr.com>
	<20100512065318.44e934d4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100512065318.44e934d4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, Joe Bryant <tenminjoe@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 12 May 2010 06:53:18 +1000
Neil Brown <neilb@suse.de> wrote:

> Theoretically, when the spares are one behind the active array and we need to
> update them all, we should update the spares first, then the rest.  If we
> don't and there is a crash at the wrong time, some spares could be 2 events
> behind the most recent device.  However that is a fairly unlikely race to
> lose and the cost is only having a spare device fall out of the array, which
> is quite easy to put back it, that I might not worry to much about it.
> 
> So if you haven't seen a patch to fix this in a week or two, please remind me.
> 

This is the sort of thing I was thinking of.
Comments?

Thanks,
NeilBrown

From bf7399c0f1e95e8af30f93114f96fcc73cb0d7c6 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 18 May 2010 09:28:43 +1000
Subject: [PATCH] md: simplify updating of event count to sometimes avoid updating spares.

When updating the event count for a simple clean <-> dirty transition,
we try to avoid updating the spares so they can safely spin-down.
As the event_counts across an array must be +/- 1, this means
decrementing the event_count on a dirty->clean transition.
This is not always safe and we have to avoid the unsafe time.
We current do this with a misguided idea about it being safe or
not depending on whether the event_count is odd or even.  This
approach only works reliably in a few common instances, but easily
falls down.

So instead, simply keep internal state concerning whether it is safe
or not, and always assume it is not safe when an array is first
assembled.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fec4abc..9ef21d9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2088,7 +2088,6 @@ static void sync_sbs(mddev_t * mddev, int nospares)
 		if (rdev->sb_events == mddev->events ||
 		    (nospares &&
 		     rdev->raid_disk < 0 &&
-		     (rdev->sb_events&1)==0 &&
 		     rdev->sb_events+1 == mddev->events)) {
 			/* Don't update this superblock */
 			rdev->sb_loaded = 2;
@@ -2141,28 +2140,14 @@ repeat:
 	 * and 'events' is odd, we can roll back to the previous clean state */
 	if (nospares
 	    && (mddev->in_sync && mddev->recovery_cp == MaxSector)
-	    && (mddev->events & 1)
-	    && mddev->events != 1)
+	    && mddev->can_decrease_events
+	    && mddev->events != 1) {
 		mddev->events--;
-	else {
+		mddev->can_decrease_events = 0;
+	} else {
 		/* otherwise we have to go forward and ... */
 		mddev->events ++;
-		if (!mddev->in_sync || mddev->recovery_cp != MaxSector) { /* not clean */
-			/* .. if the array isn't clean, an 'even' event must also go
-			 * to spares. */
-			if ((mddev->events&1)==0) {
-				nospares = 0;
-				sync_req = 2; /* force a second update to get the
-					       * even/odd in sync */
-			}
-		} else {
-			/* otherwise an 'odd' event must go to spares */
-			if ((mddev->events&1)) {
-				nospares = 0;
-				sync_req = 2; /* force a second update to get the
-					       * even/odd in sync */
-			}
-		}
+		mddev->can_decrease_events = nospares;
 	}
 
 	if (!mddev->events) {
@@ -4606,6 +4591,7 @@ static void md_clean(mddev_t *mddev)
 	mddev->layout = 0;
 	mddev->max_disks = 0;
 	mddev->events = 0;
+	mddev->can_decrease_events = 0;
 	mddev->delta_disks = 0;
 	mddev->new_level = LEVEL_NONE;
 	mddev->new_layout = 0;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a536f54..7ab5ea1 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -150,6 +150,12 @@ struct mddev_s
 	int				external_size; /* size managed
 							* externally */
 	__u64				events;
+	/* If the last 'event' was simply a clean->dirty transition, and
+	 * we didn't write it to the spares, then it is safe and simple
+	 * to just decrement the event count on a dirty->clean transition.
+	 * So we record that possibility here.
+	 */
+	int				can_decrease_events;
 
 	char				uuid[16];
 
