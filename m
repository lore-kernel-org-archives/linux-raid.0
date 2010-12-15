From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: do not load migration record from spare disk
Date: Wed, 15 Dec 2010 11:42:19 +0100
Message-ID: <20101215104219.15687.32092.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Load migration record from first 2 disks only, not from spare disks.
Check for negative values is missing.

This problem can be observed when slots are managed by md.
When they are set by mdadm problem is not visible, but still exists.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 4758951..2070869 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1602,14 +1602,15 @@ static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 {
 	unsigned long long dsize;
 	struct mdinfo *sd;
-	struct dl *dl;
+	struct dl *dl = NULL;
 	char nm[30];
 	int retval = -1;
 	int fd = -1;
 
 	for (sd = info->devs ; sd ; sd = sd->next) {
 		/* read only from one of the first two slots */
-		if (sd->disk.raid_disk > 1)
+		if ((sd->disk.raid_disk > 1) ||
+		    (sd->disk.raid_disk < 0))
 			continue;
 		sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
 		fd = dev_open(nm, O_RDONLY);
@@ -1643,7 +1644,7 @@ static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 		goto out;
 	}
 	retval = 0;
- out:
+out:
 	if (fd >= 0)
 		close(fd);
 	return retval;
@@ -1662,7 +1663,7 @@ static int write_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 
 	for (sd = info->devs ; sd ; sd = sd->next) {
 		/* write only to the first two slots */
-		if (sd->disk.raid_disk > 1)
+		if ((sd->disk.raid_disk > 1) || (sd->disk.raid_disk < 0))
 			continue;
 		sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
 		fd = dev_open(nm, O_RDWR);

