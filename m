From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/4] WORKAROUND: mdadm hangs during reshape
Date: Thu, 20 Jan 2011 11:57:46 +0100
Message-ID: <20110120105746.22926.74908.stgit@gklab-128-013.igk.intel.com>
References: <20110120104759.22926.66874.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110120104759.22926.66874.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

During reshape when reshape is finished in md, progress_reshape() hangs
on select(). Timeout is introduced to allow for reshape conditions check.

You point in the email that you do not like this solution.
It is put in to series as reminder.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 717d087..c9f4b9c 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2394,6 +2394,7 @@ int progress_reshape(struct mdinfo *info, struct reshape *reshape,
 		 * waiting forever on a dead array
 		 */
 		char action[20];
+		struct timeval timeout;
 		fd_set rfds;
 		if (sysfs_get_str(info, NULL, "sync_action",
 				  action, 20) <= 0 ||
@@ -2401,7 +2402,9 @@ int progress_reshape(struct mdinfo *info, struct reshape *reshape,
 			break;
 		FD_ZERO(&rfds);
 		FD_SET(fd, &rfds);
-		select(fd+1, NULL, NULL, &rfds, NULL);
+		timeout.tv_sec = 1;
+		timeout.tv_usec = 0;
+		select(fd+1, NULL, NULL, &rfds, &timeout);
 		if (sysfs_fd_get_ll(fd, &completed) < 0) {
 			close(fd);
 			goto check_progress;

