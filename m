From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: multipath: I/O hanging forever
Date: Fri, 4 Mar 2016 10:30:44 -0700
Message-ID: <20160304173044.GA2636@Dell>
References: <20160229015333.GA3101@Dell>
 <20160229034616.GA2682@Dell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160229034616.GA2682@Dell>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 28, 2016 at 08:46:16PM -0700, Andrea Righi wrote:
> On Sun, Feb 28, 2016 at 06:53:33PM -0700, Andrea Righi wrote:
> ... 
> > I'm using 4.5.0-rc5+, from Linus' git. I'll try to do a git bisect
> > later, I'm pretty sure this problem has been introduced recently (i.e.,
> > I've never seen this issue with 4.1.x).
> 
> I confirm, just tested kernel 4.1 and this problem doesn't happen.

Alright, I had some spare time to bisect this problem and I found that
the commit that introduced this issue is c66a14d.

So, I tried to revert the commit (with some changes to fix conflicts and
ABI changes) and now multipath seems to work fine for me (no hung task).

I'm not suggesting to apply the following patch, because if everthing
else is working (except multipath) probably the problem is in multipath
itself (any suggestion?). Anyway, for those who wanna test it, this is a
possible fix.

Thanks,
-Andrea

---
Subject: block: revert c66a14d (simplify bio_add_page())

Revert this change to avoid breaking the multipath (md) module.
After this commit doing I/O on a multipath volume makes tasks to hang
forever.

Example:

 # mdadm -C /dev/md0 --level=multipath --raid-devices=2 /dev/sdb
 # /dev/sdc
  # cat /proc/mdstat
  Personalities : [multipath]
  md0 : active multipath sdb[0] sdc[1]
        4042740 blocks super 1.2 [2/2] [UU]
  # mkfs.xfs /dev/md0
  meta-data=/dev/md0               isize=256    agcount=4, agsize=252672
  blks
           =                       sectsz=512   attr=2, projid32bit=0
  data     =                       bsize=4096   blocks=1010685, imaxpct=25
           =                       sunit=0      swidth=0 blks
  naming   =version 2              bsize=4096   ascii-ci=0
  log      =internal log           bsize=4096   blocks=2560, version=2
           =                       sectsz=512   sunit=0 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0
  ^C^C^C

 # cat /proc/`pidof mkfs.xfs`/stack
 [<ffffffff8126f53c>] do_blockdev_direct_IO+0x1adc/0x2300
 [<ffffffff8126fda3>] __blockdev_direct_IO+0x43/0x50
 [<ffffffff8126accc>] blkdev_direct_IO+0x4c/0x50
 [<ffffffff811a2014>] generic_file_direct_write+0xa4/0x160
 [<ffffffff811a2190>] __generic_file_write_iter+0xc0/0x1e0
 [<ffffffff8126afc0>] blkdev_write_iter+0x80/0x100
 [<ffffffff81228c3d>] __vfs_write+0xad/0xe0
 [<ffffffff81229a85>] vfs_write+0xa5/0x1a0
 [<ffffffff8122aacc>] SyS_pwrite64+0x6c/0xa0
 [<ffffffff818281f2>] entry_SYSCALL_64_fastpath+0x12/0x76
 [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Andrea Righi <andrea@betterlinux.com>
---
 block/bio.c | 110 ++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 58 insertions(+), 52 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index cf75915..3cfcd9d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -694,22 +694,31 @@ integrity_clone:
 EXPORT_SYMBOL(bio_clone_bioset);
 
 /**
- *	bio_add_pc_page	-	attempt to add page to bio
- *	@q: the target queue
- *	@bio: destination bio
- *	@page: page to add
- *	@len: vec entry length
- *	@offset: vec entry offset
- *
- *	Attempt to add a page to the bio_vec maplist. This can fail for a
- *	number of reasons, such as the bio being full or target block device
- *	limitations. The target block device must allow bio's up to PAGE_SIZE,
- *	so it is always possible to add a single page to an empty bio.
+ *	bio_get_nr_vecs		- return approx number of vecs
+ *	@bdev:  I/O target
  *
- *	This should only be used by REQ_PC bios.
+ *	Return the approximate number of pages we can send to this target.
+ *	There's no guarantee that you will be able to fit this number of pages
+ *	into a bio, it does not account for dynamic restrictions that vary
+ *	on offset.
  */
-int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
-		    *page, unsigned int len, unsigned int offset)
+int bio_get_nr_vecs(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	int nr_pages;
+
+	nr_pages = min_t(unsigned,
+		     queue_max_segments(q),
+		     queue_max_sectors(q) / (PAGE_SIZE >> 9) + 1);
+
+	return min_t(unsigned, nr_pages, BIO_MAX_PAGES);
+
+}
+EXPORT_SYMBOL(bio_get_nr_vecs);
+
+static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
+			  *page, unsigned int len, unsigned int offset,
+			  unsigned int max_sectors)
 {
 	int retried_segments = 0;
 	struct bio_vec *bvec;
@@ -720,7 +729,7 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
 	if (unlikely(bio_flagged(bio, BIO_CLONED)))
 		return 0;
 
-	if (((bio->bi_iter.bi_size + len) >> 9) > queue_max_hw_sectors(q))
+	if (((bio->bi_iter.bi_size + len) >> 9) > max_sectors)
 		return 0;
 
 	/*
@@ -791,6 +800,28 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
 	blk_recount_segments(q, bio);
 	return 0;
 }
+
+/**
+ *	bio_add_pc_page	-	attempt to add page to bio
+ *	@q: the target queue
+ *	@bio: destination bio
+ *	@page: page to add
+ *	@len: vec entry length
+ *	@offset: vec entry offset
+ *
+ *	Attempt to add a page to the bio_vec maplist. This can fail for a
+ *	number of reasons, such as the bio being full or target block device
+ *	limitations. The target block device must allow bio's up to PAGE_SIZE,
+ *	so it is always possible to add a single page to an empty bio.
+ *
+ *	This should only be used by REQ_PC bios.
+ */
+int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page *page,
+		    unsigned int len, unsigned int offset)
+{
+	return __bio_add_page(q, bio, page, len, offset,
+			      queue_max_hw_sectors(q));
+}
 EXPORT_SYMBOL(bio_add_pc_page);
 
 /**
@@ -800,47 +831,22 @@ EXPORT_SYMBOL(bio_add_pc_page);
  *	@len: vec entry length
  *	@offset: vec entry offset
  *
- *	Attempt to add a page to the bio_vec maplist. This will only fail
- *	if either bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.
+ *	Attempt to add a page to the bio_vec maplist. This can fail for a
+ *	number of reasons, such as the bio being full or target block device
+ *	limitations. The target block device must allow bio's up to PAGE_SIZE,
+ *	so it is always possible to add a single page to an empty bio.
  */
-int bio_add_page(struct bio *bio, struct page *page,
-		 unsigned int len, unsigned int offset)
+int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
+		 unsigned int offset)
 {
-	struct bio_vec *bv;
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+	unsigned int max_sectors;
 
-	/*
-	 * cloned bio must not modify vec list
-	 */
-	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
-		return 0;
+	max_sectors = blk_max_size_offset(q, bio->bi_iter.bi_sector);
+	if ((max_sectors < (len >> 9)) && !bio->bi_iter.bi_size)
+		max_sectors = len >> 9;
 
-	/*
-	 * For filesystems with a blocksize smaller than the pagesize
-	 * we will often be called with the same page as last time and
-	 * a consecutive offset.  Optimize this special case.
-	 */
-	if (bio->bi_vcnt > 0) {
-		bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
-
-		if (page == bv->bv_page &&
-		    offset == bv->bv_offset + bv->bv_len) {
-			bv->bv_len += len;
-			goto done;
-		}
-	}
-
-	if (bio->bi_vcnt >= bio->bi_max_vecs)
-		return 0;
-
-	bv		= &bio->bi_io_vec[bio->bi_vcnt];
-	bv->bv_page	= page;
-	bv->bv_len	= len;
-	bv->bv_offset	= offset;
-
-	bio->bi_vcnt++;
-done:
-	bio->bi_iter.bi_size += len;
-	return len;
+	return __bio_add_page(q, bio, page, len, offset, max_sectors);
 }
 EXPORT_SYMBOL(bio_add_page);
 
