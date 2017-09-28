From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 07/12] Grow: fix switching on PPL during recovery
Date: Thu, 28 Sep 2017 14:41:13 +0200
Message-ID: <20170928124118.23361-8-pawel.baldysiak@intel.com>
References: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

If raid memeber is not in sync - it is skipped during
enablement of PPL. This is not correct, since the drive that
we are currently recovering to does not have ppl_size and ppl_sector
properly set in sysfs.
Remove this skipping, so all drives are updated during turning on the PPL.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 Grow.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Grow.c b/Grow.c
index 534ba801..1d33a4eb 100644
--- a/Grow.c
+++ b/Grow.c
@@ -637,9 +637,6 @@ int Grow_consistency_policy(char *devname, int fd, struct context *c, struct sha
 			int dfd;
 			char *devpath;
 
-			if ((sd->disk.state & (1 << MD_DISK_SYNC)) == 0)
-				continue;
-
 			devpath = map_dev(sd->disk.major, sd->disk.minor, 0);
 			dfd = dev_open(devpath, O_RDWR);
 			if (dfd < 0) {
-- 
2.13.5

