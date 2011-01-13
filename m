From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 5/6] FIX: mdadm hangs during reshape
Date: Thu, 13 Jan 2011 15:50:42 +0100
Message-ID: <20110113145042.12728.21805.stgit@gklab-128-013.igk.intel.com>
References: <20110113144252.12728.82642.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113144252.12728.82642.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

During reshape when reshape is finished in md, progress_reshape() hangs
on select(). Timeout is introduced to allow for reshape conditions check.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index f1a6218..763287b 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2459,6 +2459,7 @@ int progress_reshape(struct mdinfo *info, struct reshape *reshape,
 		 * waiting forever on a dead array
 		 */
 		char action[20];
+		struct timeval timeout;
 		fd_set rfds;
 		if (sysfs_get_str(info, NULL, "sync_action",
 				  action, 20) <= 0 ||
@@ -2466,7 +2467,9 @@ int progress_reshape(struct mdinfo *info, struct reshape *reshape,
 			break;
 		FD_ZERO(&rfds);
 		FD_SET(fd, &rfds);
-		select(fd+1, NULL, NULL, &rfds, NULL);
+		timeout.tv_sec = 1;
+		timeout.tv_usec = 0;
+		select(fd+1, NULL, NULL, &rfds, &timeout);
 		if (sysfs_fd_get_ll(fd, &completed) < 0) {
 			close(fd);
 			return -1;

