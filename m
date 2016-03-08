From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/8] Manage: Manage_add(): Fix memory leak
Date: Tue,  8 Mar 2016 12:30:45 -0500
Message-ID: <1457458252-20203-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

sysfs_read() allocates and populates a struct mdinfo, however the code
forgot to free it again, before dropping the reference to the pointer.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Manage.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Manage.c b/Manage.c
index a812ba0..9d2e0d0 100644
--- a/Manage.c
+++ b/Manage.c
@@ -944,10 +944,13 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 		}
 
 		if (strncmp(mdp->sysfs_array_state, "readonly", 8) != 0) {
+			sysfs_free(mdp);
 			pr_err("%s is not readonly, cannot add journal.\n", devname);
 			return -1;
 		}
 
+		sysfs_free(mdp);
+
 		tst->ss->getinfo_super(tst, &mdi, NULL);
 		if (mdi.journal_device_required == 0) {
 			pr_err("%s does not support journal device.\n", devname);
-- 
2.5.0

