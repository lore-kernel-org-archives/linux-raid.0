From: Jody McIntyre <scjody@sun.com>
Subject: [RFC patch 1/1] md: Track raid5/6 statistics.
Date: Wed, 04 Feb 2009 20:32:04 -0500
Message-ID: <20090205013204.GB14990@clouds>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de, dan.j.williams@intel.com
List-Id: linux-raid.ids

This patch tracks various statistics related to the performance of a RAID 5
or 6 array.  These have been useful to us in the past to help solve
performance issues.  Statistics are collected after the 'md-trace' module
is loaded, and are reported via a 'stat' file in each device's 'md' directory
in sysfs, e.g. /sys/class/block/md0/md/stat

I realize that the format of the statistics may not be the best, and there may
be a better location for them, so I welcome suggestions on where to put them.
Our original suggestion of extending '/proc/mdstat' seems to be unwelcome.

This is a WIP version of the patch using tracepoints.  I am posting it now
because I'm unconvinced this approach is worthwhile compared to the previous
approach of tracking the statistics internally using atomic_inc() and
atomic_dec().  raid5.c already uses these in many places to track internal
counters, and I have not been able to measure any overhead caused by the
original stats patch.  On the other hand, this patch still causes some overhead
even when stats are not enabled (tracepoints require a branch condition check
even when they're off) and causes more overhead when they are enabled (function
call PLUS the existing atomic operation.)

If enough people feel that a tracepoint-based version of this patch is worth
merging but the original patch is not, I will continue with this approach.

Original patch: http://marc.info/?l=linux-raid&m=122772653610151&w=2

TODO:
 - Track the statistics for each array internally rather than having to
   pass in raid5_conf_t, which will make it more generic (adaptable to other
   personalities.)  This means adding traces for when arrays are assembled
   and stopped, so structures can be allocated.

 - This will also allow stat_show() to move into md-trace.  Nothing should
   be in raid5.c other than the tracepoints themselves.

 - We can probably get rid of the read_for_rmw and read_for_rcw tracepoints
   by incrementing a counter in the sh instead of calling the tracepoint,
   then incrementing the global counter in trace_md_request_out_queued()
   (when the read actually happens.)

 - Documentation: will be added once we've decided on the formatting/etc
   for all of this.

Signed-off-by: Jody McIntyre <scjody@sun.com>

Index: linux-2.6/drivers/md/raid5.c
===================================================================
--- linux-2.6.orig/drivers/md/raid5.c
+++ linux-2.6/drivers/md/raid5.c
@@ -50,6 +50,20 @@
 #include <linux/async_tx.h>
 
 /*
+ * Tracing
+ */
+
+#include <trace/md.h>
+
+DEFINE_TRACE(md_request_in_queued);
+DEFINE_TRACE(md_request_in_done);
+DEFINE_TRACE(md_request_out_queued);
+DEFINE_TRACE(md_request_out_done);
+DEFINE_TRACE(md_read_for_rmw);
+DEFINE_TRACE(md_read_for_rcw);
+DEFINE_TRACE(md_out_of_stripes);
+
+/*
  * Stripe cache
  */
 
@@ -136,7 +150,7 @@ static inline int raid6_next_disk(int di
 	return (disk < raid_disks) ? disk : 0;
 }
 
-static void return_io(struct bio *return_bi)
+static void return_io(struct bio *return_bi, raid5_conf_t *conf)
 {
 	struct bio *bi = return_bi;
 	while (bi) {
@@ -145,6 +159,7 @@ static void return_io(struct bio *return
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
 		bio_endio(bi, 0);
+		trace_md_request_in_done(conf);
 		bi = return_bi;
 	}
 }
@@ -347,6 +362,7 @@ static struct stripe_head *get_active_st
 			if (noblock && sh == NULL)
 				break;
 			if (!sh) {
+				trace_md_out_of_stripes(conf);
 				conf->inactive_blocked = 1;
 				wait_event_lock_irq(conf->wait_for_stripe,
 						    !list_empty(&conf->inactive_list) &&
@@ -444,6 +460,7 @@ static void ops_run_io(struct stripe_hea
 			    test_bit(R5_ReWrite, &sh->dev[i].flags))
 				atomic_add(STRIPE_SECTORS,
 					&rdev->corrected_errors);
+			trace_md_request_out_queued(conf, bi, 0);
 			generic_make_request(bi);
 		} else {
 			if (rw == WRITE)
@@ -547,7 +564,7 @@ static void ops_complete_biofill(void *s
 	spin_unlock_irq(&conf->device_lock);
 	clear_bit(STRIPE_BIOFILL_RUN, &sh->state);
 
-	return_io(return_bi);
+	return_io(return_bi, conf);
 
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
@@ -1073,6 +1090,7 @@ static void raid5_end_read_request(struc
 	char b[BDEVNAME_SIZE];
 	mdk_rdev_t *rdev;
 
+	trace_md_request_out_done(conf);
 
 	for (i=0 ; i<disks; i++)
 		if (bi == &sh->dev[i].req)
@@ -1153,6 +1171,8 @@ static void raid5_end_write_request(stru
 	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
+	trace_md_request_out_done(conf);
+
 	for (i=0 ; i<disks; i++)
 		if (bi == &sh->dev[i].req)
 			break;
@@ -2131,6 +2151,7 @@ static void handle_stripe_dirtying5(raid
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
+					trace_md_read_for_rmw(conf);
 				} else {
 					set_bit(STRIPE_DELAYED, &sh->state);
 					set_bit(STRIPE_HANDLE, &sh->state);
@@ -2154,6 +2175,7 @@ static void handle_stripe_dirtying5(raid
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
+					trace_md_read_for_rcw(conf);
 				} else {
 					set_bit(STRIPE_DELAYED, &sh->state);
 					set_bit(STRIPE_HANDLE, &sh->state);
@@ -2219,6 +2241,7 @@ static void handle_stripe_dirtying6(raid
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
+					trace_md_read_for_rcw(conf);
 				} else {
 					pr_debug("Request delayed stripe %llu "
 						"block %d for Reconstruct\n",
@@ -2789,7 +2812,7 @@ static bool handle_stripe5(struct stripe
 
 	ops_run_io(sh, &s);
 
-	return_io(return_bi);
+	return_io(return_bi, conf);
 
 	return blocked_rdev == NULL;
 }
@@ -3011,7 +3034,7 @@ static bool handle_stripe6(struct stripe
 
 	ops_run_io(sh, &s);
 
-	return_io(return_bi);
+	return_io(return_bi, conf);
 
 	return blocked_rdev == NULL;
 }
@@ -3217,6 +3240,7 @@ static void raid5_align_endio(struct bio
 	raid_bi->bi_next = NULL;
 
 	rdev_dec_pending(rdev, conf->mddev);
+	trace_md_request_out_done(conf);
 
 	if (!error && uptodate) {
 		bio_endio(raid_bi, 0);
@@ -3287,6 +3311,7 @@ static int chunk_aligned_read(struct req
 					&pd_idx,
 					conf);
 
+	trace_md_request_in_done(conf);
 	rcu_read_lock();
 	rdev = rcu_dereference(conf->disks[dd_idx].rdev);
 	if (rdev && test_bit(In_sync, &rdev->flags)) {
@@ -3311,6 +3336,7 @@ static int chunk_aligned_read(struct req
 		atomic_inc(&conf->active_aligned_reads);
 		spin_unlock_irq(&conf->device_lock);
 
+		trace_md_request_out_queued(conf, align_bi, 1);
 		generic_make_request(align_bi);
 		return 1;
 	} else {
@@ -3384,6 +3410,8 @@ static int make_request(struct request_q
 	const int rw = bio_data_dir(bi);
 	int cpu, remaining;
 
+	trace_md_request_in_queued(conf, bi);
+
 	if (unlikely(bio_barrier(bi))) {
 		bio_endio(bi, -EOPNOTSUPP);
 		return 0;
@@ -3508,6 +3536,7 @@ static int make_request(struct request_q
 
 		if ( rw == WRITE )
 			md_write_end(mddev);
+		trace_md_request_in_done(conf);
 
 		bio_endio(bi, 0);
 	}
@@ -3981,10 +4010,35 @@ stripe_cache_active_show(mddev_t *mddev,
 static struct md_sysfs_entry
 raid5_stripecache_active = __ATTR_RO(stripe_cache_active);
 
+static ssize_t
+stat_show(mddev_t *mddev, char *page)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+	if (conf)
+		return sprintf(page, "%u %u %u %u %u %u %u %u %u %u %u\n",
+			       atomic_read(&conf->reads_in),
+			       atomic_read(&conf->writes_in),
+			       atomic_read(&conf->reads_out),
+			       atomic_read(&conf->writes_out),
+			       atomic_read(&conf->reads_for_rmw),
+			       atomic_read(&conf->reads_for_rcw),
+			       atomic_read(&conf->aligned_reads),
+			       atomic_read(&conf->active_stripes),
+			       atomic_read(&conf->in_reqs_in_queue),
+			       atomic_read(&conf->out_reqs_in_queue),
+			       atomic_read(&conf->out_of_stripes));
+	else
+		return 0;
+}
+
+static struct md_sysfs_entry
+raid5_stats = __ATTR_RO(stat);
+
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
 	&raid5_preread_bypass_threshold.attr,
+	&raid5_stats.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
Index: linux-2.6/include/linux/raid/raid5.h
===================================================================
--- linux-2.6.orig/include/linux/raid/raid5.h
+++ linux-2.6/include/linux/raid/raid5.h
@@ -385,6 +385,22 @@ struct raid5_private_data {
 	int			pool_size; /* number of disks in stripeheads in pool */
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
+
+	/*
+	 * Stats
+	 */
+	atomic_t		reads_in;
+	atomic_t		writes_in;
+	atomic_t		reads_out;
+	atomic_t		writes_out;
+	atomic_t		out_of_stripes;
+	atomic_t		reads_for_rmw;
+	atomic_t		reads_for_rcw;
+	atomic_t		aligned_reads;
+	atomic_t		writes_zcopy;
+	atomic_t		writes_copied;
+	atomic_t		in_reqs_in_queue;
+	atomic_t		out_reqs_in_queue;
 };
 
 typedef struct raid5_private_data raid5_conf_t;
Index: linux-2.6/include/trace/md.h
===================================================================
--- /dev/null
+++ linux-2.6/include/trace/md.h
@@ -0,0 +1,54 @@
+/*
+ * Copyright (C) 2009 Sun Microsystems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ */
+
+#ifndef _TRACE_MD_H
+#define _TRACE_MD_H
+
+#include <linux/tracepoint.h>
+#include <linux/bio.h>
+#include <linux/raid/raid5.h>
+
+DECLARE_TRACE(md_request_in_queued,
+	TPPROTO(raid5_conf_t *conf, struct bio *bi),
+	TPARGS(conf, bi));
+
+DECLARE_TRACE(md_request_in_done,
+	TPPROTO(raid5_conf_t *conf),
+	TPARGS(conf));
+
+DECLARE_TRACE(md_request_out_queued,
+	TPPROTO(raid5_conf_t *conf, struct bio *bi, int aligned),
+	TPARGS(conf, bi, aligned));
+
+DECLARE_TRACE(md_request_out_done,
+	TPPROTO(raid5_conf_t *conf),
+	TPARGS(conf));
+
+DECLARE_TRACE(md_read_for_rmw,
+	TPPROTO(raid5_conf_t *conf),
+	TPARGS(conf));
+
+DECLARE_TRACE(md_read_for_rcw,
+	TPPROTO(raid5_conf_t *conf),
+	TPARGS(conf));
+
+DECLARE_TRACE(md_out_of_stripes,
+	TPPROTO(raid5_conf_t *conf),
+	TPARGS(conf, sh));
+
+#endif
Index: linux-2.6/drivers/md/Makefile
===================================================================
--- linux-2.6.orig/drivers/md/Makefile
+++ linux-2.6/drivers/md/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_MD_RAID10)		+= raid10.o
 obj-$(CONFIG_MD_RAID456)	+= raid456.o
 obj-$(CONFIG_MD_MULTIPATH)	+= multipath.o
 obj-$(CONFIG_MD_FAULTY)		+= faulty.o
+obj-$(CONFIG_MD_TRACE)		+= md-trace.o
 obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
 obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
Index: linux-2.6/drivers/md/md-trace.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/md-trace.c
@@ -0,0 +1,118 @@
+/*
+ * md-trace.c - tracepoint probes for MD devices
+ *
+ * Copyright (C) 2009 Sun Microsystems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <trace/md.h>
+#include <linux/bio.h>
+#include <linux/raid/raid5.h>
+
+static void probe_md_request_in_queued(raid5_conf_t *conf,
+				       struct bio *bi)
+{
+	atomic_inc(&conf->in_reqs_in_queue);
+
+	if (bi->bi_rw == READ)
+		atomic_inc(&conf->reads_in);
+	else
+		atomic_inc(&conf->writes_in);
+}
+
+static void probe_md_request_in_done(raid5_conf_t *conf)
+{
+	atomic_dec(&conf->in_reqs_in_queue);
+}
+
+static void probe_md_request_out_queued(raid5_conf_t *conf,
+					struct bio *bi,
+					int aligned)
+{
+	atomic_inc(&conf->out_reqs_in_queue);
+
+	if (bi->bi_rw == READ) {
+		atomic_inc(&conf->reads_out);
+		if (aligned)
+			atomic_inc(&conf->aligned_reads);
+	} else
+		atomic_inc(&conf->writes_out);
+
+}
+
+static void probe_md_request_out_done(raid5_conf_t *conf)
+{
+	atomic_dec(&conf->out_reqs_in_queue);
+}
+
+static void probe_md_read_for_rmw(raid5_conf_t *conf)
+{
+	atomic_inc(&conf->reads_for_rmw);
+}
+
+static void probe_md_read_for_rcw(raid5_conf_t *conf)
+{
+	atomic_inc(&conf->reads_for_rcw);
+}
+
+static void probe_md_out_of_stripes(raid5_conf_t *conf)
+{
+	atomic_inc(&conf->out_of_stripes);
+}
+
+static int __init md_trace_init(void)
+{
+	int ret;
+
+	ret = register_trace_md_request_in_queued(probe_md_request_in_queued);
+	WARN_ON(ret);
+	ret = register_trace_md_request_in_done(probe_md_request_in_done);
+	WARN_ON(ret);
+	ret = register_trace_md_request_out_queued(probe_md_request_out_queued);
+	WARN_ON(ret);
+	ret = register_trace_md_request_out_done(probe_md_request_out_done);
+	WARN_ON(ret);
+	ret = register_trace_md_read_for_rmw(probe_md_read_for_rmw);
+	WARN_ON(ret);
+	ret = register_trace_md_read_for_rcw(probe_md_read_for_rcw);
+	WARN_ON(ret);
+	ret = register_trace_md_out_of_stripes(probe_md_out_of_stripes);
+	WARN_ON(ret);
+
+	return 0;
+}
+
+module_init(md_trace_init);
+
+static void __exit md_trace_exit(void)
+{
+	unregister_trace_md_request_in_queued(probe_md_request_in_queued);
+	unregister_trace_md_request_in_done(probe_md_request_in_done);
+	unregister_trace_md_request_out_queued(probe_md_request_out_queued);
+	unregister_trace_md_request_out_done(probe_md_request_out_done);
+	unregister_trace_md_read_for_rmw(probe_md_read_for_rmw);
+	unregister_trace_md_read_for_rcw(probe_md_read_for_rcw);
+	unregister_trace_md_out_of_stripes(probe_md_out_of_stripes);
+
+	tracepoint_synchronize_unregister();
+}
+
+module_exit(md_trace_exit);
+
+MODULE_AUTHOR("Jody McIntyre");
+MODULE_DESCRIPTION("tracepoint probes for MD devices");
+MODULE_LICENSE("GPL");
