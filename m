From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH git-md-accel 1/2] raid5: refactor handle_stripe5 and
	handle_stripe6
Date: Mon, 18 Jun 2007 14:07:24 -0700
Message-ID: <20070618210724.19865.94357.stgit@dwillia2-linux.ch.intel.com>
References: <20070618210546.19865.7170.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070618210546.19865.7170.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

handle_stripe5 and handle_stripe6 have very deep logic paths handling the
various states of a stripe_head.  By introducing the 'stripe_head_state'
and 'r6_state' objects, large portions of the logic can be moved to
sub-routines.

'struct stripe_head_state' consumes all of the automatic variables that previously
stood alone in handle_stripe5,6.  'struct r6_state' contains the handle_stripe6
specific variables like p_failed and q_failed.

One of the nice side effects of the 'stripe_head_state' change is that it
allows for further reductions in code duplication between raid5 and raid6.
The following new routines are shared between raid5 and raid6:

	handle_completed_write_requests
	handle_requests_to_failed_array
	handle_stripe_expansion

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c         | 1484 +++++++++++++++++++++-----------------------
 include/linux/raid/raid5.h |   16 
 2 files changed, 733 insertions(+), 767 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4f51dfa..68834d2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1326,6 +1326,604 @@ static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks)
 	return pd_idx;
 }
 
+static void
+handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
+				struct stripe_head_state *s, int disks,
+				struct bio **return_bi)
+{
+	int i;
+	for (i = disks; i--;) {
+		struct bio *bi;
+		int bitmap_end = 0;
+
+		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
+			mdk_rdev_t *rdev;
+			rcu_read_lock();
+			rdev = rcu_dereference(conf->disks[i].rdev);
+			if (rdev && test_bit(In_sync, &rdev->flags))
+				/* multiple read failures in one stripe */
+				md_error(conf->mddev, rdev);
+			rcu_read_unlock();
+		}
+		spin_lock_irq(&conf->device_lock);
+		/* fail all writes first */
+		bi = sh->dev[i].towrite;
+		sh->dev[i].towrite = NULL;
+		if (bi) {
+			s->to_write--;
+			bitmap_end = 1;
+		}
+
+		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+			wake_up(&conf->wait_for_overlap);
+
+		while (bi && bi->bi_sector <
+			sh->dev[i].sector + STRIPE_SECTORS) {
+			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
+			clear_bit(BIO_UPTODATE, &bi->bi_flags);
+			if (--bi->bi_phys_segments == 0) {
+				md_write_end(conf->mddev);
+				bi->bi_next = *return_bi;
+				*return_bi = bi;
+			}
+			bi = nextbi;
+		}
+		/* and fail all 'written' */
+		bi = sh->dev[i].written;
+		sh->dev[i].written = NULL;
+		if (bi) bitmap_end = 1;
+		while (bi && bi->bi_sector <
+		       sh->dev[i].sector + STRIPE_SECTORS) {
+			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
+			clear_bit(BIO_UPTODATE, &bi->bi_flags);
+			if (--bi->bi_phys_segments == 0) {
+				md_write_end(conf->mddev);
+				bi->bi_next = *return_bi;
+				*return_bi = bi;
+			}
+			bi = bi2;
+		}
+
+		/* fail any reads if this device is non-operational */
+		if (!test_bit(R5_Insync, &sh->dev[i].flags) ||
+		    test_bit(R5_ReadError, &sh->dev[i].flags)) {
+			bi = sh->dev[i].toread;
+			sh->dev[i].toread = NULL;
+			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+				wake_up(&conf->wait_for_overlap);
+			if (bi) s->to_read--;
+			while (bi && bi->bi_sector <
+			       sh->dev[i].sector + STRIPE_SECTORS) {
+				struct bio *nextbi =
+					r5_next_bio(bi, sh->dev[i].sector);
+				clear_bit(BIO_UPTODATE, &bi->bi_flags);
+				if (--bi->bi_phys_segments == 0) {
+					bi->bi_next = *return_bi;
+					*return_bi = bi;
+				}
+				bi = nextbi;
+			}
+		}
+		spin_unlock_irq(&conf->device_lock);
+		if (bitmap_end)
+			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+					STRIPE_SECTORS, 0, 0);
+	}
+
+}
+
+static void handle_issuing_new_read_requests5(struct stripe_head *sh,
+			struct stripe_head_state *s, int disks)
+{
+	int i;
+	for (i = disks; i--;) {
+		struct r5dev *dev = &sh->dev[i];
+		if (!test_bit(R5_LOCKED, &dev->flags) &&
+		    !test_bit(R5_UPTODATE, &dev->flags) &&
+		    (dev->toread ||
+		     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
+		     s->syncing || s->expanding ||
+		     (s->failed && (sh->dev[s->failed_num].toread ||
+			(sh->dev[s->failed_num].towrite &&
+			!test_bit(R5_OVERWRITE, &sh->dev[s->failed_num].flags))
+		      )))) {
+			/* we would like to get this block, possibly
+			 * by computing it, but we might not be able to
+			 */
+			if (s->uptodate == disks-1) {
+				PRINTK("Computing block %d\n", i);
+				compute_block(sh, i);
+				s->uptodate++;
+			} else if (test_bit(R5_Insync, &dev->flags)) {
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantread, &dev->flags);
+				s->locked++;
+				PRINTK("Reading block %d (sync=%d)\n",
+					i, s->syncing);
+			}
+		}
+	}
+	set_bit(STRIPE_HANDLE, &sh->state);
+}
+
+static void handle_issuing_new_read_requests6(struct stripe_head *sh,
+			struct stripe_head_state *s, struct r6_state *r6s,
+			int disks)
+{
+	int i;
+	for (i = disks; i--;) {
+		struct r5dev *dev = &sh->dev[i];
+		if (!test_bit(R5_LOCKED, &dev->flags) &&
+		    !test_bit(R5_UPTODATE, &dev->flags) &&
+		    (dev->toread || (dev->towrite &&
+		     !test_bit(R5_OVERWRITE, &dev->flags)) ||
+		     s->syncing || s->expanding ||
+		     (s->failed >= 1 &&
+		      (sh->dev[r6s->failed_num[0]].toread ||
+		       s->to_write)) ||
+		     (s->failed >= 2 &&
+		      (sh->dev[r6s->failed_num[1]].toread ||
+		       s->to_write)))) {
+			/* we would like to get this block, possibly
+			 * by computing it, but we might not be able to
+			 */
+			if (s->uptodate == disks-1) {
+				PRINTK("Computing stripe %llu block %d\n",
+				       (unsigned long long)sh->sector, i);
+				compute_block_1(sh, i, 0);
+				s->uptodate++;
+			} else if ( s->uptodate == disks-2 && s->failed >= 2 ) {
+				/* Computing 2-failure is *very* expensive; only
+				 * do it if failed >= 2
+				 */
+				int other;
+				for (other = disks; other--;) {
+					if (other == i)
+						continue;
+					if (!test_bit(R5_UPTODATE,
+					      &sh->dev[other].flags))
+						break;
+				}
+				BUG_ON(other < 0);
+				PRINTK("Computing stripe %llu blocks %d,%d\n",
+				       (unsigned long long)sh->sector,
+				       i, other);
+				compute_block_2(sh, i, other);
+				s->uptodate += 2;
+			} else if (test_bit(R5_Insync, &dev->flags)) {
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantread, &dev->flags);
+				s->locked++;
+				PRINTK("Reading block %d (sync=%d)\n",
+					i, s->syncing);
+			}
+		}
+	}
+	set_bit(STRIPE_HANDLE, &sh->state);
+}
+
+
+/* handle_completed_write_requests
+ * any written block on an uptodate or failed drive can be returned.
+ * Note that if we 'wrote' to a failed drive, it will be UPTODATE, but
+ * never LOCKED, so we don't need to test 'failed' directly.
+ */
+static void handle_completed_write_requests(raid5_conf_t *conf,
+	struct stripe_head *sh, int disks, struct bio **return_bi)
+{
+	int i;
+	struct r5dev *dev;
+
+	for (i = disks; i--;)
+		if (sh->dev[i].written) {
+			dev = &sh->dev[i];
+			if (!test_bit(R5_LOCKED, &dev->flags) &&
+				test_bit(R5_UPTODATE, &dev->flags)) {
+				/* We can return any write requests */
+				struct bio *wbi, *wbi2;
+				int bitmap_end = 0;
+				PRINTK("Return write for disc %d\n", i);
+				spin_lock_irq(&conf->device_lock);
+				wbi = dev->written;
+				dev->written = NULL;
+				while (wbi && wbi->bi_sector <
+					dev->sector + STRIPE_SECTORS) {
+					wbi2 = r5_next_bio(wbi, dev->sector);
+					if (--wbi->bi_phys_segments == 0) {
+						md_write_end(conf->mddev);
+						wbi->bi_next = *return_bi;
+						*return_bi = wbi;
+					}
+					wbi = wbi2;
+				}
+				if (dev->towrite == NULL)
+					bitmap_end = 1;
+				spin_unlock_irq(&conf->device_lock);
+				if (bitmap_end)
+					bitmap_endwrite(conf->mddev->bitmap,
+							sh->sector,
+							STRIPE_SECTORS,
+					 !test_bit(STRIPE_DEGRADED, &sh->state),
+							0);
+			}
+		}
+}
+
+static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
+		struct stripe_head *sh,	struct stripe_head_state *s, int disks)
+{
+	int rmw = 0, rcw = 0, i;
+	for (i = disks; i--;) {
+		/* would I have to read this buffer for read_modify_write */
+		struct r5dev *dev = &sh->dev[i];
+		if ((dev->towrite || i == sh->pd_idx) &&
+		    !test_bit(R5_LOCKED, &dev->flags) &&
+		    !test_bit(R5_UPTODATE, &dev->flags)) {
+			if (test_bit(R5_Insync, &dev->flags))
+				rmw++;
+			else rmw += 2*disks;  /* cannot read it */
+		}
+		/* Would I have to read this buffer for reconstruct_write */
+		if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
+		    !test_bit(R5_LOCKED, &dev->flags) &&
+		    !test_bit(R5_UPTODATE, &dev->flags)) {
+			if (test_bit(R5_Insync, &dev->flags)) rcw++;
+			else rcw += 2*disks;
+		}
+	}
+	PRINTK("for sector %llu, rmw=%d rcw=%d\n",
+		(unsigned long long)sh->sector, rmw, rcw);
+	set_bit(STRIPE_HANDLE, &sh->state);
+	if (rmw < rcw && rmw > 0)
+		/* prefer read-modify-write, but need to get some data */
+		for (i = disks; i--;) {
+			struct r5dev *dev = &sh->dev[i];
+			if ((dev->towrite || i == sh->pd_idx) &&
+			    !test_bit(R5_LOCKED, &dev->flags) &&
+			    !test_bit(R5_UPTODATE, &dev->flags) &&
+			    test_bit(R5_Insync, &dev->flags)) {
+				if (
+				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+					PRINTK("Read_old block "
+						"%d for r-m-w\n", i);
+					set_bit(R5_LOCKED, &dev->flags);
+					set_bit(R5_Wantread, &dev->flags);
+					s->locked++;
+				} else {
+					set_bit(STRIPE_DELAYED, &sh->state);
+					set_bit(STRIPE_HANDLE, &sh->state);
+				}
+			}
+		}
+	if (rcw <= rmw && rcw > 0)
+		/* want reconstruct write, but need to get some data */
+		for (i = disks; i--;) {
+			struct r5dev *dev = &sh->dev[i];
+			if (!test_bit(R5_OVERWRITE, &dev->flags) &&
+			    i != sh->pd_idx &&
+			    !test_bit(R5_LOCKED, &dev->flags) &&
+			    !test_bit(R5_UPTODATE, &dev->flags) &&
+			    test_bit(R5_Insync, &dev->flags)) {
+				if (
+				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+					PRINTK("Read_old block "
+						"%d for Reconstruct\n", i);
+					set_bit(R5_LOCKED, &dev->flags);
+					set_bit(R5_Wantread, &dev->flags);
+					s->locked++;
+				} else {
+					set_bit(STRIPE_DELAYED, &sh->state);
+					set_bit(STRIPE_HANDLE, &sh->state);
+				}
+			}
+		}
+	/* now if nothing is locked, and if we have enough data,
+	 * we can start a write request
+	 */
+	if (s->locked == 0 && (rcw == 0 || rmw == 0) &&
+	    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
+		PRINTK("Computing parity...\n");
+		compute_parity5(sh, rcw == 0 ?
+			RECONSTRUCT_WRITE : READ_MODIFY_WRITE);
+		/* now every locked buffer is ready to be written */
+		for (i = disks; i--;)
+			if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
+				PRINTK("Writing block %d\n", i);
+				s->locked++;
+				set_bit(R5_Wantwrite, &sh->dev[i].flags);
+				if (!test_bit(R5_Insync, &sh->dev[i].flags)
+				    || (i == sh->pd_idx && s->failed == 0))
+					set_bit(STRIPE_INSYNC, &sh->state);
+			}
+		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+			atomic_dec(&conf->preread_active_stripes);
+			if (atomic_read(&conf->preread_active_stripes) <
+			    IO_THRESHOLD)
+				md_wakeup_thread(conf->mddev->thread);
+		}
+	}
+}
+
+static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
+		struct stripe_head *sh,	struct stripe_head_state *s,
+		struct r6_state *r6s, int disks)
+{
+	int rcw = 0, must_compute = 0, pd_idx = sh->pd_idx, i;
+	int qd_idx = r6s->qd_idx;
+	for (i = disks; i--;) {
+		struct r5dev *dev = &sh->dev[i];
+		/* Would I have to read this buffer for reconstruct_write */
+		if (!test_bit(R5_OVERWRITE, &dev->flags)
+		    && i != pd_idx && i != qd_idx
+		    && (!test_bit(R5_LOCKED, &dev->flags)
+			    ) &&
+		    !test_bit(R5_UPTODATE, &dev->flags)) {
+			if (test_bit(R5_Insync, &dev->flags)) rcw++;
+			else {
+				PRINTK("raid6: must_compute: "
+					"disk %d flags=%#lx\n", i, dev->flags);
+				must_compute++;
+			}
+		}
+	}
+	PRINTK("for sector %llu, rcw=%d, must_compute=%d\n",
+	       (unsigned long long)sh->sector, rcw, must_compute);
+	set_bit(STRIPE_HANDLE, &sh->state);
+
+	if (rcw > 0)
+		/* want reconstruct write, but need to get some data */
+		for (i = disks; i--;) {
+			struct r5dev *dev = &sh->dev[i];
+			if (!test_bit(R5_OVERWRITE, &dev->flags)
+			    && !(s->failed == 0 && (i == pd_idx || i == qd_idx))
+			    && !test_bit(R5_LOCKED, &dev->flags) &&
+			    !test_bit(R5_UPTODATE, &dev->flags) &&
+			    test_bit(R5_Insync, &dev->flags)) {
+				if (
+				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+					PRINTK("Read_old stripe %llu "
+						"block %d for Reconstruct\n",
+					     (unsigned long long)sh->sector, i);
+					set_bit(R5_LOCKED, &dev->flags);
+					set_bit(R5_Wantread, &dev->flags);
+					s->locked++;
+				} else {
+					PRINTK("Request delayed stripe %llu "
+						"block %d for Reconstruct\n",
+					     (unsigned long long)sh->sector, i);
+					set_bit(STRIPE_DELAYED, &sh->state);
+					set_bit(STRIPE_HANDLE, &sh->state);
+				}
+			}
+		}
+	/* now if nothing is locked, and if we have enough data, we can start a
+	 * write request
+	 */
+	if (s->locked == 0 && rcw == 0 &&
+	    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
+		if (must_compute > 0) {
+			/* We have failed blocks and need to compute them */
+			switch (s->failed) {
+			case 0:
+				BUG();
+			case 1:
+				compute_block_1(sh, r6s->failed_num[0], 0);
+				break;
+			case 2:
+				compute_block_2(sh, r6s->failed_num[0],
+						r6s->failed_num[1]);
+				break;
+			default: /* This request should have been failed? */
+				BUG();
+			}
+		}
+
+		PRINTK("Computing parity for stripe %llu\n",
+			(unsigned long long)sh->sector);
+		compute_parity6(sh, RECONSTRUCT_WRITE);
+		/* now every locked buffer is ready to be written */
+		for (i = disks; i--;)
+			if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
+				PRINTK("Writing stripe %llu block %d\n",
+				       (unsigned long long)sh->sector, i);
+				s->locked++;
+				set_bit(R5_Wantwrite, &sh->dev[i].flags);
+			}
+		/* after a RECONSTRUCT_WRITE, the stripe MUST be in-sync */
+		set_bit(STRIPE_INSYNC, &sh->state);
+
+		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+			atomic_dec(&conf->preread_active_stripes);
+			if (atomic_read(&conf->preread_active_stripes) <
+			    IO_THRESHOLD)
+				md_wakeup_thread(conf->mddev->thread);
+		}
+	}
+}
+
+static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
+				struct stripe_head_state *s, int disks)
+{
+	set_bit(STRIPE_HANDLE, &sh->state);
+	if (s->failed == 0) {
+		BUG_ON(s->uptodate != disks);
+		compute_parity5(sh, CHECK_PARITY);
+		s->uptodate--;
+		if (page_is_zero(sh->dev[sh->pd_idx].page)) {
+			/* parity is correct (on disc, not in buffer any more)
+			 */
+			set_bit(STRIPE_INSYNC, &sh->state);
+		} else {
+			conf->mddev->resync_mismatches += STRIPE_SECTORS;
+			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
+				/* don't try to repair!! */
+				set_bit(STRIPE_INSYNC, &sh->state);
+			else {
+				compute_block(sh, sh->pd_idx);
+				s->uptodate++;
+			}
+		}
+	}
+	if (!test_bit(STRIPE_INSYNC, &sh->state)) {
+		struct r5dev *dev;
+		/* either failed parity check, or recovery is happening */
+		if (s->failed == 0)
+			s->failed_num = sh->pd_idx;
+		dev = &sh->dev[s->failed_num];
+		BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
+		BUG_ON(s->uptodate != disks);
+
+		set_bit(R5_LOCKED, &dev->flags);
+		set_bit(R5_Wantwrite, &dev->flags);
+		clear_bit(STRIPE_DEGRADED, &sh->state);
+		s->locked++;
+		set_bit(STRIPE_INSYNC, &sh->state);
+	}
+}
+
+
+static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
+				struct stripe_head_state *s,
+				struct r6_state *r6s, struct page *tmp_page,
+				int disks)
+{
+	int update_p = 0, update_q = 0;
+	struct r5dev *dev;
+	int pd_idx = sh->pd_idx;
+	int qd_idx = r6s->qd_idx;
+
+	set_bit(STRIPE_HANDLE, &sh->state);
+
+	BUG_ON(s->failed > 2);
+	BUG_ON(s->uptodate < disks);
+	/* Want to check and possibly repair P and Q.
+	 * However there could be one 'failed' device, in which
+	 * case we can only check one of them, possibly using the
+	 * other to generate missing data
+	 */
+
+	/* If !tmp_page, we cannot do the calculations,
+	 * but as we have set STRIPE_HANDLE, we will soon be called
+	 * by stripe_handle with a tmp_page - just wait until then.
+	 */
+	if (tmp_page) {
+		if (s->failed == r6s->q_failed) {
+			/* The only possible failed device holds 'Q', so it
+			 * makes sense to check P (If anything else were failed,
+			 * we would have used P to recreate it).
+			 */
+			compute_block_1(sh, pd_idx, 1);
+			if (!page_is_zero(sh->dev[pd_idx].page)) {
+				compute_block_1(sh, pd_idx, 0);
+				update_p = 1;
+			}
+		}
+		if (!r6s->q_failed && s->failed < 2) {
+			/* q is not failed, and we didn't use it to generate
+			 * anything, so it makes sense to check it
+			 */
+			memcpy(page_address(tmp_page),
+			       page_address(sh->dev[qd_idx].page),
+			       STRIPE_SIZE);
+			compute_parity6(sh, UPDATE_PARITY);
+			if (memcmp(page_address(tmp_page),
+				   page_address(sh->dev[qd_idx].page),
+				   STRIPE_SIZE) != 0) {
+				clear_bit(STRIPE_INSYNC, &sh->state);
+				update_q = 1;
+			}
+		}
+		if (update_p || update_q) {
+			conf->mddev->resync_mismatches += STRIPE_SECTORS;
+			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
+				/* don't try to repair!! */
+				update_p = update_q = 0;
+		}
+
+		/* now write out any block on a failed drive,
+		 * or P or Q if they need it
+		 */
+
+		if (s->failed == 2) {
+			dev = &sh->dev[r6s->failed_num[1]];
+			s->locked++;
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantwrite, &dev->flags);
+		}
+		if (s->failed >= 1) {
+			dev = &sh->dev[r6s->failed_num[0]];
+			s->locked++;
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantwrite, &dev->flags);
+		}
+
+		if (update_p) {
+			dev = &sh->dev[pd_idx];
+			s->locked ++;
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantwrite, &dev->flags);
+		}
+		if (update_q) {
+			dev = &sh->dev[qd_idx];
+			s->locked++;
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantwrite, &dev->flags);
+		}
+		clear_bit(STRIPE_DEGRADED, &sh->state);
+
+		set_bit(STRIPE_INSYNC, &sh->state);
+	}
+}
+
+static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
+				struct r6_state *r6s)
+{
+	int i;
+
+	/* We have read all the blocks in this stripe and now we need to
+	 * copy some of them into a target stripe for expand.
+	 */
+	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
+	for (i = 0; i < sh->disks; i++)
+		if (i != sh->pd_idx && (r6s && i != r6s->qd_idx)) {
+			int dd_idx, pd_idx, j;
+			struct stripe_head *sh2;
+
+			sector_t bn = compute_blocknr(sh, i);
+			sector_t s = raid5_compute_sector(bn, conf->raid_disks,
+						conf->raid_disks-1, &dd_idx,
+						&pd_idx, conf);
+			sh2 = get_active_stripe(conf, s, conf->raid_disks,
+						pd_idx, 1);
+			if (sh2 == NULL)
+				/* so far only the early blocks of this stripe
+				 * have been requested.  When later blocks
+				 * get requested, we will try again
+				 */
+				continue;
+			if (!test_bit(STRIPE_EXPANDING, &sh2->state) ||
+			   test_bit(R5_Expanded, &sh2->dev[dd_idx].flags)) {
+				/* must have already done this block */
+				release_stripe(sh2);
+				continue;
+			}
+			memcpy(page_address(sh2->dev[dd_idx].page),
+			       page_address(sh->dev[i].page),
+			       STRIPE_SIZE);
+			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
+			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
+			for (j = 0; j < conf->raid_disks; j++)
+				if (j != sh2->pd_idx &&
+				    (r6s && j != r6s->qd_idx) &&
+				    !test_bit(R5_Expanded, &sh2->dev[j].flags))
+					break;
+			if (j == conf->raid_disks) {
+				set_bit(STRIPE_EXPAND_READY, &sh2->state);
+				set_bit(STRIPE_HANDLE, &sh2->state);
+			}
+			release_stripe(sh2);
+		}
+}
 
 /*
  * handle_stripe - do things to a stripe.
@@ -1344,20 +1942,16 @@ static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks)
  * get BH_Lock set before the stripe lock is released.
  *
  */
- 
+
 static void handle_stripe5(struct stripe_head *sh)
 {
 	raid5_conf_t *conf = sh->raid_conf;
-	int disks = sh->disks;
-	struct bio *return_bi= NULL;
-	struct bio *bi;
-	int i;
-	int syncing, expanding, expanded;
-	int locked=0, uptodate=0, to_read=0, to_write=0, failed=0, written=0;
-	int non_overwrite = 0;
-	int failed_num=0;
+	int disks = sh->disks, i;
+	struct bio *return_bi = NULL, *bi;
+	struct stripe_head_state s;
 	struct r5dev *dev;
 
+	memset(&s, 0, sizeof(s));
 	PRINTK("handling stripe %llu, cnt=%d, pd_idx=%d\n",
 		(unsigned long long)sh->sector, atomic_read(&sh->count),
 		sh->pd_idx);
@@ -1366,15 +1960,15 @@ static void handle_stripe5(struct stripe_head *sh)
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
-	syncing = test_bit(STRIPE_SYNCING, &sh->state);
-	expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-	expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
+	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
+	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
+	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
 	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
-		dev = &sh->dev[i];
+		struct r5dev *dev = &sh->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
 
 		PRINTK("check %d: state 0x%lx read %p write %p written %p\n",
@@ -1403,17 +1997,18 @@ static void handle_stripe5(struct stripe_head *sh)
 		}
 
 		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev->flags)) locked++;
-		if (test_bit(R5_UPTODATE, &dev->flags)) uptodate++;
+		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
+		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
 
-		
-		if (dev->toread) to_read++;
+		if (dev->toread)
+			s.to_read++;
 		if (dev->towrite) {
-			to_write++;
+			s.to_write++;
 			if (!test_bit(R5_OVERWRITE, &dev->flags))
-				non_overwrite++;
+				s.non_overwrite++;
 		}
-		if (dev->written) written++;
+		if (dev->written)
+			s.written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
@@ -1422,306 +2017,59 @@ static void handle_stripe5(struct stripe_head *sh)
 		}
 		if (!rdev || !test_bit(In_sync, &rdev->flags)
 		    || test_bit(R5_ReadError, &dev->flags)) {
-			failed++;
-			failed_num = i;
+			s.failed++;
+			s.failed_num = i;
 		} else
 			set_bit(R5_Insync, &dev->flags);
 	}
 	rcu_read_unlock();
 	PRINTK("locked=%d uptodate=%d to_read=%d"
 		" to_write=%d failed=%d failed_num=%d\n",
-		locked, uptodate, to_read, to_write, failed, failed_num);
+		s.locked, s.uptodate, s.to_read, s.to_write,
+		s.failed, s.failed_num);
 	/* check if the array has lost two devices and, if so, some requests might
 	 * need to be failed
 	 */
-	if (failed > 1 && to_read+to_write+written) {
-		for (i=disks; i--; ) {
-			int bitmap_end = 0;
-
-			if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
-				mdk_rdev_t *rdev;
-				rcu_read_lock();
-				rdev = rcu_dereference(conf->disks[i].rdev);
-				if (rdev && test_bit(In_sync, &rdev->flags))
-					/* multiple read failures in one stripe */
-					md_error(conf->mddev, rdev);
-				rcu_read_unlock();
-			}
-
-			spin_lock_irq(&conf->device_lock);
-			/* fail all writes first */
-			bi = sh->dev[i].towrite;
-			sh->dev[i].towrite = NULL;
-			if (bi) { to_write--; bitmap_end = 1; }
-
-			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-				wake_up(&conf->wait_for_overlap);
-
-			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
-				struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
-				clear_bit(BIO_UPTODATE, &bi->bi_flags);
-				if (--bi->bi_phys_segments == 0) {
-					md_write_end(conf->mddev);
-					bi->bi_next = return_bi;
-					return_bi = bi;
-				}
-				bi = nextbi;
-			}
-			/* and fail all 'written' */
-			bi = sh->dev[i].written;
-			sh->dev[i].written = NULL;
-			if (bi) bitmap_end = 1;
-			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS) {
-				struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
-				clear_bit(BIO_UPTODATE, &bi->bi_flags);
-				if (--bi->bi_phys_segments == 0) {
-					md_write_end(conf->mddev);
-					bi->bi_next = return_bi;
-					return_bi = bi;
-				}
-				bi = bi2;
-			}
-
-			/* fail any reads if this device is non-operational */
-			if (!test_bit(R5_Insync, &sh->dev[i].flags) ||
-			    test_bit(R5_ReadError, &sh->dev[i].flags)) {
-				bi = sh->dev[i].toread;
-				sh->dev[i].toread = NULL;
-				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-					wake_up(&conf->wait_for_overlap);
-				if (bi) to_read--;
-				while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
-					struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
-					clear_bit(BIO_UPTODATE, &bi->bi_flags);
-					if (--bi->bi_phys_segments == 0) {
-						bi->bi_next = return_bi;
-						return_bi = bi;
-					}
-					bi = nextbi;
-				}
-			}
-			spin_unlock_irq(&conf->device_lock);
-			if (bitmap_end)
-				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-						STRIPE_SECTORS, 0, 0);
-		}
-	}
-	if (failed > 1 && syncing) {
+	if (s.failed > 1 && s.to_read+s.to_write+s.written)
+		handle_requests_to_failed_array(conf, sh, &s, disks,
+						&return_bi);
+	if (s.failed > 1 && s.syncing) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
-		syncing = 0;
+		s.syncing = 0;
 	}
 
 	/* might be able to return some write requests if the parity block
 	 * is safe, or on a failed drive
 	 */
 	dev = &sh->dev[sh->pd_idx];
-	if ( written &&
-	     ( (test_bit(R5_Insync, &dev->flags) && !test_bit(R5_LOCKED, &dev->flags) &&
-		test_bit(R5_UPTODATE, &dev->flags))
-	       || (failed == 1 && failed_num == sh->pd_idx))
-	    ) {
-	    /* any written block on an uptodate or failed drive can be returned.
-	     * Note that if we 'wrote' to a failed drive, it will be UPTODATE, but 
-	     * never LOCKED, so we don't need to test 'failed' directly.
-	     */
-	    for (i=disks; i--; )
-		if (sh->dev[i].written) {
-		    dev = &sh->dev[i];
-		    if (!test_bit(R5_LOCKED, &dev->flags) &&
-			 test_bit(R5_UPTODATE, &dev->flags) ) {
-			/* We can return any write requests */
-			    struct bio *wbi, *wbi2;
-			    int bitmap_end = 0;
-			    PRINTK("Return write for disc %d\n", i);
-			    spin_lock_irq(&conf->device_lock);
-			    wbi = dev->written;
-			    dev->written = NULL;
-			    while (wbi && wbi->bi_sector < dev->sector + STRIPE_SECTORS) {
-				    wbi2 = r5_next_bio(wbi, dev->sector);
-				    if (--wbi->bi_phys_segments == 0) {
-					    md_write_end(conf->mddev);
-					    wbi->bi_next = return_bi;
-					    return_bi = wbi;
-				    }
-				    wbi = wbi2;
-			    }
-			    if (dev->towrite == NULL)
-				    bitmap_end = 1;
-			    spin_unlock_irq(&conf->device_lock);
-			    if (bitmap_end)
-				    bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-						    STRIPE_SECTORS,
-						    !test_bit(STRIPE_DEGRADED, &sh->state), 0);
-		    }
-		}
-	}
+	if ( s.written &&
+	     ((test_bit(R5_Insync, &dev->flags) &&
+	       !test_bit(R5_LOCKED, &dev->flags) &&
+	       test_bit(R5_UPTODATE, &dev->flags)) ||
+	       (s.failed == 1 && s.failed_num == sh->pd_idx)))
+		handle_completed_write_requests(conf, sh, disks, &return_bi);
 
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
 	 */
-	if (to_read || non_overwrite || (syncing && (uptodate < disks)) || expanding) {
-		for (i=disks; i--;) {
-			dev = &sh->dev[i];
-			if (!test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-			    (dev->toread ||
-			     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
-			     syncing ||
-			     expanding ||
-			     (failed && (sh->dev[failed_num].toread ||
-					 (sh->dev[failed_num].towrite && !test_bit(R5_OVERWRITE, &sh->dev[failed_num].flags))))
-				    )
-				) {
-				/* we would like to get this block, possibly
-				 * by computing it, but we might not be able to
-				 */
-				if (uptodate == disks-1) {
-					PRINTK("Computing block %d\n", i);
-					compute_block(sh, i);
-					uptodate++;
-				} else if (test_bit(R5_Insync, &dev->flags)) {
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
-					locked++;
-					PRINTK("Reading block %d (sync=%d)\n", 
-						i, syncing);
-				}
-			}
-		}
-		set_bit(STRIPE_HANDLE, &sh->state);
-	}
+	if (s.to_read || s.non_overwrite ||
+		(s.syncing && (s.uptodate < disks)) || s.expanding)
+		handle_issuing_new_read_requests5(sh, &s, disks);
 
 	/* now to consider writing and what else, if anything should be read */
-	if (to_write) {
-		int rmw=0, rcw=0;
-		for (i=disks ; i--;) {
-			/* would I have to read this buffer for read_modify_write */
-			dev = &sh->dev[i];
-			if ((dev->towrite || i == sh->pd_idx) &&
-			    (!test_bit(R5_LOCKED, &dev->flags) 
-				    ) &&
-			    !test_bit(R5_UPTODATE, &dev->flags)) {
-				if (test_bit(R5_Insync, &dev->flags)
-/*				    && !(!mddev->insync && i == sh->pd_idx) */
-					)
-					rmw++;
-				else rmw += 2*disks;  /* cannot read it */
-			}
-			/* Would I have to read this buffer for reconstruct_write */
-			if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
-			    (!test_bit(R5_LOCKED, &dev->flags) 
-				    ) &&
-			    !test_bit(R5_UPTODATE, &dev->flags)) {
-				if (test_bit(R5_Insync, &dev->flags)) rcw++;
-				else rcw += 2*disks;
-			}
-		}
-		PRINTK("for sector %llu, rmw=%d rcw=%d\n", 
-			(unsigned long long)sh->sector, rmw, rcw);
-		set_bit(STRIPE_HANDLE, &sh->state);
-		if (rmw < rcw && rmw > 0)
-			/* prefer read-modify-write, but need to get some data */
-			for (i=disks; i--;) {
-				dev = &sh->dev[i];
-				if ((dev->towrite || i == sh->pd_idx) &&
-				    !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-				    test_bit(R5_Insync, &dev->flags)) {
-					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-					{
-						PRINTK("Read_old block %d for r-m-w\n", i);
-						set_bit(R5_LOCKED, &dev->flags);
-						set_bit(R5_Wantread, &dev->flags);
-						locked++;
-					} else {
-						set_bit(STRIPE_DELAYED, &sh->state);
-						set_bit(STRIPE_HANDLE, &sh->state);
-					}
-				}
-			}
-		if (rcw <= rmw && rcw > 0)
-			/* want reconstruct write, but need to get some data */
-			for (i=disks; i--;) {
-				dev = &sh->dev[i];
-				if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
-				    !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-				    test_bit(R5_Insync, &dev->flags)) {
-					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-					{
-						PRINTK("Read_old block %d for Reconstruct\n", i);
-						set_bit(R5_LOCKED, &dev->flags);
-						set_bit(R5_Wantread, &dev->flags);
-						locked++;
-					} else {
-						set_bit(STRIPE_DELAYED, &sh->state);
-						set_bit(STRIPE_HANDLE, &sh->state);
-					}
-				}
-			}
-		/* now if nothing is locked, and if we have enough data, we can start a write request */
-		if (locked == 0 && (rcw == 0 ||rmw == 0) &&
-		    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
-			PRINTK("Computing parity...\n");
-			compute_parity5(sh, rcw==0 ? RECONSTRUCT_WRITE : READ_MODIFY_WRITE);
-			/* now every locked buffer is ready to be written */
-			for (i=disks; i--;)
-				if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
-					PRINTK("Writing block %d\n", i);
-					locked++;
-					set_bit(R5_Wantwrite, &sh->dev[i].flags);
-					if (!test_bit(R5_Insync, &sh->dev[i].flags)
-					    || (i==sh->pd_idx && failed == 0))
-						set_bit(STRIPE_INSYNC, &sh->state);
-				}
-			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-				atomic_dec(&conf->preread_active_stripes);
-				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
-					md_wakeup_thread(conf->mddev->thread);
-			}
-		}
-	}
+	if (s.to_write)
+		handle_issuing_new_write_requests5(conf, sh, &s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
 	 * Any reads will already have been scheduled, so we just see if enough data
 	 * is available
 	 */
-	if (syncing && locked == 0 &&
-	    !test_bit(STRIPE_INSYNC, &sh->state)) {
-		set_bit(STRIPE_HANDLE, &sh->state);
-		if (failed == 0) {
-			BUG_ON(uptodate != disks);
-			compute_parity5(sh, CHECK_PARITY);
-			uptodate--;
-			if (page_is_zero(sh->dev[sh->pd_idx].page)) {
-				/* parity is correct (on disc, not in buffer any more) */
-				set_bit(STRIPE_INSYNC, &sh->state);
-			} else {
-				conf->mddev->resync_mismatches += STRIPE_SECTORS;
-				if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
-					/* don't try to repair!! */
-					set_bit(STRIPE_INSYNC, &sh->state);
-				else {
-					compute_block(sh, sh->pd_idx);
-					uptodate++;
-				}
-			}
-		}
-		if (!test_bit(STRIPE_INSYNC, &sh->state)) {
-			/* either failed parity check, or recovery is happening */
-			if (failed==0)
-				failed_num = sh->pd_idx;
-			dev = &sh->dev[failed_num];
-			BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
-			BUG_ON(uptodate != disks);
-
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantwrite, &dev->flags);
-			clear_bit(STRIPE_DEGRADED, &sh->state);
-			locked++;
-			set_bit(STRIPE_INSYNC, &sh->state);
-		}
-	}
-	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
+	if (s.syncing && s.locked == 0 &&
+	    !test_bit(STRIPE_INSYNC, &sh->state))
+		handle_parity_checks5(conf, sh, &s, disks);
+	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
@@ -1729,86 +2077,45 @@ static void handle_stripe5(struct stripe_head *sh)
 	/* If the failed drive is just a ReadError, then we might need to progress
 	 * the repair/check process
 	 */
-	if (failed == 1 && ! conf->mddev->ro &&
-	    test_bit(R5_ReadError, &sh->dev[failed_num].flags)
-	    && !test_bit(R5_LOCKED, &sh->dev[failed_num].flags)
-	    && test_bit(R5_UPTODATE, &sh->dev[failed_num].flags)
+	if (s.failed == 1 && !conf->mddev->ro &&
+	    test_bit(R5_ReadError, &sh->dev[s.failed_num].flags)
+	    && !test_bit(R5_LOCKED, &sh->dev[s.failed_num].flags)
+	    && test_bit(R5_UPTODATE, &sh->dev[s.failed_num].flags)
 		) {
-		dev = &sh->dev[failed_num];
+		dev = &sh->dev[s.failed_num];
 		if (!test_bit(R5_ReWrite, &dev->flags)) {
 			set_bit(R5_Wantwrite, &dev->flags);
 			set_bit(R5_ReWrite, &dev->flags);
 			set_bit(R5_LOCKED, &dev->flags);
-			locked++;
+			s.locked++;
 		} else {
 			/* let's read it back */
 			set_bit(R5_Wantread, &dev->flags);
 			set_bit(R5_LOCKED, &dev->flags);
-			locked++;
+			s.locked++;
 		}
 	}
 
-	if (expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
+	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
 		/* Need to write out all blocks after computing parity */
 		sh->disks = conf->raid_disks;
 		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, conf->raid_disks);
 		compute_parity5(sh, RECONSTRUCT_WRITE);
-		for (i= conf->raid_disks; i--;) {
+		for (i = conf->raid_disks; i--;) {
 			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			locked++;
+			s.locked++;
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
 		}
 		clear_bit(STRIPE_EXPANDING, &sh->state);
-	} else if (expanded) {
+	} else if (s.expanded) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_overlap);
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (expanding && locked == 0) {
-		/* We have read all the blocks in this stripe and now we need to
-		 * copy some of them into a target stripe for expand.
-		 */
-		clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-		for (i=0; i< sh->disks; i++)
-			if (i != sh->pd_idx) {
-				int dd_idx, pd_idx, j;
-				struct stripe_head *sh2;
-
-				sector_t bn = compute_blocknr(sh, i);
-				sector_t s = raid5_compute_sector(bn, conf->raid_disks,
-								  conf->raid_disks-1,
-								  &dd_idx, &pd_idx, conf);
-				sh2 = get_active_stripe(conf, s, conf->raid_disks, pd_idx, 1);
-				if (sh2 == NULL)
-					/* so far only the early blocks of this stripe
-					 * have been requested.  When later blocks
-					 * get requested, we will try again
-					 */
-					continue;
-				if(!test_bit(STRIPE_EXPANDING, &sh2->state) ||
-				   test_bit(R5_Expanded, &sh2->dev[dd_idx].flags)) {
-					/* must have already done this block */
-					release_stripe(sh2);
-					continue;
-				}
-				memcpy(page_address(sh2->dev[dd_idx].page),
-				       page_address(sh->dev[i].page),
-				       STRIPE_SIZE);
-				set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
-				set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
-				for (j=0; j<conf->raid_disks; j++)
-					if (j != sh2->pd_idx &&
-					    !test_bit(R5_Expanded, &sh2->dev[j].flags))
-						break;
-				if (j == conf->raid_disks) {
-					set_bit(STRIPE_EXPAND_READY, &sh2->state);
-					set_bit(STRIPE_HANDLE, &sh2->state);
-				}
-				release_stripe(sh2);
-			}
-	}
+	if (s.expanding && s.locked == 0)
+		handle_stripe_expansion(conf, sh, NULL);
 
 	spin_unlock(&sh->lock);
 
@@ -1850,7 +2157,7 @@ static void handle_stripe5(struct stripe_head *sh)
 		rcu_read_unlock();
  
 		if (rdev) {
-			if (syncing || expanding || expanded)
+			if (s.syncing || s.expanding || s.expanded)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;
@@ -1886,29 +2193,27 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 {
 	raid6_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks;
-	struct bio *return_bi= NULL;
+	struct bio *return_bi = NULL;
 	struct bio *bi;
-	int i;
-	int syncing, expanding, expanded;
-	int locked=0, uptodate=0, to_read=0, to_write=0, failed=0, written=0;
-	int non_overwrite = 0;
-	int failed_num[2] = {0, 0};
+	int i, pd_idx = sh->pd_idx;
+	struct stripe_head_state s;
+	struct r6_state r6s;
 	struct r5dev *dev, *pdev, *qdev;
-	int pd_idx = sh->pd_idx;
-	int qd_idx = raid6_next_disk(pd_idx, disks);
-	int p_failed, q_failed;
 
-	PRINTK("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d, qd_idx=%d\n",
-	       (unsigned long long)sh->sector, sh->state, atomic_read(&sh->count),
-	       pd_idx, qd_idx);
+	r6s.qd_idx = raid6_next_disk(pd_idx, disks);
+	PRINTK("handling stripe %llu, state=%#lx cnt=%d, "
+		"pd_idx=%d, qd_idx=%d\n",
+	       (unsigned long long)sh->sector, sh->state,
+	       atomic_read(&sh->count), pd_idx, r6s.qd_idx);
+	memset(&s, 0, sizeof(s));
 
 	spin_lock(&sh->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
-	syncing = test_bit(STRIPE_SYNCING, &sh->state);
-	expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-	expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
+	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
+	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
+	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
 	rcu_read_lock();
@@ -1943,17 +2248,19 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		}
 
 		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev->flags)) locked++;
-		if (test_bit(R5_UPTODATE, &dev->flags)) uptodate++;
+		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
+		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
 
 
-		if (dev->toread) to_read++;
+		if (dev->toread)
+			s.to_read++;
 		if (dev->towrite) {
-			to_write++;
+			s.to_write++;
 			if (!test_bit(R5_OVERWRITE, &dev->flags))
-				non_overwrite++;
+				s.non_overwrite++;
 		}
-		if (dev->written) written++;
+		if (dev->written)
+			s.written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
@@ -1962,96 +2269,27 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		}
 		if (!rdev || !test_bit(In_sync, &rdev->flags)
 		    || test_bit(R5_ReadError, &dev->flags)) {
-			if ( failed < 2 )
-				failed_num[failed] = i;
-			failed++;
+			if (s.failed < 2)
+				r6s.failed_num[s.failed] = i;
+			s.failed++;
 		} else
 			set_bit(R5_Insync, &dev->flags);
 	}
 	rcu_read_unlock();
 	PRINTK("locked=%d uptodate=%d to_read=%d"
 	       " to_write=%d failed=%d failed_num=%d,%d\n",
-	       locked, uptodate, to_read, to_write, failed,
-	       failed_num[0], failed_num[1]);
-	/* check if the array has lost >2 devices and, if so, some requests might
-	 * need to be failed
+	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
+	       r6s.failed_num[0], r6s.failed_num[1]);
+	/* check if the array has lost >2 devices and, if so, some requests
+	 * might need to be failed
 	 */
-	if (failed > 2 && to_read+to_write+written) {
-		for (i=disks; i--; ) {
-			int bitmap_end = 0;
-
-			if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
-				mdk_rdev_t *rdev;
-				rcu_read_lock();
-				rdev = rcu_dereference(conf->disks[i].rdev);
-				if (rdev && test_bit(In_sync, &rdev->flags))
-					/* multiple read failures in one stripe */
-					md_error(conf->mddev, rdev);
-				rcu_read_unlock();
-			}
-
-			spin_lock_irq(&conf->device_lock);
-			/* fail all writes first */
-			bi = sh->dev[i].towrite;
-			sh->dev[i].towrite = NULL;
-			if (bi) { to_write--; bitmap_end = 1; }
-
-			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-				wake_up(&conf->wait_for_overlap);
-
-			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
-				struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
-				clear_bit(BIO_UPTODATE, &bi->bi_flags);
-				if (--bi->bi_phys_segments == 0) {
-					md_write_end(conf->mddev);
-					bi->bi_next = return_bi;
-					return_bi = bi;
-				}
-				bi = nextbi;
-			}
-			/* and fail all 'written' */
-			bi = sh->dev[i].written;
-			sh->dev[i].written = NULL;
-			if (bi) bitmap_end = 1;
-			while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS) {
-				struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
-				clear_bit(BIO_UPTODATE, &bi->bi_flags);
-				if (--bi->bi_phys_segments == 0) {
-					md_write_end(conf->mddev);
-					bi->bi_next = return_bi;
-					return_bi = bi;
-				}
-				bi = bi2;
-			}
-
-			/* fail any reads if this device is non-operational */
-			if (!test_bit(R5_Insync, &sh->dev[i].flags) ||
-			    test_bit(R5_ReadError, &sh->dev[i].flags)) {
-				bi = sh->dev[i].toread;
-				sh->dev[i].toread = NULL;
-				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
-					wake_up(&conf->wait_for_overlap);
-				if (bi) to_read--;
-				while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
-					struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
-					clear_bit(BIO_UPTODATE, &bi->bi_flags);
-					if (--bi->bi_phys_segments == 0) {
-						bi->bi_next = return_bi;
-						return_bi = bi;
-					}
-					bi = nextbi;
-				}
-			}
-			spin_unlock_irq(&conf->device_lock);
-			if (bitmap_end)
-				bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-						STRIPE_SECTORS, 0, 0);
-		}
-	}
-	if (failed > 2 && syncing) {
+	if (s.failed > 2 && s.to_read+s.to_write+s.written)
+		handle_requests_to_failed_array(conf, sh, &s, disks,
+						&return_bi);
+	if (s.failed > 2 && s.syncing) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
-		syncing = 0;
+		s.syncing = 0;
 	}
 
 	/*
@@ -2059,279 +2297,41 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	 * are safe, or on a failed drive
 	 */
 	pdev = &sh->dev[pd_idx];
-	p_failed = (failed >= 1 && failed_num[0] == pd_idx)
-		|| (failed >= 2 && failed_num[1] == pd_idx);
-	qdev = &sh->dev[qd_idx];
-	q_failed = (failed >= 1 && failed_num[0] == qd_idx)
-		|| (failed >= 2 && failed_num[1] == qd_idx);
-
-	if ( written &&
-	     ( p_failed || ((test_bit(R5_Insync, &pdev->flags)
+	r6s.p_failed = (s.failed >= 1 && r6s.failed_num[0] == pd_idx)
+		|| (s.failed >= 2 && r6s.failed_num[1] == pd_idx);
+	qdev = &sh->dev[r6s.qd_idx];
+	r6s.q_failed = (s.failed >= 1 && r6s.failed_num[0] == r6s.qd_idx)
+		|| (s.failed >= 2 && r6s.failed_num[1] == r6s.qd_idx);
+
+	if ( s.written &&
+	     ( r6s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
 			     && !test_bit(R5_LOCKED, &pdev->flags)
-			     && test_bit(R5_UPTODATE, &pdev->flags))) ) &&
-	     ( q_failed || ((test_bit(R5_Insync, &qdev->flags)
+			     && test_bit(R5_UPTODATE, &pdev->flags)))) &&
+	     ( r6s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
 			     && !test_bit(R5_LOCKED, &qdev->flags)
-			     && test_bit(R5_UPTODATE, &qdev->flags))) ) ) {
-		/* any written block on an uptodate or failed drive can be
-		 * returned.  Note that if we 'wrote' to a failed drive,
-		 * it will be UPTODATE, but never LOCKED, so we don't need
-		 * to test 'failed' directly.
-		 */
-		for (i=disks; i--; )
-			if (sh->dev[i].written) {
-				dev = &sh->dev[i];
-				if (!test_bit(R5_LOCKED, &dev->flags) &&
-				    test_bit(R5_UPTODATE, &dev->flags) ) {
-					/* We can return any write requests */
-					int bitmap_end = 0;
-					struct bio *wbi, *wbi2;
-					PRINTK("Return write for stripe %llu disc %d\n",
-					       (unsigned long long)sh->sector, i);
-					spin_lock_irq(&conf->device_lock);
-					wbi = dev->written;
-					dev->written = NULL;
-					while (wbi && wbi->bi_sector < dev->sector + STRIPE_SECTORS) {
-						wbi2 = r5_next_bio(wbi, dev->sector);
-						if (--wbi->bi_phys_segments == 0) {
-							md_write_end(conf->mddev);
-							wbi->bi_next = return_bi;
-							return_bi = wbi;
-						}
-						wbi = wbi2;
-					}
-					if (dev->towrite == NULL)
-						bitmap_end = 1;
-					spin_unlock_irq(&conf->device_lock);
-					if (bitmap_end)
-						bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-								STRIPE_SECTORS,
-								!test_bit(STRIPE_DEGRADED, &sh->state), 0);
-				}
-			}
-	}
+			     && test_bit(R5_UPTODATE, &qdev->flags)))))
+		handle_completed_write_requests(conf, sh, disks, &return_bi);
 
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
 	 */
-	if (to_read || non_overwrite || (to_write && failed) ||
-	    (syncing && (uptodate < disks)) || expanding) {
-		for (i=disks; i--;) {
-			dev = &sh->dev[i];
-			if (!test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-			    (dev->toread ||
-			     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
-			     syncing ||
-			     expanding ||
-			     (failed >= 1 && (sh->dev[failed_num[0]].toread || to_write)) ||
-			     (failed >= 2 && (sh->dev[failed_num[1]].toread || to_write))
-				    )
-				) {
-				/* we would like to get this block, possibly
-				 * by computing it, but we might not be able to
-				 */
-				if (uptodate == disks-1) {
-					PRINTK("Computing stripe %llu block %d\n",
-					       (unsigned long long)sh->sector, i);
-					compute_block_1(sh, i, 0);
-					uptodate++;
-				} else if ( uptodate == disks-2 && failed >= 2 ) {
-					/* Computing 2-failure is *very* expensive; only do it if failed >= 2 */
-					int other;
-					for (other=disks; other--;) {
-						if ( other == i )
-							continue;
-						if ( !test_bit(R5_UPTODATE, &sh->dev[other].flags) )
-							break;
-					}
-					BUG_ON(other < 0);
-					PRINTK("Computing stripe %llu blocks %d,%d\n",
-					       (unsigned long long)sh->sector, i, other);
-					compute_block_2(sh, i, other);
-					uptodate += 2;
-				} else if (test_bit(R5_Insync, &dev->flags)) {
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
-					locked++;
-					PRINTK("Reading block %d (sync=%d)\n",
-						i, syncing);
-				}
-			}
-		}
-		set_bit(STRIPE_HANDLE, &sh->state);
-	}
+	if (s.to_read || s.non_overwrite || (s.to_write && s.failed) ||
+	    (s.syncing && (s.uptodate < disks)) || s.expanding)
+		handle_issuing_new_read_requests6(sh, &s, &r6s, disks);
 
 	/* now to consider writing and what else, if anything should be read */
-	if (to_write) {
-		int rcw=0, must_compute=0;
-		for (i=disks ; i--;) {
-			dev = &sh->dev[i];
-			/* Would I have to read this buffer for reconstruct_write */
-			if (!test_bit(R5_OVERWRITE, &dev->flags)
-			    && i != pd_idx && i != qd_idx
-			    && (!test_bit(R5_LOCKED, &dev->flags)
-				    ) &&
-			    !test_bit(R5_UPTODATE, &dev->flags)) {
-				if (test_bit(R5_Insync, &dev->flags)) rcw++;
-				else {
-					PRINTK("raid6: must_compute: disk %d flags=%#lx\n", i, dev->flags);
-					must_compute++;
-				}
-			}
-		}
-		PRINTK("for sector %llu, rcw=%d, must_compute=%d\n",
-		       (unsigned long long)sh->sector, rcw, must_compute);
-		set_bit(STRIPE_HANDLE, &sh->state);
-
-		if (rcw > 0)
-			/* want reconstruct write, but need to get some data */
-			for (i=disks; i--;) {
-				dev = &sh->dev[i];
-				if (!test_bit(R5_OVERWRITE, &dev->flags)
-				    && !(failed == 0 && (i == pd_idx || i == qd_idx))
-				    && !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-				    test_bit(R5_Insync, &dev->flags)) {
-					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-					{
-						PRINTK("Read_old stripe %llu block %d for Reconstruct\n",
-						       (unsigned long long)sh->sector, i);
-						set_bit(R5_LOCKED, &dev->flags);
-						set_bit(R5_Wantread, &dev->flags);
-						locked++;
-					} else {
-						PRINTK("Request delayed stripe %llu block %d for Reconstruct\n",
-						       (unsigned long long)sh->sector, i);
-						set_bit(STRIPE_DELAYED, &sh->state);
-						set_bit(STRIPE_HANDLE, &sh->state);
-					}
-				}
-			}
-		/* now if nothing is locked, and if we have enough data, we can start a write request */
-		if (locked == 0 && rcw == 0 &&
-		    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
-			if ( must_compute > 0 ) {
-				/* We have failed blocks and need to compute them */
-				switch ( failed ) {
-				case 0:	BUG();
-				case 1: compute_block_1(sh, failed_num[0], 0); break;
-				case 2: compute_block_2(sh, failed_num[0], failed_num[1]); break;
-				default: BUG();	/* This request should have been failed? */
-				}
-			}
-
-			PRINTK("Computing parity for stripe %llu\n", (unsigned long long)sh->sector);
-			compute_parity6(sh, RECONSTRUCT_WRITE);
-			/* now every locked buffer is ready to be written */
-			for (i=disks; i--;)
-				if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
-					PRINTK("Writing stripe %llu block %d\n",
-					       (unsigned long long)sh->sector, i);
-					locked++;
-					set_bit(R5_Wantwrite, &sh->dev[i].flags);
-				}
-			/* after a RECONSTRUCT_WRITE, the stripe MUST be in-sync */
-			set_bit(STRIPE_INSYNC, &sh->state);
-
-			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-				atomic_dec(&conf->preread_active_stripes);
-				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
-					md_wakeup_thread(conf->mddev->thread);
-			}
-		}
-	}
+	if (s.to_write)
+		handle_issuing_new_write_requests6(conf, sh, &s, &r6s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
-	 * Any reads will already have been scheduled, so we just see if enough data
-	 * is available
+	 * Any reads will already have been scheduled, so we just see if enough
+	 * data is available
 	 */
-	if (syncing && locked == 0 && !test_bit(STRIPE_INSYNC, &sh->state)) {
-		int update_p = 0, update_q = 0;
-		struct r5dev *dev;
-
-		set_bit(STRIPE_HANDLE, &sh->state);
-
-		BUG_ON(failed>2);
-		BUG_ON(uptodate < disks);
-		/* Want to check and possibly repair P and Q.
-		 * However there could be one 'failed' device, in which
-		 * case we can only check one of them, possibly using the
-		 * other to generate missing data
-		 */
-
-		/* If !tmp_page, we cannot do the calculations,
-		 * but as we have set STRIPE_HANDLE, we will soon be called
-		 * by stripe_handle with a tmp_page - just wait until then.
-		 */
-		if (tmp_page) {
-			if (failed == q_failed) {
-				/* The only possible failed device holds 'Q', so it makes
-				 * sense to check P (If anything else were failed, we would
-				 * have used P to recreate it).
-				 */
-				compute_block_1(sh, pd_idx, 1);
-				if (!page_is_zero(sh->dev[pd_idx].page)) {
-					compute_block_1(sh,pd_idx,0);
-					update_p = 1;
-				}
-			}
-			if (!q_failed && failed < 2) {
-				/* q is not failed, and we didn't use it to generate
-				 * anything, so it makes sense to check it
-				 */
-				memcpy(page_address(tmp_page),
-				       page_address(sh->dev[qd_idx].page),
-				       STRIPE_SIZE);
-				compute_parity6(sh, UPDATE_PARITY);
-				if (memcmp(page_address(tmp_page),
-					   page_address(sh->dev[qd_idx].page),
-					   STRIPE_SIZE)!= 0) {
-					clear_bit(STRIPE_INSYNC, &sh->state);
-					update_q = 1;
-				}
-			}
-			if (update_p || update_q) {
-				conf->mddev->resync_mismatches += STRIPE_SECTORS;
-				if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
-					/* don't try to repair!! */
-					update_p = update_q = 0;
-			}
+	if (s.syncing && s.locked == 0 && !test_bit(STRIPE_INSYNC, &sh->state))
+		handle_parity_checks6(conf, sh, &s, &r6s, tmp_page, disks);
 
-			/* now write out any block on a failed drive,
-			 * or P or Q if they need it
-			 */
-
-			if (failed == 2) {
-				dev = &sh->dev[failed_num[1]];
-				locked++;
-				set_bit(R5_LOCKED, &dev->flags);
-				set_bit(R5_Wantwrite, &dev->flags);
-			}
-			if (failed >= 1) {
-				dev = &sh->dev[failed_num[0]];
-				locked++;
-				set_bit(R5_LOCKED, &dev->flags);
-				set_bit(R5_Wantwrite, &dev->flags);
-			}
-
-			if (update_p) {
-				dev = &sh->dev[pd_idx];
-				locked ++;
-				set_bit(R5_LOCKED, &dev->flags);
-				set_bit(R5_Wantwrite, &dev->flags);
-			}
-			if (update_q) {
-				dev = &sh->dev[qd_idx];
-				locked++;
-				set_bit(R5_LOCKED, &dev->flags);
-				set_bit(R5_Wantwrite, &dev->flags);
-			}
-			clear_bit(STRIPE_DEGRADED, &sh->state);
-
-			set_bit(STRIPE_INSYNC, &sh->state);
-		}
-	}
-
-	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
+	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
@@ -2339,9 +2339,9 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	/* If the failed drives are just a ReadError, then we might need
 	 * to progress the repair/check process
 	 */
-	if (failed <= 2 && ! conf->mddev->ro)
-		for (i=0; i<failed;i++) {
-			dev = &sh->dev[failed_num[i]];
+	if (s.failed <= 2 && !conf->mddev->ro)
+		for (i = 0; i < s.failed; i++) {
+			dev = &sh->dev[r6s.failed_num[i]];
 			if (test_bit(R5_ReadError, &dev->flags)
 			    && !test_bit(R5_LOCKED, &dev->flags)
 			    && test_bit(R5_UPTODATE, &dev->flags)
@@ -2358,7 +2358,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 			}
 		}
 
-	if (expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
+	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
 		/* Need to write out all blocks after computing P&Q */
 		sh->disks = conf->raid_disks;
 		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
@@ -2366,69 +2366,19 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		compute_parity6(sh, RECONSTRUCT_WRITE);
 		for (i = conf->raid_disks ; i-- ;  ) {
 			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			locked++;
+			s.locked++;
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
 		}
 		clear_bit(STRIPE_EXPANDING, &sh->state);
-	} else if (expanded) {
+	} else if (s.expanded) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_overlap);
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (expanding && locked == 0) {
-		/* We have read all the blocks in this stripe and now we need to
-		 * copy some of them into a target stripe for expand.
-		 */
-		clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-		for (i = 0; i < sh->disks ; i++)
-			if (i != pd_idx && i != qd_idx) {
-				int dd_idx2, pd_idx2, j;
-				struct stripe_head *sh2;
-
-				sector_t bn = compute_blocknr(sh, i);
-				sector_t s = raid5_compute_sector(
-					bn, conf->raid_disks,
-					conf->raid_disks - conf->max_degraded,
-					&dd_idx2, &pd_idx2, conf);
-				sh2 = get_active_stripe(conf, s,
-							conf->raid_disks,
-						       pd_idx2, 1);
-				if (sh2 == NULL)
-					/* so for only the early blocks of
-					 * this stripe have been requests.
-					 * When later blocks get requests, we
-					 * will try again
-					 */
-					continue;
-				if (!test_bit(STRIPE_EXPANDING, &sh2->state) ||
-				    test_bit(R5_Expanded,
-					     &sh2->dev[dd_idx2].flags)) {
-					/* must have already done this block */
-					release_stripe(sh2);
-					continue;
-				}
-				memcpy(page_address(sh2->dev[dd_idx2].page),
-				       page_address(sh->dev[i].page),
-				       STRIPE_SIZE);
-				set_bit(R5_Expanded, &sh2->dev[dd_idx2].flags);
-				set_bit(R5_UPTODATE, &sh2->dev[dd_idx2].flags);
-				for (j = 0 ; j < conf->raid_disks ; j++)
-					if (j != sh2->pd_idx &&
-					    j != raid6_next_disk(sh2->pd_idx,
-							   sh2->disks) &&
-					    !test_bit(R5_Expanded,
-						      &sh2->dev[j].flags))
-						break;
-				if (j == conf->raid_disks) {
-					set_bit(STRIPE_EXPAND_READY,
-						&sh2->state);
-					set_bit(STRIPE_HANDLE, &sh2->state);
-				}
-				release_stripe(sh2);
-			}
-	}
+	if (s.expanding && s.locked == 0)
+		handle_stripe_expansion(conf, sh, &r6s);
 
 	spin_unlock(&sh->lock);
 
@@ -2470,7 +2420,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		rcu_read_unlock();
 
 		if (rdev) {
-			if (syncing || expanding || expanded)
+			if (s.syncing || s.expanding || s.expanded)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index d8286db..208aa68 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -145,6 +145,22 @@ struct stripe_head {
 		unsigned long	flags;
 	} dev[1]; /* allocated with extra space depending of RAID geometry */
 };
+
+/* stripe_head_state - collects and tracks the dynamic state of a stripe_head
+ *     for handle_stripe.  It is only valid under spin_lock(sh->lock);
+ */
+struct stripe_head_state {
+	int syncing, expanding, expanded;
+	int locked, uptodate, to_read, to_write, failed, written;
+	int non_overwrite, dirty;
+	int failed_num;
+};
+
+/* r6_state - extra state data only relevant to r6 */
+struct r6_state {
+	int p_failed, q_failed, qd_idx, failed_num[2];
+};
+
 /* Flags */
 #define	R5_UPTODATE	0	/* page contains current data */
 #define	R5_LOCKED	1	/* IO has been submitted on "req" */
