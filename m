Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15F72638A0
	for <linux-raid@vger.kernel.org>; Fri, 18 Apr 2025 01:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744941424; cv=none; b=m4rVZ58+B3d8x0O5WRkg0qOHIHtX6JjePSu+dCARaeWX4lwrGYC8X3p+ZHmmEtf7uDROM75ae9OfYDC+F7U8iSoKHhoVQ6TcrSD8+4spKwS21FeP0kYwUmbk6vUegEgRvspkQByKunqvEdnBvCj6FXANVmsLWjZNyz+VqTc838Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744941424; c=relaxed/simple;
	bh=+qoTot+2ndz3qJ4EmytkGuzuKLI8yU9Srs6UHH1jDaQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uO1yXyMSvAuDcHxMB0LzfwgrXs4uXI3fGg6ZcJscOg5hA7JCfvnDMa//bz7A/vO9a/oPPYQOA46q5QFNpsDPZp4Plk8zZwPfLO+Mypfc8cgUD0Nb21weGFUlamEYNT/GvYXlJS8pQRKucl2RVRiOPacg5qhfCz5tezDlEk9SOGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=LhhF1W+s; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="LhhF1W+s"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53I12lk5006550
	for <linux-raid@vger.kernel.org>; Thu, 17 Apr 2025 18:57:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=TGtNMLzrs07SCqlpHd
	wN+tWcc+MuCfDUHBHJByB374k=; b=LhhF1W+sOg2oPoauUQzG4ysKipPlCWCjir
	CwMBML0MUD33eY4CKD/I1hnB0pLDQlT5RaOr2QOO9Ke4W3R9QTfk6dxfX1wLYTW4
	3hJIVQFj5FR+hPIoHm2GXTle3FW25av0si6Svg3bUL/uYP7sWplm5HZhohwlbsns
	28jWV2pXOzuivqDraywHloc6RenpHQOWZDygXK/4/0B2WMUFUEmEjMy0gZAup/ef
	5hQL/ft/2DCn639mR1fUQsZ672yRpV/5KYwryRComOCcumlREjmRAyjjM8Z5xlEy
	0NUFQf4ZpezGchL2HgFbR840alLk6Py+erlsUKg4DUEtcWj+R+qQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 463akp99a7-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 17 Apr 2025 18:57:01 -0700 (PDT)
Received: from twshared53813.03.ash8.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Fri, 18 Apr 2025 01:56:49 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 4ED9B1A63EFB7; Thu, 17 Apr 2025 18:56:37 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <song@kernel.org>, <yukuai3@huawei.com>, <linux-raid@vger.kernel.org>
CC: <hch@lst.de>, <willy@infradead.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH-RFC] md-bitmap: use page cache for file backed
Date: Thu, 17 Apr 2025 18:56:36 -0700
Message-ID: <20250418015636.2457376-1-kbusch@meta.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=X/BSKHTe c=1 sm=1 tr=0 ts=6801b16d cx=c_pps a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=DH78Tv9yR_RMhg1aOm4A:9 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: pHZNFpYbZ37q0cHRVGsnqIsMY7A4t52a
X-Proofpoint-ORIG-GUID: pHZNFpYbZ37q0cHRVGsnqIsMY7A4t52a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-18_01,2025-04-17_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

The md bitmap file had been using a custom page and buffer_head mapping,
going around the filesystem. Use pages from the file's page cache
instead, removing the abused buffer_head and bmap usage.

For file backed bitmaps, pages are initialized with read_mapping_page
instead of allocating special pages. This returns pages synced with the
backing file. Persisting changes just needs to set the dirty pages and
initiate a write back as needed.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---

I became interested in trying this during the LSFMM. There was also this
an earlier discussion on the mailing list where Willy casuaully
mentioned something I think is along this idea:

  https://lore.kernel.org/linux-block/Z8XJSL-rSLUtx-NL@casper.infradead.o=
rg/

Christoph suggested an alternative kernel intitiated direct-io path, but
I think this is just too simple to not consider. In fact, it's so darn
simple, I wonder if the "internal" option ought provide an
address_space_operations to help abstract the backing store from the
bitmap management to further converge this feature.

I've ran this through fstests with different filesystems and didn't see
any alarms. I also ran it through mdadm's test suite, but those do not
test anything with md file bitmap, so much of the changes wouldn't be
exercised with that test.

Anyway, I've this marked RFC since I am not yet familiar enough with
md-bitmap, so I'm sure I've missed something. Thanks

 drivers/md/md-bitmap.c | 253 ++++++++++++-----------------------------
 1 file changed, 74 insertions(+), 179 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 44ec9b17cfd33..01a26bf2c13d9 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -497,134 +497,10 @@ static void write_sb_page(struct bitmap *bitmap, u=
nsigned long pg_index,
=20
 static void md_bitmap_file_kick(struct bitmap *bitmap);
=20
-#ifdef CONFIG_MD_BITMAP_FILE
-static void write_file_page(struct bitmap *bitmap, struct page *page, in=
t wait)
-{
-	struct buffer_head *bh =3D page_buffers(page);
-
-	while (bh && bh->b_blocknr) {
-		atomic_inc(&bitmap->pending_writes);
-		set_buffer_locked(bh);
-		set_buffer_mapped(bh);
-		submit_bh(REQ_OP_WRITE | REQ_SYNC, bh);
-		bh =3D bh->b_this_page;
-	}
-
-	if (wait)
-		wait_event(bitmap->write_wait,
-			   atomic_read(&bitmap->pending_writes) =3D=3D 0);
-}
-
-static void end_bitmap_write(struct buffer_head *bh, int uptodate)
-{
-	struct bitmap *bitmap =3D bh->b_private;
-
-	if (!uptodate)
-		set_bit(BITMAP_WRITE_ERROR, &bitmap->flags);
-	if (atomic_dec_and_test(&bitmap->pending_writes))
-		wake_up(&bitmap->write_wait);
-}
-
-static void free_buffers(struct page *page)
-{
-	struct buffer_head *bh;
-
-	if (!PagePrivate(page))
-		return;
-
-	bh =3D page_buffers(page);
-	while (bh) {
-		struct buffer_head *next =3D bh->b_this_page;
-		free_buffer_head(bh);
-		bh =3D next;
-	}
-	detach_page_private(page);
-	put_page(page);
-}
-
-/* read a page from a file.
- * We both read the page, and attach buffers to the page to record the
- * address of each block (using bmap).  These addresses will be used
- * to write the block later, completely bypassing the filesystem.
- * This usage is similar to how swap files are handled, and allows us
- * to write to a file with no concerns of memory allocation failing.
- */
-static int read_file_page(struct file *file, unsigned long index,
-		struct bitmap *bitmap, unsigned long count, struct page *page)
-{
-	int ret =3D 0;
-	struct inode *inode =3D file_inode(file);
-	struct buffer_head *bh;
-	sector_t block, blk_cur;
-	unsigned long blocksize =3D i_blocksize(inode);
-
-	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
-		 (unsigned long long)index << PAGE_SHIFT);
-
-	bh =3D alloc_page_buffers(page, blocksize);
-	if (!bh) {
-		ret =3D -ENOMEM;
-		goto out;
-	}
-	attach_page_private(page, bh);
-	blk_cur =3D index << (PAGE_SHIFT - inode->i_blkbits);
-	while (bh) {
-		block =3D blk_cur;
-
-		if (count =3D=3D 0)
-			bh->b_blocknr =3D 0;
-		else {
-			ret =3D bmap(inode, &block);
-			if (ret || !block) {
-				ret =3D -EINVAL;
-				bh->b_blocknr =3D 0;
-				goto out;
-			}
-
-			bh->b_blocknr =3D block;
-			bh->b_bdev =3D inode->i_sb->s_bdev;
-			if (count < blocksize)
-				count =3D 0;
-			else
-				count -=3D blocksize;
-
-			bh->b_end_io =3D end_bitmap_write;
-			bh->b_private =3D bitmap;
-			atomic_inc(&bitmap->pending_writes);
-			set_buffer_locked(bh);
-			set_buffer_mapped(bh);
-			submit_bh(REQ_OP_READ, bh);
-		}
-		blk_cur++;
-		bh =3D bh->b_this_page;
-	}
-
-	wait_event(bitmap->write_wait,
-		   atomic_read(&bitmap->pending_writes)=3D=3D0);
-	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
-		ret =3D -EIO;
-out:
-	if (ret)
-		pr_err("md: bitmap read error: (%dB @ %llu): %d\n",
-		       (int)PAGE_SIZE,
-		       (unsigned long long)index << PAGE_SHIFT,
-		       ret);
-	return ret;
-}
-#else /* CONFIG_MD_BITMAP_FILE */
-static void write_file_page(struct bitmap *bitmap, struct page *page, in=
t wait)
-{
-}
-static int read_file_page(struct file *file, unsigned long index,
-		struct bitmap *bitmap, unsigned long count, struct page *page)
-{
-	return -EIO;
-}
 static void free_buffers(struct page *page)
 {
 	put_page(page);
 }
-#endif /* CONFIG_MD_BITMAP_FILE */
=20
 /*
  * bitmap file superblock operations
@@ -643,11 +519,7 @@ static void filemap_write_page(struct bitmap *bitmap=
, unsigned long pg_index,
 		/* go to node bitmap area starting point */
 		pg_index +=3D store->sb_index;
 	}
-
-	if (store->file)
-		write_file_page(bitmap, page, wait);
-	else
-		write_sb_page(bitmap, pg_index, page, wait);
+	write_sb_page(bitmap, pg_index, page, wait);
 }
=20
 /*
@@ -658,8 +530,7 @@ static void filemap_write_page(struct bitmap *bitmap,=
 unsigned long pg_index,
 static void md_bitmap_wait_writes(struct bitmap *bitmap)
 {
 	if (bitmap->storage.file)
-		wait_event(bitmap->write_wait,
-			   atomic_read(&bitmap->pending_writes)=3D=3D0);
+		return;
 	else
 		/* Note that we ignore the return value.  The writes
 		 * might have failed, but that would just mean that
@@ -706,9 +577,10 @@ static void bitmap_update_sb(void *data)
 					   bitmap_info.space);
 	kunmap_local(sb);
=20
-	if (bitmap->storage.file)
-		write_file_page(bitmap, bitmap->storage.sb_page, 1);
-	else
+	if (bitmap->storage.file) {
+		set_page_dirty(bitmap->storage.sb_page);
+		filemap_fdatawrite_range(bitmap->storage.file->f_mapping, 0, 1);
+	} else
 		write_sb_page(bitmap, bitmap->storage.sb_index,
 			      bitmap->storage.sb_page, 1);
 }
@@ -741,6 +613,15 @@ static void bitmap_print_sb(struct bitmap *bitmap)
 	kunmap_local(sb);
 }
=20
+static struct page *get_sb_page(struct bitmap_storage *store, int index)
+{
+	struct file *file =3D store->file;
+
+	if (file)
+		return read_mapping_page(file->f_mapping, index, file);
+	return alloc_page(GFP_KERNEL | __GFP_ZERO);
+}
+
 /*
  * bitmap_new_disk_sb
  * @bitmap
@@ -757,7 +638,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitma=
p)
 	bitmap_super_t *sb;
 	unsigned long chunksize, daemon_sleep, write_behind;
=20
-	bitmap->storage.sb_page =3D alloc_page(GFP_KERNEL | __GFP_ZERO);
+	bitmap->storage.sb_page =3D get_sb_page(&bitmap->storage, 0);
 	if (bitmap->storage.sb_page =3D=3D NULL)
 		return -ENOMEM;
 	bitmap->storage.sb_index =3D 0;
@@ -806,6 +687,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitma=
p)
 	bitmap->mddev->bitmap_info.nodes =3D 0;
=20
 	kunmap_local(sb);
+	set_page_dirty(bitmap->storage.sb_page);
=20
 	return 0;
 }
@@ -832,9 +714,14 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 		goto out_no_sb;
 	}
 	/* page 0 is the superblock, read it... */
-	sb_page =3D alloc_page(GFP_KERNEL);
+	sb_page =3D get_sb_page(&bitmap->storage, 0);
 	if (!sb_page)
 		return -ENOMEM;
+	if (bitmap->storage.file && !PageUptodate(sb_page)) {
+		put_page(sb_page);
+		return -EIO;
+	}
+
 	bitmap->storage.sb_page =3D sb_page;
=20
 re_read:
@@ -853,18 +740,12 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 			bitmap->cluster_slot, offset);
 	}
=20
-	if (bitmap->storage.file) {
-		loff_t isize =3D i_size_read(bitmap->storage.file->f_mapping->host);
-		int bytes =3D isize > PAGE_SIZE ? PAGE_SIZE : isize;
-
-		err =3D read_file_page(bitmap->storage.file, 0,
-				bitmap, bytes, sb_page);
-	} else {
+	if (!bitmap->storage.file) {
 		err =3D read_sb_page(bitmap->mddev, offset, sb_page, 0,
 				   sizeof(bitmap_super_t));
+		if (err)
+			return err;
 	}
-	if (err)
-		return err;
=20
 	err =3D -EINVAL;
 	sb =3D kmap_local_page(sb_page);
@@ -1028,7 +909,7 @@ static int md_bitmap_storage_alloc(struct bitmap_sto=
rage *store,
 		return -ENOMEM;
=20
 	if (with_super && !store->sb_page) {
-		store->sb_page =3D alloc_page(GFP_KERNEL|__GFP_ZERO);
+		store->sb_page =3D get_sb_page(store, 0);
 		if (store->sb_page =3D=3D NULL)
 			return -ENOMEM;
 	}
@@ -1041,7 +922,7 @@ static int md_bitmap_storage_alloc(struct bitmap_sto=
rage *store,
 	}
=20
 	for ( ; pnum < num_pages; pnum++) {
-		store->filemap[pnum] =3D alloc_page(GFP_KERNEL|__GFP_ZERO);
+		store->filemap[pnum] =3D get_sb_page(store, pnum);
 		if (!store->filemap[pnum]) {
 			store->file_pages =3D pnum;
 			return -ENOMEM;
@@ -1172,6 +1053,7 @@ static void md_bitmap_file_set_bit(struct bitmap *b=
itmap, sector_t block)
 	pr_debug("set file bit %lu page %lu\n", bit, index);
 	/* record page number so it gets flushed to disk when unplug occurs */
 	set_page_attr(bitmap, index - node_offset, BITMAP_PAGE_DIRTY);
+	set_page_dirty(page);
 }
=20
 static void md_bitmap_file_clear_bit(struct bitmap *bitmap, sector_t blo=
ck)
@@ -1198,6 +1080,7 @@ static void md_bitmap_file_clear_bit(struct bitmap =
*bitmap, sector_t block)
 	else
 		clear_bit_le(bit, paddr);
 	kunmap_local(paddr);
+	set_page_dirty(page);
 	if (!test_page_attr(bitmap, index - node_offset, BITMAP_PAGE_NEEDWRITE)=
) {
 		set_page_attr(bitmap, index - node_offset, BITMAP_PAGE_PENDING);
 		bitmap->allclean =3D 0;
@@ -1250,11 +1133,15 @@ static void __bitmap_unplug(struct bitmap *bitmap=
)
 					"md bitmap_unplug");
 			}
 			clear_page_attr(bitmap, i, BITMAP_PAGE_PENDING);
-			filemap_write_page(bitmap, i, false);
-			writing =3D 1;
+			if (!bitmap->storage.file) {
+				filemap_write_page(bitmap, i, false);
+				writing =3D 1;
+			}
 		}
 	}
-	if (writing)
+	if (bitmap->storage.file)
+		filemap_fdatawrite(bitmap->storage.file->f_mapping);
+	else if (writing)
 		md_bitmap_wait_writes(bitmap);
=20
 	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
@@ -1355,6 +1242,9 @@ static int md_bitmap_init_from_disk(struct bitmap *=
bitmap, sector_t start)
 	if (mddev_is_clustered(mddev))
 		node_offset =3D bitmap->cluster_slot * (DIV_ROUND_UP(store->bytes, PAG=
E_SIZE));
=20
+	if (file)
+		goto check_stale;
+
 	for (i =3D 0; i < store->file_pages; i++) {
 		struct page *page =3D store->filemap[i];
 		int count;
@@ -1365,15 +1255,13 @@ static int md_bitmap_init_from_disk(struct bitmap=
 *bitmap, sector_t start)
 		else
 			count =3D PAGE_SIZE;
=20
-		if (file)
-			ret =3D read_file_page(file, i, bitmap, count, page);
-		else
-			ret =3D read_sb_page(mddev, 0, page, i + node_offset,
-					   count);
+		ret =3D read_sb_page(mddev, 0, page, i + node_offset,
+				   count);
 		if (ret)
 			goto err;
 	}
=20
+check_stale:
 	if (outofdate) {
 		pr_warn("%s: bitmap file is out of date, doing full recovery\n",
 			bmname(bitmap));
@@ -1393,13 +1281,22 @@ static int md_bitmap_init_from_disk(struct bitmap=
 *bitmap, sector_t start)
 			paddr =3D kmap_local_page(page);
 			memset(paddr + offset, 0xff, PAGE_SIZE - offset);
 			kunmap_local(paddr);
+			set_page_dirty(page);
=20
-			filemap_write_page(bitmap, i, true);
-			if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags)) {
-				ret =3D -EIO;
-				goto err;
+			if (!file) {
+				filemap_write_page(bitmap, i, true);
+				if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags)) {
+					ret =3D -EIO;
+					goto err;
+				}
 			}
 		}
+
+		if (file) {
+			ret =3D filemap_fdatawait_keep_errors(file->f_mapping);
+			if (ret)
+				goto err;
+		}
 	}
=20
 	for (i =3D 0; i < chunks; i++) {
@@ -1552,8 +1449,8 @@ static void bitmap_daemon_work(struct mddev *mddev)
 			sb->events_cleared =3D
 				cpu_to_le64(bitmap->events_cleared);
 			kunmap_local(sb);
-			set_page_attr(bitmap, 0,
-				      BITMAP_PAGE_NEEDWRITE);
+			set_page_dirty(bitmap->storage.sb_page);
+			set_page_attr(bitmap, 0, BITMAP_PAGE_NEEDWRITE);
 		}
 	}
 	/* Now look at the bitmap counters and if any are '2' or '1',
@@ -1606,16 +1503,17 @@ static void bitmap_daemon_work(struct mddev *mdde=
v)
 	     j < bitmap->storage.file_pages
 		     && !test_bit(BITMAP_STALE, &bitmap->flags);
 	     j++) {
-		if (test_page_attr(bitmap, j,
-				   BITMAP_PAGE_DIRTY))
+		if (test_page_attr(bitmap, j, BITMAP_PAGE_DIRTY))
 			/* bitmap_unplug will handle the rest */
 			break;
 		if (bitmap->storage.filemap &&
 		    test_and_clear_page_attr(bitmap, j,
-					     BITMAP_PAGE_NEEDWRITE))
+					     BITMAP_PAGE_NEEDWRITE) &&
+		    !bitmap->storage.file)
 			filemap_write_page(bitmap, j, false);
 	}
-
+	if (bitmap->storage.file)
+		filemap_fdatawrite(bitmap->storage.file->f_mapping);
  done:
 	if (bitmap->allclean =3D=3D 0)
 		mddev_set_timeout(mddev, mddev->bitmap_info.daemon_sleep, true);
@@ -2156,15 +2054,9 @@ static struct bitmap *__bitmap_create(struct mddev=
 *mddev, int slot)
 	} else
 		bitmap->sysfs_can_clear =3D NULL;
=20
-	bitmap->storage.file =3D file;
-	if (file) {
-		get_file(file);
-		/* As future accesses to this file will use bmap,
-		 * and bypass the page cache, we must sync the file
-		 * first.
-		 */
-		vfs_fsync(file, 1);
-	}
+	if (file)
+		bitmap->storage.file =3D get_file(file);
+
 	/* read superblock from bitmap file (this sets mddev->bitmap_info.chunk=
size) */
 	if (!mddev->bitmap_info.external) {
 		/*
@@ -2440,7 +2332,13 @@ static int __bitmap_resize(struct bitmap *bitmap, =
sector_t blocks,
=20
 	chunks =3D DIV_ROUND_UP_SECTOR_T(blocks, 1 << chunkshift);
 	memset(&store, 0, sizeof(store));
-	if (bitmap->mddev->bitmap_info.offset || bitmap->mddev->bitmap_info.fil=
e)
+
+	store.file =3D bitmap->mddev->bitmap_info.file;
+	bitmap->storage.file =3D NULL;
+	if (store.file)
+		store.sb_page =3D bitmap->storage.sb_page;
+
+	if (bitmap->mddev->bitmap_info.offset || store.file)
 		ret =3D md_bitmap_storage_alloc(&store, chunks,
 					      !bitmap->mddev->bitmap_info.external,
 					      mddev_is_clustered(bitmap->mddev)
@@ -2462,10 +2360,7 @@ static int __bitmap_resize(struct bitmap *bitmap, =
sector_t blocks,
 	if (!init)
 		bitmap->mddev->pers->quiesce(bitmap->mddev, 1);
=20
-	store.file =3D bitmap->storage.file;
-	bitmap->storage.file =3D NULL;
-
-	if (store.sb_page && bitmap->storage.sb_page)
+	if (!store.file && store.sb_page && bitmap->storage.sb_page)
 		memcpy(page_address(store.sb_page),
 		       page_address(bitmap->storage.sb_page),
 		       sizeof(bitmap_super_t));
--=20
2.47.1

