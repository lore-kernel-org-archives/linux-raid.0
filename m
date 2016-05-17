From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] IMSM: retry reading sync_completed during reshape
Date: Tue, 17 May 2016 13:24:41 +0200
Message-ID: <146348428075.32064.12075746168157997590.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com, aleksey.obitotskiy@intel.com, tomasz.majchrzak@intel.com
List-Id: linux-raid.ids

The sync_completed after restarting a reshape
(for example - after reboot) is set to "delayed" until
mdmon changes the state. Mdadm does not wait for that change with
old kernels. If this condition occurs - it exits and reshape
is not continuing. This patch adds retry of reading sync_complete
with a delay. It gives time for mdmon to change the "delayed" state.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ba3ee48..7e2860c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10378,6 +10378,7 @@ exit_imsm_reshape_super:
 int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 {
 	int fd = sysfs_get_fd(sra, NULL, "sync_completed");
+	int retry = 3;
 	unsigned long long completed;
 	/* to_complete : new sync_max position */
 	unsigned long long to_complete = sra->reshape_progress;
@@ -10388,11 +10389,17 @@ int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 		return 1;
 	}
 
-	if (sysfs_fd_get_ll(fd, &completed) < 0) {
-		dprintf("cannot read reshape_position (no reshape in progres)\n");
-		close(fd);
-		return 1;
-	}
+	do {
+		if (sysfs_fd_get_ll(fd, &completed) < 0) {
+			if (!retry) {
+				dprintf("cannot read reshape_position (no reshape in progres)\n");
+				close(fd);
+				return 1;
+			}
+			usleep(30000);
+		} else
+			break;
+	} while (retry--);
 
 	if (completed > position_to_set) {
 		dprintf("wrong next position to set %llu (%llu)\n",

