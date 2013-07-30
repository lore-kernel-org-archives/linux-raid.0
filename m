From: mwilck@arcor.de
Subject: [PATCH 01/10] DDF: ddf_activate_spare: bugfix for 62ff3c40
Date: Tue, 30 Jul 2013 23:18:25 +0200
Message-ID: <1375219114-5626-2-git-send-email-mwilck@arcor.de>
References: <51F82D3B.6060104@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F82D3B.6060104@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

From: Martin Wilck <mwilck@arcor.de>

Move the check for good drives in the dl loop - otherwise dl
may be NULL and mdmon may crash.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 683f969..46262ce 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4774,13 +4774,6 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 	/* For each slot, if it is not working, find a spare */
 	dl = ddf->dlist;
 	for (i = 0; i < a->info.array.raid_disks; i++) {
-		be16 state = ddf->phys->entries[dl->pdnum].state;
-		if (be16_and(state,
-			     cpu_to_be16(DDF_Failed|DDF_Missing)) ||
-		    !be16_and(state,
-			      cpu_to_be16(DDF_Online)))
-			continue;
-
 		for (d = a->info.devs ; d ; d = d->next)
 			if (d->disk.raid_disk == i)
 				break;
@@ -4798,6 +4791,13 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 			int is_dedicated = 0;
 			struct extent *ex;
 			unsigned int j;
+			be16 state = ddf->phys->entries[dl->pdnum].state;
+			if (be16_and(state,
+				     cpu_to_be16(DDF_Failed|DDF_Missing)) ||
+			    !be16_and(state,
+				      cpu_to_be16(DDF_Online)))
+				continue;
+
 			/* If in this array, skip */
 			for (d2 = a->info.devs ; d2 ; d2 = d2->next)
 				if (d2->state_fd >= 0 &&
-- 
1.7.1
