From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 11/21] FIX: Honor !reshape state on wait_reshape() entry
Date: Tue, 23 Nov 2010 13:41:05 +0100
Message-ID: <20101123124104.17770.92952.stgit@gklab-170-024.igk.intel.com>
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

When wait_reshape() function starts it can occurs that reshape is finished already,
before wait_reshape() start. This can lead to wait for change state inside this function for a long time.
To avoid this before wait we should test if finish conditions are not reached already.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/Grow.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mdadm/mdadm/Grow.c b/mdadm/mdadm/Grow.c
index 9b1c4c5..f56613f 100644
--- a/mdadm/mdadm/Grow.c
+++ b/mdadm/mdadm/Grow.c
@@ -506,17 +506,20 @@ void wait_reshape(struct mdinfo *sra)
 	int fd = sysfs_get_fd(sra, NULL, "sync_action");
 	char action[20];
 
-	do {
+	if (sysfs_fd_get_str(fd, action, 20) < 0) {
+		close(fd);
+		return;
+	}
+	while  (strncmp(action, "reshape", 7) == 0) {
 		fd_set rfds;
 		FD_ZERO(&rfds);
 		FD_SET(fd, &rfds);
 		select(fd+1, NULL, NULL, &rfds, NULL);
-		
 		if (sysfs_fd_get_str(fd, action, 20) < 0) {
 			close(fd);
 			return;
 		}
-	} while  (strncmp(action, "reshape", 7) == 0);
+	}
 }
 
 static int reshape_super(struct supertype *st, long long size, int level,

