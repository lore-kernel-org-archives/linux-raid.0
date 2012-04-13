From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 08/14] FIX: Respect metadata size limitations
Date: Fri, 13 Apr 2012 16:52:02 +0200
Message-ID: <1334328728-12544-9-git-send-email-adam.kwolek@intel.com>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-4-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-5-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-6-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-7-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-8-git-send-email-adam.kwolek@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-8-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

When reshape_super() updates metadata with new size, due to some metadata
limitations saved value can be different than requested value by user.
Update size (read it from metadata) for setting it in md.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Grow.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index e8f6554..86d1020 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1637,6 +1637,27 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			goto release;
 		}
 		sync_metadata(st);
+		if (st->ss->external) {
+			/* metadata can have size limitation
+			 * update size value according to metadata information
+			 */
+			struct mdinfo *sizeinfo =
+				st->ss->container_content(st, subarray);
+			if (sizeinfo) {
+				unsigned long long new_size =
+					sizeinfo->custom_array_size/2;
+				int data_disks = get_data_disks(
+						sizeinfo->array.level,
+						sizeinfo->array.layout,
+						sizeinfo->array.raid_disks);
+				new_size /= data_disks;
+				dprintf("Metadata size correction from %llu to "
+					"%llu (%llu)\n", orig_size, new_size,
+					new_size * data_disks);
+				size = new_size;
+				sysfs_free(sizeinfo);
+			}
+		}
 
 		/* Update the size of each member device in case
 		 * they have been resized.  This will never reduce
-- 
1.6.4.2

