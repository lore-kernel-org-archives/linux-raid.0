Received: from va-2-55.ptr.blmpb.com (va-2-55.ptr.blmpb.com [209.127.231.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238A62F6562
	for <linux-raid@vger.kernel.org>; Mon,  5 Oct 2026 17:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791220989; cv=none; b=p6tmCRPu5lLzIfJtneQFCoqxMuP9g2JMDc5TQBcvdXE0NHoeozgblZmiU4ESX5lEqeZyUfDdCGksjbGcGDajPB60qRqrFuswI1kUyuc5ZtBZT7me4fvlB+0jjcCAkk/QMBhu2RI0+Mz/3DNnUWK/yHxCkwXIjCXvAlu6gyochS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791220989; c=relaxed/simple;
	bh=+4dwxtkuASJ+VXA542DwW+MJLJJ4Vv84XSBi1O04Fh0=;
	h=Message-Id:Mime-Version:To:Cc:References:In-Reply-To:Content-Type:
	 From:Subject:Date; b=P/EW0K9/FppvTjYS+bULNeyfnY8J+6aJpWCzM3ByHMK6d4bktGf6OMYgyTp/U3fVC1vkDIwn13Jxj4OXQGJZ83R6v6dL7bM35g6LjhRFuo6saZTfYClsXx3uYgUkfUKoPfpUL8QXvIgwUAzLGSjgitNNtwRDXz0jHH0kviuTo2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=S2kMZ5pN; arc=none smtp.client-ip=209.127.231.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="S2kMZ5pN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1791220979;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=xslE3x+zIE1ZTUq02+3BJMjQkkhFAMeVu0zHJVwqij4=;
 b=S2kMZ5pNT20HKGRsdVj51UpzxZwRkPb6I7GlXR/Jly0JRbNXmmIXqL7hXwhbByhsXFn+9Z
 v3Hz8lnQodMS8W3Bd07qrH31SzoHtNcLe+Un6532uk8DcbWac+v1uHl7xr+rlhkAKNOvZz
 DIHEtk2HIqPbJzRzDvFCfeo1IuYlEPy1Q0ktjWRUQ5kkSQdAGLaJWxL0H/f6mBUgxlG3lx
 LDSPdQSv7JU+7RsUU793uB/8wcSWYeBeKThotPgqKA9QkGIKJLngDP4nonHxdGQvwc9SSY
 i9wYu//4T7iUv6g/Gis06OM0DjiSZqU2TQsTO4Z12I+xJy98HffN1ZRhaoDxIA==
Message-Id: <7f55f471-867b-47a9-8f02-f65adaf6cd29@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ac3dcf2+ddec5b+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.177]) by smtp.larksuite.com with ESMTPS; Mon, 05 Oct 2026 17:22:57 +0000
To: "Palla Raghunath" <raghunathpalla.0209@gmail.com>, 
	<linux-kernel@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
Cc: "Shuah Khan" <shuah@kernel.org>, 
	"Brigham Campbell" <me@brighamcampbell.com>, 
	<linux-kernel-mentees@lists.linux.dev>, 
	<syzbot+422b372cabfbaa528725@syzkaller.appspotmail.com>, 
	"Song Liu" <song@kernel.org>, "Li Nan" <magiclinan@didiglobal.com>, 
	"Xiao Ni" <xiao@kernel.org>, "NeilBrown" <neil@brown.name>,  "Trela, 
	 Maciej" <Maciej.Trela@intel.com>, <linux-raid@vger.kernel.org>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
References: <20260923161729.122240-1-raghunathpalla.0209@gmail.com>
In-Reply-To: <20260923161729.122240-1-raghunathpalla.0209@gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid0: don't BUG() on a bio that lands off the end of the array
Date: Tue, 6 Oct 2026 01:22:53 +0800

Hi,

=E5=9C=A8 2026/9/24 0:17, Palla Raghunath =E5=86=99=E9=81=93:
> find_zone() looks for the strip zone holding a given sector and BUG()s if
> it can't find one.  That is only a safe assumption while the capacity the
> array advertises matches what the zones actually cover, and a personality
> takeover can break exactly that.
>
> level_store() lets you switch a live array to a different personality.
> The new ->run() recalculates mddev->array_sectors, but level_store() neve=
r
> tells the gendisk about it - it is the one place in md that changes the
> array size without a set_capacity_and_notify(), which do_md_run(),
> array_size_store(), update_size(), md_reap_sync_thread() and linear_add()
> all do.  So when a takeover makes the array smaller, the block device goe=
s
> on advertising the old size and I/O sails off the end of the new mapping.
>
> syzbot got there with a raid1 that had no metadata.  Such a member comes =
in
> through md_import_device(dev, -1, -1), which never sets rdev->sectors, an=
d
> the check in bind_rdev_to_array() that keeps mddev->dev_sectors inside th=
e
> member is skipped precisely when rdev->sectors is 0:
>
> 	if (!test_bit(Journal, &rdev->flags) &&
> 	    rdev->sectors &&
> 	    (mddev->dev_sectors =3D=3D 0 || rdev->sectors < mddev->dev_sectors))=
 {
>
> md/component_size had set dev_sectors to 2048, so raid1 came up with
> array_sectors =3D 2048 and the disk got a 2048 sector capacity.  Writing
> "raid0" to md/level then took the array over: create_strip_zones() rounde=
d
> rdev->sectors (0) down to a chunk multiple, so the single strip zone ende=
d
> at 0 and raid0_size() returned 0.  The capacity stayed at 2048, so the
> partition scan on the next open of /dev/md0 read sector 0 and fell over:

This takeover looks like real problem in the first place, a takeover on liv=
e array
can't shrink or mess up the user data, which means if there is a file syste=
m mounted
on the array, the file system should still be consistent after take over.

I'll suggest rejecting such takeover to fix this problem.

>
>    kernel BUG at drivers/md/raid0.c:318!
>    RIP: 0010:find_zone drivers/md/raid0.c:318 [inline]
>    RIP: 0010:raid0_map_submit_bio drivers/md/raid0.c:568 [inline]
>    RIP: 0010:raid0_make_request+0xf17/0x10b0 drivers/md/raid0.c:626
>    Call Trace:
>     <TASK>
>     md_handle_request+0xb0a/0xe60 drivers/md/md.c:417
>     __submit_bio+0x27f/0x340 block/blk-core.c:681
>     submit_bio_noacct_nocheck+0x4e8/0xa40 block/blk-core.c:792
>     block_read_full_folio+0x7a6/0x810 fs/buffer.c:2373
>     read_part_sector+0xb6/0x2b0 block/partitions/core.c:724
>     adfspart_check_ICS+0xb1/0x960 block/partitions/acorn.c:357
>     bdev_disk_changed+0x851/0x17a0 block/partitions/core.c:695
>     blkdev_get_whole+0x372/0x510 block/bdev.c:793
>     bdev_open+0x324/0xd70 block/bdev.c:1002
>     blkdev_open+0x461/0x600 block/fops.c:674
>     __x64_sys_openat+0x138/0x170 fs/open.c:1434
>
> Just refreshing the capacity in level_store() is not enough on its own.
> If the size is managed externally - md/array_size written while the array
> was stopped, which slips past array_size_store()'s -E2BIG check -
> md_set_array_sectors() does nothing, array_sectors keeps the larger value
> and we BUG() all the same.  level_store() cannot turn the takeover away
> the way do_md_run() does either, because ->takeover() has already run and
> the old personality has already been freed.
>
> md-linear has always just failed a sector outside its mapping instead of
> asserting, so do the same here: let find_zone() return NULL and have its
> two callers report the bio and end it with an I/O error.
>
> Tested both ways into this state - a takeover that leaves the array
> zero-length, and one where md/array_size pins array_sectors at 2048.
> Before, each panics in find_zone(); after, the read just fails:
>
>    md/raid0:md0: sector 0 out of bounds, array size 0
>    md/raid0:md0: sector 0 out of bounds, array size 2048
>
> Reported-by: syzbot+422b372cabfbaa528725@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D422b372cabfbaa528725
> Fixes: 9af204cf720c ("md: Add support for Raid5->Raid0 and Raid10->Raid0 =
takeover")
> Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
> ---
>   drivers/md/raid0.c | 21 ++++++++++++++++++++-
>   1 file changed, 20 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 35e103f0c2c3..04c022d74fae 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -301,6 +301,7 @@ static int create_strip_zones(struct mddev *mddev, st=
ruct r0conf **private_conf)
>  =20
>   /* Find the zone which holds a particular offset
>    * Update *sectorp to be an offset in that zone
> + * Returns NULL if the sector is off the end of the array.
>    */
>   static struct strip_zone *find_zone(struct r0conf *conf,
>   				    sector_t *sectorp)
> @@ -315,7 +316,16 @@ static struct strip_zone *find_zone(struct r0conf *c=
onf,
>   				*sectorp =3D sector - z[i-1].zone_end;
>   			return z + i;
>   		}
> -	BUG();
> +	return NULL;
> +}
> +
> +static void raid0_out_of_bounds(struct mddev *mddev, struct bio *bio)
> +{
> +	pr_err_ratelimited("md/raid0:%s: sector %llu out of bounds, array size =
%llu\n",
> +			   mdname(mddev),
> +			   (unsigned long long)bio->bi_iter.bi_sector,
> +			   (unsigned long long)mddev->array_sectors);
> +	bio_io_error(bio);
>   }
>  =20
>   /*
> @@ -471,6 +481,10 @@ static void raid0_handle_discard(struct mddev *mddev=
, struct bio *bio)
>  =20
>   	orig_start =3D start;
>   	zone =3D find_zone(conf, &start);
> +	if (!zone) {
> +		raid0_out_of_bounds(mddev, bio);
> +		return;
> +	}
>  =20
>   	if (bio_end_sector(bio) > zone->zone_end) {
>   		bio =3D bio_submit_split_bioset(bio,
> @@ -566,6 +580,11 @@ static void raid0_map_submit_bio(struct mddev *mddev=
, struct bio *bio)
>   	md_account_bio(mddev, &bio);
>  =20
>   	zone =3D find_zone(mddev->private, &sector);
> +	if (!zone) {
> +		raid0_out_of_bounds(mddev, bio);
> +		return;
> +	}
> +
>   	switch (conf->layout) {
>   	case RAID0_ORIG_LAYOUT:
>   		tmp_dev =3D map_sector(mddev, zone, bio_sector, &sector);

--=20
Thanks,
Kuai
