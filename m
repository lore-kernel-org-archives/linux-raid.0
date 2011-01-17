From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH] Monitor: avoid adding too many spares to container
Date: Mon, 17 Jan 2011 10:06:10 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E96E13B@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 4a320a5fbaaa7044567036e2ecf89e980447c7e8 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Mon, 17 Jan 2011 10:47:50 +0100
Subject: [PATCH] Monitor: avoid adding too many spares to container
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

Tests revealed that sometimes there are still more spares taken
than needed. The reason for this is that after adding one spare
to container with degraded subarray
if between ioctl in main loop and load_container in try_spare_migration
mdmon activates the spare we see active<raid but find no spares in parent
container and so add an extra spare.

To prevent such behaviour we count active disks in the list returned
by getinfo_super_disks and compare it with subarray->active.
If the number has increased it means new spare was added and activated
so there is no need for more.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   33 ++++++++++++++++++++++++++++++---
 1 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 9e2a478..597e322 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -784,7 +784,7 @@ static dev_t choose_spare(struct state *from, struct state *to,
 
 static dev_t container_choose_spare(struct state *from, struct state *to,
 				    struct domainlist *domlist,
-				    unsigned long long min_size)
+				    unsigned long long min_size, int active)
 {
 	/* This is similar to choose_spare, but we cannot trust devstate,
 	 * so we need to read the metadata instead
@@ -807,6 +807,33 @@ static dev_t container_choose_spare(struct state *from, struct state *to,
 	if (err)
 		return 0;
 	
+	if (from == to) {
+		/* We must check if number of active disks has not increased
+		 * since ioctl in main loop. mdmon may have added spare
+		 * to subarray. If so we do not need to look for more spares
+		 * so return non zero value */
+		int active_cnt = 0;
+		struct mdinfo *dp;
+		list = st->ss->getinfo_super_disks(st);
+		if (!list) {
+			st->ss->free_super(st);
+			return 1;
+		}
+		dp = list->devs;
+		while (dp) {
+			if (dp->disk.state & (1<<MD_DISK_SYNC) &&
+			    !(dp->disk.state & (1<<MD_DISK_FAULTY)))
+				active_cnt++;
+			dp = dp->next;
+		}
+		sysfs_free(list);
+		if (active < active_cnt) {
+			/* Spare just activated.*/
+			st->ss->free_super(st);
+			return 1;
+		}
+	}
+
 	/* We only need one spare so full list not needed */
 	list = container_choose_spares(st, min_size, domlist, from->spare_group,
 				       to->metadata->ss->name, 1);
@@ -851,7 +878,7 @@ static void try_spare_migration(struct state *statelist, struct alert_info *info
 				 * no suitable spare in container already.
 				 * If there is we don't add more */
 				dev_t devid = container_choose_spare(
-					to, to, NULL, min_size);
+					to, to, NULL, min_size, st->active);
 				if (devid > 0)
 					continue;
 			}
@@ -874,7 +901,7 @@ static void try_spare_migration(struct state *statelist, struct alert_info *info
 					continue;
 				if (from->metadata->ss->external)
 					devid = container_choose_spare(
-						from, to, domlist, min_size);
+						from, to, domlist, min_size, 0);
 				else
 					devid = choose_spare(from, to, domlist,
 							     min_size);
-- 
1.7.1

