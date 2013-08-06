From: mwilck@arcor.de
Subject: [PATCH 9/9] Create: set array status to frozen until monitoring starts
Date: Tue,  6 Aug 2013 23:38:03 +0200
Message-ID: <1375825083-7856-5-git-send-email-mwilck@arcor.de>
References: <52016A06.8070400@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52016A06.8070400@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

When we create an array while mdmon is working on an event
(e.g. disk failure), the meta data on disk may not be up-to-date.

Patch "DDF: ddf_open_new: check device status for new subarray"
added some checks for in the monitor for that situation - in particular,
to handle a freshly created array with faulty disks. The remaining
problem is that the kernel may start syncing the disks before this
situation is detected. This patch delays recovery until mdmon finished
checking.

tests/10ddf-fail-create-race should succeed reliably with this patch
and "DDF: ddf_open_new: check device status for new subarray". Without,
it will fail sporadically.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 Create.c    |    8 ++++++++
 managemon.c |    6 ++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Create.c b/Create.c
index ac22f77..f9b7db2 100644
--- a/Create.c
+++ b/Create.c
@@ -993,6 +993,14 @@ int Create(struct supertype *st, char *mddev,
 				need_mdmon = 0;
 				break;
 			default:
+				/*
+				 * The meta data we saw on disk may not be
+				 * up-to-date. The monitor will check and
+				 * possibly fail. Avoid a resync happening
+				 * in the kernel before that.
+				 */
+				sysfs_set_str(&info, NULL, "sync_action",
+					      "frozen");
 				err = sysfs_set_str(&info, NULL, "array_state",
 						    "readonly");
 				break;
diff --git a/managemon.c b/managemon.c
index f40bbdb..5bc54da 100644
--- a/managemon.c
+++ b/managemon.c
@@ -744,6 +744,12 @@ static void manage_new(struct mdstat_ent *mdstat,
 		new->container = NULL;
 		free_aa(new);
 	} else {
+		/*
+		 * Create() set this to frozen.
+		 * This relies on the kernel clear FROZEN status
+		 * if an invalid value is written to sync_action.
+		 */
+		sysfs_set_str(&new->info, NULL, "sync_action", "");
 		replace_array(container, victim, new);
 		if (failed) {
 			new->check_degraded = 1;
-- 
1.7.1
