From: NeilBrown <neilb@suse.com>
Subject: Re: report a bug that panic when grow size for external bitmap
Date: Tue, 29 Aug 2017 20:47:19 +1000
Message-ID: <87k21mhcqw.fsf@notabene.neil.brown.name>
References: <ad8c69c7-f1e0-b6ab-dc87-a81aa7bca391@suse.com> <87y3q3gq8g.fsf@notabene.neil.brown.name> <6eaf97d4-bd8c-e33c-a9c7-37d0fe2086ce@suse.com> <87mv6jgj8z.fsf@notabene.neil.brown.name> <ba801ebe-9c0c-d911-2b18-936495fe0ed3@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ba801ebe-9c0c-d911-2b18-936495fe0ed3@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 29 2017, Zhilong Liu wrote:

> On 08/29/2017 11:12 AM, NeilBrown wrote:
>> On Tue, Aug 29 2017, Zhilong Liu wrote:
>>
>>> Hi, Neil;
>>>       Thanks for your pointing and sorry for the incorrect dmesg for la=
st
>>> mail.
>>>
>>> Here update the pure steps and paste the dmesg.
>>>
>>> ENV:
>>> OS: 4.13-rc7 upstream
>>> linux-apta:~/mdadm-test # df -T /mnt/
>>> Filesystem     Type 1K-blocks     Used Available Use% Mounted on
>>> /dev/sda2      ext4  44248848 24416952  18778472  57% /
>>>
>>> Reproduce: 100%
>>>
>>> Steps:
>>> linux-apta:~/mdadm-test # ./mdadm -CR /dev/md0 -l1 -b /mnt/3 -n2 -x1
>>> /dev/loop[0-2] --force
>>> mdadm: Note: this array has metadata at the start and
>>>       may not be suitable as a boot device.  If you plan to
>>>       store '/boot' on this device please ensure that
>>>       your boot-loader understands md/v1.x metadata, or use
>>>       --metadata=3D0.90
>>> mdadm: Defaulting to version 1.2 metadata
>>> mdadm: array /dev/md0 started.
>>> linux-apta:~/mdadm-test # cat /proc/mdstat
>>> Personalities : [raid1]
>>> md0 : active raid1 loop2[2](S) loop1[1] loop0[0]
>>>         18944 blocks super 1.2 [2/2] [UU]
>>>         bitmap: 3/3 pages [12KB], 4KB chunk, file: /mnt/3
>>>
>>> unused devices: <none>
>>> linux-apta:~/mdadm-test # dmesg -c
>>> [  181.378209] md/raid1:md0: not clean -- starting background reconstru=
ction
>>> [  181.378211] md/raid1:md0: active with 2 out of 2 mirrors
>>> [  181.379354] md0: detected capacity change from 0 to 19398656
>>> [  181.379773] md: resync of RAID array md0
>>> [  190.396162] md: md0: resync done.
>>>
>>> linux-apta:~/mdadm-test # ./mdadm --grow /dev/md0 --size 128
>>> Segmentation fault
>>> linux-apta:~/mdadm-test # cat /sys/block/md0/md/component_size
>>> 18944                         "here is incorrect also."
>>> linux-apta:~/mdadm-test # dmesg -c
>>> [  208.027505] ------------[ cut here ]------------
>>> [  208.027508] kernel BUG at drivers/md/bitmap.c:298!
>> Thanks.  Less confusing now.
>>
>> The problem is that when the bitmap is resized, new pages are allocated
>> to store the on-disk copy, but these are not read from the file, the
>> contents are set from the in-memory bitmap.
>> So read_page() isn't called and particularly
>>
>> 	bh =3D alloc_page_buffers(page, 1<<inode->i_blkbits, 0);
>>          ...
>> 	attach_page_buffers(page, bh);
>>
>> doesn't happen.
>>
>> Maybe something like this will work.
>> Can you test it?
>
> Another panic happens when I built with the below patch.
>
> Steps:
> 1. patching the codes to bitmap.c
> 2. rebuilt the kernel source code.
> 3. reboot and test.
>
> linux-apta:~/mdadm-test # ./mdadm -CR /dev/md0 -l1 -b /mnt/3 -n2 -x1=20
> /dev/loop[0-2] --force
> mdadm: Note: this array has metadata at the start and
>      may not be suitable as a boot device.  If you plan to
>      store '/boot' on this device please ensure that
>      your boot-loader understands md/v1.x metadata, or use
>      --metadata=3D0.90
> mdadm: Defaulting to version 1.2 metadata
> Segmentation fault
> linux-apta:~/mdadm-test # dmesg -c
> [   46.416567] md/raid1:md0: not clean -- starting background reconstruct=
ion
> [   46.416570] md/raid1:md0: active with 2 out of 2 mirrors
> [   46.417003] ------------[ cut here ]------------
> [   46.417004] kernel BUG at drivers/md/bitmap.c:371!

Thanks.  I see what I missed. Please try this patch instead.

NeilBrown

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 40f3cd7eab0f..ca7633a81632 100644
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
@@ -801,15 +802,33 @@ static int bitmap_storage_alloc(struct bitmap_storage=
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
@@ -2091,7 +2110,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blo=
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

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmlRjkACgkQOeye3VZi
gbkoEg/+Oxlc4naZRlRh1Gb+06RO2DQzQoMK1ii2gc5li44Hr446n0Uae9L1YAvQ
KiuQx5L+JUJQI6HAOzxgnhYVRssE4NWL6ihiALB2TMPQzBpOjjjoaIQSxwCEZ8Ex
yonFtrScFLOEa/9e0QjhhAnZ6p0RFJ39+iWQJ8zfiOGrG7Vs/jfpfcBJuJp6agCB
OqCW2NU7edK9WYSefgnv05PUOV95cPOKZM3MVNsHMk4YBJ9YhptH0Lag/uEiufbr
9Ted1O0ocfgUGMpLA0fFKbsNiZGzFBH0a0AuIMUiHfuxxi5aNv+QRMy+EYWUD2lE
uDdEMbliu7PSnwojgx4lPLifErDgYlNDkE7MneemHoeJPA8YVCEipv8O5sgOzhS7
sE+yc1457awKpefKgabm2GjIXfh32lu8OE+/MJ84PAlZ5kbhjtycFQdY5x7WurTx
mOhSA9i7XrSsHjy76KjgTMmr5pCPPJsv4c1a8JFiU/yKps+HjxmPyUw27tpZJmeq
o7RMxrZKhJhHWpeKi8s2TcckW1zXTSwtKE7d2zKcJV9vG4YySAbk2K/7yLkGKgiF
edw1HFtqF/V+tvImJs656CGhBGxwNQIR0i8/vGs6W465nq79VViEVi5GahpPkpqB
5Dnd6+7HbWzmX/u5xHnW2ZGNbjwct0K85GIfIf2sZ9fiy3LVlXY=
=qY9u
-----END PGP SIGNATURE-----
--=-=-=--
