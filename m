From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 002 of 2] Allow md arrays to be started read-only (module parameter).
Date: Mon, 31 Oct 2005 16:59:05 +1100
Message-ID: <1051031055905.8213@suse.de>
References: <20051031165552.8151.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When an md array is started, the superblock will be written,
and resync may commense.  This is not good if you want to be
completely read-only as, for example, when preparing to resume
from a suspend-to-disk image.

So introduce a module parameter "start_ro" which can be set
to '1' at boot, at module load, or via 
  /sys/module/md_mod/parameters/start_ro

When this is set, new arrays get an 'auto-ro' mode, which disables all
internal io (superblock updates, resync, recovery) and is automatically
switched to 'rw' when the first write request arrives.

The array can be set to true 'ro' mode using 'mdadm -r' before
the first write request, or resync can be started without a
write using 'mdadm -w'.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 8 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-31 15:54:59.000000000 +1100
+++ ./drivers/md/md.c	2005-10-31 15:55:06.000000000 +1100
@@ -131,6 +131,8 @@ static ctl_table raid_root_table[] = {
 
 static struct block_device_operations md_fops;
 
+static int start_readonly;
+
 /*
  * Enables to iterate over all existing md arrays
  * all_mddevs_lock protects this list.
@@ -2029,6 +2031,9 @@ static int do_md_run(mddev_t * mddev)
 	mddev->resync_max_sectors = mddev->size << 1; /* may be over-ridden by personality */
 	mddev->barriers_work = 1;
 
+	if (start_readonly)
+		mddev->ro = 2; /* read-only, but switch on first write */
+
 	/* before we start the array running, initialise the bitmap */
 	err = bitmap_create(mddev);
 	if (err)
@@ -2141,7 +2146,7 @@ static int do_md_stop(mddev_t * mddev, i
 
 		if (ro) {
 			err  = -ENXIO;
-			if (mddev->ro)
+			if (mddev->ro==1)
 				goto out;
 			mddev->ro = 1;
 		} else {
@@ -3258,12 +3263,22 @@ static int md_ioctl(struct inode *inode,
 
 	/*
 	 * The remaining ioctls are changing the state of the
-	 * superblock, so we do not allow read-only arrays
-	 * here:
+	 * superblock, so we do not allow them on read-only arrays.
+	 * However non-MD ioctls (e.g. get-size) will still come through
+	 * here and hit the 'default' below, so only disallow
+	 * 'md' ioctls, and switch to rw mode if started auto-readonly.
 	 */
-	if (mddev->ro) {
-		err = -EROFS;
-		goto abort_unlock;
+	if (_IOC_TYPE(cmd) == MD_MAJOR &&
+	    mddev->ro && mddev->pers) {
+		if (mddev->ro == 2) {
+			mddev->ro = 0;
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
+
+		} else {
+			err = -EROFS;
+			goto abort_unlock;
+		}
 	}
 
 	switch (cmd)
@@ -3651,8 +3666,10 @@ static int md_seq_show(struct seq_file *
 		seq_printf(seq, "%s : %sactive", mdname(mddev),
 						mddev->pers ? "" : "in");
 		if (mddev->pers) {
-			if (mddev->ro)
+			if (mddev->ro==1)
 				seq_printf(seq, " (read-only)");
+			if (mddev->ro==2)
+				seq_printf(seq, "(auto-read-only)");
 			seq_printf(seq, " %s", mddev->pers->name);
 		}
 
@@ -3696,7 +3713,9 @@ static int md_seq_show(struct seq_file *
 				status_resync (seq, mddev);
 				seq_printf(seq, "\n      ");
 			} else if (mddev->curr_resync == 1 || mddev->curr_resync == 2)
-				seq_printf(seq, "	resync=DELAYED\n      ");
+				seq_printf(seq, "\tresync=DELAYED\n      ");
+			else if (mddev->recovery_cp < MaxSector)
+				seq_printf(seq, "\tresync=PENDING\n      ");
 		} else
 			seq_printf(seq, "\n       ");
 
@@ -3833,6 +3852,13 @@ void md_write_start(mddev_t *mddev, stru
 	if (bio_data_dir(bi) != WRITE)
 		return;
 
+	BUG_ON(mddev->ro == 1);
+	if (mddev->ro == 2) {
+		/* need to switch to read/write */
+		mddev->ro = 0;
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
+	}
 	atomic_inc(&mddev->writes_pending);
 	if (mddev->in_sync) {
 		spin_lock_irq(&mddev->write_lock);
@@ -4429,6 +4455,23 @@ static __exit void md_exit(void)
 module_init(md_init)
 module_exit(md_exit)
 
+static int get_ro(char *buffer, struct kernel_param *kp)
+{
+	return sprintf(buffer, "%d", start_readonly);
+}
+static int set_ro(const char *val, struct kernel_param *kp)
+{
+	char *e;
+	int num = simple_strtoul(val, &e, 10);
+	if (*val && (*e == '\0' || *e == '\n')) {
+		start_readonly = num;
+		return 0;;
+	}
+	return -EINVAL;
+}
+
+module_param_call(start_ro, set_ro, get_ro, NULL, 0600);
+
 EXPORT_SYMBOL(register_md_personality);
 EXPORT_SYMBOL(unregister_md_personality);
 EXPORT_SYMBOL(md_error);
