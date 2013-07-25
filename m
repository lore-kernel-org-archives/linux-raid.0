From: mwilck@arcor.de
Subject: [PATCH 3/4] DDF: ddf_activate_spare: only activate good drives
Date: Thu, 25 Jul 2013 20:59:12 +0200
Message-ID: <1374778753-6252-4-git-send-email-mwilck@arcor.de>
References: <1374778753-6252-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374778753-6252-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Do not try to activate drives marked missing or failed.
---
 super-ddf.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 13a2e61..ae1222c 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4773,6 +4773,13 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 	/* For each slot, if it is not working, find a spare */
 	dl = ddf->dlist;
 	for (i = 0; i < a->info.array.raid_disks; i++) {
+		be16 state = ddf->phys->entries[dl->pdnum].state;
+		if (be16_and(state,
+			     cpu_to_be16(DDF_Failed|DDF_Missing)) ||
+		    !be16_and(state,
+			      cpu_to_be16(DDF_Online)))
+			continue;
+
 		for (d = a->info.devs ; d ; d = d->next)
 			if (d->disk.raid_disk == i)
 				break;
-- 
1.7.1
