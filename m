From: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Subject: [PATCH 5/6] Display size with human_size_brief with a chosen prefix
Date: Wed, 26 Sep 2012 13:44:15 +0200
Message-ID: <20120926114415.328.68023.stgit@gklab-128-174.igk.intel.com>
References: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

When using human_size_brief, only IEC prefixes were supported. Now
it's possible to specify which format we want to see - either IEC
(kibi, mibi, gibi) or JEDEC (kilo, mega, giga).

Signed-off-by: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
---
 Query.c |    2 +-
 mdadm.h |    7 ++++++-
 util.c  |   36 +++++++++++++++++++++++++++---------
 3 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/Query.c b/Query.c
index b9c209f..329e583 100644
--- a/Query.c
+++ b/Query.c
@@ -76,7 +76,7 @@ int Query(char *dev)
 	else {
 		printf("%s: %s %s %d devices, %d spare%s. Use mdadm --detail for more detail.\n",
 		       dev,
-		       human_size_brief(larray_size),
+		       human_size_brief(larray_size,IEC),
 		       map_num(pers, array.level),
 		       array.raid_disks,
 		       array.spare_disks, array.spare_disks==1?"":"s");
diff --git a/mdadm.h b/mdadm.h
index e27275b..a24b803 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -329,6 +329,11 @@ enum special_options {
 	ControllerPath,
 };
 
+enum prefix_standard {
+	JEDEC,
+	IEC
+};
+
 /* structures read from config file */
 /* List of mddevice names and identifiers
  * Identifiers can be:
@@ -1242,7 +1247,7 @@ extern int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info);
 unsigned long long min_recovery_start(struct mdinfo *array);
 
 extern char *human_size(long long bytes);
-extern char *human_size_brief(long long bytes);
+extern char *human_size_brief(long long bytes, int prefix);
 extern void print_r10_layout(int layout);
 
 #define NoMdDev (1<<23)
diff --git a/util.c b/util.c
index 09971a2..cb97816 100644
--- a/util.c
+++ b/util.c
@@ -682,7 +682,7 @@ char *human_size(long long bytes)
 	return buf;
 }
 
-char *human_size_brief(long long bytes)
+char *human_size_brief(long long bytes, int prefix)
 {
 	static char buf[30];
 
@@ -693,19 +693,37 @@ char *human_size_brief(long long bytes)
 	 * gigabytes, as that shows more precision and isn't
 	 * too large a number.
 	 * Terabytes are not yet handled.
+	 *
+	 * If prefix == IEC, we mean prefixes like kibi,mebi,gibi etc.
+	 * If prefix == JEDEC, we mean prefixes like kilo,mega,giga etc.
 	 */
 
 	if (bytes < 5000*1024)
 		buf[0] = 0;
-	else if (bytes < 2*1024LL*1024LL*1024LL) {
-		long cMiB = (bytes / ( (1LL<<20) / 200LL ) +1) /2;
-		snprintf(buf, sizeof(buf), " (%ld.%02ldMiB)",
-			cMiB/100 , cMiB % 100);
-	} else {
-		long cGiB = (bytes / ( (1LL<<30) / 200LL ) +1) /2;
-		snprintf(buf, sizeof(buf), " (%ld.%02ldGiB)",
-				cGiB/100 , cGiB % 100);
+	else if (prefix == IEC) {
+		if (bytes < 2*1024LL*1024LL*1024LL) {
+			long cMiB = (bytes / ( (1LL<<20) / 200LL ) +1) /2;
+			snprintf(buf, sizeof(buf), "%ld.%02ldMiB",
+				cMiB/100 , cMiB % 100);
+		} else {
+			long cGiB = (bytes / ( (1LL<<30) / 200LL ) +1) /2;
+			snprintf(buf, sizeof(buf), "%ld.%02ldGiB",
+					cGiB/100 , cGiB % 100);
+		}
+	}
+	else if (prefix == JEDEC) {
+		if (bytes < 2*1024LL*1024LL*1024LL) {
+			long cMB  = (bytes / ( 1000000LL / 200LL ) +1) /2;
+			snprintf(buf, sizeof(buf), "%ld.%02ldMB",
+					cMB/100, cMB % 100);
+		} else {
+			long cGB  = (bytes / (1000000000LL/200LL ) +1) /2;
+			snprintf(buf, sizeof(buf), "%ld.%02ldGB",
+					cGB/100 , cGB % 100);
+		}
 	}
+	else
+		buf[0] = 0;
 
 	return buf;
 }

