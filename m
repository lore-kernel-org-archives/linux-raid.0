From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PATCH 0/2] external-metadata recovery checkpointing for 2.6.33
Date: Sat, 12 Dec 2009 21:17:01 -0700
Message-ID: <20091213041123.12532.15225.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: ed.ciechanowski@intel.com, marcin.labun@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

A bit late, but hopefully acceptable.  This allows mdmon to restart
recovery operations.

     git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git for-neil

The modifications to mdadm/mdmon need a bit more testing but you can see
the current results on my 'scratch' [1] branch, and I have copied the
meat of the mdmon implementation below:  'mdmon: add recovery checkpoint
support'.

Thanks,
Dan

---

Dan Williams (2):
      md: rcu_read_lock() walk of mddev->disks in md_do_sync()
      md: add 'recovery_start' sysfs attribute

 Documentation/md.txt |   15 ++++++++---
 drivers/md/md.c      |   71 ++++++++++++++++++++++++++++++++++++++++++++------
 drivers/md/md.h      |    1 +
 3 files changed, 75 insertions(+), 12 deletions(-)

---

[1]: git://git.kernel.org/pub/scm/linux/kernel/git/djbw/mdadm.git scratch

mdmon: add recovery checkpoint support

From: Dan Williams <dan.j.williams@intel.com>

With the md/recovery_start attribute userspace can specifiy the starting
position of a spare recovery operation.  The manager thread of mdmon is
modified to activate spares prior to notifying the monitor thread of new
arrays.  This allows the monitor thread to process the 'activate spare'
metadata update message prior to the array being marked active.  If
->process_update() finds that the metadata update is a no-op (i.e. the
spare was already in process of being rebuilt) then the checkpoint can
be assumed valid, otherwise the checkpoint is reset to zero.  Before the
array is marked active resume_recovery() is called to update
md/recovery_start.

Recording the recovery checkpoint is the same as the md/resync_start
case.  Whenever sync_action transitions to idle the kernel updates
md/recovery_start.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 managemon.c   |   57 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 mdadm.h       |    2 ++
 monitor.c     |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 super-ddf.c   |    1 +
 super-intel.c |   31 ++++++++++++++++++++++++-------
 5 files changed, 117 insertions(+), 19 deletions(-)


diff --git a/managemon.c b/managemon.c
index 9d73521..7e09d97 100644
--- a/managemon.c
+++ b/managemon.c
@@ -360,8 +360,8 @@ static void manage_container(struct mdstat_ent *mdstat,
 	}
 }
 
-static void manage_member(struct mdstat_ent *mdstat,
-			  struct active_array *a)
+static int manage_member(struct mdstat_ent *mdstat, struct active_array *a,
+			 int init)
 {
 	/* Compare mdstat info with known state of member array.
 	 * We do not need to look for device state changes here, that
@@ -373,9 +373,15 @@ static void manage_member(struct mdstat_ent *mdstat,
 	 * mdstat until the reshape completes FIXME.
 	 *
 	 * Actually, we also want to handle degraded arrays here by
-	 * trying to find and assign a spare.
-	 * We do that whenever the monitor tells us too.
+	 * trying to find and assign a spare.  We do that whenever the
+	 * monitor tells us too, and at init time as a special case.  At
+	 * init time we want to continue any in-progress recovery
+	 * operations before the array becomes writable, and before the
+	 * monitor has a chance to mark the spare disk(s) as missing in
+	 * the metadata
 	 */
+	int activated = 0;
+
 	// FIXME
 	a->info.array.raid_disks = mdstat->raid_disks;
 	a->info.array.chunk_size = mdstat->chunk_size;
@@ -394,7 +400,7 @@ static void manage_member(struct mdstat_ent *mdstat,
 		 */
 		newdev = a->container->ss->activate_spare(a, &updates);
 		if (!newdev)
-			return;
+			return 0;
 
 		newa = duplicate_aa(a);
 		if (!newa)
@@ -424,8 +430,25 @@ static void manage_member(struct mdstat_ent *mdstat,
 		}
 		queue_metadata_update(updates);
 		updates = NULL;
-		replace_array(a->container, a, newa);
-		sysfs_set_str(&a->info, NULL, "sync_action", "recover");
+		if (init) {
+			/* monitor never saw 'a' so we can free it
+			 * directly, and let the monitor handle the
+			 * start of recovery
+			 */
+			free_aa(a);
+
+			/* monitor needs to see the metadata update
+			 * before the array to verify the recovery
+			 * checkpoint
+			 */
+			check_update_queue(newa->container);
+			barrier();
+			replace_array(newa->container, NULL, newa);
+		} else {
+			replace_array(a->container, a, newa);
+			sysfs_set_str(&a->info, NULL, "sync_action", "recover");
+		}
+		activated = 1;
  out:
 		while (newdev) {
 			d = newdev->next;
@@ -434,6 +457,8 @@ static void manage_member(struct mdstat_ent *mdstat,
 		}
 		free_updates(&updates);
 	}
+
+	return activated;
 }
 
 static int aa_ready(struct active_array *aa)
@@ -557,10 +582,20 @@ static void manage_new(struct mdstat_ent *mdstat,
 		new->container = NULL;
 		free_aa(new);
 	} else {
-		replace_array(container, victim, new);
-		if (failed) {
+		/* try to assign spares before the monitor thread
+		 * activates this array, if that attempt fails, or if
+		 * this array was previously active, just hot add spares
+		 * as normal
+		 */
+		int active = 0;
+
+		if (failed)
 			new->check_degraded = 1;
-			manage_member(mdstat, new);
+		if (victim == NULL)
+			active = manage_member(mdstat, new, 1);
+		if (!active) {
+			replace_array(container, victim, new);
+			manage_member(mdstat, new, 0);
 		}
 	}
 }
@@ -585,7 +620,7 @@ void manage(struct mdstat_ent *mdstat, struct supertype *container)
 		for (a = container->arrays; a; a = a->next) {
 			if (mdstat->devnum == a->devnum) {
 				if (a->container)
-					manage_member(mdstat, a);
+					manage_member(mdstat, a, 0);
 				break;
 			}
 		}
diff --git a/mdadm.h b/mdadm.h
index 9766cdf..d0fc360 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -128,6 +128,8 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #endif
 #endif /* __KLIBC__ */
 
+/* compiler optimization barrier */
+#define barrier() __asm__ __volatile__("": : :"memory")
 
 /*
  * min()/max()/clamp() macros that also do
diff --git a/monitor.c b/monitor.c
index d02e735..c91c0b7 100644
--- a/monitor.c
+++ b/monitor.c
@@ -157,6 +157,46 @@ static void signal_manager(void)
 	syscall(SYS_tgkill, pid, mgr_tid, SIGUSR1);
 }
 
+static enum sync_action resume_recovery(struct active_array *a)
+{
+	/* FIXME currently only honors recovery_start requests when
+	 * there is only one spare in the array.  We cannot guarantee
+	 * the slot assignment selected by the kernel in the multi-spare
+	 * case.
+	 *
+	 * We rely on several events having happened before this point:
+	 * 1/ manage_member() reactivates a previously active spare
+	 * 2/ ->process_update() validates the update record
+	 *    a) if the update is a no-op then the metadata's checkpoint
+	 *       is valid
+	 *    b) if the update modifies metadata the checkpoint is reset
+	 * 3/ ->set_array_state() upon initial activation sets
+	 *    recovery_start to the stored/reset checkpoint
+	 */
+	enum sync_action action = bad_action;
+	struct mdinfo *mdi;
+	int spares = 0;
+
+	for (mdi = a->info.devs; mdi ; mdi = mdi->next)
+		if (mdi->curr_state & DS_SPARE)
+			spares++;
+
+	if (spares == 1) {
+		char buf[30];
+		int rc;
+
+		sprintf(buf, "%llu", a->recovery_start);
+		rc = write_attr(buf, a->recovery_start_fd);
+		if (rc < 0)
+			dprintf("%s: failed to write %llu to recovery_start (%d)\n",
+				__func__, a->recovery_start, errno);
+		action = recover;
+	}
+
+	return action;
+}
+
+
 /* Monitor a set of active md arrays - all of which share the
  * same metadata - and respond to events that require
  * metadata update.
@@ -273,7 +313,9 @@ static int read_and_act(struct active_array *a)
 			if (a->container->ss->set_array_state(a, 2))
 				a->next_state = read_auto; /* array is clean */
 			else {
-				a->next_state = active; /* Now active for recovery etc */
+				/* Now active for recovery etc */
+				a->next_state = active;
+				a->next_action = resume_recovery(a);
 				dirty = 1;
 			}
 		}
@@ -297,6 +339,7 @@ static int read_and_act(struct active_array *a)
 		/* A recovery has finished.  Some disks may be in sync now,
 		 * and the array may no longer be degraded
 		 */
+		a->container->ss->set_array_state(a, a->curr_state <= clean);
 		for (mdi = a->info.devs ; mdi ; mdi = mdi->next) {
 			a->container->ss->set_disk(a, mdi->disk.raid_disk,
 						   mdi->curr_state);
diff --git a/super-ddf.c b/super-ddf.c
index fe83642..c74d7cf 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3068,6 +3068,7 @@ static int ddf_set_array_state(struct active_array *a, int consistent)
 		consistent = 1;
 		if (!is_resync_complete(a))
 			consistent = 0;
+		a->recovery_start = 0;
 	}
 	if (consistent)
 		ddf->virt->entries[inst].state &= ~DDF_state_inconsistent;
diff --git a/super-intel.c b/super-intel.c
index 3a05ae5..3bc47dd 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4310,8 +4310,14 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 	if (consistent == 2 &&
 	    (!is_resync_complete(a) ||
 	     map_state != IMSM_T_STATE_NORMAL ||
-	     dev->vol.migr_state))
+	     dev->vol.migr_state)) {
 		consistent = 0;
+		if (is_rebuilding(dev)) {
+			__u32 units = __le32_to_cpu(dev->vol.curr_migr_unit);
+
+			a->recovery_start = units * blocks_per_migr_unit(dev);
+		}
+	}
 
 	if (is_resync_complete(a)) {
 		/* complete intialization / resync,
@@ -4358,8 +4364,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 
 	/* mark dirty / clean */
 	if (dev->vol.dirty != !consistent) {
-		dprintf("imsm: mark '%s' (%llu)\n",
-			consistent ? "clean" : "dirty", a->resync_start);
+		dprintf("imsm: mark '%s'\n", consistent ? "clean" : "dirty");
 		if (consistent)
 			dev->vol.dirty = 0;
 		else
@@ -4815,8 +4820,6 @@ static void imsm_process_update(struct supertype *st,
 			return;
 		}
 
-		super->updates_pending++;
-
 		/* count failures (excluding rebuilds and the victim)
 		 * to determine map[0] state
 		 */
@@ -4829,12 +4832,26 @@ static void imsm_process_update(struct supertype *st,
 				failed++;
 		}
 
-		/* adding a pristine spare, assign a new index */
+		disk = &dl->disk;
 		if (dl->index < 0) {
+			/* adding a pristine spare, assign a new index */
 			dl->index = super->anchor->num_disks;
 			super->anchor->num_disks++;
+		} else if (dl->index == victim && failed == 0 &&
+			   is_rebuilding(dev) &&
+			   is_configured(disk) && !is_spare(disk)) {
+			/* we don't need to touch metadata to process
+			 * this update record which is our indication
+			 * that a recovery operation can be resumed
+			 */
+			dprintf("%s: resuming recovery of slot%d from %d\n",
+				__func__, victim,
+				__le32_to_cpu(dev->vol.curr_migr_unit));
+			break;
 		}
-		disk = &dl->disk;
+
+		super->updates_pending++;
+
 		disk->status |= CONFIGURED_DISK;
 		disk->status &= ~SPARE_DISK;
