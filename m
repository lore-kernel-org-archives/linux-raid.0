Received: from va-2-44.ptr.blmpb.com (va-2-44.ptr.blmpb.com [209.127.231.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943C3282F0A
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 20:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781985735; cv=none; b=SVA6CuUgrrwlEh5U6/JUl+cfmq+9wajDSpl8U0xnDQ8LjPF2yQ/Q7SrlmRLADfY9uaWwrO852++B8Kt29NgJ18EVTCSbo4H8F+AtNZjpJ36bHjkhqZ5h5nnwbOCIp797fk90kHOtzAhqrxrDA6Jl0fqiaJ3owFFqip/pJsTVLeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781985735; c=relaxed/simple;
	bh=pUaHkKc293XISCnBa1FOkEUtQcsvTPYR+syTjizC6bI=;
	h=Content-Type:From:Message-Id:References:Cc:To:Subject:
	 Mime-Version:Date:In-Reply-To; b=RtbuHoF59ZLDFdlAT3yFz3FonmZBK+7+Sp6OLp3YF6nZwjoAj0pK2T02aVZeevCQdbaZ+TFXbNFFUBM567dbX24KfMmvbGyHECTnctBCJLFupTy37UIHJHFXT5dsMAQ4c6bm0RwvjNRSYWvcAYvn2Hlzam+dJNpeGiBNza+zxKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=FNwPjKFb; arc=none smtp.client-ip=209.127.231.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="FNwPjKFb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781985729;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=6pLzvF7mKEUki7lF7boJ45Xtx0y5qRc68ML+PXjWmKs=;
 b=FNwPjKFbb2HkVbZ1OfJPlQvff40upDF+ggVe1PZPdfQZsumIkCEGIlMgE5aCY/7ZLB84Fr
 5hQHlEfkgzhavjMkY83n2xoGl/6g6tvmXcMcmJTIhj1DMLymoeOalawh1DKfbqOVr3uByw
 6gcWQazGSq1TW7peOXB9whtN1qXB9nj1KG3zIteGNrQkx1LLkiwU4JF9lj1kgnDWtQKAN/
 0+zaC0uMsqxSuo/g+irbDhLwHOAtvp7HPz0iNpqcpYi14UHF6fDo++01R08Kf95s+YrjQ0
 CKViE+37a8vyhQzDYzkeP24CrQQZ2zJtyHi6bjyJttpp6IqOdjUn3mHLh09I6Q==
X-Lms-Return-Path: <lba+26a36f1c0+f4b564+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <21def978-3c6e-4a9f-8c60-c213e760fb7c@fygo.io>
References: <20260603035925.217847-1-chencheng@fnnas.com> <20260603035925.217847-4-chencheng@fnnas.com>
Cc: <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Subject: Re: [PATCH v4 3/3] md/raid10: bound reused r10bio devs[] walks by used_nr_devs
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Date: Sun, 21 Jun 2026 04:02:04 +0800
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Sat, 20 Jun 2026 20:02:07 +0000
In-Reply-To: <20260603035925.217847-4-chencheng@fnnas.com>
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/6/3 11:59, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> After reshape changes raid_disks, an in-flight r10bio from the old geomet=
ry
> can still be completed or freed later. In that case, using the current
> geometry to walk r10_bio->devs[] is unsafe. A failure was reproduced with=
 a
> simple write workload while reshaping a raid10 array from 4 disks to 5 di=
sks.
> e.g.:
>
>    mdadm -C /dev/md777 -l10 -n4 /dev/sda /dev/sdb /dev/sdc /dev/sdd
>    mkfs.ext4 /dev/md777
>    mount /dev/md777 /mnt/test
>    fsstress -d /mnt/test -n 24000 -p 8 -l 24 &
>    mdadm /dev/md777 --add /dev/sde
>    mdadm --grow /dev/md777 --raid-devices=3D5 \
>      --backup-file=3D/tmp/md-reshape-backup
>
> the sequence above can trigger:
>
>    BUG: KASAN: slab-out-of-bounds in free_r10bio+0x1c4/0x260 [raid10]
>    Read of size 8 at addr ffff00008c2dfac8 by task ksoftirqd/0/15
>    free_r10bio
>    raid_end_bio_io
>    one_write_done
>    raid10_end_write_request
>
> The buggy object was 200 bytes long, which matches an r10bio with space f=
or
> only four devs[] entries. However, put_all_bios() and find_bio_disk() wal=
k
> r10_bio->devs[] using the current conf->geo.raid_disks value. Once reshap=
e
> switches conf->geo.raid_disks from 4 to 5, an old 4-slot r10bio can be
> completed or freed as if it had 5 slots, and the walk overruns devs[4]. T=
he
I don't understand, is this still possible after patch 1.
> same stale-width mismatch can also surface during a 5-disk to 4-disk resh=
ape.
>
> Track the number of valid devs[] entries in each reused r10bio with
> used_nr_devs. Initialize it whenever an r10bio is prepared for regular I/=
O,
> discard, or resync/recovery/reshape work, and use it to bound devs[] walk=
s
> in put_all_bios() and find_bio_disk().
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid10.c | 8 ++++++--
>   drivers/md/raid10.h | 2 ++
>   2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 5eca34432e63..f134b93fd593 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -273,11 +273,11 @@ static void r10buf_pool_free(void *__r10_bio, void =
*data)
>  =20
>   static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
>   {
>   	int i;
>  =20
> -	for (i =3D 0; i < conf->geo.raid_disks; i++) {
> +	for (i =3D 0; i < r10_bio->used_nr_devs; i++) {
>   		struct bio **bio =3D & r10_bio->devs[i].bio;
>   		if (!BIO_SPECIAL(*bio))
>   			bio_put(*bio);
>   		*bio =3D NULL;
>   		bio =3D &r10_bio->devs[i].repl_bio;
> @@ -370,11 +370,11 @@ static int find_bio_disk(struct r10conf *conf, stru=
ct r10bio *r10_bio,
>   			 struct bio *bio, int *slotp, int *replp)
>   {
>   	int slot;
>   	int repl =3D 0;
>  =20
> -	for (slot =3D 0; slot < conf->geo.raid_disks; slot++) {
> +	for (slot =3D 0; slot < r10_bio->used_nr_devs; slot++) {
>   		if (r10_bio->devs[slot].bio =3D=3D bio)
>   			break;
>   		if (r10_bio->devs[slot].repl_bio =3D=3D bio) {
>   			repl =3D 1;
>   			break;
> @@ -1561,10 +1561,11 @@ static void __make_request(struct mddev *mddev, s=
truct bio *bio, int sectors)
>  =20
>   	r10_bio->mddev =3D mddev;
>   	r10_bio->sector =3D bio->bi_iter.bi_sector;
>   	r10_bio->state =3D 0;
>   	r10_bio->read_slot =3D -1;
> +	r10_bio->used_nr_devs =3D conf->geo.raid_disks;
>   	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
>   			conf->geo.raid_disks);
>  =20
>   	if (bio_data_dir(bio) =3D=3D READ)
>   		raid10_read_request(mddev, bio, r10_bio);
> @@ -1749,10 +1750,11 @@ static int raid10_handle_discard(struct mddev *md=
dev, struct bio *bio)
>   	r10_bio =3D mempool_alloc(conf->r10bio_pool, GFP_NOIO);
>   	r10_bio->mddev =3D mddev;
>   	r10_bio->state =3D 0;
>   	r10_bio->sectors =3D 0;
>   	r10_bio->read_slot =3D -1;
> +	r10_bio->used_nr_devs =3D geo->raid_disks;
>   	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
>   	wait_blocked_dev(mddev, r10_bio);
>  =20
>   	/*
>   	 * For far layout it needs more than one r10bio to cover all regions.
> @@ -3083,10 +3085,12 @@ static struct r10bio *raid10_alloc_init_r10buf(st=
ruct r10conf *conf)
>   	    test_bit(MD_RECOVERY_RESHAPE, &conf->mddev->recovery))
>   		nalloc =3D conf->copies; /* resync */
>   	else
>   		nalloc =3D 2; /* recovery */
>  =20
> +	r10bio->used_nr_devs =3D nalloc;
> +
>   	for (i =3D 0; i < nalloc; i++) {
>   		bio =3D r10bio->devs[i].bio;
>   		rp =3D bio->bi_private;
>   		bio_reset(bio, NULL, 0);
>   		bio->bi_private =3D rp;
> diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
> index b711626a5db7..4751119f9770 100644
> --- a/drivers/md/raid10.h
> +++ b/drivers/md/raid10.h
> @@ -125,10 +125,12 @@ struct r10bio {
>   	struct bio		*master_bio;
>   	/*
>   	 * if the IO is in READ direction, then this is where we read
>   	 */
>   	int			read_slot;
> +	/* Used to bound devs[] walks when the object is reused. */
> +	unsigned int		used_nr_devs;
>  =20
>   	struct list_head	retry_list;
>   	/*
>   	 * if the IO is in WRITE direction, then multiple bios are used,
>   	 * one for each copy.

--=20
Thanks,
Kuai
