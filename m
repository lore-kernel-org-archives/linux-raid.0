From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 5 of 5] Fixes to make version-1 superblocks work in md driver
Date: Wed, 20 Oct 2004 13:26:21 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1CK77F-0008Ia-Ia@notabene.cse.unsw.edu.au>
References: <20041020132354.31830.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Add some missing data_offset additions and some le_to_cpu
convertions and fix a few other little mistakes.
Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c           |   31 +++++++++++--------------------
 ./drivers/md/multipath.c    |    2 ++
 ./drivers/md/raid10.c       |    1 +
 ./include/linux/raid/md.h   |    2 +-
 ./include/linux/raid/md_p.h |    4 ++--
 5 files changed, 17 insertions(+), 23 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-10-20 13:21:27.000000000 +1000
+++ ./drivers/md/md.c	2004-10-20 13:21:27.000000000 +1000
@@ -791,7 +791,7 @@ static unsigned int calc_sb_1_csum(struc
 {
 	unsigned int disk_csum, csum;
 	unsigned long long newcsum;
-	int size = 256 + sb->max_dev*2;
+	int size = 256 + le32_to_cpu(sb->max_dev)*2;
 	unsigned int *isuper = (unsigned int*)sb;
 	int i;
 
@@ -806,7 +806,7 @@ static unsigned int calc_sb_1_csum(struc
 
 	csum = (newcsum & 0xffffffff) + (newcsum >> 32);
 	sb->sb_csum = disk_csum;
-	return csum;
+	return cpu_to_le32(csum);
 }
 
 static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
@@ -828,7 +828,7 @@ static int super_1_load(mdk_rdev_t *rdev
 	case 0:
 		sb_offset = rdev->bdev->bd_inode->i_size >> 9;
 		sb_offset -= 8*2;
-		sb_offset &= ~(4*2);
+		sb_offset &= ~(4*2-1);
 		/* convert from sectors to K */
 		sb_offset /= 2;
 		break;
@@ -861,6 +861,11 @@ static int super_1_load(mdk_rdev_t *rdev
 			bdevname(rdev->bdev,b));
 		return -EINVAL;
 	}
+	if (le64_to_cpu(sb->data_size) < 10) {
+		printk("md: data_size too small on %s\n",
+		       bdevname(rdev->bdev,b));
+		return -EINVAL;
+	}
 	rdev->preferred_minor = 0xffff;
 	rdev->data_offset = le64_to_cpu(sb->data_offset);
 
@@ -905,7 +910,6 @@ static int super_1_validate(mddev_t *mdd
 
 	if (mddev->raid_disks == 0) {
 		mddev->major_version = 1;
-		mddev->minor_version = 0;
 		mddev->patch_version = 0;
 		mddev->persistent = 1;
 		mddev->chunk_size = le32_to_cpu(sb->chunksize) << 9;
@@ -914,7 +918,7 @@ static int super_1_validate(mddev_t *mdd
 		mddev->level = le32_to_cpu(sb->level);
 		mddev->layout = le32_to_cpu(sb->layout);
 		mddev->raid_disks = le32_to_cpu(sb->raid_disks);
-		mddev->size = (u32)le64_to_cpu(sb->size);
+		mddev->size = le64_to_cpu(sb->size)/2;
 		mddev->events = le64_to_cpu(sb->events);
 		
 		mddev->recovery_cp = le64_to_cpu(sb->resync_offset);
@@ -982,7 +986,7 @@ static void super_1_sync(mddev_t *mddev,
 		if (rdev2->desc_nr > max_dev)
 			max_dev = rdev2->desc_nr;
 	
-	sb->max_dev = max_dev;
+	sb->max_dev = cpu_to_le32(max_dev);
 	for (i=0; i<max_dev;i++)
 		sb->dev_roles[max_dev] = cpu_to_le16(0xfffe);
 	
@@ -1477,17 +1481,6 @@ static int analyze_sbs(mddev_t * mddev)
 	}
 
 
-	/*
-	 * Check if we can support this RAID array
-	 */
-	if (mddev->major_version != MD_MAJOR_VERSION ||
-			mddev->minor_version > MD_MINOR_VERSION) {
-		printk(KERN_ALERT 
-			"md: %s: unsupported raid array version %d.%d.%d\n",
-			mdname(mddev), mddev->major_version,
-			mddev->minor_version, mddev->patch_version);
-		goto abort;
-	}
 
 	if ((mddev->recovery_cp != MaxSector) &&
 	    ((mddev->level == 1) ||
@@ -1497,8 +1490,6 @@ static int analyze_sbs(mddev_t * mddev)
 		       mdname(mddev));
 
 	return 0;
-abort:
-	return 1;
 }
 
 int mdp_major = 0;
@@ -2023,7 +2014,7 @@ static int get_array_info(mddev_t * mdde
 
 	info.major_version = mddev->major_version;
 	info.minor_version = mddev->minor_version;
-	info.patch_version = 1;
+	info.patch_version = MD_PATCHLEVEL_VERSION;
 	info.ctime         = mddev->ctime;
 	info.level         = mddev->level;
 	info.size          = mddev->size;

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2004-10-20 13:21:27.000000000 +1000
+++ ./drivers/md/multipath.c	2004-10-20 13:21:27.000000000 +1000
@@ -209,6 +209,7 @@ static int multipath_make_request (reque
 	multipath = conf->multipaths + mp_bh->path;
 
 	mp_bh->bio = *bio;
+	mp_bh->bio.bi_sector += multipath->rdev->data_offset;
 	mp_bh->bio.bi_bdev = multipath->rdev->bdev;
 	mp_bh->bio.bi_rw |= (1 << BIO_RW_FAILFAST);
 	mp_bh->bio.bi_end_io = multipath_end_request;
@@ -428,6 +429,7 @@ static void multipathd (mddev_t *mddev)
 				bdevname(bio->bi_bdev,b),
 				(unsigned long long)bio->bi_sector);
 			*bio = *(mp_bh->master_bio);
+			bio->bi_sector += conf->multipaths[mp_bh->path].rdev->data_offset;
 			bio->bi_bdev = conf->multipaths[mp_bh->path].rdev->bdev;
 			bio->bi_rw |= (1 << BIO_RW_FAILFAST);
 			bio->bi_end_io = multipath_end_request;

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2004-10-20 13:21:27.000000000 +1000
+++ ./drivers/md/raid10.c	2004-10-20 13:21:27.000000000 +1000
@@ -1149,6 +1149,7 @@ static void sync_request_write(mddev_t *
 		atomic_inc(&r10_bio->remaining);
 		md_sync_acct(conf->mirrors[d].rdev->bdev, tbio->bi_size >> 9);
 
+		tbio->bi_sector += conf->mirrors[d].rdev->data_offset;
 		generic_make_request(tbio);
 	}
 

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2004-10-20 13:21:27.000000000 +1000
+++ ./include/linux/raid/md.h	2004-10-20 13:21:27.000000000 +1000
@@ -60,7 +60,7 @@
  */
 #define MD_MAJOR_VERSION                0
 #define MD_MINOR_VERSION                90
-#define MD_PATCHLEVEL_VERSION           0
+#define MD_PATCHLEVEL_VERSION           1
 
 extern int register_md_personality (int p_num, mdk_personality_t *p);
 extern int unregister_md_personality (int p_num);

diff ./include/linux/raid/md_p.h~current~ ./include/linux/raid/md_p.h
--- ./include/linux/raid/md_p.h~current~	2004-10-20 13:21:27.000000000 +1000
+++ ./include/linux/raid/md_p.h	2004-10-20 13:21:27.000000000 +1000
@@ -197,7 +197,7 @@ struct mdp_superblock_1 {
 
 	__u32	chunksize;	/* in 512byte sectors */
 	__u32	raid_disks;
-	__u8	pad1[128-92];	/* set to 0 when written */
+	__u8	pad1[128-96];	/* set to 0 when written */
 
 	/* constant this-device information - 64 bytes */
 	__u64	data_offset;	/* sector start of data, often 0 */
@@ -215,7 +215,7 @@ struct mdp_superblock_1 {
 	__u64	resync_offset;	/* data before this offset (from data_offset) known to be in sync */
 	__u32	sb_csum;	/* checksum upto devs[max_dev] */
 	__u32	max_dev;	/* size of devs[] array to consider */
-	__u8	pad3[64-40];	/* set to 0 when writing */
+	__u8	pad3[64-32];	/* set to 0 when writing */
 
 	/* device state information. Indexed by dev_number.
 	 * 2 bytes per device
