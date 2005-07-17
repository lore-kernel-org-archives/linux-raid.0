From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md ] When resizing an array, we need to update resync_max_sectors as well as size.
Date: Sun, 17 Jul 2005 18:27:40 +1000
Message-ID: <E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au>
References: <20050717182650.24540.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Another md patch against 2.6.13-rc2-mm2, suitable for 2.6.13.
Thanks,
NeilBrown

### Comments for Changeset

Without this, and attempt to 'grow' an array will claim to have synced
the extra part without actually having done anything.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c     |    1 +
 ./drivers/md/raid5.c     |    1 +
 ./drivers/md/raid6main.c |    1 +
 3 files changed, 3 insertions(+)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-07-17 18:25:47.000000000 +1000
+++ ./drivers/md/raid1.c	2005-07-17 17:18:13.000000000 +1000
@@ -1467,6 +1467,7 @@ static int raid1_resize(mddev_t *mddev, 
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
 	mddev->size = mddev->array_size;
+	mddev->resync_max_sectors = sectors;
 	return 0;
 }
 

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-07-17 18:25:47.000000000 +1000
+++ ./drivers/md/raid5.c	2005-07-17 18:25:52.000000000 +1000
@@ -1931,6 +1931,7 @@ static int raid5_resize(mddev_t *mddev, 
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
 	mddev->size = sectors /2;
+	mddev->resync_max_sectors = sectors;
 	return 0;
 }
 

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-07-17 18:25:47.000000000 +1000
+++ ./drivers/md/raid6main.c	2005-07-17 17:19:04.000000000 +1000
@@ -2095,6 +2095,7 @@ static int raid6_resize(mddev_t *mddev, 
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
 	mddev->size = sectors /2;
+	mddev->resync_max_sectors = sectors;
 	return 0;
 }
 
