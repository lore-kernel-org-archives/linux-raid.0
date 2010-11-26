From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 45/53] mdadm: support grow operation for external meta
Date: Fri, 26 Nov 2010 09:09:40 +0100
Message-ID: <20101126080940.5221.6355.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Assumptions for external metadata reshape implementation:
- mdadm controls weather writing over live data
- mdadm advances suspend_hi, does a backup if needed,
  tells mdmon it is safe to continue by sending
  resync_max command_msg to mdmon
- mdmon controls sync_max sysfs entry - so the kernel won't
  cross the safe position (reshape progress from metadata)
- mdmon monitors resync_completed and update the metadata
  to reflect 'resync_completed'.
- mdmon moves suspend_lo forward in line with changes in
  resync_completed
- md moves syspend_hi forward: if resync_position crosses
  suspend_hi, suspend_hi is pushed forward to the new reshape_position.
- md updates/notifies resync_completed periodically which
  guide mdmon in updating the metadata periodically.

Above "mdadm" here means a background process forked by "mdadm --grow"
or "mdadm --assemble" which monitors an ongoing reshape.
A general algorithm for external metadata reshape:

<=====we are writing over live data
1. mdadm sets suspend_lo = 0, suspend_hi = 0
2. monitor waits for new sync_max message from mdadm
3. mdadm sets suspend_hi
4. mdadm perform critical data backup with save_backup()
5. mdadm sends new resync_max to monitor
6. mdadm waits on suspend_lo change
7. mdmon wakes up on socket msg
8. mdmon: sync_max is not MAX (we are still writing over live data)
            monitor sets sysfs:sync_max
9. md reshape critical stripes
10. mdmon wakes up on new sync_completed
11. mdmon updates metadata using discard_backup()
12. mdmon updates suspend_lo
13. mdmon wakes on suspend_lo
14. go back to 2.

<==== now critical section is finished
2. mdmon waits for new sync_max message from mdadm
3. mdadm sends new sync_max = MAX to monitor
        (this means the end of critical section)
6. mdadm exits
7. mdmon wakes up on socket msg
8. mdmon calculates at which stripe the next checkpoint must be made
9. mdmon
sets sysfs:sync_max = next checkpoint
10. md reshape critical stripes
11. mdmon wakes up on new sync_completed
12. mdmon updates metadata with discard_backup()
13. mdmon sets
suspend_lo = sync_completed
14. go back to 8.

A new external counterpart for grow_backup() is implemented:
grow_backup_ext().
For non-grow reshape (number of data disks do not change) a new child_same_size_ext() function is implemented.
Both uses save_stripes to read critical data from the source array to the buffer and than writes the buffer to the external backup area with save_backup().
mdmon uses discard_backup() when notified with the new sync_completed.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c        |  314 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 managemon.c   |   36 ++++++-
 mdadm.h       |    4 -
 mdmon.h       |    8 +
 monitor.c     |   78 ++++++++++++++
 super-intel.c |    3 -
 6 files changed, 411 insertions(+), 32 deletions(-)

diff --git a/Grow.c b/Grow.c
index 64fb1c2..7253e5a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -422,7 +422,8 @@ static int child_shrink(int afd, struct mdinfo *sra, unsigned long blocks,
 			int *fds, unsigned long long *offsets,
 			int disks, int chunk, int level, int layout, int data,
 			int dests, int *destfd, unsigned long long *destoffsets);
-static int child_same_size(int afd, struct mdinfo *sra, unsigned long blocks,
+static int child_same_size(struct supertype *st,
+			   int afd, struct mdinfo *sra, unsigned long blocks,
 			   int *fds, unsigned long long *offsets,
 			   unsigned long long start,
 			   int disks, int chunk, int level, int layout, int data,
@@ -839,7 +840,6 @@ void reshape_free_fdlist(int **fdlist_in,
 		dprintf(Name " Error: Parameters verification error #1.\n");
 		return;
 	}
-
 	fdlist = *fdlist_in;
 	offsets = *offsets_in;
 	if ((fdlist == NULL) || (offsets == NULL)) {
@@ -1837,9 +1837,16 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			else
 				fd = -1;
 			mlockall(MCL_FUTURE);
-
+			sra->array.raid_disks = odisks;
+			sra->array.level = array.level;
+			sra->array.layout = olayout;
+			sra->array.chunk_size = ochunk;
+			sra->delta_disks = ndisks - odisks;
+			sra->new_level = (level == UnSet) ? array.level : level;
+			sra->new_layout = nlayout;
+			sra->new_chunk = nchunk;
 			if (odata < ndata)
-				done = child_grow(fd, sra, stripes,
+				done = child_grow(st, fd, sra, stripes,
 						  fdlist, offsets,
 						  odisks, ochunk, array.level, olayout, odata,
 						  d - odisks, fdlist+odisks, offsets+odisks);
@@ -1849,7 +1856,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 						    odisks, ochunk, array.level, olayout, odata,
 						    d - odisks, fdlist+odisks, offsets+odisks);
 			else
-				done = child_same_size(fd, sra, stripes,
+				done = child_same_size(st, fd, sra, stripes,
 						       fdlist, offsets,
 						       0,
 						       odisks, ochunk, array.level, olayout, odata,
@@ -2198,31 +2205,233 @@ static void validate(int afd, int bfd, unsigned long long offset)
 	}
 }
 
-int child_grow(int afd, struct mdinfo *sra, unsigned long stripes,
-	       int *fds, unsigned long long *offsets,
+int wait_reshape_completed_ext(struct supertype *st,
+			       struct mdinfo *sra,
+			       unsigned long long offset /* per device */)
+{
+
+	/* Wait for resync to pass the section that was backed up
+	 * then erase the backup and allow IO
+	 */
+	int fd = sysfs_get_fd(sra, NULL, "suspend_lo");
+	unsigned long long completed;
+
+	struct timeval timeout;
+
+	if (fd < 0)
+		return -1;
+	timeout.tv_sec = 0;
+	timeout.tv_usec = 500000;
+	do {
+		char action[20];
+		fd_set rfds;
+		FD_ZERO(&rfds);
+		FD_SET(fd, &rfds);
+		select(fd+1, NULL, NULL, &rfds, &timeout);
+		if (sysfs_fd_get_ll(fd, &completed) < 0) {
+			close(fd);
+			return -1;
+		}
+		if (sysfs_get_str(sra, NULL, "sync_action",  action, 20) > 0) {
+			if (strncmp(action, "reshape", 7) != 0) {
+				close(fd);
+				return -2;
+			}
+		} else {
+			/* takeover support, when we will back to raid0
+			 * sync_action sysfs entry disappears
+			 * so we have to exit also
+			 */
+			if (sysfs_get_str(sra, NULL, "level",  action, 20) > 0) {
+				if (strncmp(action, "raid0", 5) == 0) {
+					close(fd);
+					return -2;
+				}
+		    }
+		}
+	} while (completed < offset);
+	close(fd);
+
+	return 0;
+}
+
+void send_resync_max_to_mdmon(struct supertype *st,
+			      struct mdinfo *sra,
+			      unsigned long long resync_max)
+{
+	struct mdmon_update msg;
+	struct cmd_message cmd_msg;
+
+	cmd_msg.type = SET_SYNC_MAX;
+	cmd_msg.devnum = devname2devnum(sra->sys_name);
+	cmd_msg.msg_buf.new_sync_max = resync_max;
+	msg.buf = (void *)&cmd_msg;
+	msg.len = sizeof(cmd_msg);
+
+	send_mdmon_cmd(st, &msg);
+}
+
+int grow_backup_ext(struct supertype *st, struct mdinfo *sra,
+		unsigned long long offset, /* per device */
+		unsigned long long stripes, /* per device */
+		int *sources, unsigned long long *offsets,
+		int dests, int *destfd, unsigned long long *destoffsets,
+		int *degraded, char *buf)
+{
+	int disks = sra->array.raid_disks;
+	int chunk = sra->array.chunk_size;
+	int level = sra->array.level;
+	int layout = sra->array.layout;
+	unsigned long long new_degraded;
+	unsigned long long processed = 0;
+	unsigned long long read_offset = 0;
+	unsigned long long write_offset;
+	unsigned long long resync_max;
+	unsigned bytes_per_unit;
+	int new_disks, new_odata;
+	int odata = disks;
+	int retval = 0;
+	int rv = 0;
+	int i;
+
+	if (level >= 4)
+		odata--;
+	if (level == 6)
+		odata--;
+	sysfs_set_num(sra, NULL, "suspend_hi", (offset + stripes * chunk/512) * odata);
+	/* Check that array hasn't become degraded, else we might backup the wrong data */
+	sysfs_get_ll(sra, NULL, "degraded", &new_degraded);
+	if (new_degraded != (unsigned long long)*degraded) {
+		/* check each device to ensure it is still working */
+		struct mdinfo *sd;
+		for (sd = sra->devs ; sd ; sd = sd->next) {
+			if (sd->disk.state & (1<<MD_DISK_FAULTY))
+				continue;
+			if (sd->disk.state & (1<<MD_DISK_SYNC)) {
+				char sbuf[20];
+				if (sysfs_get_str(sra, sd, "state", sbuf, 20) < 0 ||
+				    strstr(sbuf, "faulty") ||
+				    strstr(sbuf, "in_sync") == NULL) {
+					/* this device is dead */
+					sd->disk.state = (1<<MD_DISK_FAULTY);
+					if (sd->disk.raid_disk >= 0 &&
+					    sources[sd->disk.raid_disk] >= 0) {
+						close(sources[sd->disk.raid_disk]);
+						sources[sd->disk.raid_disk] = -1;
+					}
+				}
+			}
+		}
+		*degraded = new_degraded;
+	}
+
+	for (i = 0; i < dests; i++)
+		lseek64(destfd[i], destoffsets[i], 0);
+
+	/* save critical stripes to buf */
+	for (i = 0; i < (int)stripes; i++)
+		rv |= save_stripes(sources, offsets,
+				  disks, chunk, level, layout,
+				  dests, destfd,
+				  offset * 512 * odata + (i * chunk * odata),
+				  chunk * odata,
+				  buf + (i * chunk * odata));
+
+	if (rv)
+		return rv;
+
+	new_disks = disks + sra->delta_disks;
+	new_odata = new_disks;
+	if (sra->new_level >= 4)
+		new_odata--;
+	if (sra->new_level == 6)
+		new_odata--;
+
+	write_offset = offset * 512 * new_odata;
+	bytes_per_unit = sra->new_chunk * new_odata;
+	if (chunk > sra->new_chunk)
+		bytes_per_unit *= (chunk / sra->new_chunk);
+	while ((processed < stripes * chunk * odata) ||
+		(processed == 0 && stripes * chunk * odata == 0)) {
+		int dn;
+		char *devname;
+
+		/* Save critical stripes to external backup */
+		if (st->ss->save_backup)
+			st->ss->save_backup(st, sra,
+					    buf + read_offset,
+					    write_offset,
+					    bytes_per_unit);
+
+		/* send new sync_max to mdmon */
+		resync_max = write_offset / 512 / new_odata +
+			bytes_per_unit / 512 / new_odata;
+		send_resync_max_to_mdmon(st, sra, resync_max);
+
+		/* Wait for updated suspend_lo */
+		retval = wait_reshape_completed_ext(st, sra, resync_max * new_odata);
+		if (retval == -2) {
+			/* reshape has been finished
+			 */
+			rv = -1;
+			break;
+		}
+
+		processed += bytes_per_unit;
+		read_offset += bytes_per_unit;
+		write_offset += bytes_per_unit;
+		sra->reshape_progress = write_offset / 512;
+
+		dn = devname2devnum(sra->text_version + 1);
+		devname = devnum2devname(dn);
+		if (devname) {
+			ping_monitor(devname);
+			free(devname);
+		}
+	}
+
+	return rv;
+}
+
+int child_grow(struct supertype *st, int afd, struct mdinfo *sra,
+	       unsigned long stripes, int *fds, unsigned long long *offsets,
 	       int disks, int chunk, int level, int layout, int data,
 	       int dests, int *destfd, unsigned long long *destoffsets)
 {
 	char *buf;
 	int degraded = 0;
+	int ext_backup = (st->ss->save_backup) ? 1 : 0;
+	unsigned int buf_size;
 
-	if (posix_memalign((void**)&buf, 4096, disks * chunk))
+	buf_size = (ext_backup) ? stripes * disks * chunk :
+		(unsigned int)(disks * chunk);
+	if (posix_memalign((void **)&buf, 4096, buf_size))
 		/* Don't start the 'reshape' */
 		return 0;
 	sysfs_set_num(sra, NULL, "suspend_hi", 0);
 	sysfs_set_num(sra, NULL, "suspend_lo", 0);
-	grow_backup(sra, 0, stripes,
-		    fds, offsets, disks, chunk, level, layout,
-		    dests, destfd, destoffsets,
-		    0, &degraded, buf);
-	validate(afd, destfd[0], destoffsets[0]);
-	wait_backup(sra, 0, stripes * (chunk / 512), stripes * (chunk / 512),
-		    dests, destfd, destoffsets,
-		    0);
+	if (ext_backup) {
+		grow_backup_ext(st, sra, 0, stripes, fds,
+				offsets, dests, destfd, destoffsets,
+				&degraded, buf);
+
+		/* Send resync_max=MAX (-1LLU) to mdmon */
+		send_resync_max_to_mdmon(st, sra, -1LLU);
+	} else {
+		grow_backup(sra, 0, stripes,
+			    fds, offsets, disks, chunk, level, layout,
+			    dests, destfd, destoffsets,
+			    0, &degraded, buf);
+		validate(afd, destfd[0], destoffsets[0]);
+		wait_backup(sra, 0, stripes * chunk / 512, stripes * chunk / 512,
+			    dests, destfd, destoffsets,
+			    0);
+		sysfs_set_num(sra, NULL, "suspend_lo", (stripes * chunk/512) * data);
+		/* FIXME this should probably be numeric */
+		sysfs_set_str(sra, NULL, "sync_max", "max");
+	}
 	sysfs_set_num(sra, NULL, "suspend_lo", (stripes * (chunk/512)) * data);
 	free(buf);
-	/* FIXME this should probably be numeric */
-	sysfs_set_str(sra, NULL, "sync_max", "max");
 	return 1;
 }
 
@@ -2253,7 +2462,7 @@ static int child_shrink(int afd, struct mdinfo *sra, unsigned long stripes,
 		    dests, destfd, destoffsets,
 		    0, &degraded, buf);
 	validate(afd, destfd[0], destoffsets[0]);
-	wait_backup(sra, start, stripes*(chunk/512), 0,
+	wait_backup(sra, start, stripes*chunk/512, 0,
 		    dests, destfd, destoffsets, 0);
 	sysfs_set_num(sra, NULL, "suspend_lo", (stripes * (chunk/512)) * data);
 	free(buf);
@@ -2262,11 +2471,58 @@ static int child_shrink(int afd, struct mdinfo *sra, unsigned long stripes,
 	return 1;
 }
 
-static int child_same_size(int afd, struct mdinfo *sra, unsigned long stripes,
-			   int *fds, unsigned long long *offsets,
-			   unsigned long long start,
-			   int disks, int chunk, int level, int layout, int data,
-			   int dests, int *destfd, unsigned long long *destoffsets)
+static int child_same_size_ext(struct supertype *st, int afd, struct mdinfo *sra,
+			unsigned long stripes, int *fds,
+			unsigned long long *offsets, unsigned long long start,
+			int disks, int chunk, int level, int layout, int data,
+			int dests, int *destfd, unsigned long long *destoffsets)
+{
+	unsigned long long size;
+	unsigned long tailstripes = stripes;
+	char *buf;
+	unsigned long long speed;
+	int degraded = 0;
+	int status;
+
+	if (posix_memalign((void **)&buf, 4096, stripes * disks * chunk))
+		return 0;
+
+	sysfs_set_num(sra, NULL, "suspend_lo", 0);
+	sysfs_set_num(sra, NULL, "suspend_hi", 0);
+
+	sysfs_get_ll(sra, NULL, "sync_speed_min", &speed);
+	sysfs_set_num(sra, NULL, "sync_speed_min", 200000);
+
+	/* Start the reshape - give a chance to update the metadata */
+	sysfs_set_num(sra, NULL, "sync_max", 0);
+	sysfs_set_str(sra, NULL, "sync_action", "reshape");
+	flush_metadata_updates(st);
+
+	size = sra->component_size / (chunk/512);
+	while (start < size) {
+		if (start + stripes > size)
+			tailstripes = (size - start);
+
+		status = grow_backup_ext(st, sra, start*chunk/512, tailstripes,
+					fds, offsets,
+					dests, destfd, destoffsets,
+					&degraded, buf);
+		if (status == 0)
+			start += stripes;
+		else
+			break;
+	}
+	sysfs_set_num(sra, NULL, "sync_speed_min", speed);
+	free(buf);
+	return 1;
+}
+
+int child_same_size(struct supertype *st, int afd,
+		    struct mdinfo *sra, unsigned long stripes,
+		    int *fds, unsigned long long *offsets,
+		    unsigned long long start,
+		    int disks, int chunk, int level, int layout, int data,
+		    int dests, int *destfd, unsigned long long *destoffsets)
 {
 	unsigned long long size;
 	unsigned long tailstripes = stripes;
@@ -2275,6 +2531,13 @@ static int child_same_size(int afd, struct mdinfo *sra, unsigned long stripes,
 	unsigned long long speed;
 	int degraded = 0;
 
+	int ext_backup = (st->ss->save_backup) ? 1 : 0;
+
+	if (ext_backup)
+		return child_same_size_ext(st, afd, sra, stripes,
+					   fds, offsets,
+					   start, disks, chunk, level, layout, data,
+					   dests, destfd, destoffsets);
 
 	if (posix_memalign((void**)&buf, 4096, disks * chunk))
 		return 0;
@@ -2298,6 +2561,7 @@ static int child_same_size(int afd, struct mdinfo *sra, unsigned long stripes,
 	validate(afd, destfd[0], destoffsets[0]);
 	part = 0;
 	start += stripes * 2; /* where to read next */
+
 	size = sra->component_size / (chunk/512);
 	while (start < size) {
 		if (wait_backup(sra, (start-stripes*2)*(chunk/512),
@@ -2754,7 +3018,7 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 			 */
 			unsigned long long start = info->reshape_progress / ndata;
 			start /= (info->array.chunk_size/512);
-			done = child_same_size(-1, info, stripes,
+			done = child_same_size(st, -1, info, stripes,
 					       fds, offsets,
 					       start,
 					       info->array.raid_disks,
diff --git a/managemon.c b/managemon.c
index 9ff3632..abc1291 100644
--- a/managemon.c
+++ b/managemon.c
@@ -120,6 +120,7 @@ static void close_aa(struct active_array *aa)
 	close(aa->action_fd);
 	close(aa->info.state_fd);
 	close(aa->resync_start_fd);
+	close(aa->sync_completed_fd);
 }
 
 static void free_aa(struct active_array *aa)
@@ -431,6 +432,7 @@ static void manage_member(struct mdstat_ent *mdstat,
 			struct metadata_update *updates = NULL;
 			struct mdinfo *newdev = NULL;
 			struct mdinfo *d;
+			int delta_disks = a->reshape_delta_disks;
 
 			newdev = newa->container->ss->reshape_array(newa, reshape_in_progress, &updates);
 			if (newdev) {
@@ -465,6 +467,26 @@ static void manage_member(struct mdstat_ent *mdstat,
 					/* reshape executed
 					 */
 					dprintf("Reshape was started\n");
+					/* during reshape new_data_disks should be set
+					* for proper checkpointing handle
+					*/
+					newa->old_data_disks = newa->info.array.raid_disks;
+					if (newa->info.array.level == 4)
+						newa->old_data_disks--;
+					if (newa->info.array.level == 5)
+						newa->old_data_disks--;
+					if (newa->info.array.level == 6)
+						newa->old_data_disks--;
+					newa->new_data_disks = newa->info.array.raid_disks + delta_disks;
+					if (level == 4)
+						newa->new_data_disks--;
+					if (level == 5)
+						newa->new_data_disks--;
+					if (level == 6)
+						newa->new_data_disks--;
+					newa->waiting_for = wait_grow_backup;
+					newa->grow_sync_max = 0;
+
 					replace_array(a->container, a, newa);
 					a = newa;
 				} else {
@@ -582,7 +604,7 @@ static void manage_new(struct mdstat_ent *mdstat,
 		return;
 
 	mdi = sysfs_read(-1, mdstat->devnum,
-			 GET_LEVEL|GET_CHUNK|GET_DISKS|GET_COMPONENT|
+			 GET_LEVEL|GET_LAYOUT|GET_CHUNK|GET_DISKS|GET_COMPONENT|
 			 GET_DEGRADED|GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE);
 
 	new = malloc(sizeof(*new));
@@ -745,6 +767,18 @@ static void handle_command(struct supertype *container, struct cmd_message *msg)
 	switch (msg->type) {
 	case SET_SYNC_MAX:
 		/* Add SET_SYNC_MAX handler here */
+		if (a->waiting_for == wait_grow_backup) {
+			if (msg->msg_buf.new_sync_max <= a->grow_sync_max) {
+				dprintf("%s: unexpected sync_max value: %llu <= %llu!\n",
+					__func__, msg->msg_buf.new_sync_max,
+					a->grow_sync_max);
+			}
+			a->grow_sync_max = msg->msg_buf.new_sync_max;
+		} else {
+			dprintf("%s: unexpected sync_max msg from mdadm!\n",
+				__func__);
+		}
+		wakeup_monitor();
 		break;
 	}
 }
diff --git a/mdadm.h b/mdadm.h
index eacf0f5..7611a06 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -463,7 +463,8 @@ extern void reshape_free_fdlist(int **fdlist_in,
 				int size);
 extern unsigned long compute_backup_blocks(int nchunk, int ochunk,
 					   unsigned int ndata, unsigned int odata);
-extern int child_grow(int afd, struct mdinfo *sra, unsigned long stripes,
+extern int child_grow(struct supertype *st,
+		      int afd, struct mdinfo *sra, unsigned long blocks,
 		      int *fds, unsigned long long *offsets,
 		      int disks, int chunk, int level, int layout, int data,
 		      int dests, int *destfd, unsigned long long *destoffsets);
@@ -875,7 +876,6 @@ extern int Grow_restart(struct supertype *st, struct mdinfo *info,
 			int *fdlist, int cnt, char *backup_file, int verbose);
 extern int Grow_continue(int mdfd, struct supertype *st,
 			 struct mdinfo *info, char *backup_file);
-
 extern int Assemble(struct supertype *st, char *mddev,
 		    mddev_ident_t ident,
 		    mddev_dev_t devlist, char *backup_file,
diff --git a/mdmon.h b/mdmon.h
index 2c41e47..6e86994 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -23,6 +23,7 @@ enum array_state { clear, inactive, suspended, readonly, read_auto,
 
 enum sync_action { idle, reshape, resync, recover, check, repair, bad_action };
 
+enum reshape_wait { wait_grow_backup, wait_md_reshape };
 
 enum state_of_reshape { reshape_not_active, reshape_is_starting, reshape_in_progress, reshape_cancel_request };
 
@@ -49,9 +50,10 @@ struct active_array {
 
 	enum state_of_reshape reshape_state;
 	int reshape_delta_disks;
-	int waiting_resync_max; /* wait for resync_max cmd from mdadm */
-	long long unsigned resync_max;
-	long long unsigned sync_completed;
+	unsigned long long grow_sync_max; /* sync_max from mdadm Grow */
+	enum reshape_wait waiting_for; /* we can wait for grow backup event
+					  or for md reshape completed */
+	int old_data_disks, new_data_disks;
 
 	int check_degraded; /* flag set by mon, read by manage */
 
diff --git a/monitor.c b/monitor.c
index 3e26a8a..2a92dee 100644
--- a/monitor.c
+++ b/monitor.c
@@ -218,12 +218,17 @@ static int read_and_act(struct active_array *a)
 	int deactivate = 0;
 	struct mdinfo *mdi;
 	int dirty = 0;
+	long long unsigned new_sync_completed;
+	long long unsigned curr_sync_max;
+	unsigned long long safe_sync_max;
+	int signal_md_reshape = 0;
 
 	a->next_state = bad_word;
 	a->next_action = bad_action;
 
 	a->curr_state = read_state(a->info.state_fd);
 	a->curr_action = read_action(a->action_fd);
+	new_sync_completed = read_resync_start(a->sync_completed_fd);
 	a->info.resync_start = read_resync_start(a->resync_start_fd);
 	sync_completed = read_sync_completed(a->sync_completed_fd);
 	for (mdi = a->info.devs; mdi ; mdi = mdi->next) {
@@ -234,6 +239,79 @@ static int read_and_act(struct active_array *a)
 		}
 	}
 
+	if (a->curr_action == reshape && a->waiting_for == wait_grow_backup) {
+		/* We are waiting for mdadm Grow backup completed
+		 */
+		sysfs_get_ll(&a->info, NULL, "sync_max", &curr_sync_max);
+		if (a->grow_sync_max > curr_sync_max) {
+			/* grow_resync_max was update by mdadm:
+			 * continue the reshape with md
+			 */
+			signal_md_reshape = 1;
+		}
+	}
+
+	if (a->curr_action == reshape && a->waiting_for == wait_md_reshape) {
+		/* We are waiting for md reshape completed.
+		 * note: if new_sync_completed == 0 md completed the reshape
+		 */
+		if (new_sync_completed > 0) {
+			/* It is possible that sync_completed = sync_max + 2 */
+			new_sync_completed &= ~(a->info.array.chunk_size / 512 - 1);
+
+			if (new_sync_completed * a->new_data_disks >= a->info.reshape_progress) {
+				a->info.reshape_progress = new_sync_completed * a->new_data_disks;
+
+				/* write_metadata: migration record */
+				a->container->ss->discard_backup(a->container, &a->info);
+			}
+
+			sysfs_get_ll(&a->info, NULL, "sync_max", &curr_sync_max);
+			if (curr_sync_max == 0)
+				/* sync_max was set to max */
+				curr_sync_max = -1LLU;
+
+			if (new_sync_completed >= curr_sync_max) {
+
+				if (sysfs_set_num(&a->info, NULL, "suspend_lo",
+						  new_sync_completed * a->new_data_disks) != 0)
+					dprintf("mdmon: setting suspend_lo() FAILED!\n");
+
+				if (a->grow_sync_max != -1LLU)
+					/* Still have to wait for mdadm Grow backup */
+					a->waiting_for = wait_grow_backup;
+				else
+					/* calculate next sync_max and wait for md*/
+					signal_md_reshape = 1;
+			}
+		} else {
+			/* reshape was finished. should we do something here? */
+		}
+	}
+
+	if (a->curr_action == reshape && signal_md_reshape == 1) {
+		if (a->grow_sync_max == -1LLU) {
+			/* calculate next safe sync_max for the reshape */
+			safe_sync_max = a->info.reshape_progress / a->old_data_disks;
+			safe_sync_max &= ~(a->info.array.chunk_size / 512 - 1);
+
+			if (safe_sync_max >= a->info.component_size)
+				sysfs_set_str(&a->info, NULL, "sync_max", "max");
+			else {
+				/* Workarround:
+				 * sometimes md reports sync_completed == 2 but in fact it is 0
+				 */
+				if ((new_sync_completed == 2) && (safe_sync_max == 0))
+					safe_sync_max = 2;
+				sysfs_set_num(&a->info, NULL, "sync_max", safe_sync_max);
+			}
+		} else {
+			sysfs_set_num(&a->info, NULL, "sync_max", a->grow_sync_max);
+		}
+		/* sync_max was set. wait for md. */
+		a->waiting_for = wait_md_reshape;
+	}
+
 	if (a->curr_state <= inactive &&
 	    a->prev_state > inactive) {
 		/* array has been stopped */
diff --git a/super-intel.c b/super-intel.c
index 7eb7107..7e755fe 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7911,7 +7911,8 @@ int imsm_child_grow(struct supertype *st, char *devname, int validate_fd, struct
 		stripes = blocks / (sra->array.chunk_size/512) / odata;
 		/* child grow returns fixed value == 1
 		 */
-		child_grow(validate_fd, sra, stripes,
+
+		child_grow(st, validate_fd, sra, stripes,
 			fdlist, offsets,
 			odisks, sra->array.chunk_size,
 			sra->array.level, -1, odata,

