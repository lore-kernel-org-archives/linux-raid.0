From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH v2] Monitor: don't assume mdadm parameter is a block device
Date: Mon, 19 Jun 2017 11:19:53 +0200
Message-ID: <1497863993-9725-1-git-send-email-tomasz.majchrzak@intel.com>
References: <20170619091658.GA9305@proton.igk.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170619091658.GA9305@proton.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, zlliu@suse.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

If symlink (e.g. /dev/md/raid) is passed as a parameter to mdadm --wait,
it fails as it's not able to find a corresponding entry in /proc/mdstat
output. Get parameter file major:minor and look for block device name in
sysfs. This commit is partial revert of commit 9e04ac1c43e6
("mdadm/util: unify stat checking blkdev into function").

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 Monitor.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

v2:
  corrected referenced commit title in commit message

diff --git a/Monitor.c b/Monitor.c
index bef2f1b..c9f24bd 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -982,12 +982,21 @@ static void link_containers_with_subarrays(struct state *list)
 int Wait(char *dev)
 {
 	char devnm[32];
+	dev_t rdev;
+	char *tmp;
 	int rv = 1;
 	int frozen_remaining = 3;
 
-	if (!stat_is_blkdev(dev, NULL))
+	if (!stat_is_blkdev(dev, &rdev))
+		return 2;
+
+	tmp = devid2devnm(rdev);
+	if (!tmp) {
+		pr_err("Cannot get md device name.\n");
 		return 2;
-	strcpy(devnm, dev);
+	}
+
+	strcpy(devnm, tmp);
 
 	while(1) {
 		struct mdstat_ent *ms = mdstat_read(1, 0);
-- 
1.8.3.1

