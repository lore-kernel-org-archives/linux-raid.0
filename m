From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: Why are MD block IO requests subject to 'plugging'?
Date: Tue, 25 Mar 2008 19:39:44 +0000
Message-ID: <18409.21760.288502.76254@tree.ty.sabi.co.uk>
References: <18382.54925.354731.996508@tree.ty.sabi.co.UK>
	<18408.60019.523141.419772@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18408.60019.523141.419772@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... low low read rates unless enormous read-aheads are used
... ]

>> * Most revealingly, when I used values of read ahead which
>>   were powers of 10, the numbers of block/s reported by
>>   'vmstat 1' was also a multiple of that power of 10.

> More precisely it seems that the thruput is an exact multiple
> of readhead and interrupts per second. For example on a single
> hard disk, reading it 32KiB at a time with a read ahead of
> 1000 512B sectors: [ ... ]

Well, I have now setup an old PC I have with a test RAID, and it
is an otherwise totally quiescent system, so I can observe
things a bit more precisely.

It shows that problem exists not just on MD devices, but on 'hd'
and 'sd' devices too.

It is pretty ridiculous in the sense that the PC does exactly
101 interrupts per second, and if I run for example something
like one of:

  dd bs=NNk iflag=direct if=/dev/hdX of=/dev/null

  blockdev --setra NN /dev/hdX && sysctl vm/drop_caches=1 \
    && dd bs=32k if=/dev/hdX of=/dev/null

The number of block/s reported by 'vmstat 1' is exactly a
multiple of 100 or 101, e.g. 6464/s or 12800/s or 130256/s where
the apparent request issue rate can sort of halve wrt 100Hz but
not exceed it. This happens with the 'noop' elevator too, so
it must be some absurd thing 

> This before I spend a bit of time doing a bit of 'blktrace'
> work to see how unplugging "helps" MD

Seems ever more likely that I need to have a look at 'blktrace',
but it is not an MD specific issue.

> and perhaps setting 'unplug_thresh' globally to 1 "just for
> fun" :-).

Uhm I have exported both 'unplug_thresh' and 'unplug_delay' and
defaulted them both to 1 in the appended patch, and I am trying
also out of curiosity to figure out how to make the 'queue'
object/entry appear under '/sys/block/md0/md/'...

--- block/ll_rw_blk.c-dist	2007-11-17 17:22:41.484066984 +0000
+++ block/ll_rw_blk.c	2008-03-25 15:50:11.110010883 +0000
@@ -217,8 +217,8 @@
 	blk_queue_congestion_threshold(q);
 	q->nr_batching = BLK_BATCH_REQ;
 
-	q->unplug_thresh = 4;		/* hmm */
-	q->unplug_delay = (3 * HZ) / 1000;	/* 3 milliseconds */
+	q->unplug_thresh = 1;		/* hmm */
+	q->unplug_delay = (1 * HZ) / 1000;	/* 3 milliseconds */
 	if (q->unplug_delay == 0)
 		q->unplug_delay = 1;
 
@@ -3997,6 +3997,54 @@
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_unplug_thresh_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->unplug_thresh, (page));
+}
+
+static ssize_t
+queue_unplug_thresh_store(struct request_queue *q, const char *page, size_t count)
+{
+	unsigned long unplug_thresh;
+	ssize_t ret = queue_var_store(&unplug_thresh, page, count);
+
+	spin_lock_irq(q->queue_lock);
+	q->unplug_thresh = unplug_thresh;
+	spin_unlock_irq(q->queue_lock);
+
+	return ret;
+}
+
+static ssize_t queue_unplug_delay_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->unplug_delay, (page));
+}
+
+static ssize_t
+queue_unplug_delay_store(struct request_queue *q, const char *page, size_t count)
+{
+	unsigned long unplug_delay;
+	ssize_t ret = queue_var_store(&unplug_delay, page, count);
+
+	spin_lock_irq(q->queue_lock);
+	q->unplug_delay = unplug_delay;
+	spin_unlock_irq(q->queue_lock);
+
+	return ret;
+}
+
+
+static struct queue_sysfs_entry queue_unplug_thresh_entry = {
+	.attr = {.name = "unplug_thresh", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_unplug_thresh_show,
+	.store = queue_unplug_thresh_store,
+};
+
+static struct queue_sysfs_entry queue_unplug_delay_entry = {
+	.attr = {.name = "unplug_delay", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_unplug_delay_show,
+	.store = queue_unplug_delay_store,
+};
 
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
@@ -4028,6 +4076,8 @@
 };
 
 static struct attribute *default_attrs[] = {
+	&queue_unplug_thresh_entry.attr,
+	&queue_unplug_delay_entry.attr,
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
