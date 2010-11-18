From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 06/13] Grow: fix check for raid6 layout normalization
Date: Thu, 18 Nov 2010 10:22:09 +0100
Message-ID: <20101118092209.29508.12528.stgit@gklab-170-111.igk.intel.com>
References: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

If the user does not specify a layout, don't skip asking about retaining
the non-standard raid6 layout which may be implicitly changed.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Grow.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Grow.c b/Grow.c
index f16228d..bf634d3 100644
--- a/Grow.c
+++ b/Grow.c
@@ -706,9 +706,9 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 
 	/* ========= set shape (chunk_size / layout / ndisks)  ============== */
 	/* Check if layout change is a no-op */
-	if (layout_str) switch(array.level) {
+	switch(array.level) {
 	case 5:
-		if (array.layout == map_name(r5layout, layout_str))
+		if (layout_str && array.layout == map_name(r5layout, layout_str))
 			layout_str = NULL;
 		break;
 	case 6:
@@ -724,8 +724,9 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			rv = 1;
 			goto release;
 		}
-		if (strcmp(layout_str, "normalise") == 0 ||
-		    strcmp(layout_str, "normalize") == 0) {
+		if (layout_str &&
+		    (strcmp(layout_str, "normalise") == 0 ||
+		     strcmp(layout_str, "normalize") == 0)) {
 			char *hyphen;
 			strcpy(alt_layout, map_num(r6layout, array.layout));
 			hyphen = strrchr(alt_layout, '-');
@@ -735,7 +736,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			}
 		}
 
-		if (array.layout == map_name(r6layout, layout_str))
+		if (layout_str && array.layout == map_name(r6layout, layout_str))
 			layout_str = NULL;
 		if (layout_str && strcmp(layout_str, "preserve") == 0)
 			layout_str = NULL;

