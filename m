From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 5/6] Remove code for non re-striping operations.
Date: Wed, 12 Jan 2011 17:01:32 +0100
Message-ID: <20110112160132.18013.92612.stgit@gklab-128-111.igk.intel.com>
References: <20110112155905.18013.73701.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112155905.18013.73701.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Neil,
How was your intention when you add this part of code?
I can't find the case when it will be necessary.
Moreover it breaks flow for takeover operations because
ioctl not succeeded when more than one parameter is changed.
I've remove this code temporally to be able test takeover
operations.
We can restore this code after we decide what it should do.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Grow.c |   43 +++++--------------------------------------
 1 files changed, 5 insertions(+), 38 deletions(-)

diff --git a/Grow.c b/Grow.c
index 253f289..6835f34 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1666,6 +1666,11 @@ static int reshape_array(char *container, int fd, char *devname,
 		ping_monitor(container);
 	}
 
+	if (reshape.backup_blocks == 0) {
+		/* If operation not not reuire re-striping we can finish */
+		return rv;
+	}
+
 	/* ->reshape_super might have chosen some spares from the
 	 * container that it wants to be part of the new array.
 	 * We can collect them with ->container_content and give
@@ -1692,44 +1697,6 @@ static int reshape_array(char *container, int fd, char *devname,
 		}
 	}
 
-	if (reshape.backup_blocks == 0) {
-		/* No restriping needed, but we might need to impose
-		 * some more changes: layout, raid_disks, chunk_size
-		 */
-		if (info->new_layout != UnSet &&
-		    info->new_layout != info->array.layout) {
-			info->array.layout = info->new_layout;
-			if (ioctl(fd, SET_ARRAY_INFO, &info->array) != 0) {
-				fprintf(stderr, Name ": failed to set new layout\n");
-				rv = 1;
-			} else if (!quiet)
-				printf("layout for %s set to %d\n",
-				       devname, info->array.layout);
-		}
-		if (info->delta_disks != UnSet &&
-		    info->delta_disks != 0) {
-			info->array.raid_disks += info->delta_disks;
-			if (ioctl(fd, SET_ARRAY_INFO, &info->array) != 0) {
-				fprintf(stderr, Name ": failed to set raid disks\n");
-				rv = 1;
-			} else if (!quiet)
-				printf("raid_disks for %s set to %d\n",
-				       devname, info->array.raid_disks);
-		}
-		if (info->new_chunk != 0 &&
-		    info->new_chunk != info->array.chunk_size) {
-			if (sysfs_set_num(info, NULL,
-					  "chunk_size", info->new_chunk) != 0) {
-				fprintf(stderr, Name ": failed to set chunk size\n");
-				rv = 1;
-			} else if (!quiet)
-				printf("chunk size for %s set to %d\n",
-				       devname, info->array.chunk_size);
-		}
-
-		return rv;
-	}
-
 	/*
 	 * There are three possibilities.
 	 * 1/ The array will shrink.

