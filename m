From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Sat, 24 Sep 2005 03:44:12 +0200
Message-ID: <20050924014412.GA19832@uio.no>
References: <20050920143346.GA5777@uio.no> <17200.9302.242957.23189@cse.unsw.edu.au> <20050920153622.GA14287@uio.no> <17202.55529.310871.877019@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="mYCpIKhGyMATD0i+"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17202.55529.310871.877019@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Sep 22, 2005 at 06:16:41PM +0200, Neil Brown wrote:
> 2/ Reserve the stripe_heads needed for a chunk-resize in make_request
>    (where it is safe to block) rather than in handle_stripe.

See the attached patch for at least a partial implementation of this (on top
of the last patch); it pre-allocates the write stripes, but not the read
stripes. In other words, it still uses a temporary buffer, and it doesn't
block requests against the to-be-expanded area.

There's also one extra fix I snuck in; before recomputing the parity for the
written out blocks, I actually lock it. This shouldn't break anything, and
AFAICS should be a good idea both in this and the previous implementation.

I'm unsure how much this actually buys us (there's a slight reduction in
complexity, but I fear that will go up again once I implement it for read
stripes as well), and I seem to have created a somewhat nasty regression --
if I do I/O against the volume while it's expanding, it causes a panic
_somewhere_ in handle_stripe, which I'm having a hard time tracking down. (If
you have a good way of actually mapping the offsets to C lines, let me know
-- every approach I've tried seems to fail, and the disassembly even shows
lots of nonsensical asm :-) )

In short, I think getting the original patch more or less bug-free is a
higher priority than this, although I do agree that it's a conceptually
cleaner way. What I really need is external testing of this, and of course
preferrably someone tracking down the bugs that are still left there... There
might be something that's really obvious to you (like “why on earth isn't he
locking that there?”) that I've overlooked, simply because you know this code
a _lot_ better than me :-)

/* Steinar */
-- 
Homepage: http://www.sesse.net/

--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="raid5-online-expand-prealloc.diff"

--- include/linux/raid/raid5.h.orig	2005-09-24 01:08:00.000000000 +0200
+++ include/linux/raid/raid5.h	2005-09-24 05:17:50.000000000 +0200
@@ -225,6 +225,9 @@
 	struct list_head	wait_for_expand_list;
 	
 	struct expand_buf	*expand_buffer;
+	
+	int			expand_stripes_ready;	
+	struct stripe_head	**expand_stripes;
 
 	struct list_head	handle_list; /* stripes needing handling */
 	struct list_head	delayed_list; /* stripes that have plugged requests */
--- drivers/md/raid5.c.orig	2005-09-24 01:05:32.000000000 +0200
+++ drivers/md/raid5.c	2005-09-24 05:22:30.000000000 +0200
@@ -1371,9 +1371,8 @@
 			needed_uptodate = ((conf->mddev->array_size << 1) - conf->expand_progress) / STRIPE_SECTORS;
 //			printk("reading partial block at the end: %u\n", needed_uptodate);
 		}
-		if (needed_uptodate > 0 && uptodate == needed_uptodate) {
+		if (needed_uptodate > 0 && uptodate == needed_uptodate && conf->expand_stripes_ready) {
 			// we can do an expand!
-			struct stripe_head *newsh[256];   // FIXME: dynamic allocation somewhere instead?
 			sector_t dest_sector, advance;
 			unsigned i;
 			unsigned int dummy1, dummy2, pd_idx;
@@ -1435,72 +1434,50 @@
 				}
 			}
 
-			/*
-			 * Check that we have enough free stripes to write out our
-			 * entire chunk in the new layout. If not, we'll have to wait
-			 * until some writes have been retired. We can't just do
-			 * as in get_active_stripe() and sleep here until enough are
-			 * free, since all busy stripes might have STRIPE_HANDLE set
-			 * and thus won't be retired until somebody (our thread!) takes
-			 * care of them.
-			 */	
-			
-			{
-				int not_enough_free = 0;
-				
-				for (i = 0; i < conf->chunk_size / STRIPE_SIZE; ++i) {
-					newsh[i] = get_free_stripe(conf, 1);
-					if (newsh[i] == NULL) {
-						not_enough_free = 1;
-						break;
-					}
-					init_stripe(newsh[i], dest_sector + i * STRIPE_SECTORS, pd_idx);		
-				}
-
-				if (not_enough_free) {
-					// release all the stripes we allocated
-					for (i = 0; i < conf->chunk_size / STRIPE_SIZE; ++i) {
-						if (newsh[i] == NULL)
-							break;
-						atomic_inc(&newsh[i]->count);
-						__release_stripe(conf, newsh[i]);
-					}
-					printk("Aborting, not enough destination stripes free\n");
-					spin_unlock_irq(&conf->device_lock);
-					goto please_wait;
-				}
-			}
-
 			for (i = 0; i < conf->chunk_size / STRIPE_SIZE; ++i) {
+				struct stripe_head *newsh = conf->expand_stripes[i];
+				init_stripe(newsh, dest_sector + i * STRIPE_SECTORS, pd_idx);
+
 				for (d = 0; d < conf->raid_disks; ++d) {
 					unsigned dd_idx = d;
-					
+					                                        
 					if (d != pd_idx) {
+						struct page *tmp;
+						unsigned di;
+						
 						if (dd_idx > pd_idx)
 							--dd_idx;
 
-						memcpy(page_address(newsh[i]->dev[d].page), page_address(conf->expand_buffer[dd_idx * conf->chunk_size / STRIPE_SIZE + i].page), STRIPE_SIZE);
+						di = dd_idx * conf->chunk_size / STRIPE_SIZE + i;
+						
+						// swap the two pages, moving the data in place into the stripe
+						tmp = newsh->dev[d].page;
+						newsh->dev[d].page = conf->expand_buffer[di].page;
+						conf->expand_buffer[di].page = tmp;
+						
+						conf->expand_buffer[di].up_to_date = 0;
 					}
-					set_bit(R5_Wantwrite, &newsh[i]->dev[d].flags);
-					set_bit(R5_Syncio, &newsh[i]->dev[d].flags);
+					set_bit(R5_Wantwrite, &newsh->dev[d].flags);
+					set_bit(R5_Syncio, &newsh->dev[d].flags);
 				}
 			}
 			
-			for (i=0; i < (conf->raid_disks - 1) * (conf->chunk_size / STRIPE_SIZE); ++i) {
-				conf->expand_buffer[i].up_to_date = 0;
-			}
-
+			conf->expand_stripes_ready = 0;
 			conf->expand_progress += advance;
 			
 			spin_unlock_irq(&conf->device_lock);
 			
 			for (i = 0; i < conf->chunk_size / STRIPE_SIZE; ++i) {
-				compute_parity(newsh[i], RECONSTRUCT_WRITE);
+				struct stripe_head *newsh = conf->expand_stripes[i];
+
+				spin_lock(&newsh->lock);
+				compute_parity(newsh, RECONSTRUCT_WRITE);
 					
-				atomic_inc(&newsh[i]->count);
-				set_bit(STRIPE_INSYNC, &newsh[i]->state);
-				set_bit(STRIPE_HANDLE, &newsh[i]->state);
-				release_stripe(newsh[i]);
+				atomic_inc(&newsh->count);
+				set_bit(STRIPE_INSYNC, &newsh->state);
+				set_bit(STRIPE_HANDLE, &newsh->state);
+				spin_unlock(&newsh->lock);
+				release_stripe(newsh);
 			}
 
 			spin_lock_irq(&conf->device_lock);
@@ -2025,6 +2002,37 @@
 		spin_unlock_irq(&conf->device_lock);
 	}
 
+	/*
+	 * In an expand, we also need to make sure that we have enough destination stripes
+	 * available for writing out the block after we've read in the data, so make sure
+	 * we get them before we start reading any data.
+	 */
+	if (conf->expand_in_progress && !conf->expand_stripes_ready) {
+		unsigned i;
+		
+		spin_lock_irq(&conf->device_lock);
+		for (i = 0; i < conf->chunk_size / STRIPE_SIZE; ++i) {
+			do {
+				conf->expand_stripes[i] = get_free_stripe(conf, 1);
+
+				if (conf->expand_stripes[i] == NULL) {
+					conf->inactive_blocked_expand = 1;
+					wait_event_lock_irq(conf->wait_for_stripe_expand,
+							    !list_empty(&conf->inactive_list_expand) &&
+							    (atomic_read(&conf->active_stripes_expand) < (NR_STRIPES *3/4)
+							     || !conf->inactive_blocked_expand),
+							    conf->device_lock,
+							    unplug_slaves(conf->mddev);
+						);
+					conf->inactive_blocked_expand = 0;
+				}
+			} while (conf->expand_stripes[i] == NULL);
+		}
+		spin_unlock_irq(&conf->device_lock);
+
+		conf->expand_stripes_ready = 1;
+	}
+
 	x = sector_nr;
 	chunk_offset = sector_div(x, sectors_per_chunk);
 	stripe = x;
@@ -2653,6 +2661,15 @@
 		kfree(newconf);
 		return -ENOMEM;
 	}
+
+	newconf->expand_stripes = kmalloc (sizeof(struct stripe_head *) * (conf->chunk_size / STRIPE_SIZE), GFP_KERNEL);
+	if (newconf->expand_stripes == NULL) {
+		printk(KERN_ERR "raid5: couldn't allocate memory for expand stripe pointers\n");
+		shrink_stripes(newconf);
+		kfree(newconf);
+		return -ENOMEM;
+	}
+	newconf->expand_stripes_ready = 0;
 	
 	for (i = 0; i < (conf->chunk_size / STRIPE_SIZE) * (raid_disks-1); ++i) {
 		newconf->expand_buffer[i].page = alloc_page(GFP_KERNEL);

--mYCpIKhGyMATD0i+--
