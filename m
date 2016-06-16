From: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Subject: [PATCH 2/2] imsm: properly handle values of sync_completed
Date: Thu, 16 Jun 2016 11:31:37 +0200
Message-ID: <1466069497-29503-3-git-send-email-aleksey.obitotskiy@intel.com>
References: <1466069497-29503-1-git-send-email-aleksey.obitotskiy@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1466069497-29503-1-git-send-email-aleksey.obitotskiy@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The sync_completed can be set to such values:
- two numbers of processed sectors and total during synchronization,
separated with '/';
- 'none' if synchronization process is stopped;
- 'delayed' if synchronization process is delayed.
Handle value of sync_completed not only as numbers but
also check for 'none' and 'delayed'.

Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 7950bef..b401f3c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10363,6 +10363,33 @@ exit_imsm_reshape_super:
 	return ret_val;
 }
 
+#define COMPLETED_OK		0
+#define COMPLETED_NONE		1
+#define COMPLETED_DELAYED	2
+
+static int read_completed(int fd, unsigned long long *val)
+{
+	int ret;
+	char buf[50];
+
+	ret = sysfs_fd_get_str(fd, buf, 50);
+	if (ret < 0)
+		return ret;
+
+	ret = COMPLETED_OK;
+	if (strncmp(buf, "none", 4) == 0) {
+		ret = COMPLETED_NONE;
+	} else if (strncmp(buf, "delayed", 7) == 0) {
+		ret = COMPLETED_DELAYED;
+	} else {
+		char *ep;
+		*val = strtoull(buf, &ep, 0);
+		if (ep == buf || (*ep != 0 && *ep != '\n' && *ep != ' '))
+			ret = -1;
+	}
+	return ret;
+}
+
 /*******************************************************************************
  * Function:	wait_for_reshape_imsm
  * Description:	Function writes new sync_max value and waits until
@@ -10417,7 +10444,9 @@ int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 	}
 
 	do {
+		int rc;
 		char action[20];
+
 		int timeout = 3000;
 		sysfs_wait(fd, &timeout);
 		if (sysfs_get_str(sra, NULL, "sync_action",
@@ -10428,11 +10457,14 @@ int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 			close(fd);
 			return -1;
 		}
-		if (sysfs_fd_get_ll(fd, &completed) < 0) {
+
+		rc = read_completed(fd, &completed);
+		if (rc < 0) {
 			dprintf("cannot read reshape_position (in loop)\n");
 			close(fd);
 			return 1;
-		}
+		} else if (rc == COMPLETED_NONE)
+			break;
 	} while (completed < position_to_set);
 
 	close(fd);
-- 
2.7.4

