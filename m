From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 07/22] imsm: Add wait_for_reshape_imsm() implementation
Date: Thu, 02 Jun 2011 16:49:08 +0200
Message-ID: <20110602144908.27355.89349.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

After each checkpoint mdadm should set new reshaped area and wait
until md finishes reshape. Function wait_for_reshape_imsm() sets
new reshape range and waits for job completion.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 31fae1e..c395a48 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8248,6 +8248,67 @@ exit_imsm_reshape_super:
 	return ret_val;
 }
 
+/*******************************************************************************
+ * Function:	wait_for_reshape_imsm
+ * Description:	Function writes new sync_max value and waits until
+ *		reshape process reach new position
+ * Parameters:
+ *	sra		: general array info
+ *	to_complete	: new sync_max position
+ *	ndata		: number of disks in new array's layout
+ * Returns:
+ *	 0 : success,
+ *	 1 : there is no reshape in progress,
+ *	-1 : fail
+ ******************************************************************************/
+int wait_for_reshape_imsm(struct mdinfo *sra, unsigned long long to_complete,
+			  int ndata)
+{
+	int fd = sysfs_get_fd(sra, NULL, "reshape_position");
+	unsigned long long completed;
+
+	struct timeval timeout;
+
+	if (fd < 0)
+		return 1;
+
+	sysfs_fd_get_ll(fd, &completed);
+
+	if (to_complete == 0) {/* reshape till the end of array */
+		sysfs_set_str(sra, NULL, "sync_max", "max");
+		to_complete = MaxSector;
+	} else {
+		if (completed > to_complete)
+			return -1;
+		if (sysfs_set_num(sra, NULL, "sync_max",
+				  to_complete / ndata) != 0) {
+			close(fd);
+			return -1;
+		}
+	}
+
+	timeout.tv_sec = 0;
+	timeout.tv_usec = 500000;
+	do {
+		char action[20];
+		fd_set rfds;
+		FD_ZERO(&rfds);
+		FD_SET(fd, &rfds);
+		select(fd+1, NULL, NULL, &rfds, &timeout);
+		if (sysfs_fd_get_ll(fd, &completed) < 0) {
+			close(fd);
+			return 1;
+		}
+		if (sysfs_get_str(sra, NULL, "sync_action",
+			    action, 20) > 0 &&
+			    strncmp(action, "reshape", 7) != 0)
+			continue;
+	} while (completed < to_complete);
+	close(fd);
+	return 0;
+
+}
+
 static int imsm_manage_reshape(
 	int afd, struct mdinfo *sra, struct reshape *reshape,
 	struct supertype *st, unsigned long stripes,

