From: mwilck@arcor.de
Subject: [PATCH 09/10] mdmon: manage_member: fix race condition during slow meta data writes
Date: Tue, 30 Jul 2013 23:18:33 +0200
Message-ID: <1375219114-5626-10-git-send-email-mwilck@arcor.de>
References: <51F82D3B.6060104@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F82D3B.6060104@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

From: Martin Wilck <mwilck@arcor.de>

In order to track kernel state changes, the monitor needs to
notice changes in sysfs. If the changes are transient, and the
monitor is busy writing meta data, it can happen that the changes
are missed. This will cause the meta data to be inconsistent with
the real state of the array.

I can reproduce this in  a test scenario with a DDF container and
two subarrays, where I set a disk to "failed" and then add a global
hot-spare. On a typical MD test setup with loop devices, I can
reliably reproduce a failure where the metadata show degraded members
although the kernel finished the recovery successfully.

This patch fixes this problem by applying two changes. First, when
a metadata update is queued, wait until it is certain that the monitor
actually applied these meta data (the for loop is actually needed to
avoid failures completely in my test case). Second, after triggering the
recovery, set prev_state of the changed array to "recover", in case
the monitor misses the transient "recover" state.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 managemon.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/managemon.c b/managemon.c
index a655108..40c863f 100644
--- a/managemon.c
+++ b/managemon.c
@@ -535,8 +535,14 @@ static void manage_member(struct mdstat_ent *mdstat,
 		}
 		queue_metadata_update(updates);
 		updates = NULL;
+		while (update_queue_pending || update_queue) {
+			check_update_queue(container);
+			usleep(15*1000);
+		}
 		replace_array(container, a, newa);
-		sysfs_set_str(&a->info, NULL, "sync_action", "recover");
+		if (sysfs_set_str(&a->info, NULL, "sync_action", "recover")
+		    == 0)
+			newa->prev_action = recover;
 		dprintf("%s: recovery started on %s\n", __func__,
 			a->info.sys_name);
  out:
-- 
1.7.1
