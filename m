From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 01/36] md: beginnings of bad block management.
Date: Tue, 26 Jul 2011 12:26:27 +1000
Message-ID: <20110726122627.5288a3ff@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025847.8422.29443.stgit@notabene.brown>
	<878vrq5pda.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878vrq5pda.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 23 Jul 2011 00:03:45 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> > This the first step in allowing md to track bad-blocks per-device so
> > that we can fail individual blocks rather than the whole device.
> >
> > This patch just adds a data structure for recording bad blocks, with
> > routines to add, remove, search the list.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >
> >  drivers/md/md.c |  457 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/md/md.h |   49 ++++++
> >  2 files changed, 502 insertions(+), 4 deletions(-)
> >
> > +
> > +/* Bad block management.
> > + * We can record which blocks on each device are 'bad' and so just
> > + * fail those blocks, or that stripe, rather than the whole device.
> > + * Entries in the bad-block table are 64bits wide.  This comprises:
> > + * Length of bad-range, in sectors: 0-511 for lengths 1-512
> > + * Start of bad-range, sector offset, 54 bits (allows 8 exbibytes)
> > + *  A 'shift' can be set so that larger blocks are tracked and
> > + *  consequently larger devices can be covered.
> > + * 'Acknowledged' flag - 1 bit. - the most significant bit.
> > + */
> > +/* Locking of the bad-block table is a two-layer affair.
> > + * Read access through ->active_page only requires an rcu_readlock.
> > + * However if ->active_page is found to be NULL, the table
> > + * should be accessed through ->page which requires an irq-spinlock.
> > + * Updating the page requires setting ->active_page to NULL,
> > + * synchronising with rcu, then updating ->page under the same
> > + * irq-spinlock.
> > + * We always set or clear bad blocks from process context, but
> > + * might look-up bad blocks from interrupt/bh context.
> > + *
> 
> Empty line.
> 
> If the locking is complex, it'd be better defining separate functions to
> deal with it, IMHO. Please see below.

I too have been feeling uncomfortable about the locking and I recently
realised that I really should be using a seqlock rather than trying to force
RCU into the mould.  So I have changed it and it is much better now.  Below
is new version.


> > +EXPORT_SYMBOL_GPL(rdev_set_badblocks);
> 
> I think it would be better if all exported functions in md.c have
> prefixed 'md_'.
> 

Probably good advice.  I don't think I'll change it now but maybe in a
subsequent patch so that I change them all at once.

Thanks,
NeilBrown

commit 0980048be17a45ae9e181ad04a549c31a499dee9
Author: NeilBrown <neilb@suse.de>
Date:   Tue Jul 26 12:22:08 2011 +1000

    md: beginnings of bad block management.
    
    This the first step in allowing md to track bad-blocks per-device so
    that we can fail individual blocks rather than the whole device.
    
    This patch just adds a data structure for recording bad blocks, with
    routines to add, remove, search the list.
    
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7caa096..a9b853b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1952,6 +1952,9 @@ static void unbind_rdev_from_array(mdk_rdev_t * rdev)
 	sysfs_remove_link(&rdev->kobj, "block");
 	sysfs_put(rdev->sysfs_state);
 	rdev->sysfs_state = NULL;
+	kfree(rdev->badblocks.page);
+	rdev->badblocks.count = 0;
+	rdev->badblocks.page = NULL;
 	/* We need to delay this, otherwise we can deadlock when
 	 * writing to 'remove' to "dev/state".  We also need
 	 * to delay it due to rcu usage.
@@ -2778,7 +2781,7 @@ static struct kobj_type rdev_ktype = {
 	.default_attrs	= rdev_default_attrs,
 };
 
-void md_rdev_init(mdk_rdev_t *rdev)
+int md_rdev_init(mdk_rdev_t *rdev)
 {
 	rdev->desc_nr = -1;
 	rdev->saved_raid_disk = -1;
@@ -2794,6 +2797,19 @@ void md_rdev_init(mdk_rdev_t *rdev)
 
 	INIT_LIST_HEAD(&rdev->same_set);
 	init_waitqueue_head(&rdev->blocked_wait);
+
+	/* Add space to store bad block list.
+	 * This reserves the space even on arrays where it cannot
+	 * be used - I wonder if that matters
+	 */
+	rdev->badblocks.count = 0;
+	rdev->badblocks.shift = 0;
+	rdev->badblocks.page = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	seqlock_init(&rdev->badblocks.lock);
+	if (rdev->badblocks.page == NULL)
+		return -ENOMEM;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(md_rdev_init);
 /*
@@ -2819,8 +2835,11 @@ static mdk_rdev_t *md_import_device(dev_t newdev, int super_format, int super_mi
 		return ERR_PTR(-ENOMEM);
 	}
 
-	md_rdev_init(rdev);
-	if ((err = alloc_disk_sb(rdev)))
+	err = md_rdev_init(rdev);
+	if (err)
+		goto abort_free;
+	err = alloc_disk_sb(rdev);
+	if (err)
 		goto abort_free;
 
 	err = lock_rdev(rdev, newdev, super_format == -2);
@@ -7326,6 +7345,395 @@ void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev)
 }
 EXPORT_SYMBOL(md_wait_for_blocked_rdev);
 
+
+/* Bad block management.
+ * We can record which blocks on each device are 'bad' and so just
+ * fail those blocks, or that stripe, rather than the whole device.
+ * Entries in the bad-block table are 64bits wide.  This comprises:
+ * Length of bad-range, in sectors: 0-511 for lengths 1-512
+ * Start of bad-range, sector offset, 54 bits (allows 8 exbibytes)
+ *  A 'shift' can be set so that larger blocks are tracked and
+ *  consequently larger devices can be covered.
+ * 'Acknowledged' flag - 1 bit. - the most significant bit.
+ *
+ * Locking of the bad-block table uses a seqlock so md_is_badblock
+ * might need to retry if it is very unlucky.
+ * We will sometimes want to check for bad blocks in a bi_end_io function,
+ * so we use the write_seqlock_irq variant.
+ *
+ * When looking for a bad block we specify a range and want to
+ * know if any block in the range is bad.  So we binary-search
+ * to the last range that starts at-or-before the given endpoint,
+ * (or "before the sector after the target range")
+ * then see if it ends after the given start.
+ * We return
+ *  0 if there are no known bad blocks in the range
+ *  1 if there are known bad block which are all acknowledged
+ * -1 if there are bad blocks which have not yet been acknowledged in metadata.
+ * plus the start/length of the first bad section we overlap.
+ */
+int md_is_badblock(struct badblocks *bb, sector_t s, int sectors,
+		   sector_t *first_bad, int *bad_sectors)
+{
+	int hi;
+	int lo = 0;
+	u64 *p = bb->page;
+	int rv = 0;
+	sector_t target = s + sectors;
+	unsigned seq;
+
+	if (bb->shift > 0) {
+		/* round the start down, and the end up */
+		s >>= bb->shift;
+		target += (1<<bb->shift) - 1;
+		target >>= bb->shift;
+		sectors = target - s;
+	}
+	/* 'target' is now the first block after the bad range */
+
+retry:
+	seq = read_seqbegin(&bb->lock);
+
+	hi = bb->count;
+
+	/* Binary search between lo and hi for 'target'
+	 * i.e. for the last range that starts before 'target'
+	 */
+	/* INVARIANT: ranges before 'lo' and at-or-after 'hi'
+	 * are known not to be the last range before target.
+	 * VARIANT: hi-lo is the number of possible
+	 * ranges, and decreases until it reaches 1
+	 */
+	while (hi - lo > 1) {
+		int mid = (lo + hi) / 2;
+		sector_t a = BB_OFFSET(p[mid]);
+		if (a < target)
+			/* This could still be the one, earlier ranges
+			 * could not. */
+			lo = mid;
+		else
+			/* This and later ranges are definitely out. */
+			hi = mid;
+	}
+	/* 'lo' might be the last that started before target, but 'hi' isn't */
+	if (hi > lo) {
+		/* need to check all range that end after 's' to see if
+		 * any are unacknowledged.
+		 */
+		while (lo >= 0 &&
+		       BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > s) {
+			if (BB_OFFSET(p[lo]) < target) {
+				/* starts before the end, and finishes after
+				 * the start, so they must overlap
+				 */
+				if (rv != -1 && BB_ACK(p[lo]))
+					rv = 1;
+				else
+					rv = -1;
+				*first_bad = BB_OFFSET(p[lo]);
+				*bad_sectors = BB_LEN(p[lo]);
+			}
+			lo--;
+		}
+	}
+
+	if (read_seqretry(&bb->lock, seq))
+		goto retry;
+
+	return rv;
+}
+EXPORT_SYMBOL_GPL(md_is_badblock);
+
+/*
+ * Add a range of bad blocks to the table.
+ * This might extend the table, or might contract it
+ * if two adjacent ranges can be merged.
+ * We binary-search to find the 'insertion' point, then
+ * decide how best to handle it.
+ */
+static int md_set_badblocks(struct badblocks *bb, sector_t s, int sectors,
+			    int acknowledged)
+{
+	u64 *p;
+	int lo, hi;
+	int rv = 1;
+
+	if (bb->shift < 0)
+		/* badblocks are disabled */
+		return 0;
+
+	if (bb->shift) {
+		/* round the start down, and the end up */
+		sector_t next = s + sectors;
+		s >>= bb->shift;
+		next += (1<<bb->shift) - 1;
+		next >>= bb->shift;
+		sectors = next - s;
+	}
+
+	write_seqlock_irq(&bb->lock);
+
+	p = bb->page;
+	lo = 0;
+	hi = bb->count;
+	/* Find the last range that starts at-or-before 's' */
+	while (hi - lo > 1) {
+		int mid = (lo + hi) / 2;
+		sector_t a = BB_OFFSET(p[mid]);
+		if (a <= s)
+			lo = mid;
+		else
+			hi = mid;
+	}
+	if (hi > lo && BB_OFFSET(p[lo]) > s)
+		hi = lo;
+
+	if (hi > lo) {
+		/* we found a range that might merge with the start
+		 * of our new range
+		 */
+		sector_t a = BB_OFFSET(p[lo]);
+		sector_t e = a + BB_LEN(p[lo]);
+		int ack = BB_ACK(p[lo]);
+		if (e >= s) {
+			/* Yes, we can merge with a previous range */
+			if (s == a && s + sectors >= e)
+				/* new range covers old */
+				ack = acknowledged;
+			else
+				ack = ack && acknowledged;
+
+			if (e < s + sectors)
+				e = s + sectors;
+			if (e - a <= BB_MAX_LEN) {
+				p[lo] = BB_MAKE(a, e-a, ack);
+				s = e;
+			} else {
+				/* does not all fit in one range,
+				 * make p[lo] maximal
+				 */
+				if (BB_LEN(p[lo]) != BB_MAX_LEN)
+					p[lo] = BB_MAKE(a, BB_MAX_LEN, ack);
+				s = a + BB_MAX_LEN;
+			}
+			sectors = e - s;
+		}
+	}
+	if (sectors && hi < bb->count) {
+		/* 'hi' points to the first range that starts after 's'.
+		 * Maybe we can merge with the start of that range */
+		sector_t a = BB_OFFSET(p[hi]);
+		sector_t e = a + BB_LEN(p[hi]);
+		int ack = BB_ACK(p[hi]);
+		if (a <= s + sectors) {
+			/* merging is possible */
+			if (e <= s + sectors) {
+				/* full overlap */
+				e = s + sectors;
+				ack = acknowledged;
+			} else
+				ack = ack && acknowledged;
+
+			a = s;
+			if (e - a <= BB_MAX_LEN) {
+				p[hi] = BB_MAKE(a, e-a, ack);
+				s = e;
+			} else {
+				p[hi] = BB_MAKE(a, BB_MAX_LEN, ack);
+				s = a + BB_MAX_LEN;
+			}
+			sectors = e - s;
+			lo = hi;
+			hi++;
+		}
+	}
+	if (sectors == 0 && hi < bb->count) {
+		/* we might be able to combine lo and hi */
+		/* Note: 's' is at the end of 'lo' */
+		sector_t a = BB_OFFSET(p[hi]);
+		int lolen = BB_LEN(p[lo]);
+		int hilen = BB_LEN(p[hi]);
+		int newlen = lolen + hilen - (s - a);
+		if (s >= a && newlen < BB_MAX_LEN) {
+			/* yes, we can combine them */
+			int ack = BB_ACK(p[lo]) && BB_ACK(p[hi]);
+			p[lo] = BB_MAKE(BB_OFFSET(p[lo]), newlen, ack);
+			memmove(p + hi, p + hi + 1,
+				(bb->count - hi - 1) * 8);
+			bb->count--;
+		}
+	}
+	while (sectors) {
+		/* didn't merge (it all).
+		 * Need to add a range just before 'hi' */
+		if (bb->count >= MD_MAX_BADBLOCKS) {
+			/* No room for more */
+			rv = 0;
+			break;
+		} else {
+			int this_sectors = sectors;
+			memmove(p + hi + 1, p + hi,
+				(bb->count - hi) * 8);
+			bb->count++;
+
+			if (this_sectors > BB_MAX_LEN)
+				this_sectors = BB_MAX_LEN;
+			p[hi] = BB_MAKE(s, this_sectors, acknowledged);
+			sectors -= this_sectors;
+			s += this_sectors;
+		}
+	}
+
+	bb->changed = 1;
+	write_sequnlock_irq(&bb->lock);
+
+	return rv;
+}
+
+int rdev_set_badblocks(mdk_rdev_t *rdev, sector_t s, int sectors,
+		       int acknowledged)
+{
+	int rv = md_set_badblocks(&rdev->badblocks,
+				  s + rdev->data_offset, sectors, acknowledged);
+	if (rv) {
+		/* Make sure they get written out promptly */
+		set_bit(MD_CHANGE_CLEAN, &rdev->mddev->flags);
+		md_wakeup_thread(rdev->mddev->thread);
+	}
+	return rv;
+}
+EXPORT_SYMBOL_GPL(rdev_set_badblocks);
+
+/*
+ * Remove a range of bad blocks from the table.
+ * This may involve extending the table if we spilt a region,
+ * but it must not fail.  So if the table becomes full, we just
+ * drop the remove request.
+ */
+static int md_clear_badblocks(struct badblocks *bb, sector_t s, int sectors)
+{
+	u64 *p;
+	int lo, hi;
+	sector_t target = s + sectors;
+	int rv = 0;
+
+	if (bb->shift > 0) {
+		/* When clearing we round the start up and the end down.
+		 * This should not matter as the shift should align with
+		 * the block size and no rounding should ever be needed.
+		 * However it is better the think a block is bad when it
+		 * isn't than to think a block is not bad when it is.
+		 */
+		s += (1<<bb->shift) - 1;
+		s >>= bb->shift;
+		target >>= bb->shift;
+		sectors = target - s;
+	}
+
+	write_seqlock_irq(&bb->lock);
+
+	p = bb->page;
+	lo = 0;
+	hi = bb->count;
+	/* Find the last range that starts before 'target' */
+	while (hi - lo > 1) {
+		int mid = (lo + hi) / 2;
+		sector_t a = BB_OFFSET(p[mid]);
+		if (a < target)
+			lo = mid;
+		else
+			hi = mid;
+	}
+	if (hi > lo) {
+		/* p[lo] is the last range that could overlap the
+		 * current range.  Earlier ranges could also overlap,
+		 * but only this one can overlap the end of the range.
+		 */
+		if (BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > target) {
+			/* Partial overlap, leave the tail of this range */
+			int ack = BB_ACK(p[lo]);
+			sector_t a = BB_OFFSET(p[lo]);
+			sector_t end = a + BB_LEN(p[lo]);
+
+			if (a < s) {
+				/* we need to split this range */
+				if (bb->count >= MD_MAX_BADBLOCKS) {
+					rv = 0;
+					goto out;
+				}
+				memmove(p+lo+1, p+lo, (bb->count - lo) * 8);
+				bb->count++;
+				p[lo] = BB_MAKE(a, s-a, ack);
+				lo++;
+			}
+			p[lo] = BB_MAKE(target, end - target, ack);
+			/* there is no longer an overlap */
+			hi = lo;
+			lo--;
+		}
+		while (lo >= 0 &&
+		       BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > s) {
+			/* This range does overlap */
+			if (BB_OFFSET(p[lo]) < s) {
+				/* Keep the early parts of this range. */
+				int ack = BB_ACK(p[lo]);
+				sector_t start = BB_OFFSET(p[lo]);
+				p[lo] = BB_MAKE(start, s - start, ack);
+				/* now low doesn't overlap, so.. */
+				break;
+			}
+			lo--;
+		}
+		/* 'lo' is strictly before, 'hi' is strictly after,
+		 * anything between needs to be discarded
+		 */
+		if (hi - lo > 1) {
+			memmove(p+lo+1, p+hi, (bb->count - hi) * 8);
+			bb->count -= (hi - lo - 1);
+		}
+	}
+
+	bb->changed = 1;
+out:
+	write_sequnlock_irq(&bb->lock);
+	return rv;
+}
+
+int rdev_clear_badblocks(mdk_rdev_t *rdev, sector_t s, int sectors)
+{
+	return md_clear_badblocks(&rdev->badblocks,
+				  s + rdev->data_offset,
+				  sectors);
+}
+EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
+
+/*
+ * Acknowledge all bad blocks in a list.
+ * This only succeeds if ->changed is clear.  It is used by
+ * in-kernel metadata updates
+ */
+void md_ack_all_badblocks(struct badblocks *bb)
+{
+	if (bb->page == NULL || bb->changed)
+		/* no point even trying */
+		return;
+	write_seqlock_irq(&bb->lock);
+
+	if (bb->changed == 0) {
+		u64 *p = bb->page;
+		int i;
+		for (i = 0; i < bb->count ; i++) {
+			if (!BB_ACK(p[i])) {
+				sector_t start = BB_OFFSET(p[i]);
+				int len = BB_LEN(p[i]);
+				p[i] = BB_MAKE(start, len, 1);
+			}
+		}
+	}
+	write_sequnlock_irq(&bb->lock);
+}
+EXPORT_SYMBOL_GPL(md_ack_all_badblocks);
+
 static int md_notify_reboot(struct notifier_block *this,
 			    unsigned long code, void *x)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7d906a9..85af843 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -29,6 +29,13 @@
 typedef struct mddev_s mddev_t;
 typedef struct mdk_rdev_s mdk_rdev_t;
 
+/* Bad block numbers are stored sorted in a single page.
+ * 64bits is used for each block or extent.
+ * 54 bits are sector number, 9 bits are extent size,
+ * 1 bit is an 'acknowledged' flag.
+ */
+#define MD_MAX_BADBLOCKS	(PAGE_SIZE/8)
+
 /*
  * MD's 'extended' device
  */
@@ -111,8 +118,47 @@ struct mdk_rdev_s
 
 	struct sysfs_dirent *sysfs_state; /* handle for 'state'
 					   * sysfs entry */
+
+	struct badblocks {
+		int	count;		/* count of bad blocks */
+		int	shift;		/* shift from sectors to block size
+					 * a -ve shift means badblocks are
+					 * disabled.*/
+		u64	*page;		/* badblock list */
+		int	changed;
+		seqlock_t lock;
+	} badblocks;
 };
 
+#define BB_LEN_MASK	(0x00000000000001FFULL)
+#define BB_OFFSET_MASK	(0x7FFFFFFFFFFFFE00ULL)
+#define BB_ACK_MASK	(0x8000000000000000ULL)
+#define BB_MAX_LEN	512
+#define BB_OFFSET(x)	(((x) & BB_OFFSET_MASK) >> 9)
+#define BB_LEN(x)	(((x) & BB_LEN_MASK) + 1)
+#define BB_ACK(x)	(!!((x) & BB_ACK_MASK))
+#define BB_MAKE(a, l, ack) (((a)<<9) | ((l)-1) | ((u64)(!!(ack)) << 63))
+
+extern int md_is_badblock(struct badblocks *bb, sector_t s, int sectors,
+			  sector_t *first_bad, int *bad_sectors);
+static inline int is_badblock(mdk_rdev_t *rdev, sector_t s, int sectors,
+			      sector_t *first_bad, int *bad_sectors)
+{
+	if (unlikely(rdev->badblocks.count)) {
+		int rv = md_is_badblock(&rdev->badblocks, rdev->data_offset + s,
+					sectors,
+					first_bad, bad_sectors);
+		if (rv)
+			*first_bad -= rdev->data_offset;
+		return rv;
+	}
+	return 0;
+}
+extern int rdev_set_badblocks(mdk_rdev_t *rdev, sector_t s, int sectors,
+			      int acknowledged);
+extern int rdev_clear_badblocks(mdk_rdev_t *rdev, sector_t s, int sectors);
+extern void md_ack_all_badblocks(struct badblocks *bb);
+
 struct mddev_s
 {
 	void				*private;
@@ -517,7 +563,7 @@ extern void mddev_init(mddev_t *mddev);
 extern int md_run(mddev_t *mddev);
 extern void md_stop(mddev_t *mddev);
 extern void md_stop_writes(mddev_t *mddev);
-extern void md_rdev_init(mdk_rdev_t *rdev);
+extern int md_rdev_init(mdk_rdev_t *rdev);
 
 extern void mddev_suspend(mddev_t *mddev);
 extern void mddev_resume(mddev_t *mddev);

