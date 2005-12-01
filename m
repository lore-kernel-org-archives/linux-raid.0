From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 006 of 14] Make /proc/mdstat pollable.
Date: Thu, 1 Dec 2005 14:23:16 +1100
Message-ID: <1051201032316.29617@suse.de>
References: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


With this patch it is possible to poll /proc/mdstat to detect
arrays appearing or disappearing, to detect failures,
recovery starting, recovery completing, and devices being
added and removed.

It is similar to the poll-ability of /proc/mounts, though different in that:

We always report that the file is readable (because face it, it is, even
if only for EOF).
We report POLLPRI when there is a change so that select() can detect
it as an exceptional event.  Not only are these exceptional events, but 
that is the mechanism that the current 'mdadm' uses to watch for events
(It also polls after a timeout).
(We also report POLLERR like /proc/mounts).
Finally, we only reset the per-file event counter when the start of the 
file is read, rather than when poll() returns an event.  This is more
robust as it means that an fd will continue to report activity to poll/select
until the program clearly responds to that activity.

md_new_event takes an 'mddev' which isn't currently used, but it will
be soon.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 76 insertions(+), 5 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-01 13:56:49.000000000 +1100
+++ ./drivers/md/md.c	2005-12-01 13:57:01.000000000 +1100
@@ -42,6 +42,7 @@
 #include <linux/devfs_fs_kernel.h>
 #include <linux/buffer_head.h> /* for invalidate_bdev */
 #include <linux/suspend.h>
+#include <linux/poll.h>
 
 #include <linux/init.h>
 
@@ -134,6 +135,24 @@ static struct block_device_operations md
 static int start_readonly;
 
 /*
+ * We have a system wide 'event count' that is incremented
+ * on any 'interesting' event, and readers of /proc/mdstat
+ * can use 'poll' or 'select' to find out when the event
+ * count increases.
+ *
+ * Events are:
+ *  start array, stop array, error, add device, remove device,
+ *  start build, activate spare
+ */
+DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
+static atomic_t md_event_count;
+void md_new_event(mddev_t *mddev)
+{
+	atomic_inc(&md_event_count);
+	wake_up(&md_event_waiters);
+}
+
+/*
  * Enables to iterate over all existing md arrays
  * all_mddevs_lock protects this list.
  */
@@ -2111,6 +2130,7 @@ static int do_md_run(mddev_t * mddev)
 	mddev->queue->make_request_fn = mddev->pers->make_request;
 
 	mddev->changed = 1;
+	md_new_event(mddev);
 	return 0;
 }
 
@@ -2238,6 +2258,7 @@ static int do_md_stop(mddev_t * mddev, i
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
 			mdname(mddev));
 	err = 0;
+	md_new_event(mddev);
 out:
 	return err;
 }
@@ -2712,6 +2733,7 @@ static int hot_remove_disk(mddev_t * mdd
 
 	kick_rdev_from_array(rdev);
 	md_update_sb(mddev);
+	md_new_event(mddev);
 
 	return 0;
 busy:
@@ -2802,7 +2824,7 @@ static int hot_add_disk(mddev_t * mddev,
 	 */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
-
+	md_new_event(mddev);
 	return 0;
 
 abort_unbind_export:
@@ -3523,6 +3545,7 @@ void md_error(mddev_t *mddev, mdk_rdev_t
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
+	md_new_event(mddev);
 }
 
 /* seq_file implementation /proc/mdstat */
@@ -3663,12 +3686,17 @@ static void md_seq_stop(struct seq_file 
 		mddev_put(mddev);
 }
 
+struct mdstat_info {
+	int event;
+};
+
 static int md_seq_show(struct seq_file *seq, void *v)
 {
 	mddev_t *mddev = v;
 	sector_t size;
 	struct list_head *tmp2;
 	mdk_rdev_t *rdev;
+	struct mdstat_info *mi = seq->private;
 	int i;
 	struct bitmap *bitmap;
 
@@ -3681,6 +3709,7 @@ static int md_seq_show(struct seq_file *
 
 		spin_unlock(&pers_lock);
 		seq_printf(seq, "\n");
+		mi->event = atomic_read(&md_event_count);
 		return 0;
 	}
 	if (v == (void*)2) {
@@ -3789,16 +3818,52 @@ static struct seq_operations md_seq_ops 
 static int md_seq_open(struct inode *inode, struct file *file)
 {
 	int error;
+	struct mdstat_info *mi = kmalloc(sizeof(*mi), GFP_KERNEL);
+	if (mi == NULL)
+		return -ENOMEM;
 
 	error = seq_open(file, &md_seq_ops);
+	if (error)
+		kfree(mi);
+	else {
+		struct seq_file *p = file->private_data;
+		p->private = mi;
+		mi->event = atomic_read(&md_event_count);
+	}
 	return error;
 }
 
+static int md_seq_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = file->private_data;
+	struct mdstat_info *mi = m->private;
+	m->private = NULL;
+	kfree(mi);
+	return seq_release(inode, file);
+}
+
+static unsigned int mdstat_poll(struct file *filp, poll_table *wait)
+{
+	struct seq_file *m = filp->private_data;
+	struct mdstat_info *mi = m->private;
+	int mask;
+
+	poll_wait(filp, &md_event_waiters, wait);
+
+	/* always allow read */
+	mask = POLLIN | POLLRDNORM;
+
+	if (mi->event != atomic_read(&md_event_count))
+		mask |= POLLERR | POLLPRI;
+	return mask;
+}
+
 static struct file_operations md_seq_fops = {
 	.open           = md_seq_open,
 	.read           = seq_read,
 	.llseek         = seq_lseek,
-	.release	= seq_release,
+	.release	= md_seq_release,
+	.poll		= mdstat_poll,
 };
 
 int register_md_personality(int pnum, mdk_personality_t *p)
@@ -4068,7 +4133,11 @@ static void md_do_sync(mddev_t *mddev)
 
 		j += sectors;
 		if (j>1) mddev->curr_resync = j;
-
+		if (last_check == 0)
+			/* this is the earliers that rebuilt will be
+			 * visible in /proc/mdstat
+			 */
+			md_new_event(mddev);
 
 		if (last_check + window > io_sectors || j == max_sectors)
 			continue;
@@ -4254,6 +4323,7 @@ void md_check_recovery(mddev_t *mddev)
 			mddev->recovery = 0;
 			/* flag recovery needed just to double check */
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+			md_new_event(mddev);
 			goto unlock;
 		}
 		/* Clear some bits that don't mean anything, but
@@ -4291,6 +4361,7 @@ void md_check_recovery(mddev_t *mddev)
 						sprintf(nm, "rd%d", rdev->raid_disk);
 						sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
 						spares++;
+						md_new_event(mddev);
 					} else
 						break;
 				}
@@ -4323,9 +4394,9 @@ void md_check_recovery(mddev_t *mddev)
 					mdname(mddev));
 				/* leave the spares where they are, it shouldn't hurt */
 				mddev->recovery = 0;
-			} else {
+			} else
 				md_wakeup_thread(mddev->sync_thread);
-			}
+			md_new_event(mddev);
 		}
 	unlock:
 		mddev_unlock(mddev);
