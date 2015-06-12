From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: Fw: Problems with bdev_write_page().
Date: Fri, 12 Jun 2015 10:48:11 -0400
Message-ID: <20150612144811.GN2729@linux.intel.com>
References: <20150611064126.1d05dc20@home.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150611064126.1d05dc20@home.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Charles Bertsch <cbertsch@cox.net>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 11, 2015 at 06:41:26AM +1000, Neil Brown wrote:
> Hi Matthew,
>  did you see this?  Should I resend it more publicly to this different address
>  I just found?
>  or did I miss a reply?

Hi Neil,

Sorry, I completely missed this.  Outlook isn't the best of email
interfaces.

> Hi Matthew,
>  I've just been looking at bdev_write_page().
> You can read about why here:
> 
>   http://marc.info/?t=142984068300001&r=1&w=2
> 
> it ends with a "git bisect" which points the finger at you.
> 
> If I look at bdev_write_page() it says:
> 
>  * On entry, the page should be locked and not currently under writeback.
>  * On exit, if the write started successfully, the page will be unlocked and
>  * under writeback.  If the write failed already (eg the driver failed to
>  * queue the page to the device), the page will still be locked.  If the
>  * caller is a ->writepage implementation, it will need to unlock the page.
> 
> So the page is unlocked on success.
> 
> In __mpage_writepage() I find
> 
> 			if (!bdev_write_page(bdev, blocks[0] << (blkbits - 9),
> 								page, wbc)) {
> 				clean_buffers(page, first_unmapped);
> 
> 
> so if bdev_write_page() succeeds, i.e. if it returns '0', then
> clean_buffers() is called.  At this point the page is unlocked remember.
> 
> clean_buffers may call
> 
> 		try_to_free_buffers(page);
> 
> (without first locking the page, so still unlocked)..
> try_to_free_buffers starts:
> 
> 	BUG_ON(!PageLocked(page));
> 
> 
> Opps.
> 
> Can you propose a fix for Charles, who can trigger this bug and nicely
> bisected it for us - thanks Charles!!!

I can ... but it's a bit involved, which is why it's taken me a couple of
days to respond.  The BUG_ON is the noisy part of the problem ... there's
the further problem that try_to_free_buffers() won't actually do anything
because the next line after this is:

	if (PageWriteback(page))
		return 0;

This check is perfectly reasonable for try_to_free_buffers to be doing.
If the page is under writeback, we don't want to be freeing the buffers
which are currently associated with this page.  But this check conflicts
with how bdev_write_page() uses PageWriteback; in the BIO write flow,
there's a moment when the page is definitely going to be submitted for
I/O, but hasn't been handed to the device driver yet.

So we could make calling clean_buffers(); set_page_writeback(); the
driver's responsibility (yuck!).  Or we could introduce a variant of
try_to_free_buffers() that doesn't check PageWriteback(), which is what
the below patch does.


> Also while looking at the code, I notice that brd_rw_page() unconditionally
> calls page_endio() and, in the WRITE case, page_endio unconditionally calls
> end_page_writeback(), which has
> 
> 	if (!test_clear_page_writeback(page))
> 		BUG();
> 
> 
> and so cannot tolerate being called twice in a row.
> So if brd_rw_page() ever returned an error (which seems possible though not
> likely), end_page_writeback() would be called once by page_endio() and once
> in the error path of bdev_write_page(), and the BUG above would be triggered.
> 
> I'll leave that for you to sort out too :-)

Erp.  Somehow I got the wrong error return in brd.c.  It should return 0,
even in the error case, because it has successfully submitted the I/O.  It
got an error, but that's reported through PageError, and not by returning
an error from ->rw_page().

(this patch probably doesn't apply to the current tree; it's done against
a bit of a mishmash tree in my current working directory.  it's not for
applynig, but for commentary).

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 898b4f2..44230d4 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -366,7 +366,7 @@ static int brd_rw_page(struct block_device *bdev, sector_t sector,
 	struct brd_device *brd = bdev->bd_disk->private_data;
 	int err = brd_do_bvec(brd, page, PAGE_CACHE_SIZE, 0, rw, sector);
 	page_endio(page, rw & WRITE, err);
-	return err;
+	return 0;
 }
 
 #ifdef CONFIG_BLK_DEV_RAM_DAX
diff --git a/fs/block_dev.c b/fs/block_dev.c
index f314c2c..9349c65 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -386,11 +386,12 @@ int bdev_read_page(struct block_device *bdev, sector_t sector,
 			struct page *page)
 {
 	const struct block_device_operations *ops = bdev->bd_disk->fops;
-	if (!ops->rw_page)
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	if (!ops->rw_page || bdev_get_integrity(bdev))
 		return -EOPNOTSUPP;
 	return ops->rw_page(bdev, sector + get_start_sect(bdev), page, READ);
 }
-EXPORT_SYMBOL_GPL(bdev_read_page);
+EXPORT_UNUSED_SYMBOL_GPL(bdev_read_page);
 
 /**
  * bdev_write_page() - Start writing a page to a block device
@@ -400,14 +401,13 @@ EXPORT_SYMBOL_GPL(bdev_read_page);
  * @wbc: The writeback_control for the write
  *
  * On entry, the page should be locked and not currently under writeback.
- * On exit, if the write started successfully, the page will be unlocked and
- * under writeback.  If the write failed already (eg the driver failed to
- * queue the page to the device), the page will still be locked.  If the
- * caller is a ->writepage implementation, it will need to unlock the page.
+ * On exit, the page will still be locked, and shall be under writeback if
+ * the I/O is in progress.
  *
- * Errors returned by this function are usually "soft", eg out of memory, or
- * queue full; callers should try a different route to write this page rather
- * than propagate an error back up the stack.
+ * Errors returned by this function indicate that something went wrong with
+ * the submission.  Callers should try a different route to write this page
+ * rather than propagate an error back up the stack.  If the device has an
+ * error, that will be indicated by setting PageError.
  *
  * Return: negative errno if an error occurs, 0 if submission was successful.
  */
@@ -417,17 +417,16 @@ int bdev_write_page(struct block_device *bdev, sector_t sector,
 	int result;
 	int rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE;
 	const struct block_device_operations *ops = bdev->bd_disk->fops;
-	if (!ops->rw_page)
+	VM_BUG_ON_PAGE(!PageLocked(page) || PageWriteback(page), page);
+	if (!ops->rw_page || bdev_get_integrity(bdev))
 		return -EOPNOTSUPP;
 	set_page_writeback(page);
 	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, rw);
 	if (result)
 		end_page_writeback(page);
-	else
-		unlock_page(page);
 	return result;
 }
-EXPORT_SYMBOL_GPL(bdev_write_page);
+EXPORT_UNUSED_SYMBOL_GPL(bdev_write_page);
 
 /**
  * bdev_direct_access() - Get the address for directly-accessibly memory
diff --git a/fs/buffer.c b/fs/buffer.c
index 20805db..13eaab3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3211,15 +3211,13 @@ failed:
 	return 0;
 }
 
-int try_to_free_buffers(struct page *page)
+int __try_to_free_buffers(struct page *page)
 {
 	struct address_space * const mapping = page->mapping;
 	struct buffer_head *buffers_to_free = NULL;
-	int ret = 0;
+	int ret;
 
 	BUG_ON(!PageLocked(page));
-	if (PageWriteback(page))
-		return 0;
 
 	if (mapping == NULL) {		/* can this still happen? */
 		ret = drop_buffers(page, &buffers_to_free);
@@ -3258,6 +3256,14 @@ out:
 	}
 	return ret;
 }
+
+int try_to_free_buffers(struct page *page)
+{
+	BUG_ON(!PageLocked(page));
+	if (PageWriteback(page))
+		return 0;
+	return __try_to_free_buffers(page);
+}
 EXPORT_SYMBOL(try_to_free_buffers);
 
 /*
diff --git a/fs/mpage.c b/fs/mpage.c
index 587c7ed..3c5c10a 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -456,7 +456,7 @@ static void clean_buffers(struct page *page, unsigned first_unmapped)
 	 * disk before we reach the platter.
 	 */
 	if (buffer_heads_over_limit && PageUptodate(page))
-		try_to_free_buffers(page);
+		__try_to_free_buffers(page);
 }
 
 static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
@@ -599,6 +599,7 @@ alloc_new:
 			if (!bdev_write_page(bdev, blocks[0] << (blkbits - 9),
 								page, wbc)) {
 				clean_buffers(page, first_unmapped);
+				unlock_page(page);
 				goto out;
 			}
 		}
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 73b4522..060ff4e 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -154,6 +154,7 @@ void touch_buffer(struct buffer_head *bh);
 void set_bh_page(struct buffer_head *bh,
 		struct page *page, unsigned long offset);
 int try_to_free_buffers(struct page *);
+int __try_to_free_buffers(struct page *);
 struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 		int retry);
 void create_empty_buffers(struct page *, unsigned long,
diff --git a/mm/page_io.c b/mm/page_io.c
index 955db8b..eeccb1a 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -311,6 +311,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 
 	ret = bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc);
 	if (!ret) {
+		unlock_page(page);
 		count_vm_event(PSWPOUT);
 		return 0;
 	}
