From: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Subject: [PATCH 4/6] Synchronize size calculation in human_size and
 human_size_brief
Date: Wed, 26 Sep 2012 13:44:08 +0200
Message-ID: <20120926114408.328.96284.stgit@gklab-128-174.igk.intel.com>
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

It would be better if two size-calculating methods had the same
calculating algorithm. The human_size way of calculation seems
more readable, so let's use it for both methods.

Signed-off-by: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
---
 util.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/util.c b/util.c
index c63a232..09971a2 100644
--- a/util.c
+++ b/util.c
@@ -686,20 +686,27 @@ char *human_size_brief(long long bytes)
 {
 	static char buf[30];
 
+	/* We convert bytes to either centi-M{ega,ibi}bytes or
+	 * centi-G{igi,ibi}bytes, with appropriate rounding,
+	 * and then print 1/100th of those as a decimal.
+	 * We allow upto 2048Megabytes before converting to
+	 * gigabytes, as that shows more precision and isn't
+	 * too large a number.
+	 * Terabytes are not yet handled.
+	 */
+
 	if (bytes < 5000*1024)
-		snprintf(buf, sizeof(buf), "%ld.%02ldKiB",
-			(long)(bytes>>10), (long)(((bytes&1023)*100+512)/1024)
-			);
-	else if (bytes < 2*1024LL*1024LL*1024LL)
-		snprintf(buf, sizeof(buf), "%ld.%02ldMiB",
-			(long)(bytes>>20),
-			(long)((bytes&0xfffff)+0x100000/200)/(0x100000/100)
-			);
-	else
-		snprintf(buf, sizeof(buf), "%ld.%02ldGiB",
-			(long)(bytes>>30),
-			(long)(((bytes>>10)&0xfffff)+0x100000/200)/(0x100000/100)
-			);
+		buf[0] = 0;
+	else if (bytes < 2*1024LL*1024LL*1024LL) {
+		long cMiB = (bytes / ( (1LL<<20) / 200LL ) +1) /2;
+		snprintf(buf, sizeof(buf), " (%ld.%02ldMiB)",
+			cMiB/100 , cMiB % 100);
+	} else {
+		long cGiB = (bytes / ( (1LL<<30) / 200LL ) +1) /2;
+		snprintf(buf, sizeof(buf), " (%ld.%02ldGiB)",
+				cGiB/100 , cGiB % 100);
+	}
+
 	return buf;
 }
 

