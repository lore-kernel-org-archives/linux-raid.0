From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.29-rc7] md: fix deadlock when stopping arrays
Date: Thu, 05 Mar 2009 16:07:23 -0700
Message-ID: <20090305230615.9122.62640.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, jacek.danecki@intel.com
List-Id: linux-raid.ids

Resolve a deadlock when stopping redundant arrays, i.e. ones that
require a call to sysfs_remove_group when shutdown.  The deadlock is
summarized below:

Thread1                Thread2
-------                -------
read sysfs attribute   stop array
                       take mddev lock
                       sysfs_remove_group
sysfs_get_active
wait for mddev lock
                       wait for active

Sysrq-w:
--------
mdmon         S 00000017  2212  4163      1
  f1982ea8 00000046 2dcf6b85 00000017 c0b23100 f2f83ed0 c0b23100 f2f8413c
  c0b23100 c0b23100 c0b1fb98 f2f8413c 00000000 f2f8413c c0b23100 f2291ecc
  00000002 c0b23100 00000000 00000017 f2f83ed0 f1982eac 00000046 c044d9dd
Call Trace:
  [<c044d9dd>] ? debug_mutex_add_waiter+0x1d/0x58
  [<c06ef451>] __mutex_lock_common+0x1d9/0x338
  [<c06ef451>] ? __mutex_lock_common+0x1d9/0x338
  [<c06ef5e3>] mutex_lock_interruptible_nested+0x33/0x3a
  [<c0634553>] ? mddev_lock+0x14/0x16
  [<c0634553>] mddev_lock+0x14/0x16
  [<c0634eda>] md_attr_show+0x2a/0x49
  [<c04e9997>] sysfs_read_file+0x93/0xf9
mdadm         D 00000017  2812  4177      1
  f0401d78 00000046 430456f8 00000017 f0401d58 f0401d20 c0b23100 f2da2c4c
  c0b23100 c0b23100 c0b1fb98 f2da2c4c 0a10fc36 00000000 c0b23100 f0401d70
  00000003 c0b23100 00000000 00000017 f2da29e0 00000001 00000002 00000000
Call Trace:
  [<c06eed1b>] schedule_timeout+0x1b/0x95
  [<c06eed1b>] ? schedule_timeout+0x1b/0x95
  [<c06eeb97>] ? wait_for_common+0x34/0xdc
  [<c044fa8a>] ? trace_hardirqs_on_caller+0x18/0x145
  [<c044fbc2>] ? trace_hardirqs_on+0xb/0xd
  [<c06eec03>] wait_for_common+0xa0/0xdc
  [<c0428c7c>] ? default_wake_function+0x0/0x12
  [<c06eeccc>] wait_for_completion+0x17/0x19
  [<c04ea620>] sysfs_addrm_finish+0x19f/0x1d1
  [<c04e920e>] sysfs_hash_and_remove+0x42/0x55
  [<c04eb4db>] sysfs_remove_group+0x57/0x86
  [<c0638086>] do_md_stop+0x13a/0x499

This has been there for a while, but is easier to trigger now that mdmon
is closely watching sysfs.

Reported-by: Jacek Danecki <jacek.danecki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Also available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git md-deadlock-fix

 drivers/md/md.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03b4cd0..a307f87 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -214,12 +214,7 @@ static inline mddev_t *mddev_get(mddev_t *mddev)
 	return mddev;
 }
 
-static void mddev_delayed_delete(struct work_struct *ws)
-{
-	mddev_t *mddev = container_of(ws, mddev_t, del_work);
-	kobject_del(&mddev->kobj);
-	kobject_put(&mddev->kobj);
-}
+static void mddev_delayed_delete(struct work_struct *ws);
 
 static void mddev_put(mddev_t *mddev)
 {
@@ -3542,6 +3537,21 @@ static struct kobj_type md_ktype = {
 
 int mdp_major = 0;
 
+static void mddev_delayed_delete(struct work_struct *ws)
+{
+	mddev_t *mddev = container_of(ws, mddev_t, del_work);
+
+	if (mddev->private == &md_redundancy_group) {
+		sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
+		if (mddev->sysfs_action)
+			sysfs_put(mddev->sysfs_action);
+		mddev->sysfs_action = NULL;
+		mddev->private = NULL;
+	}
+	kobject_del(&mddev->kobj);
+	kobject_put(&mddev->kobj);
+}
+
 static int md_alloc(dev_t dev, char *name)
 {
 	static DEFINE_MUTEX(disks_mutex);
@@ -4033,13 +4043,9 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 			mddev->queue->merge_bvec_fn = NULL;
 			mddev->queue->unplug_fn = NULL;
 			mddev->queue->backing_dev_info.congested_fn = NULL;
-			if (mddev->pers->sync_request) {
-				sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
-				if (mddev->sysfs_action)
-					sysfs_put(mddev->sysfs_action);
-				mddev->sysfs_action = NULL;
-			}
 			module_put(mddev->pers->owner);
+			if (mddev->pers->sync_request)
+				mddev->private = &md_redundancy_group;
 			mddev->pers = NULL;
 			/* tell userspace to handle 'inactive' */
 			sysfs_notify_dirent(mddev->sysfs_state);

