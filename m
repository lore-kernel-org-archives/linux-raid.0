From: Erik Berg <erikberg@digitalgarden.no>
Subject: [PATCH] Monitor: Allow taking spare from rebuilding array
Date: Wed, 25 Oct 2017 12:37:39 +0200
Message-ID: <eddc14d2-8210-a73d-d879-7d709de4fde1@digitalgarden.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When you have a box with 60 8TB drives, 8 RAID6 sets and 12 spares
assigned to the first set, and the first set has a failed disk and is
rebuilding, spares aren't given to other sets with failing disks.
Waiting 2-3 days for a rebuild to complete before giving out spares to
other failing sets seems excessive.
---
 Monitor.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index b60996b..b1178fd 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -781,14 +781,41 @@ static int check_donor(struct state *from, struct state *to)
 		 */
 		if (sub->active < sub->raid)
 			return 0;
-	if (from->metadata->ss->external == 0)
-		if (from->active < from->raid)
-			return 0;
 	if (from->spare <= 0)
 		return 0;
 	return 1;
 }
 
+int spare_rebuilding(struct state *dev)
+{
+	mdu_disk_info_t disk;
+	mdu_array_info_t array;
+
+	int fd = open(dev->devname, O_RDONLY);
+	if (fd < 0) {
+		pr_err("cannot open %s: %s\n",
+			dev->devname, strerror(errno));
+		return 1;
+	}
+
+	md_get_disk_info(fd, &disk);
+	md_get_array_info(fd, &array);
+
+	close(fd);
+
+	if ((disk.state &
+	     ((1 << MD_DISK_ACTIVE) | (1 << MD_DISK_SYNC) |
+	      (1 << MD_DISK_REMOVED) | (1 << MD_DISK_FAULTY) |
+	      (1 << MD_DISK_JOURNAL))) == 0) {
+
+		if (disk.raid_disk < array.raid_disks &&
+		    disk.raid_disk >= 0)
+			return 1;
+	}
+
+	return 0;
+}
+
 static dev_t choose_spare(struct state *from, struct state *to,
 			  struct domainlist *domlist, struct spare_criteria *sc)
 {
@@ -821,7 +848,8 @@ static dev_t choose_spare(struct state *from, struct state *to,
 				pol_add(&pol, pol_domain,
 					from->spare_group, NULL);
 			if (domain_test(domlist, pol,
-					to->metadata->ss->name) == 1)
+					to->metadata->ss->name) == 1 &&
+			    !spare_rebuilding(from))
 			    dev = from->devid[d];
 			dev_policy_free(pol);
 		}
-- 
2.14.1
