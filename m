From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 4] md: Make sure the events count in an md array never returns to zero.
Date: Tue, 23 Jan 2007 11:26:56 +1100
Message-ID: <1070123002656.29477@suse.de>
References: <20070123112437.29357.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932603AbXAWA1m@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Now that we sometimes step the array events count backwards
(when transitioning dirty->clean where nothing else interesting
has happened - so that we don't need to write to spares all the time),
it is possible for the event count to return to zero, which is
potentially confusing and triggers and MD_BUG.

We could possibly remove the MD_BUG, but is just as easy, and
probably safer, to make sure we never return to zero.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-01-23 11:13:44.000000000 +1100
+++ ./drivers/md/md.c	2007-01-23 11:23:58.000000000 +1100
@@ -1633,7 +1633,8 @@ repeat:
 	 * and 'events' is odd, we can roll back to the previous clean state */
 	if (nospares
 	    && (mddev->in_sync && mddev->recovery_cp == MaxSector)
-	    && (mddev->events & 1))
+	    && (mddev->events & 1)
+	    && mddev->events != 1)
 		mddev->events--;
 	else {
 		/* otherwise we have to go forward and ... */
