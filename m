From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 24/24] Add new disk to clustered array
Date: Thu, 18 Dec 2014 10:19:12 -0600
Message-ID: <20141218161912.GA29675@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Algorithm:
1. Node 1 issues mdadm --manage /dev/mdX --add /dev/sdYY which issues
   ioctl(ADD_NEW_DISC with disc.state set to MD_DISK_CLUSTER_ADD)
2. Node 1 sends NEWDISK with uuid and slot number
3. Other nodes issue kobject_uevent_env with uuid and slot number
(Steps 4,5 could be a udev rule)
4. In userspace, the node searches for the disk, perhaps
   using blkid -t SUB_UUID=""
5. Other nodes issue either of the following depending on whether the disk
   was found:
   ioctl(ADD_NEW_DISK with disc.state set to MD_DISK_CANDIDATE and
	 disc.number set to slot number)
   ioctl(CLUSTERED_DISK_NACK)
6. Other nodes drop lock on no-new-devs (CR) if device is found
7. Node 1 attempts EX lock on no-new-devs
8. If node 1 gets the lock, it sends METADATA_UPDATED after unmarking the disk
   as SpareLocal
9. If not (get no-new-dev lock), it fails the operation and sends METADATA_UPDATED
10. Other nodes understand if the device is added or not by reading the superblock again after receiving the METADATA_UPDATED message.

Signed-off-by: Lidong Zhong <lzhong@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c        | 107 +++++++++++++++++++++++++++++++++++++++--
 drivers/md/md-cluster.h        |   4 ++
 drivers/md/md.c                |  54 +++++++++++++++++++--
 drivers/md/md.h                |   5 ++
 drivers/md/raid1.c             |   1 +
 include/uapi/linux/raid/md_p.h |   8 ++-
 include/uapi/linux/raid/md_u.h |   1 +
 7 files changed, 171 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 9feb6ff2..37158f3 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -15,11 +15,13 @@
 #include <linux/module.h>
 #include <linux/dlm.h>
 #include <linux/sched.h>
+#include <linux/raid/md_p.h>
 #include "md.h"
 #include "bitmap.h"
 #include "md-cluster.h"
 
 #define LVB_SIZE	64
+#define NEW_DEV_TIMEOUT 5000
 
 struct dlm_lock_resource {
 	dlm_lockspace_t *ls;
@@ -59,19 +61,25 @@ struct md_cluster_info {
 	struct dlm_lock_resource *ack_lockres;
 	struct dlm_lock_resource *message_lockres;
 	struct dlm_lock_resource *token_lockres;
+	struct dlm_lock_resource *no_new_dev_lockres;
 	struct md_thread *recv_thread;
+	struct completion newdisk_completion;
 };
 
 enum msg_type {
 	METADATA_UPDATED = 0,
-	RESYNCING
+	RESYNCING,
+	NEWDISK,
 };
 
 struct cluster_msg {
 	int type;
 	int slot;
+	/* TODO: Unionize this for smaller footprint */
 	sector_t low;
 	sector_t high;
+	char uuid[16];
+	int raid_slot;
 };
 
 static void sync_ast(void *arg)
@@ -360,13 +368,40 @@ static void process_suspend_info(struct md_cluster_info *cinfo,
 	spin_unlock_irq(&cinfo->suspend_lock);
 }
 
+static void process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
+{
+	char disk_uuid[64];
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	char event_name[]="EVENT=ADD_DEVICE";
+	char raid_slot[16];
+	char *envp[] = {event_name, disk_uuid, raid_slot, NULL};
+	int len;
+
+	len = snprintf(disk_uuid, 64, "DEVICE_UUID=");
+	pretty_uuid(disk_uuid + len, cmsg->uuid);
+	snprintf(raid_slot, 16, "RAID_DISK=%d", cmsg->raid_slot);
+	printk("%s:%d Sending kobject change with %s and %s\n", __func__, __LINE__, disk_uuid, raid_slot);
+	init_completion(&cinfo->newdisk_completion);
+	kobject_uevent_env(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE, envp);
+	wait_for_completion_timeout(&cinfo->newdisk_completion,
+			NEW_DEV_TIMEOUT);
+}
+
+
+static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	md_reload_sb(mddev);
+	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
+}
+
 static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 {
 	switch (msg->type) {
 		case METADATA_UPDATED:
 			pr_info("%s: %d Received message: METADATA_UPDATE from %d\n",
 					__func__, __LINE__, msg->slot);
-			md_reload_sb(mddev);
+			process_metadata_update(mddev, msg);
 			break;
 		case RESYNCING:
 			pr_info("%s: %d Received message: RESYNCING from %d\n",
@@ -374,6 +409,10 @@ static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 			process_suspend_info(mddev->cluster_info, msg->slot,
 					msg->low, msg->high);
 			break;
+		case NEWDISK:
+			pr_info("%s: %d Received message: NEWDISK from %d\n",
+					__func__, __LINE__, msg->slot);
+			process_add_new_disk(mddev, msg);
 	};
 }
 
@@ -593,14 +632,22 @@ static int join(struct mddev *mddev, int nodes)
 	cinfo->ack_lockres = lockres_init(mddev, "ack", ack_bast, 0);
 	if (!cinfo->ack_lockres)
 		goto err;
+	cinfo->no_new_dev_lockres = lockres_init(mddev, "no-new-dev", NULL, 0);
+	if (!cinfo->no_new_dev_lockres)
+		goto err;
+
 	/* get sync CR lock on ACK. */
 	if (dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR))
 		pr_err("md-cluster: failed to get a sync CR lock on ACK!(%d)\n",
 				ret);
+	/* get sync CR lock on no-new-dev. */
+	if (dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR))
+		pr_err("md-cluster: failed to get a sync CR lock on "
+				"no-new-dev!(%d)\n", ret);
+
 
 	pr_info("Joined cluster %s slot %d\n", str, cinfo->slot_number);
 
-	memset(str, '\0', 64);
 	snprintf(str, 64, "bitmap%04d", cinfo->slot_number - 1);
 	cinfo->bitmap_lockres = lockres_init(mddev, str, NULL, 1);
 	if (!cinfo->bitmap_lockres)
@@ -623,6 +670,7 @@ err:
 	lockres_free(cinfo->message_lockres);
 	lockres_free(cinfo->token_lockres);
 	lockres_free(cinfo->ack_lockres);
+	lockres_free(cinfo->no_new_dev_lockres);
 	lockres_free(cinfo->bitmap_lockres);
 	lockres_free(cinfo->sb_lock);
 	if (cinfo->lockspace)
@@ -643,6 +691,7 @@ static int leave(struct mddev *mddev)
 	lockres_free(cinfo->message_lockres);
 	lockres_free(cinfo->token_lockres);
 	lockres_free(cinfo->ack_lockres);
+	lockres_free(cinfo->no_new_dev_lockres);
 	lockres_free(cinfo->sb_lock);
 	lockres_free(cinfo->bitmap_lockres);
 	dlm_release_lockspace(cinfo->lockspace, 2);
@@ -738,6 +787,53 @@ out:
 	return ret;
 }
 
+static int add_new_disk_start(struct mddev *mddev, struct md_rdev *rdev)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	struct cluster_msg cmsg;
+	int ret = 0;
+	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
+	char *uuid = sb->device_uuid;
+	memset(&cmsg, 0, sizeof(cmsg));
+	cmsg.type = cpu_to_le32(NEWDISK);
+	memcpy(cmsg.uuid, uuid, 16);
+	cmsg.raid_slot = rdev->desc_nr;
+	lock_comm(cinfo);
+	ret = __sendmsg(cinfo, &cmsg);
+	if (ret)
+		return ret;
+	cinfo->no_new_dev_lockres->flags |= DLM_LKF_NOQUEUE;
+	ret = dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_EX);
+	cinfo->no_new_dev_lockres->flags &= ~DLM_LKF_NOQUEUE;
+	/* Some node does not "see" the device */
+	if (ret == -EAGAIN)
+		ret = -ENOENT;
+	else
+		dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
+	return ret;
+}
+
+static int add_new_disk_finish(struct mddev *mddev)
+{
+	struct cluster_msg cmsg;
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	int ret;
+	/* Write sb and inform others */
+	md_update_sb(mddev, 1);
+	cmsg.type = METADATA_UPDATED;
+	ret = __sendmsg(cinfo, &cmsg);
+	unlock_comm(cinfo);
+	return ret;
+}
+
+static void new_disk_ack(struct mddev *mddev, bool ack)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	if (ack)
+		dlm_unlock_sync(cinfo->no_new_dev_lockres);
+	complete(&cinfo->newdisk_completion);
+}
+
 static struct md_cluster_operations cluster_ops = {
 	.join   = join,
 	.leave  = leave,
@@ -748,7 +844,10 @@ static struct md_cluster_operations cluster_ops = {
 	.metadata_update_start = metadata_update_start,
 	.metadata_update_finish = metadata_update_finish,
 	.metadata_update_cancel = metadata_update_cancel,
-	.area_resyncing = area_resyncing
+	.area_resyncing = area_resyncing,
+	.add_new_disk_start = add_new_disk_start,
+	.add_new_disk_finish = add_new_disk_finish,
+	.new_disk_ack = new_disk_ack,
 };
 
 static int __init cluster_init(void)
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index 0378540..60d7e58 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -6,6 +6,7 @@
 #include "md.h"
 
 struct mddev;
+struct md_rdev;
 
 struct md_cluster_operations {
 	int (*join)(struct mddev *mddev, int nodes);
@@ -18,6 +19,9 @@ struct md_cluster_operations {
 	int (*metadata_update_finish)(struct mddev *mddev);
 	int (*metadata_update_cancel)(struct mddev *mddev);
 	int (*area_resyncing)(struct mddev *mddev, sector_t lo, sector_t hi);
+	int (*add_new_disk_start)(struct mddev *mddev, struct md_rdev *rdev);
+	int (*add_new_disk_finish)(struct mddev *mddev);
+	void (*new_disk_ack)(struct mddev *mddev, bool ack);
 };
 
 #endif /* _MD_CLUSTER_H */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5be7719..6de96a3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2375,7 +2375,7 @@ static void sync_sbs(struct mddev * mddev, int nospares)
 	}
 }
 
-static void md_update_sb(struct mddev * mddev, int force_change)
+void md_update_sb(struct mddev * mddev, int force_change)
 {
 	struct md_rdev *rdev;
 	int sync_req;
@@ -2539,6 +2539,7 @@ repeat:
 		wake_up(&rdev->blocked_wait);
 	}
 }
+EXPORT_SYMBOL(md_update_sb);
 
 /* words written to sysfs files may, or may not, be \n terminated.
  * We want to accept with case. For this we use cmd_match.
@@ -3331,7 +3332,7 @@ static void analyze_sbs(struct mddev * mddev)
 			kick_rdev_from_array(rdev);
 			continue;
 		}
-		if (rdev != freshest)
+		if (rdev != freshest) {
 			if (super_types[mddev->major_version].
 			    validate_super(mddev, rdev)) {
 				printk(KERN_WARNING "md: kicking non-fresh %s"
@@ -3340,6 +3341,16 @@ static void analyze_sbs(struct mddev * mddev)
 				kick_rdev_from_array(rdev);
 				continue;
 			}
+			/* No device should have a Candidate flag
+			 * when reading devices
+			 */
+			if (test_bit(Candidate, &rdev->flags)) {
+				pr_info("md: kicking Cluster Candidate %s"
+					" from array!\n",
+					bdevname(rdev->bdev,b));
+				kick_rdev_from_array(rdev);
+			}
+		}
 		if (mddev->level == LEVEL_MULTIPATH) {
 			rdev->desc_nr = i++;
 			rdev->raid_disk = rdev->desc_nr;
@@ -5648,7 +5659,6 @@ static int get_array_info(struct mddev * mddev, void __user * arg)
 		info.state = (1<<MD_SB_BITMAP_PRESENT);
 	if (mddev_is_clustered(mddev))
 		info.state |= (1<<MD_SB_CLUSTERED);
-
 	info.active_disks  = insync;
 	info.working_disks = working;
 	info.failed_disks  = failed;
@@ -5743,6 +5753,12 @@ static int add_new_disk(struct mddev * mddev, mdu_disk_info_t *info)
 	struct md_rdev *rdev;
 	dev_t dev = MKDEV(info->major,info->minor);
 
+	if (mddev_is_clustered(mddev) &&
+		!(info->state & ((1 << MD_DISK_CLUSTER_ADD) | (1 << MD_DISK_CANDIDATE)))) {
+		pr_err("%s: Cannot add to clustered mddev. Try --cluster-add\n", mdname(mddev));
+		return -EINVAL;
+	}
+
 	if (info->major != MAJOR(dev) || info->minor != MINOR(dev))
 		return -EOVERFLOW;
 
@@ -5829,6 +5845,25 @@ static int add_new_disk(struct mddev * mddev, mdu_disk_info_t *info)
 		else
 			clear_bit(WriteMostly, &rdev->flags);
 
+		/*
+		 * check whether the device shows up in other nodes
+		 */
+		if (mddev_is_clustered(mddev)) {
+			if (info->state & (1 << MD_DISK_CANDIDATE)) {
+				/* Through --cluster-confirm */
+				set_bit(Candidate, &rdev->flags);
+				md_cluster_ops->new_disk_ack(mddev, true);
+			} else if (info->state & (1 << MD_DISK_CLUSTER_ADD)) {
+				/* --add initiated by this node */
+				err = md_cluster_ops->add_new_disk_start(mddev, rdev);
+				if (err) {
+					md_cluster_ops->add_new_disk_finish(mddev);
+					export_rdev(rdev);
+					return err;
+				}
+			}
+		}
+
 		rdev->raid_disk = -1;
 		err = bind_rdev_to_array(rdev, mddev);
 		if (!err && !mddev->pers->hot_remove_disk) {
@@ -5854,6 +5889,9 @@ static int add_new_disk(struct mddev * mddev, mdu_disk_info_t *info)
 		if (!err)
 			md_new_event(mddev);
 		md_wakeup_thread(mddev->thread);
+		if (mddev_is_clustered(mddev) &&
+				(info->state & (1 << MD_DISK_CLUSTER_ADD)))
+			md_cluster_ops->add_new_disk_finish(mddev);
 		return err;
 	}
 
@@ -6433,6 +6471,7 @@ static inline bool md_ioctl_valid(unsigned int cmd)
 	case SET_DISK_FAULTY:
 	case STOP_ARRAY:
 	case STOP_ARRAY_RO:
+	case CLUSTERED_DISK_NACK:
 		return true;
 	default:
 		return false;
@@ -6638,6 +6677,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 				break;
 			else
 				err = add_new_disk(mddev, &info);
+
 			goto done_unlock;
 		}
 		break;
@@ -6712,6 +6752,13 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 		goto done_unlock;
 	}
 
+	case CLUSTERED_DISK_NACK:
+		if (mddev_is_clustered(mddev))
+			md_cluster_ops->new_disk_ack(mddev, false);
+		else
+			err = -EINVAL;
+		goto done_unlock;
+
 	case HOT_ADD_DISK:
 		err = hot_add_disk(mddev, new_decode_dev(arg));
 		goto done_unlock;
@@ -6735,7 +6782,6 @@ abort_unlock:
 	    err != -EINVAL)
 		mddev->hold_active = 0;
 	mddev_unlock(mddev);
-
 	return err;
 done:
 	if (err)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 620384a..1395a93 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -171,6 +171,10 @@ enum flag_bits {
 				 * a want_replacement device with same
 				 * raid_disk number.
 				 */
+	Candidate,		/* For clustered environments only:
+				 * This device is seen locally but not
+				 * by the whole cluster
+				 */
 };
 
 #define BB_LEN_MASK	(0x00000000000001FFULL)
@@ -634,6 +638,7 @@ extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 
 extern void md_unplug(struct blk_plug_cb *cb, bool from_schedule);
 extern void md_reload_sb(struct mddev *mddev);
+extern void md_update_sb(struct mddev *mddev, int force);
 static inline int mddev_check_plugged(struct mddev *mddev)
 {
 	return !!blk_check_plugged(md_unplug, mddev,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4dcbaae..cb2e378 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1584,6 +1584,7 @@ static int raid1_spare_active(struct mddev *mddev)
 		struct md_rdev *rdev = conf->mirrors[i].rdev;
 		struct md_rdev *repl = conf->mirrors[conf->raid_disks + i].rdev;
 		if (repl
+		    && !test_bit(Candidate, &repl->flags)
 		    && repl->recovery_offset == MaxSector
 		    && !test_bit(Faulty, &repl->flags)
 		    && !test_and_set_bit(In_sync, &repl->flags)) {
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index 643489d..5d0e4c0 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -78,6 +78,12 @@
 #define MD_DISK_ACTIVE		1 /* disk is running or spare disk */
 #define MD_DISK_SYNC		2 /* disk is in sync with the raid set */
 #define MD_DISK_REMOVED		3 /* disk is in sync with the raid set */
+#define MD_DISK_CLUSTER_ADD     4 /* Initiate a disk add across the cluster
+				   * For clustered enviroments only.
+				   */
+#define MD_DISK_CANDIDATE	5 /* disk is added as spare (local) until confirmed
+				   * For clustered enviroments only.
+				   */
 
 #define	MD_DISK_WRITEMOSTLY	9 /* disk is "write-mostly" is RAID1 config.
 				   * read requests will only be sent here in
@@ -101,7 +107,7 @@ typedef struct mdp_device_descriptor_s {
 #define MD_SB_CLEAN		0
 #define MD_SB_ERRORS		1
 
-#define	MD_SB_CLUSTERED		5 /* MD is clustered */
+#define	MD_SB_CLUSTERED 	5 /* MD is clustered */
 #define	MD_SB_BITMAP_PRESENT	8 /* bitmap may be present nearby */
 
 /*
diff --git a/include/uapi/linux/raid/md_u.h b/include/uapi/linux/raid/md_u.h
index 4133e74..5a7029c 100644
--- a/include/uapi/linux/raid/md_u.h
+++ b/include/uapi/linux/raid/md_u.h
@@ -63,6 +63,7 @@
 #define STOP_ARRAY		_IO (MD_MAJOR, 0x32)
 #define STOP_ARRAY_RO		_IO (MD_MAJOR, 0x33)
 #define RESTART_ARRAY_RW	_IO (MD_MAJOR, 0x34)
+#define CLUSTERED_DISK_NACK	_IO (MD_MAJOR, 0x35)
 
 /* 63 partitions with the alternate major number (mdp) */
 #define MdpMinorShift 6
-- 
2.1.2

