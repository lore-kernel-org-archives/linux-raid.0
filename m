From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/3] [mdadm] in --add assign raid_disk of 0 to journal
Date: Mon, 21 Dec 2015 11:23:42 -0800
Message-ID: <1450725823-1832511-3-git-send-email-songliubraving@fb.com>
References: <1450725823-1832511-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450725823-1832511-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 Manage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Manage.c b/Manage.c
index 4540fac..7e1b94b 100644
--- a/Manage.c
+++ b/Manage.c
@@ -948,7 +948,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			pr_err("%s does not support journal device.\n", devname);
 			return -1;
 		}
-		disc.raid_disk = array->raid_disks;
+		disc.raid_disk = 0;
 	}
 
 	if (array->not_persistent==0) {
-- 
2.4.6

