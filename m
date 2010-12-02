From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 09/10] FIX: Honor !reshape state on wait_reshape() entry
Date: Thu, 02 Dec 2010 09:19:51 +0100
Message-ID: <20101202081950.4639.14389.stgit@gklab-170-024.igk.intel.com>
References: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

When wait_reshape() function starts it can occurs that reshape is finished already,
before wait_reshape() start. This can lead to wait for change state inside this function for a long time.
To avoid this before wait we should test if finish conditions are not reached already.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/Grow.c b/Grow.c
index 96c9526..24c5c39 100644
--- a/Grow.c
+++ b/Grow.c
@@ -548,17 +548,22 @@ static void wait_reshape(struct mdinfo *sra)
 	int fd = sysfs_get_fd(sra, NULL, "sync_action");
 	char action[20];
 
-	do {
+	if (fd < 0)
+		return;
+
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
-		if (sysfs_fd_get_str(fd, action, 20) < 0) {
-			close(fd);
-			return;
-		}
-	} while  (strncmp(action, "reshape", 7) == 0);
+		if (sysfs_fd_get_str(fd, action, 20) < 0)
+			break;
+	}
+	close(fd);
 }
 
 static int reshape_super(struct supertype *st, long long size, int level,

