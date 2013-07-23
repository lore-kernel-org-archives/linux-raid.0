From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2 v2] md: add sync-bitmap to only resync WRITTEN data
 when adding new disk in raid array.
Date: Tue, 23 Jul 2013 15:11:29 +1000
Message-ID: <20130723151129.24cb6b82@notabene.brown>
References: <1374473271-18551-1-git-send-email-robin.k.dong@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jeahfhd9lzrY6J4Bor+K8cr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374473271-18551-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/jeahfhd9lzrY6J4Bor+K8cr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Jul 2013 14:07:50 +0800 Robin Dong <robin.k.dong@gmail.com> wrot=
e:

> From: Robin Dong <sanbai@taobao.com>
>=20
> Add a new bitmap type named "sync-bitmap" for md, all the WRITTEN data wi=
ll be
> marked and when adding a new disk, the md will only resync WRITTEN data to
> new disk therefore it will save a lot of time and reduce disk-durability.
>=20
> We add the "sync-bitmap" behind the "write-intent-bitmap", not closely but
> aligned to PAGE_SIZE:
>=20
> |          page0                       |        page1                   |
> +--------------------------------------+--------------------------------+
> |bitmap_super and write-intent-bitmap  |         sync-bitmap            |
>=20
> all the write-operation will set the bit in sync-bitmap.
>=20
>=20
> TEST CASE:
> 	mdadm --create /dev/md1 --bitmap=3Dinternal --level=3D5 --raid-devices=
=3D4 /dev/sd[c-f]
> 	mkfs.ext4 /dev/md1
> 	mount -t ext4 /dev/md1 /mnt/
> 	cp kernel.tgz /mnt/
> 	reboot
> 	mdadm -As
> 	echo offline > /sys/block/sdc/device/state
> 	mdadm --add /dev/md1 /dev/sdg
> 	(waiting resync done)
> 	mount -t ext4 /dev/md1 /mnt/ (mount success)
> 	cksum /mnt/kernel.tgz        (cksum ok)
>=20
> TODO:
> 	* Allow "discard" to clear bit in sync-bitmap
>=20
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> Cc: NeilBrown <neilb@suse.de>

Hi Robin,
 thanks again.  This is looking very promising.

 One addition that would be be very useful is if 'mdadm -X' could report so=
me
 details about the sync bitmap - at least how many bits are set.

 What happens when you remove a bitmap from the array?  We could:
   - disallow that unless all the bits are set or
   - set recovery_cp to the address of the first unset bit in the bitmap
 Are there any other options?
 I'm not sure which I prefer.  If we chose the first option we would need
 some way to for md to perform a 'sync' which sets all the bits.
 Have you thought about this?  I couldn't see anything related in the patch
 but I might have missed something.

 What happens when you add a bitmap to an existing array?  I suspect that is
 up to "mdadm" to some extent - it can choose which version to use.  You wo=
uld
 presumably set all the bits.  Some might then be cleared by 'discard' if
 that support is ever added.

 Other comments in the code (some very minor).

> ---
> changelog:
> v1 --> v2:
>  * Encode the presence of sync-bitmap into the version number in superblo=
ck of bitmap
>  * Read-modify-write in RAID456 will cause inconsistent if array is not i=
n-sync, so
>    add:
>    1. In bitmap_endwrite to a not-in-sync region, set the write-intent bi=
t and
>    	wake up resync thread.
>    2. When resync finishes, set the sync bit and clear write-intent bit.
>=20
> v1: http://www.spinics.net/lists/raid/msg43570.html
>=20
>  drivers/md/bitmap.c |  196 +++++++++++++++++++++++++++++++++++++++++++++=
++++--
>  drivers/md/bitmap.h |   11 +++-
>  drivers/md/md.c     |    1 +
>  drivers/md/md.h     |    1 +
>  drivers/md/raid1.c  |    7 ++
>  5 files changed, 208 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index a7fd821..0d894af 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -30,6 +30,13 @@
>  #include "md.h"
>  #include "bitmap.h"
> =20
> +static inline sector_t syncbitmap_offset(struct bitmap *bitmap, sector_t=
 block)
> +{
> +	return block +
> +		(bitmap->syncbitmap_num_pages << bitmap->counts.chunkshift
> +		 << PAGE_SHIFT << 3);
> +}
> +
>  static inline char *bmname(struct bitmap *bitmap)
>  {
>  	return bitmap->mddev ? mdname(bitmap->mddev) : "mdX";
> @@ -620,6 +627,8 @@ static int bitmap_read_sb(struct bitmap *bitmap)
>  	bitmap->flags |=3D le32_to_cpu(sb->state);
>  	if (le32_to_cpu(sb->version) =3D=3D BITMAP_MAJOR_HOSTENDIAN)
>  		set_bit(BITMAP_HOSTENDIAN, &bitmap->flags);
> +	if (le32_to_cpu(sb->version) >=3D BITMAP_MAJOR_SYNCBITMAP)
> +		bitmap->mddev->bitmap_info.sync_bitmap =3D 1;
>  	bitmap->events_cleared =3D le64_to_cpu(sb->events_cleared);
>  	err =3D 0;
>  out:
> @@ -682,18 +691,40 @@ static inline struct page *filemap_get_page(struct =
bitmap_storage *store,
>  			      - file_page_index(store, 0)];
>  }
> =20
> -static int bitmap_storage_alloc(struct bitmap_storage *store,
> -				unsigned long chunks, int with_super)
> +static void chunks_to_pages(unsigned long chunks, unsigned long *res_byt=
es,
> +			unsigned long *res_pages, int with_super)

Please try to maintain the formatting.  The "unsigned" in the second line
should line up with the first "unsigned" in the first line.

>  {
> -	int pnum;
> -	unsigned long num_pages;
>  	unsigned long bytes;
> =20
>  	bytes =3D DIV_ROUND_UP(chunks, 8);
>  	if (with_super)
>  		bytes +=3D sizeof(bitmap_super_t);
> =20
> -	num_pages =3D DIV_ROUND_UP(bytes, PAGE_SIZE);
> +	if (res_bytes)
> +		*res_bytes =3D bytes;
> +	if (res_pages)
> +		*res_pages =3D DIV_ROUND_UP(bytes, PAGE_SIZE);
> +}
> +
> +static int bitmap_storage_alloc(struct bitmap_storage *store,
> +				unsigned long chunks, int with_super,
> +				int with_sync_bitmap)
> +{
> +	int pnum;
> +	unsigned long num_pages;
> +	unsigned long bytes;
> +	unsigned long syncbitmap_num_pages;
> +
> +	chunks_to_pages(chunks, &bytes, &num_pages, with_super);
> +	/* we need two bitmaps: write-intent-bitmap and sync-bitmap, sync-bitmap
> +	 * locates behind write-intent-bitmap closely. write-intent-bit maps
> +	 * "this was written recently, a resync might be needed after a crash"
> +	 * and the sync-bit maps "This has been written since array create,
> +	 * so the chunk needs to be recovered to any spare".
> +	 */
> +	chunks_to_pages(chunks, NULL, &syncbitmap_num_pages, 0);
> +	if (with_sync_bitmap)
> +		num_pages +=3D syncbitmap_num_pages;
> =20
>  	store->filemap =3D kmalloc(sizeof(struct page *)
>  				 * num_pages, GFP_KERNEL);
> @@ -853,6 +884,41 @@ static void bitmap_file_set_bit(struct bitmap *bitma=
p, sector_t block)
>  	set_page_attr(bitmap, page->index, BITMAP_PAGE_DIRTY);
>  }
> =20
> +static int syncbitmap_file_test_bit(struct bitmap *bitmap, sector_t bloc=
k)
> +{
> +	unsigned long bit;
> +	struct page *page;
> +	void *kaddr;
> +	unsigned long chunk;
> +	int res;
> +
> +	chunk =3D syncbitmap_offset(bitmap, block) >> bitmap->counts.chunkshift;
> +
> +	page =3D filemap_get_page(&bitmap->storage, chunk);
> +	if (!page)
> +		return 1;
> +	bit =3D file_page_offset(&bitmap->storage, chunk);
> +
> +	/* set the bit */
> +	kaddr =3D kmap_atomic(page);
> +	if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
> +		res =3D test_bit(bit, kaddr);
> +	else
> +		res =3D test_bit_le(bit, kaddr);

The sync bitmap can never be HOSTENDIAN - so this test can be removed.
Similarly below.


> +	kunmap_atomic(kaddr);
> +	pr_debug("test syncbitmap bit %lu page %lu\n", bit, page->index);
> +	return res;
> +}
> +
> +/*
> + * syncbitmap_file_set_bit -- set the bit in sync-bitmap, just jump out
> + * the offset of write-intent-bitmap.
> + */
> +static void syncbitmap_file_set_bit(struct bitmap *bitmap, sector_t bloc=
k)
> +{
> +	bitmap_file_set_bit(bitmap, syncbitmap_offset(bitmap, block));
> +}
> +
>  static void bitmap_file_clear_bit(struct bitmap *bitmap, sector_t block)
>  {
>  	unsigned long bit;
> @@ -1038,6 +1104,61 @@ static int bitmap_init_from_disk(struct bitmap *bi=
tmap, sector_t start)
>  		offset =3D 0;
>  	}
> =20
> +	if (bitmap->mddev->bitmap_info.sync_bitmap) {
> +		for (i =3D 0; i < chunks; i++) {
> +			int b;
> +			index =3D file_page_index(&bitmap->storage, i) +
> +				bitmap->syncbitmap_num_pages;
> +			bit =3D file_page_offset(&bitmap->storage, i);
> +			if (index !=3D oldindex) {
> +				/* this is a new page, read it in */
> +				page =3D store->filemap[index];
> +				if (file)
> +					ret =3D read_page(file, index, bitmap,
> +							PAGE_SIZE, page);
> +				else
> +					ret =3D read_sb_page(
> +						bitmap->mddev,
> +						bitmap->mddev->bitmap_info.offset,
> +						page,
> +						index, PAGE_SIZE);
> +				if (ret)
> +					goto err;
> +
> +				oldindex =3D index;
> +
> +				if (outofdate) {
> +					/*
> +					 * if bitmap is out of date, dirty the
> +					 * whole page and write it out
> +					 */
> +					paddr =3D kmap_atomic(page);
> +					memset(paddr + offset, 0xff,
> +						   PAGE_SIZE - offset);
> +					kunmap_atomic(paddr);
> +					write_page(bitmap, page, 1);
> +
> +					ret =3D -EIO;
> +					if (test_bit(BITMAP_WRITE_ERROR,
> +							 &bitmap->flags))
> +						goto err;
> +				}
> +			}
> +			paddr =3D kmap_atomic(page);
> +			if (test_bit(BITMAP_HOSTENDIAN, &bitmap->flags))
> +				b =3D test_bit(bit, paddr);
> +			else
> +				b =3D test_bit_le(bit, paddr);
> +			kunmap_atomic(paddr);
> +			if (b) {
> +				/* if the disk bit is set, set the memory bit */
> +				syncbitmap_file_set_bit(bitmap, (sector_t)i <<
> +						bitmap->counts.chunkshift);
> +				bit_cnt++;
> +			}
> +			offset =3D 0;
> +		}
> +	}
>  	printk(KERN_INFO "%s: bitmap initialized from disk: "
>  	       "read %lu pages, set %lu of %lu bits\n",
>  	       bmname(bitmap), store->file_pages,
> @@ -1358,6 +1479,8 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_=
t offset, unsigned long secto
>  			sysfs_notify_dirent_safe(bitmap->sysfs_can_clear);
>  		}
> =20
> +		syncbitmap_file_set_bit(bitmap, offset);
> +
>  		if (!success && !NEEDED(*bmc))
>  			*bmc |=3D NEEDED_MASK;
> =20
> @@ -1431,6 +1554,40 @@ int bitmap_start_sync(struct bitmap *bitmap, secto=
r_t offset, sector_t *blocks,
>  }
>  EXPORT_SYMBOL(bitmap_start_sync);
> =20
> +int __syncbitmap_start_sync(struct bitmap *bitmap, sector_t offset,
> +						sector_t *blocks)
> +{
> +	int res;
> +	unsigned long csize;
> +	if (bitmap =3D=3D NULL || !bitmap->mddev->bitmap_info.sync_bitmap) {
> +		*blocks =3D 1024;
> +		return 1;
> +	}
> +
> +	spin_lock_irq(&bitmap->counts.lock);
> +	res =3D syncbitmap_file_test_bit(bitmap, offset);
> +	csize =3D ((sector_t)1) << bitmap->counts.chunkshift;
> +	*blocks =3D csize - (offset & (csize - 1));
> +	spin_unlock_irq(&bitmap->counts.lock);
> +	return res;
> +}
> +
> +int syncbitmap_start_sync(struct bitmap *bitmap, sector_t offset,
> +						sector_t *blocks)
> +{
> +	int rv =3D 0;
> +	sector_t blocks1;
> +
> +	*blocks =3D 0;
> +	while (*blocks < (PAGE_SIZE>>9)) {
> +		rv |=3D __syncbitmap_start_sync(bitmap, offset, &blocks1);
> +		offset +=3D blocks1;
> +		*blocks +=3D blocks1;
> +	}
> +	return rv;
> +}
> +EXPORT_SYMBOL(syncbitmap_start_sync);
> +
>  void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *b=
locks, int aborted)
>  {
>  	bitmap_counter_t *bmc;
> @@ -1805,6 +1962,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t b=
locks,
>  	sector_t old_blocks, new_blocks;
>  	int chunkshift;
>  	int ret =3D 0;
> +	unsigned long pnum, old_pnum, num_pages, old_num_pages;
>  	long pages;
>  	struct bitmap_page *new_bp;
> =20
> @@ -1842,7 +2000,8 @@ int bitmap_resize(struct bitmap *bitmap, sector_t b=
locks,
>  	memset(&store, 0, sizeof(store));
>  	if (bitmap->mddev->bitmap_info.offset || bitmap->mddev->bitmap_info.fil=
e)
>  		ret =3D bitmap_storage_alloc(&store, chunks,
> -					   !bitmap->mddev->bitmap_info.external);
> +				!bitmap->mddev->bitmap_info.external,
> +				bitmap->mddev->bitmap_info.sync_bitmap);

You've changed the indenting here - please keep it the same as it was...


>  	if (ret)
>  		goto err;
> =20
> @@ -1865,6 +2024,31 @@ int bitmap_resize(struct bitmap *bitmap, sector_t =
blocks,
>  		memcpy(page_address(store.sb_page),
>  		       page_address(bitmap->storage.sb_page),
>  		       sizeof(bitmap_super_t));
> +	if (bitmap->mddev->bitmap_info.sync_bitmap) {
> +		/* copy old sync-bitmap to new one */
> +		chunks_to_pages(chunks, NULL, &pnum,
> +					!bitmap->mddev->bitmap_info.external);
> +		bitmap->syncbitmap_num_pages =3D pnum;
> +		if (bitmap->storage.filemap) {
> +			chunks_to_pages(bitmap->counts.chunks, NULL, &old_pnum,
> +				!bitmap->mddev->bitmap_info.external);
> +			num_pages =3D pnum * 2;
> +			old_num_pages =3D old_pnum * 2;
> +			pnum++;
> +			old_pnum++;
> +			for (; pnum <=3D num_pages && old_pnum <=3D old_num_pages;
> +					pnum++, old_pnum++) {
> +				memcpy(store.filemap[pnum],
> +					bitmap->storage.filemap[old_pnum],
> +					PAGE_SIZE);
> +				/* All new sync-bitmap data
> +				 * shoule be write out */
> +				set_bit((pnum << 2) + BITMAP_PAGE_DIRTY,
> +					store.filemap_attr);
> +			}
> +		}
> +	}
> +
>  	bitmap_file_unmap(&bitmap->storage);
>  	bitmap->storage =3D store;
> =20
> diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
> index df4aeb6..ddc30da 100644
> --- a/drivers/md/bitmap.h
> +++ b/drivers/md/bitmap.h
> @@ -7,11 +7,13 @@
>  #define BITMAP_H 1
> =20
>  #define BITMAP_MAJOR_LO 3
> -/* version 4 insists the bitmap is in little-endian order
> +/* version greater or equal to 4 insists the bitmap is in little-endian =
order
> + * version greater or equal to 5 insists it has sync-bitmap
>   * with version 3, it is host-endian which is non-portable
>   */
> -#define BITMAP_MAJOR_HI 4
> +#define BITMAP_MAJOR_HI 6
>  #define	BITMAP_MAJOR_HOSTENDIAN 3
> +#define	BITMAP_MAJOR_SYNCBITMAP 5
> =20
>  /*
>   * in-memory bitmap:
> @@ -226,6 +228,7 @@ struct bitmap {
>  	wait_queue_head_t behind_wait;
> =20
>  	struct sysfs_dirent *sysfs_can_clear;
> +	unsigned long syncbitmap_num_pages;
>  };
> =20
>  /* the bitmap API */
> @@ -252,6 +255,10 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t=
 offset,
>  			unsigned long sectors, int success, int behind);
>  int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *=
blocks, int degraded);
>  void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *b=
locks, int aborted);
> +
> +int syncbitmap_start_sync(struct bitmap *bitmap, sector_t offset,
> +						sector_t *blocks);
> +
>  void bitmap_close_sync(struct bitmap *bitmap);
>  void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector);
> =20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9f13e13..74f4ee4 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1622,6 +1622,7 @@ static int super_1_validate(struct mddev *mddev, st=
ruct md_rdev *rdev)
>  		mddev->events =3D ev1;
>  		mddev->bitmap_info.offset =3D 0;
>  		mddev->bitmap_info.space =3D 0;
> +		mddev->bitmap_info.sync_bitmap =3D 0;
>  		/* Default location for bitmap is 1K after superblock
>  		 * using 3K - total of 4K
>  		 */
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 20f02c0..298c5cd 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -412,6 +412,7 @@ struct mddev {
>  		unsigned long		daemon_sleep; /* how many jiffies between updates? */
>  		unsigned long		max_write_behind; /* write-behind mode */
>  		int			external;
> +		int			sync_bitmap;
>  	} bitmap_info;
> =20
>  	atomic_t 			max_corr_read_errors; /* max read retries */
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d60412c..c2d5b72 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2414,6 +2414,13 @@ static sector_t sync_request(struct mddev *mddev, =
sector_t sector_nr, int *skipp
>  		*skipped =3D 1;
>  		return sync_blocks;
>  	}
> +
> +	if (conf->fullsync && !syncbitmap_start_sync(mddev->bitmap,
> +				sector_nr, &sync_blocks)) {
> +		*skipped =3D 1;
> +		return sync_blocks;
> +	}
> +
>  	/*
>  	 * If there is non-resync activity waiting for a turn,
>  	 * and resync is going fast enough,

I wonder if this is quite enough of a change to raid1.c
If the bitmap chunk size is less than the raid1 resync window size (which is
2Meg I think), then as soon as it finds one chunk that is allowed to be
resynced, it could resync a full window.

Should syncbitmap_start_sync be merged into bitmap_start_sync?

I'm not sure ... your code might be close enough but I'm not quite convinced
yet.


Thanks again,
NeilBrown


--Sig_/jeahfhd9lzrY6J4Bor+K8cr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUe4QgTnsnt1WYoG5AQLpQxAAqDdy5pC9zigJLiTcWgx+CQ3csTHI+qj3
fE8iUdFEQ+eGSgtcVK1rw+PKB1OtnY0L1he9H52jRpyjEg9jco5GCrFXgMp0wBDz
rXDzx45ayH+eaV9bL5dCyIQsdxhzODYEO7uPkEmoTbRDNYIfi2FzmvMBzjOOlhKT
9emFY+1/kZjjKalCqVwytAtVh3aydIR+MM+YmKoD32lHsrjtKnTRoQpYdq0eJ8WN
83f9ECRTk1kYt8Uhd9QP28Gpx4gnlJCr0qSFdv09Ix1uHO9K23quROe7ZMWFhDio
f8M42uqcOdOlRBbxqnC0bGrcoJX58e9vYUJ9gT+FLMTBtQAkiqmXwOOMMXHfrBhp
sBUb7r2fwAJYzOKQKrbUy/XjHyUC02ZDDntgaT5mXKgUkNkKzF02y6LrdFnosvh8
eSeM/wRKJeNyt1rafJet/fq0wfy6s1yx7F1kVwDk+oSAntaPguwa4QBzmNGM/pMc
dBORpWUFi9bUcJrGG8sy6HBhAsXfZg6A3+9iJf+Z6YF1VVX/hpaB3VDK6PpmGPuI
IE2HAAuKAT/SYCXw+dczx3J1KnUxLPzLK7EXq+cOUAg1ArwF5D10D82W45cm6++n
TKVWiO+d+Qd4oOyewoRbsrjF0xHUPIng3LAcyFTjb6R7naIYCSpcYRnRc/9zl1Yf
W65aRGcix3g=
=tyAT
-----END PGP SIGNATURE-----

--Sig_/jeahfhd9lzrY6J4Bor+K8cr--
