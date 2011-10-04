From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/3] Set correct reshape restart position
Date: Tue, 04 Oct 2011 17:54:04 +0200
Message-ID: <20111004155404.27434.89339.stgit@gklab-128-013.igk.intel.com>
References: <20111004155129.27434.81564.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111004155129.27434.81564.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

This patch version is simplified compared to previous one.
There is no use of freeze_reshape flag in start_reshape(). It is assumed
that for reshape starting condition reshape_progress field contains
0 value /correct start position/. For reshape restart case, it contains
correct restart position. This approach doesn't make start_reshape()
difficult to read/manage and /imho/ kernel changes to change mdstat
reporting behavior are not necessary.

Setting correct position allows user to see it in the mdstat during
reshape restart and reshape process is not reported as resync.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/Grow.c b/Grow.c
index 076375a..44505b3 100644
--- a/Grow.c
+++ b/Grow.c
@@ -696,15 +696,19 @@ static int subarray_set_num(char *container, struct mdinfo *sra, char *name, int
 	return rc;
 }
 
-int start_reshape(struct mdinfo *sra, int already_running)
+int start_reshape(struct mdinfo *sra, int already_running, int data_disks)
 {
 	int err;
+	unsigned long long sync_max_to_set;
+
 	sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
-	err = sysfs_set_num(sra, NULL, "suspend_hi", 0);
-	err = err ?: sysfs_set_num(sra, NULL, "suspend_lo", 0);
+	err = sysfs_set_num(sra, NULL, "suspend_hi", sra->reshape_progress);
+	err = err ?: sysfs_set_num(sra, NULL, "suspend_lo",
+				   sra->reshape_progress);
+	sync_max_to_set = sra->reshape_progress / data_disks;
 	if (!already_running)
-		sysfs_set_num(sra, NULL, "sync_min", 0);
-	err = err ?: sysfs_set_num(sra, NULL, "sync_max", 0);
+		sysfs_set_num(sra, NULL, "sync_min", sync_max_to_set);
+	err = err ?: sysfs_set_num(sra, NULL, "sync_max", sync_max_to_set);
 	if (!already_running)
 		err = err ?: sysfs_set_str(sra, NULL, "sync_action", "reshape");
 
@@ -2241,7 +2245,8 @@ started:
 		}
 	}
 
-	err = start_reshape(sra, restart);
+	err = start_reshape(sra, restart,
+			    info->array.raid_disks - reshape.parity);
 	if (err) {
 		fprintf(stderr, 
 			Name ": Cannot %s reshape for %s\n",

