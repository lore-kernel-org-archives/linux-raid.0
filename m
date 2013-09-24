From: mwilck@arcor.de
Subject: [PATCH] Monitor: write meta data in readonly state, sometimes
Date: Tue, 24 Sep 2013 20:53:18 +0200
Message-ID: <1380048798-31699-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This patch reverts 24a216bf:
"Monitor: Don't write metadata in inactive array state".

While it's true that writing meta data is usually not necessary
in readonly state, there is one important exception: if a
disk goes faulty, we want to record that, even if the array is
inactive.

We might as well just revert 24a216bf, because with the recently
submitted patch
"Monitor: don't set arrays dirty after transition to read-only"
those meta data writes that really annoying (for a clean, readonly,
healthy array during startup) are gone anyway.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 monitor.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/monitor.c b/monitor.c
index 3b57ed0..f81e707 100644
--- a/monitor.c
+++ b/monitor.c
@@ -421,8 +421,7 @@ static int read_and_act(struct active_array *a)
 	if (sync_completed > a->last_checkpoint)
 		a->last_checkpoint = sync_completed;
 
-	if (deactivate || a->curr_state >= clean)
-		a->container->ss->sync_metadata(a->container);
+	a->container->ss->sync_metadata(a->container);
 	dprintf("%s(%d): state:%s action:%s next(", __func__, a->info.container_member,
 		array_states[a->curr_state], sync_actions[a->curr_action]);
 
-- 
1.7.3.4
