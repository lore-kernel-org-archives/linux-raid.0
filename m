From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] Grow: Do not try to restart if reshape is running
Date: Wed, 16 Jul 2014 12:20:34 +0200
Message-ID: <20140716102034.18952.74271.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Grow process did not check if reshape is already started
when deciding about restarting.
Sync_action should be checked in this case, and if
reshape is running - restart flag should not be set.
Otherwise, Grow process will fail to write data to
sysfs, and reshape will not be continued.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Grow.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index a2f4f14..9ba7f76 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2822,6 +2822,7 @@ static int reshape_array(char *container, int fd, char *devname,
 	unsigned long long array_size;
 	int done;
 	struct mdinfo *sra = NULL;
+	char buf[20];
 
 	/* when reshaping a RAID0, the component_size might be zero.
 	 * So try to fix that up.
@@ -2869,7 +2870,9 @@ static int reshape_array(char *container, int fd, char *devname,
 		goto release;
 	}
 
-	if (st->ss->external && restart && (info->reshape_progress == 0)) {
+	if (st->ss->external && restart && (info->reshape_progress == 0) &&
+		!((sysfs_get_str(info, NULL, "sync_action", buf, sizeof(buf)) > 0) &&
+		(strncmp(buf, "reshape", 7) == 0))) {
 		/* When reshape is restarted from '0', very begin of array
 		 * it is possible that for external metadata reshape and array
 		 * configuration doesn't happen.

