From: mwilck@arcor.de
Subject: [PATCH 08/10] mdmon: manage_member: debug messages for array state
Date: Tue, 30 Jul 2013 23:18:32 +0200
Message-ID: <1375219114-5626-9-git-send-email-mwilck@arcor.de>
References: <51F82D3B.6060104@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F82D3B.6060104@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

From: Martin Wilck <mwilck@arcor.de>

Add debug messages to watch the manager's steps.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 managemon.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/managemon.c b/managemon.c
index f50f954..a655108 100644
--- a/managemon.c
+++ b/managemon.c
@@ -518,6 +518,7 @@ static void manage_member(struct mdstat_ent *mdstat,
 		/* prevent the kernel from activating the disk(s) before we
 		 * finish adding them
 		 */
+		dprintf("%s: freezing %s\n", __func__,  a->info.sys_name);
 		sysfs_set_str(&a->info, NULL, "sync_action", "frozen");
 
 		/* Add device to array and set offset/size/slot.
@@ -536,6 +537,8 @@ static void manage_member(struct mdstat_ent *mdstat,
 		updates = NULL;
 		replace_array(container, a, newa);
 		sysfs_set_str(&a->info, NULL, "sync_action", "recover");
+		dprintf("%s: recovery started on %s\n", __func__,
+			a->info.sys_name);
  out:
 		while (newdev) {
 			d = newdev->next;
-- 
1.7.1
