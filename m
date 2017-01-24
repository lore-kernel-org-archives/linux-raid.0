From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 1/1] imsm: fix missing error message during migration
Date: Tue, 24 Jan 2017 14:29:33 +0100
Message-ID: <20170124132933.16943-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

If user tries to migrate from raid0 to raid5 and there is no spare
drive to perform it - mdadm will exit with errorcode, but
no error message is printed.

Print error instead of debug message when this condition occurs,
so user is informed why requested migration is not started.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/super-intel.c b/super-intel.c
index 433bb6d..d5e9517 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10718,7 +10718,7 @@ static int imsm_create_metadata_update_for_migration(
 			free(u);
 			sysfs_free(spares);
 			update_memory_size = 0;
-			dprintf("error: cannot get spare device for requested migration");
+			pr_err("cannot get spare device for requested migration\n");
 			return 0;
 		}
 		sysfs_free(spares);
-- 
2.9.3

