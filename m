From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 3 - Remove some inappropriate MD_BUG calls when hot_removing
Date: Tue, 17 Dec 2002 13:00:49 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18O72P-0000pR-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Marcelo,
  This is the first of three patches for 2.4.21-pre that make smallish
  improvements to md/raid.
  Thanks, NeilBrown


If you try to hot-remove an active device, md will currently
print an MD_BUG message which is inappropriate and confusing.
This patch removes these.


 ----------- Diffstat output ------------
 ./drivers/md/md.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2002-12-16 16:28:35.000000000 +1100
+++ ./drivers/md/md.c	2002-12-16 16:28:35.000000000 +1100
@@ -2337,20 +2337,16 @@ static int hot_remove_disk(mddev_t * mdd
 		return -EINVAL;
 	}
 	disk = &mddev->sb->disks[rdev->desc_nr];
-	if (disk_active(disk)) {
-		MD_BUG();
+	if (disk_active(disk))
 		goto busy;
-	}
-	if (disk_removed(disk)) {
-		MD_BUG();
+
+	if (disk_removed(disk))
 		return -EINVAL;
-	}
 
 	err = mddev->pers->diskop(mddev, &disk, DISKOP_HOT_REMOVE_DISK);
-	if (err == -EBUSY) {
-		MD_BUG();
+	if (err == -EBUSY)
 		goto busy;
-	}
+
 	if (err) {
 		MD_BUG();
 		return -EINVAL;
