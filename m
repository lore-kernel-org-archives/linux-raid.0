From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - fix for raid1 superblock update in 2.4.19-rc1
Date: Fri, 28 Jun 2002 02:31:25 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15643.15837.457888.423868@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Marcelo,
 This patch fixes a little bug in md/raid1 that I noticed during my
 hack/rip/tear at the 2.5 code.  
Thanks,
NeilBrown
=================
Make sure raid1 superblock changes get written out promptly.

mark_disk_bad (called from raid1_error) sets "sb_dirty"
and wakes-up raid1d to get the superblock written.

However, raid1d only writes the superblock if there are
pending failed read requests to be retried.  So if a device
fails on a write or an ioctl (raidsetfaulty), then the superblock
wont be updated.

This patch moves the call to md_update_sb outside of the loop
in raid1d.  This is consistant with the pattern in raid5.


 ----------- Diffstat output ------------
 ./drivers/md/raid1.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

--- ./drivers/md/raid1.c	2002/06/27 15:36:23	1.1
+++ ./drivers/md/raid1.c	2002/06/27 16:17:41	1.2
@@ -1152,9 +1152,12 @@ static void raid1d (void *data)
 	struct raid1_bh *r1_bh;
 	struct buffer_head *bh;
 	unsigned long flags;
-	mddev_t *mddev;
+	raid1_conf_t *conf = data;
+	mddev_t *mddev = conf->mddev;
 	kdev_t dev;
 
+	if (mddev->sb_dirty)
+		md_update_sb(mddev);
 
 	for (;;) {
 		md_spin_lock_irqsave(&retry_list_lock, flags);
@@ -1165,8 +1168,6 @@ static void raid1d (void *data)
 		md_spin_unlock_irqrestore(&retry_list_lock, flags);
 
 		mddev = r1_bh->mddev;
-		if (mddev->sb_dirty)
-			md_update_sb(mddev);
 		bh = &r1_bh->bh_req;
 		switch(r1_bh->cmd) {
 		case SPECIAL:
@@ -1177,7 +1178,6 @@ static void raid1d (void *data)
 				int i, sum_bhs = 0;
 				int disks = MD_SB_DISKS;
 				struct buffer_head *bhl, *mbh;
-				raid1_conf_t *conf;
 				
 				conf = mddev_to_conf(mddev);
 				bhl = raid1_alloc_bh(conf, conf->raid_disks); /* don't really need this many */
