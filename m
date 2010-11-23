From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 16/21] FIX: Start mdmon after changing level
Date: Tue, 23 Nov 2010 13:41:47 +0100
Message-ID: <20101123124147.17770.58762.stgit@gklab-170-024.igk.intel.com>
References: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

When level is changing from not monitored (raid0) to monitored level
mdmon should be run. This is common situation, so code from super-intel.c
has to be moved to Grow.c

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/Grow.c        |    8 ++++++++
 mdadm/mdadm/super-intel.c |   11 -----------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/mdadm/mdadm/Grow.c b/mdadm/mdadm/Grow.c
index 3747f76..66a2303 100644
--- a/mdadm/mdadm/Grow.c
+++ b/mdadm/mdadm/Grow.c
@@ -1241,6 +1241,14 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 					rv = 1;
 					goto release;
 				}
+				/* before sending update make sure that for external metadata
+				 * and after changing raid level mdmon is running
+				 */
+				if (st->ss->external && !mdmon_running(st->container_dev) &&
+				    level > 0) {
+					start_mdmon(st->container_dev);
+					ping_monitor(container);
+				}
 				sync_metadata(st);
 			}
 		}
diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c
index 945cc94..7481126 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -7410,17 +7410,6 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 				ret_val = 0;
 				goto imsm_reshape_super_exit;
 			}
-			/* if raid0 was takeovered by any other
-			 * personality start mdmon */
-			if (sra->array.level == 0) {
-				char *dname = devnum2devname(dn);
-				if (!mdmon_running(dn))
-					start_mdmon(dn);
-				if (dname) {
-					ping_monitor(dname);
-					free(dname);
-				}
-			}
 			ret_val = 0;
 		}
 		sysfs_free(sra);

