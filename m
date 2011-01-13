From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/6] FIX: continue raid0 reshape
Date: Thu, 13 Jan 2011 15:50:18 +0100
Message-ID: <20110113145018.12728.49048.stgit@gklab-128-013.igk.intel.com>
References: <20110113144252.12728.82642.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113144252.12728.82642.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

In case when second array is raid0 array, mdmon will not start reshape
for it because this array is not monitored.
To resolve this situation, all reshaped devices are collected in to list.
If nothing is found for reshape (no arrays with reshape_active flag),
already reshaped list is searched and checked if everything
is reshaped. If we find that raid0 array is not reshaped we are continuing
reshape for this device.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index a765308..fadaf2d 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2056,6 +2056,7 @@ int reshape_container(char *container, int cfd, char *devname,
 		      int quiet)
 {
 	struct mdinfo *cc = NULL;
+	struct mdstat_ent *mdstat_collection = NULL;
 
 	/* component_size is not meaningful for a container,
 	 * so pass '-1' meaning 'no change'
@@ -2113,6 +2114,31 @@ int reshape_container(char *container, int cfd, char *devname,
 				continue;
 			break;
 		}
+		/* check if reshape decision should be taken here
+		 */
+		if (!content) {
+			for (content = cc; content ; content = content->next) {
+				struct mdstat_ent *mdstat_check =
+							      mdstat_collection;
+				char *subarray;
+
+				subarray = strchr(content->text_version + 1,
+						  '/') + 1;
+				mdstat = mdstat_by_subdev(subarray,
+						  devname2devnum(container));
+				while (mdstat_check &&
+				       mdstat &&
+					(mdstat->devnum !=
+					 mdstat_check->devnum)) {
+					mdstat_check = mdstat_check->next;
+				}
+				if (mdstat_check) {
+					free_mdstat(mdstat);
+					continue;
+				}
+				break;
+			}
+		}
 		if (!content)
 			break;
 
@@ -2131,11 +2157,15 @@ int reshape_container(char *container, int cfd, char *devname,
 				   content, force,
 				   backup_file, quiet, 1);
 		close(fd);
+		mdstat->next = mdstat_collection;
+		mdstat_collection = mdstat;
 		if (rv)
 			break;
 	}
 	unfreeze(st);
+	free_mdstat(mdstat_collection);
 	sysfs_free(cc);
+
 	exit(0);
 }
 

