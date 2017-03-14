From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] r5cache: allow adding journal to array without journal
Date: Mon, 13 Mar 2017 17:09:07 -0700
Message-ID: <20170314000907.2184606-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jsorensen@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

This seems just work.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Manage.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/Manage.c b/Manage.c
index 5c3d2b9..9ab999d 100644
--- a/Manage.c
+++ b/Manage.c
@@ -963,11 +963,6 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 
 		sysfs_free(mdp);
 
-		tst->ss->getinfo_super(tst, &mdi, NULL);
-		if (mdi.journal_device_required == 0) {
-			pr_err("%s does not support journal device.\n", devname);
-			return -1;
-		}
 		disc.raid_disk = 0;
 	}
 
-- 
2.9.3

