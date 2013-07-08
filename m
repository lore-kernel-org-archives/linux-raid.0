From: mwilck@arcor.de
Subject: [PATCH 29/39] Monitor: Don't write metadata in inactive array state
Date: Mon,  8 Jul 2013 23:50:38 +0200
Message-ID: <1373320248-7520-3-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

The kernel docs state that meta data is never written in states
clear, inactive, suspended, readonly, and read_auto.
Why should this be different for containers?

We need to write metadata when the array is disabled, though.
Tested with the DDF (10*) and IMSM (9*) tests, works.
---
 monitor.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/monitor.c b/monitor.c
index 47432b2..67b40b1 100644
--- a/monitor.c
+++ b/monitor.c
@@ -416,7 +416,8 @@ static int read_and_act(struct active_array *a)
 	if (sync_completed > a->last_checkpoint)
 		a->last_checkpoint = sync_completed;
 
-	a->container->ss->sync_metadata(a->container);
+	if (deactivate || a->curr_state >= clean)
+		a->container->ss->sync_metadata(a->container);
 	dprintf("%s(%d): state:%s action:%s next(", __func__, a->info.container_member,
 		array_states[a->curr_state], sync_actions[a->curr_action]);
 
-- 
1.7.1
