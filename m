From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 00/24] Allow bitmaps to be resized.
Date: Tue, 17 Apr 2012 18:43:39 +1000
Message-ID: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The following series has just been added to my for-next queue
and so should be in 3.5.
  git://neil.brown.name/md for-next
  git://github.com/neilbrown/linux.git md/for-next

It allows md to resize a bitmap on an active array.  This
means that arrays can now be reshaped without first removing the
bitmap.  The bitmap is resized in-place.

As always: review and testing would be greatly appreciated.

NeilBrown

---

NeilBrown (24):
      md/raid5: Allow reshape while a bitmap is present.
      md/raid10: resize bitmap when required during reshape.
      md: allow array to be resized while bitmap is present.
      md/bitmap: make sure reshape request are reflected in superblock.
      md/bitmap: add bitmap_resize function to allow bitmap resizing.
      md/bitmap: use DIV_ROUND_UP instead of open-code
      md/bitmap: create a 'struct bitmap_counts' substructure of 'struct bitmap'
      md/bitmap: make bitmap bitops atomic.
      md/bitmap: make _page_attr bitops atomic.
      md/bitmap: merge bitmap_file_unmap and bitmap_file_put.
      md/bitmap: remove async freeing of bitmap file.
      md/bitmap: convert some spin_lock_irqsave to spin_lock_irq
      md/bitmap: use set_bit, test_bit, etc for operation on bitmap->flags.
      md/bitmap: remove single-bit manipulation on sb->state
      md/bitmap: remove bitmap_mask_state
      md/bitmap: move storage allocation from bitmap_load to bitmap_create.
      md/bitmap: separate bitmap file allocation to its own function.
      md/bitmap: store bytes in file rather than just in last page.
      md/bitmap: move some fields of 'struct bitmap' into a 'storage' substruct.
      md/bitmap: change *_page_attr() to take a page number, not a page.
      md/bitmap: centralise allocation of bitmap file pages.
      md/bitmap: allow a bitmap with no backing storage.
      md/bitmap: add new 'space' attribute for bitmaps.
      md/bitmap: disentangle two different 'pending' flags.


 drivers/md/bitmap.c | 1089 +++++++++++++++++++++++++++++----------------------
 drivers/md/bitmap.h |   58 ++-
 drivers/md/md.c     |   53 ++
 drivers/md/md.h     |    3 
 drivers/md/raid1.c  |   11 -
 drivers/md/raid10.c |   47 +-
 drivers/md/raid5.c  |   20 +
 7 files changed, 754 insertions(+), 527 deletions(-)

-- 
Signature

