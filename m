From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] imsm: make messages more understandable
Date: Fri, 16 Dec 2011 15:04:53 +0100
Message-ID: <20111216140452.20625.63109.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The printed messages should be more appropriate and understandable
for user. If maxsize is equal 0, this means there is no free space left
on device. If size is greater than maxsize, this means there is not enough
space to create a new volume of given size.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 3c10d29..3990d58 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5466,9 +5466,16 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 	}
 
 	if (maxsize < size || maxsize == 0) {
-		if (verbose)
-			fprintf(stderr, Name ": not enough space after merge (%llu < %llu)\n",
-				maxsize, size);
+		if (verbose) {
+			if (maxsize == 0)
+				fprintf(stderr, Name ": no free space"
+						" left on device. Aborting...\n");
+			else
+				fprintf(stderr, Name ": not enough space"
+						" to create volume of given size"
+						" (%llu < %llu). Aborting...\n",
+						maxsize, size);
+		}
 		return 0;
 	}
 

