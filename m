From: Samuel Tardieu <sam@rfc1149.net>
Subject: [PATCH reposted] raid1 load balancing
Date: Thu, 24 Jan 2008 22:57:20 +0100
Message-ID: <87sl0mrinz.fsf@willow.rfc1149.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have been running Konstantin's patch to add raid1 load balancing
since last November. I follow Linus' git version of the kernel + this
patch and haven't noticed any drawback.

Maybe it would be a good idea to apply it, maybe with a FIXME which
reminds people that a more elaborate solution could be used. Here is
patch updated to apply against Linus' HEAD.

Author: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
Date:   Sat Nov 3 20:08:42 2007 +1000

md: add dm-raid1 read balancing

This patch adds RAID1 read balancing to device mapper. A read operation
that is close (in terms of sectors) to a previous read or write goes to
the same mirror.
    
Signed-off-by: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
Tested-by: Samuel Tardieu <sam@rfc1149.net>

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 31123d4..a103340 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -19,6 +19,7 @@
 #include <linux/time.h>
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
+#include <linux/random.h>
 #include <linux/log2.h>
 
 #define DM_MSG_PREFIX "raid1"
@@ -27,6 +28,9 @@
 #define DM_RAID1_HANDLE_ERRORS 0x01
 #define errors_handled(p)	((p)->features & DM_RAID1_HANDLE_ERRORS)
 
+/* Read balancing max hdd head distance */
+#define DM_RAID1_BALANCE_MAX_IO_DISTANCE	(256)
+
 static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
 
 /*-----------------------------------------------------------------
@@ -118,6 +122,7 @@ struct mirror {
 	atomic_t error_count;
 	struct dm_dev *dev;
 	sector_t offset;
+	sector_t last_io_sector;
 };
 
 struct mirror_set {
@@ -743,13 +748,51 @@ static void do_recovery(struct mirror_set *ms)
 	}
 }
 
+static void set_mirror_last_io_sector(struct mirror *m, sector_t sector)
+{
+	/* FIXME: Probably some more work is needed here, however this is unlikely */
+	m->last_io_sector = sector;
+}
+
 /*-----------------------------------------------------------------
  * Reads
  *---------------------------------------------------------------*/
+/*
+ * There is a per-array 'last IO operation' sector number maintained by
+ * read and write handlers for the region. When balancing reads we pick
+ * the disk whose IO operation (HDD head position) is closest.
+ */
 static struct mirror *choose_mirror(struct mirror_set *ms, sector_t sector)
 {
-	/* FIXME: add read balancing */
-	return ms->default_mirror;
+	/* If we got here, then the array is in sync and we can pick any mirror */
+
+	unsigned int i;
+	struct mirror *use_mirror;
+	sector_t use_distance, new_distance;
+
+	use_mirror = &ms->mirror[0];
+	use_distance = abs(sector - ms->mirror[0].last_io_sector);
+
+	for (i = 1; i < ms->nr_mirrors; i++) {
+		new_distance = abs(sector - ms->mirror[i].last_io_sector);
+		if (new_distance < use_distance) {
+			use_distance = new_distance;
+			use_mirror = &ms->mirror[i];
+		}
+	}
+
+	/*
+	 * If the HDD head is too far from the needed sector then we do stochastic
+	 * balancing - chose the mirror randomly. This appers to have a better
+	 * chance of chosing an idle disk in case of two or more regions residing
+	 * on the same physical disk.
+	 *
+	 * TODO: Gather more statistical data and verify that the above is correct
+	 */
+	if (use_distance > DM_RAID1_BALANCE_MAX_IO_DISTANCE)
+		return &ms->mirror[random32() % ms->nr_mirrors];
+	else
+		return use_mirror;
 }
 
 /*
@@ -778,6 +821,9 @@ static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 		else
 			m = ms->default_mirror;
 
+		/* Set last IO position for chosen mirror */
+		set_mirror_last_io_sector(m, bio->bi_sector);
+
 		map_bio(ms, m, bio);
 		generic_make_request(bio);
 	}
@@ -804,6 +850,21 @@ static void write_callback(unsigned long error, void *context)
 	bio_set_ms(bio, NULL);
 
 	/*
+	 * Things might be different for various region states:
+	 * SYNC:	writing is done to all mirrors, reading is balanced
+	 * RECOVERING:	writing is delayed, reading is done from the default
+	 * NOSYNC:	writing to default only, reading from the default
+	 *
+	 * In any case, if we update last IO sector at all mirrors, we will use
+	 * the up-to-date data when doing read balancing
+	 *
+	 * FIXME: update write position only on the region being written
+	 */
+
+	for (i = 0; i < ms->nr_mirrors; i++)
+		set_mirror_last_io_sector(&ms->mirror[i], bio->bi_sector);
+
+	/*
 	 * NOTE: We don't decrement the pending count here,
 	 * instead it is done by the targets endio function.
 	 * This way we handle both writes to SYNC and NOSYNC

