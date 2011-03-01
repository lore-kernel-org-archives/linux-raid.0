From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/7] FIX: configure disks slot for expansion
Date: Tue, 01 Mar 2011 15:57:06 +0100
Message-ID: <20110301145706.10678.63966.stgit@gklab-128-013.igk.intel.com>
References: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Some raid_disks that are used for expansion, are not configured yet.
This is due to earlier set raid_disks limitation.
Set raid_disks to new (bigger) value and finish disks slot configuration.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 6aff049..fa3a0a6 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1586,9 +1586,22 @@ int assemble_container_content(struct supertype *st, int mdfd,
 					chosen_name, working + preexist);
 			if (preexist)
 				fprintf(stderr, " (%d new)", working);
-			if (expansion)
+			if (expansion) {
 				fprintf(stderr, " ( + %d for expansion)",
 					expansion);
+			sysfs_set_num(content, NULL, "raid_disks",
+				      content->array.raid_disks + expansion);
+			for (dev = content->devs; dev; dev = dev->next)
+				if (dev->disk.raid_disk >=
+				    content->array.raid_disks) {
+					int rv;
+					dprintf("\n\tExpansion: configure slot:"
+						"%i", dev->disk.raid_disk);
+					rv = sysfs_set_num(content, dev, "slot",
+							   dev->disk.raid_disk);
+					dprintf(" (status = %i)\n", rv);
+				}
+			}
 			fprintf(stderr, "\n");
 		}
 		if (!err)

