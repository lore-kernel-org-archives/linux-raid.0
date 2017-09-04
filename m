From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH] Monitor: Check redundancy for arrays
Date: Mon,  4 Sep 2017 12:52:46 +0200
Message-ID: <1504522366-21913-1-git-send-email-mariusz.tkaczyk@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
List-Id: linux-raid.ids

GET_MISMATCH option doesn't exist for RAID arrays without redundancy
so sysfs_read fails if this information is requested. Set options
according to the device using information from /proc/mdstat.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 Monitor.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 497e364..b60996b 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -466,7 +466,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	int new_array = 0;
 	int retval;
 	int is_container = 0;
-	unsigned long array_only_flags = 0;
+	unsigned long redundancy_only_flags = 0;
 
 	if (test)
 		alert("TestMessage", dev, NULL, ainfo);
@@ -504,11 +504,11 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	if (md_get_array_info(fd, &array) < 0)
 		goto disappeared;
 
-	if (!is_container)
-		array_only_flags |= GET_MISMATCH;
+	if (!is_container && map_name(pers, mse->level) > 0)
+		redundancy_only_flags |= GET_MISMATCH;
 
 	sra = sysfs_read(-1, st->devnm, GET_LEVEL | GET_DISKS | GET_DEVS |
-			GET_STATE | array_only_flags);
+			GET_STATE | redundancy_only_flags);
 
 	if (!sra)
 		goto disappeared;
-- 
1.8.3.1

