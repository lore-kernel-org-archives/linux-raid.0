From: NeilBrown <neilb@suse.com>
Subject: Re: report a bug that panic when grow size for external bitmap
Date: Wed, 30 Aug 2017 14:08:27 +1000
Message-ID: <87ziahg0jo.fsf@notabene.neil.brown.name>
References: <ad8c69c7-f1e0-b6ab-dc87-a81aa7bca391@suse.com> <87y3q3gq8g.fsf@notabene.neil.brown.name> <6eaf97d4-bd8c-e33c-a9c7-37d0fe2086ce@suse.com> <87mv6jgj8z.fsf@notabene.neil.brown.name> <ba801ebe-9c0c-d911-2b18-936495fe0ed3@suse.com> <87k21mhcqw.fsf@notabene.neil.brown.name> <73429dce-a22d-149e-656a-13af228c093f@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73429dce-a22d-149e-656a-13af228c093f@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 30 2017, Zhilong Liu wrote:

>
> Hi, Neil;
>      I have tested the following patch, I still got the call-trace after=
=20
> I built with it.
> If you need other infos, I would append.

Ok, one more try.  If this doesn't work I do the testing myself to
avoid the back-and-forth.

Thanks,
NeilBrown

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 40f3cd7eab0f..05ba9c7d33b4 100644
=2D-- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -368,12 +368,7 @@ static int read_page(struct file *file, unsigned long =
index,
 	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
 		 (unsigned long long)index << PAGE_SHIFT);
=20
=2D	bh =3D alloc_page_buffers(page, 1<<inode->i_blkbits, 0);
=2D	if (!bh) {
=2D		ret =3D -ENOMEM;
=2D		goto out;
=2D	}
=2D	attach_page_buffers(page, bh);
+	bh =3D page_buffers(page);
 	block =3D index << (PAGE_SHIFT - inode->i_blkbits);
 	while (bh) {
 		if (count =3D=3D 0)
@@ -616,9 +611,16 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	}
=20
 	if (bitmap->storage.file) {
=2D		loff_t isize =3D i_size_read(bitmap->storage.file->f_mapping->host);
+		struct inode *inode =3D bitmap->storage.file->f_mapping->host;
+		loff_t isize =3D i_size_read(inode);
 		int bytes =3D isize > PAGE_SIZE ? PAGE_SIZE : isize;
+		struct buffer_head *bh;
=20
+		bh =3D alloc_page_buffers(sb_page, 1 << inode->i_blkbits, 0);
+		if (bh)
+			attach_page_buffers(sb_page, bh);
+		else
+			return -ENOMEM;
 		err =3D read_page(bitmap->storage.file, 0,
 				bitmap, bytes, sb_page);
 	} else {
@@ -771,12 +773,18 @@ static inline struct page *filemap_get_page(struct bi=
tmap_storage *store,
 }
=20
 static int bitmap_storage_alloc(struct bitmap_storage *store,
=2D				unsigned long chunks, int with_super,
+				unsigned long chunks,
+				struct file *file,
+				int with_super,
 				int slot_number)
 {
 	int pnum, offset =3D 0;
 	unsigned long num_pages;
 	unsigned long bytes;
+	struct inode *inode =3D NULL;
+
+	if (file)
+		inode =3D file_inode(file);
=20
 	bytes =3D DIV_ROUND_UP(chunks, 8);
 	if (with_super)
@@ -801,15 +809,33 @@ static int bitmap_storage_alloc(struct bitmap_storage=
 *store,
 		store->filemap[0] =3D store->sb_page;
 		pnum =3D 1;
 		store->sb_page->index =3D offset;
+		if (inode) {
+			struct buffer_head *bh;
+			struct page *p =3D store->sb_page;
+			bh =3D alloc_page_buffers(p, 1 << inode->i_blkbits, 0);
+			if (bh)
+				attach_page_buffers(p, bh);
+			else
+				return -ENOMEM;
+		}
 	}
=20
 	for ( ; pnum < num_pages; pnum++) {
=2D		store->filemap[pnum] =3D alloc_page(GFP_KERNEL|__GFP_ZERO);
=2D		if (!store->filemap[pnum]) {
+		struct page *p =3D alloc_page(GFP_KERNEL|__GFP_ZERO);
+		store->filemap[pnum] =3D p;
+		if (!p) {
 			store->file_pages =3D pnum;
 			return -ENOMEM;
 		}
=2D		store->filemap[pnum]->index =3D pnum + offset;
+		if (inode) {
+			struct buffer_head *bh;
+			bh =3D alloc_page_buffers(p, 1 << inode->i_blkbits, 0);
+			if (bh)
+				attach_page_buffers(p, bh);
+			else
+				return -ENOMEM;
+		}
+		p->index =3D pnum + offset;
 	}
 	store->file_pages =3D pnum;
=20
@@ -2091,7 +2117,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blo=
cks,
 	chunks =3D DIV_ROUND_UP_SECTOR_T(blocks, 1 << chunkshift);
 	memset(&store, 0, sizeof(store));
 	if (bitmap->mddev->bitmap_info.offset || bitmap->mddev->bitmap_info.file)
=2D		ret =3D bitmap_storage_alloc(&store, chunks,
+		ret =3D bitmap_storage_alloc(&store, chunks, bitmap->mddev->bitmap_info.=
file,
 					   !bitmap->mddev->bitmap_info.external,
 					   mddev_is_clustered(bitmap->mddev)
 					   ? bitmap->cluster_slot : 0);

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmmOjwACgkQOeye3VZi
gbmpNg/+PuTAQX2uN9EWWyXdMvqmFoQjJgBsxZKJumi/Ze6NfWxiiVVJw7EuPAwA
AUiAcPRVxTJ/fp8yRwZg9QvlGdNoTvETxdFro5RCv/rKZPis8Iu11kM33VxxeSku
R7hCLyiYaazyjIFUk2NfO+5hD2C1HgGAXh52UgBMqSRPc6jxhrxBuMZZT4t+ap/b
cI0IDs3X7Ft0Y42IsRoAnm/snEQNTzrWUqQ8+UzTwEVt2C0aPdlFNv8mTcpXPZ0Z
6Sgg5YayrWvWYrULZvb5jkBwQLf/3CLLbrvoXUFt4/fW0EVm41V/fNGw5nTY2sPq
CesXVnlsuh+8AgjPFxNbeLXNdsuorgrVPg8oyxnq8GtJzRq4vXiYT2/zqKcGXMZk
GyGnfAYFG4N4u2l4pw78lyhBz4SoQtVvsmHR1OR5HJtngkKKfVENVwfLCRTf/e1v
ZUAKQs8wnB9mW1y1Vwk7AS2Mlh/6zPteoSi0J2aAB4N4FBumbTrB2BQvMvnShXqc
Yx8Sms6rhHQB4dwXXCyXj9n9DZGhqXsgmxd2peO0iDvOWD8YUfe4+AxhMBlgiYrX
gEtugTORvSEGQkVMFRFYL8bMg34XWqD5f7GETSHGlRANMV563EvzDeoCbN0IXHml
pusDIww1kFud0XOG5lmj4/aY4eyn6nkNrqVtW32NjYJkIiqq9sI=
=YGz/
-----END PGP SIGNATURE-----
--=-=-=--
