From: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Subject: [PATCH] Fix RAID metadata check
Date: Wed, 14 Sep 2016 12:43:31 +0200
Message-ID: <1473849811-29110-1-git-send-email-mariusz.dabrowski@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com, maksymilian.kunt@intel.com, tomasz.majchrzak@intel.com, Mariusz Dabrowski <mariusz.dabrowski@intel.com>
List-Id: linux-raid.ids

mdadm recognizes devices with partition table as part of an RAID array
and invalid warning message is displayed. After this fix proper warning
messages are being displayed for MBR/GPT disks and devices with RAID
metadata.

Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
---
 util.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/util.c b/util.c
index c38ede7..5c845a0 100644
--- a/util.c
+++ b/util.c
@@ -710,17 +710,23 @@ int check_raid(int fd, char *name)
 
 	if (!st)
 		return 0;
-	st->ss->load_super(st, fd, name);
-	/* Looks like a raid array .. */
-	pr_err("%s appears to be part of a raid array:\n",
-		name);
-	st->ss->getinfo_super(st, &info, NULL);
-	st->ss->free_super(st);
-	crtime = info.array.ctime;
-	level = map_num(pers, info.array.level);
-	if (!level) level = "-unknown-";
-	cont_err("level=%s devices=%d ctime=%s",
-		 level, info.array.raid_disks, ctime(&crtime));
+	if (st->ss->add_to_super != NULL) {
+		st->ss->load_super(st, fd, name);
+		/* Looks like a raid array .. */
+		pr_err("%s appears to be part of a raid array:\n",
+			name);
+		st->ss->getinfo_super(st, &info, NULL);
+		st->ss->free_super(st);
+		crtime = info.array.ctime;
+		level = map_num(pers, info.array.level);
+		if (!level) level = "-unknown-";
+		cont_err("level=%s devices=%d ctime=%s",
+		level, info.array.raid_disks, ctime(&crtime));
+	}
+	else {
+		/* Looks like GPT or MBR */
+		pr_err("partition table exists on %s\n", name);
+	}
 	return 1;
 }
 
-- 
1.8.3.1

