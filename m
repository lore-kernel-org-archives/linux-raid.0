From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 5/5] FIX: Do not configure and start, already started reshape
Date: Mon, 28 Feb 2011 16:07:35 +0100
Message-ID: <20110228150735.14670.87814.stgit@gklab-128-013.igk.intel.com>
References: <20110228145815.14670.56597.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110228145815.14670.56597.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When Grow_continue() calls reshape_array(), reshape is configured
and it is started with array together.
We cannot start it again.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/Grow.c b/Grow.c
index a5041de..47b8809 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1965,7 +1965,7 @@ started:
 		 * metadata, and for kernels before 2.6.38 we can
 		 * fail if we try.
 		 */
-	} else {
+	} else if (!restart) {
 		/* set them all just in case some old 'new_*' value
 		 * persists from some earlier problem.
 		 * We even set them when restarting in the middle.  They will
@@ -1995,13 +1995,18 @@ started:
 		}
 	}
 
-	err = start_reshape(sra, (info->reshape_active && !st->ss->external));
-	if (err) {
-		fprintf(stderr, Name ": Cannot start reshape for %s\n",
-			devname);
-		goto release;
-	}
-	if (restart)
+	/* if reshape is already started,
+	 * there is no need to do this again
+	 */
+	if (!restart) {
+		err = start_reshape(sra,
+				   (info->reshape_active && !st->ss->external));
+		if (err) {
+			fprintf(stderr, Name ": Cannot start reshape for %s\n",
+				devname);
+			goto release;
+		}
+	} else
 		sysfs_set_str(sra, NULL, "array_state", "active");
 
 	/* Now we just need to kick off the reshape and watch, while

