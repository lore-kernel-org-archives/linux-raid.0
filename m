From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 19/21] imsm: FIX: Remove timeout from wait_for_reshape_imsm()
Date: Wed, 08 Jun 2011 18:12:06 +0200
Message-ID: <20110608161206.24327.29007.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Timeout should not be used for select function in wait_for_reshape_imsm().

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 8806339..fae1218 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8574,8 +8574,6 @@ int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 	unsigned long long to_complete = sra->reshape_progress;
 	unsigned long long position_to_set = to_complete / ndata;
 
-	struct timeval timeout;
-
 	if (fd < 0) {
 		dprintf("imsm: wait_for_reshape_imsm() "
 			"cannot open reshape_position\n");
@@ -8606,25 +8604,22 @@ int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 		return -1;
 	}
 
-	/* FIXME should not need a timeout at all */
-	timeout.tv_sec = 30;
-	timeout.tv_usec = 0;
 	do {
 		char action[20];
 		fd_set rfds;
 		FD_ZERO(&rfds);
 		FD_SET(fd, &rfds);
-		select(fd+1, NULL, NULL, &rfds, &timeout);
+		select(fd+1, &rfds, NULL, NULL, NULL);
+		if (sysfs_get_str(sra, NULL, "sync_action",
+				  action, 20) > 0 &&
+				strncmp(action, "reshape", 7) != 0)
+			break;
 		if (sysfs_fd_get_ll(fd, &completed) < 0) {
 			dprintf("imsm: wait_for_reshape_imsm() "
 				"cannot read reshape_position (in loop)\n");
 			close(fd);
 			return 1;
 		}
-		if (sysfs_get_str(sra, NULL, "sync_action",
-				  action, 20) > 0 &&
-		    strncmp(action, "reshape", 7) != 0)
-			break;
 	} while (completed < to_complete);
 	close(fd);
 	return 0;

