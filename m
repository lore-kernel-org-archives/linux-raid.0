From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 47/53] FIX: Honor !reshape state on wait_reshape() entry
Date: Fri, 26 Nov 2010 09:09:55 +0100
Message-ID: <20101126080955.5221.11777.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
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
index fdc5bfd..d5f3f16 100644
--- a/Grow.c
+++ b/Grow.c
@@ -507,17 +507,22 @@ void wait_reshape(struct mdinfo *sra)
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

