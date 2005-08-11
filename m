From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 001 of 6] Make sure mddev->bitmap_offset gets cleared between array instantiations.
Date: Thu, 11 Aug 2005 17:22:26 +1000
Message-ID: <E1E37OU-0002j9-7K@notabene.cse.unsw.edu.au>
References: <20050811171720.10115.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


... otherwise we might try to load a bitmap from an array which hasn't one.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    3 +++
 1 files changed, 3 insertions(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-09 10:22:01.000000000 +1000
+++ ./drivers/md/md.c	2005-08-09 10:22:01.000000000 +1000
@@ -623,6 +623,7 @@ static int super_90_validate(mddev_t *md
 		mddev->raid_disks = sb->raid_disks;
 		mddev->size = sb->size;
 		mddev->events = md_event(sb);
+		mddev->bitmap_offset = 0;
 
 		if (sb->state & (1<<MD_SB_CLEAN))
 			mddev->recovery_cp = MaxSector;
@@ -938,6 +939,7 @@ static int super_1_validate(mddev_t *mdd
 		mddev->raid_disks = le32_to_cpu(sb->raid_disks);
 		mddev->size = le64_to_cpu(sb->size)/2;
 		mddev->events = le64_to_cpu(sb->events);
+		mddev->bitmap_offset = 0;
 		
 		mddev->recovery_cp = le64_to_cpu(sb->resync_offset);
 		memcpy(mddev->uuid, sb->set_uuid, 16);
@@ -1824,6 +1826,7 @@ static int do_md_stop(mddev_t * mddev, i
 		fput(mddev->bitmap_file);
 		mddev->bitmap_file = NULL;
 	}
+	mddev->bitmap_offset = 0;
 
 	/*
 	 * Free resources if final stop
