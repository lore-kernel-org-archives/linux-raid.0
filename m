From: NeilBrown <neilb@suse.com>
Subject: Re: report a bug that panic when grow size for external bitmap
Date: Tue, 29 Aug 2017 13:12:12 +1000
Message-ID: <87mv6jgj8z.fsf@notabene.neil.brown.name>
References: <ad8c69c7-f1e0-b6ab-dc87-a81aa7bca391@suse.com> <87y3q3gq8g.fsf@notabene.neil.brown.name> <6eaf97d4-bd8c-e33c-a9c7-37d0fe2086ce@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6eaf97d4-bd8c-e33c-a9c7-37d0fe2086ce@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 29 2017, Zhilong Liu wrote:

> Hi, Neil;
>      Thanks for your pointing and sorry for the incorrect dmesg for last=
=20
> mail.
>
> Here update the pure steps and paste the dmesg.
>
> ENV:
> OS: 4.13-rc7 upstream
> linux-apta:~/mdadm-test # df -T /mnt/
> Filesystem     Type 1K-blocks     Used Available Use% Mounted on
> /dev/sda2      ext4  44248848 24416952  18778472  57% /
>
> Reproduce: 100%
>
> Steps:
> linux-apta:~/mdadm-test # ./mdadm -CR /dev/md0 -l1 -b /mnt/3 -n2 -x1=20
> /dev/loop[0-2] --force
> mdadm: Note: this array has metadata at the start and
>      may not be suitable as a boot device.  If you plan to
>      store '/boot' on this device please ensure that
>      your boot-loader understands md/v1.x metadata, or use
>      --metadata=3D0.90
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> linux-apta:~/mdadm-test # cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 loop2[2](S) loop1[1] loop0[0]
>        18944 blocks super 1.2 [2/2] [UU]
>        bitmap: 3/3 pages [12KB], 4KB chunk, file: /mnt/3
>
> unused devices: <none>
> linux-apta:~/mdadm-test # dmesg -c
> [  181.378209] md/raid1:md0: not clean -- starting background reconstruct=
ion
> [  181.378211] md/raid1:md0: active with 2 out of 2 mirrors
> [  181.379354] md0: detected capacity change from 0 to 19398656
> [  181.379773] md: resync of RAID array md0
> [  190.396162] md: md0: resync done.
>
> linux-apta:~/mdadm-test # ./mdadm --grow /dev/md0 --size 128
> Segmentation fault
> linux-apta:~/mdadm-test # cat /sys/block/md0/md/component_size
> 18944                         "here is incorrect also."
> linux-apta:~/mdadm-test # dmesg -c
> [  208.027505] ------------[ cut here ]------------
> [  208.027508] kernel BUG at drivers/md/bitmap.c:298!

Thanks.  Less confusing now.

The problem is that when the bitmap is resized, new pages are allocated
to store the on-disk copy, but these are not read from the file, the
contents are set from the in-memory bitmap.
So read_page() isn't called and particularly

	bh =3D alloc_page_buffers(page, 1<<inode->i_blkbits, 0);
        ...
	attach_page_buffers(page, bh);

doesn't happen.

Maybe something like this will work.
Can you test it?

Thanks,
NeilBrown

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 40f3cd7eab0f..52fe93fa4598 100644
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
@@ -771,12 +766,18 @@ static inline struct page *filemap_get_page(struct bi=
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
@@ -804,12 +805,21 @@ static int bitmap_storage_alloc(struct bitmap_storage=
 *store,
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
@@ -2091,7 +2101,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blo=
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

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmk248ACgkQOeye3VZi
gbk4rRAAkRS0l8NmQCIYCBLJHbe1Llw0yq/R6D9BxlAYanzn/udKdyOuqi5xgpJi
pjCsfw5jJwQfwCLRpCXyxdOffk0epJ509TeQJweUMH+oST/ptJimpF9HPBJziPOT
BnyijR1KvuMrpbT9R+a3Nl8/rIQgkSmyBldwqYZCZXIKr9yis+4L6Iz9SSPkVHg6
zMg7GTgpDEvl3tF5zfTa1zDMk3m5M5ElKTmn4ZaRPf/SbgKxQ1qDTv/lrJfsNKeL
fNkPWa6WtgRlC9SOA4f5zDy98TD57W1qLga/aZbPZ10sQeaMGGg0VIsEC/Q8AU/w
3GQ/zxnS7DEy1c5xmjmaECH1X3XnPTUKfPzbo2YOSTNEeOa6qvenJTB7adubAuRC
qCGllIolnPyaRILajF2fj1P/WOleUdtFgNgEsoxpu+y5UFDgzg1MqorwPq8avGnd
Hdb2F9yP4UxSJyzxOfjx38xicjCcZkM2l9pFcYK/4yRYOsOk+Y/lMRuGu4jcexJ0
5N+rfNzRt/uz/X9LMs15GKYmBRT1h/BkhjptihwGsVTHPbb64weHSJCd/2d927ll
UQMIobCiZUQEiOSzZApGjIMq7gjNC3vFUqETI2cPpOubNKBFOAOBiJsNsgKux6o5
SIx84duqi/vETBGXObTqkdAPflLS12R/8GoJWJG+BYRZV8lD8RM=
=ZkU+
-----END PGP SIGNATURE-----
--=-=-=--
