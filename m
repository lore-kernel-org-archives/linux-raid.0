Received: from va-2-40.ptr.blmpb.com (va-2-40.ptr.blmpb.com [209.127.231.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D589D28F948
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 06:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782110070; cv=none; b=pSSqTB4Vl8LM5rx8qCoq5Dibq0+MpNZ2rN1xzsPUqkTp+22/jI7GTVq9JR3bVUODjL+OVuvw+YZ+bz7htaRDFMlAB317u0LvoRsn4XkCM5eZFK4bmdjHHK8usXayDIVtSjO4uRyakaYtMw8fV8qo+XKFNqbIb51kfa4OTtIHElU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782110070; c=relaxed/simple;
	bh=1R0PN4DhXJSWYepxEFS784CXSc4B+sArUT/HnZk4p5M=;
	h=In-Reply-To:Date:Message-Id:From:Mime-Version:References:To:Cc:
	 Subject:Content-Type; b=C7oLpY3BTvYG0VKajnfELigV6GLu+7vU+sOkj298S1z6BDS1696CTPOc72Sb0cw5YUpyZlwgS+qnt51UTGURUv7awdQmpNpjVTes8GEEHAUUbc7Pf+bOcMir3D3cfmyzQgMQGG9CUQUJFQ/e9dDl+REbWD0MMT/S+FcenmJw4TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=F4KjxmA2; arc=none smtp.client-ip=209.127.231.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="F4KjxmA2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782110057;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=dcMerUFQnFB7yII0fzfCg+DPH66aF90URRe171E2xxk=;
 b=F4KjxmA2EkOViDggv46A2wqq7nnlwTVvFh1ijpVouq5NWDz18podJUsfL9mdQZiX9XpW61
 FPrdE23p9UYSzlaEBAs2r+reldW8xX5SZbzc1PQwKO8qcS/d5ldLsoaebpp4IpKs+wER7D
 JGoimkDsfKXJaReOQqY/RLhq+Ih68Z42xPCVnjKmPolCDVP7/DiWxaei/bttk8vR5x5nwV
 29iFsgWT6ItbYGwhmDeagHXlBP1Scl3950RqGNK6D3EqpD6fMHIq3sO52VJE8Rp1fbMGN7
 HaXy2EPDDws45K039T5OCbayXkwBx8FFI+H+hTFagShIfrI6kayutcbpGFfKeg==
User-Agent: Mozilla Thunderbird
In-Reply-To: <21def978-3c6e-4a9f-8c60-c213e760fb7c@fygo.io>
Date: Mon, 22 Jun 2026 14:34:12 +0800
Message-Id: <f877d9f4-4912-4331-8c14-e7726adf24bc@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.8.62] ([183.34.162.92]) by smtp.feishu.cn with ESMTPS; Mon, 22 Jun 2026 14:34:13 +0800
References: <20260603035925.217847-1-chencheng@fnnas.com> <20260603035925.217847-4-chencheng@fnnas.com> <21def978-3c6e-4a9f-8c60-c213e760fb7c@fygo.io>
X-Lms-Return-Path: <lba+26a38d767+15d045+vger.kernel.org+chencheng@fnnas.com>
To: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] md/raid10: bound reused r10bio devs[] walks by used_nr_devs
Content-Type: text/plain; charset=UTF-8
X-Original-From: Chen Cheng <chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/6/21 04:02, yu kuai =E5=86=99=E9=81=93:
> Hi,
>=20
> =E5=9C=A8 2026/6/3 11:59, Chen Cheng =E5=86=99=E9=81=93:
>> From: Chen Cheng <chencheng@fnnas.com>
>>
>> After reshape changes raid_disks, an in-flight r10bio from the old geome=
try
>> can still be completed or freed later. In that case, using the current
>> geometry to walk r10_bio->devs[] is unsafe. A failure was reproduced wit=
h a
>> simple write workload while reshaping a raid10 array from 4 disks to 5 d=
isks.
>> e.g.:
>>
>>     mdadm -C /dev/md777 -l10 -n4 /dev/sda /dev/sdb /dev/sdc /dev/sdd
>>     mkfs.ext4 /dev/md777
>>     mount /dev/md777 /mnt/test
>>     fsstress -d /mnt/test -n 24000 -p 8 -l 24 &
>>     mdadm /dev/md777 --add /dev/sde
>>     mdadm --grow /dev/md777 --raid-devices=3D5 \
>>       --backup-file=3D/tmp/md-reshape-backup
>>
>> the sequence above can trigger:
>>
>>     BUG: KASAN: slab-out-of-bounds in free_r10bio+0x1c4/0x260 [raid10]
>>     Read of size 8 at addr ffff00008c2dfac8 by task ksoftirqd/0/15
>>     free_r10bio
>>     raid_end_bio_io
>>     one_write_done
>>     raid10_end_write_request
>>
>> The buggy object was 200 bytes long, which matches an r10bio with space =
for
>> only four devs[] entries. However, put_all_bios() and find_bio_disk() wa=
lk
>> r10_bio->devs[] using the current conf->geo.raid_disks value. Once resha=
pe
>> switches conf->geo.raid_disks from 4 to 5, an old 4-slot r10bio can be
>> completed or freed as if it had 5 slots, and the walk overruns devs[4]. =
The
> I don't understand, is this still possible after patch 1.



patch 1 and 2 just prepare work.
The true dangerous is in-flight r10bio which use old geometry.
And patch 3 record and use r10bio's own width to free r10bio's bios.



>> same stale-width mismatch can also surface during a 5-disk to 4-disk res=
hape.
>>
>> Track the number of valid devs[] entries in each reused r10bio with
>> used_nr_devs. Initialize it whenever an r10bio is prepared for regular I=
/O,
>> discard, or resync/recovery/reshape work, and use it to bound devs[] wal=
ks
>> in put_all_bios() and find_bio_disk().
>>
>> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
>> ---
>>    drivers/md/raid10.c | 8 ++++++--
>>    drivers/md/raid10.h | 2 ++
>>    2 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 5eca34432e63..f134b93fd593 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -273,11 +273,11 @@ static void r10buf_pool_free(void *__r10_bio, void=
 *data)
>>   =20
>>    static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio=
)
>>    {
>>    	int i;
>>   =20
>> -	for (i =3D 0; i < conf->geo.raid_disks; i++) {
>> +	for (i =3D 0; i < r10_bio->used_nr_devs; i++) {
>>    		struct bio **bio =3D & r10_bio->devs[i].bio;
>>    		if (!BIO_SPECIAL(*bio))
>>    			bio_put(*bio);
>>    		*bio =3D NULL;
>>    		bio =3D &r10_bio->devs[i].repl_bio;
>> @@ -370,11 +370,11 @@ static int find_bio_disk(struct r10conf *conf, str=
uct r10bio *r10_bio,
>>    			 struct bio *bio, int *slotp, int *replp)
>>    {
>>    	int slot;
>>    	int repl =3D 0;
>>   =20
>> -	for (slot =3D 0; slot < conf->geo.raid_disks; slot++) {
>> +	for (slot =3D 0; slot < r10_bio->used_nr_devs; slot++) {
>>    		if (r10_bio->devs[slot].bio =3D=3D bio)
>>    			break;
>>    		if (r10_bio->devs[slot].repl_bio =3D=3D bio) {
>>    			repl =3D 1;
>>    			break;
>> @@ -1561,10 +1561,11 @@ static void __make_request(struct mddev *mddev, =
struct bio *bio, int sectors)
>>   =20
>>    	r10_bio->mddev =3D mddev;
>>    	r10_bio->sector =3D bio->bi_iter.bi_sector;
>>    	r10_bio->state =3D 0;
>>    	r10_bio->read_slot =3D -1;
>> +	r10_bio->used_nr_devs =3D conf->geo.raid_disks;
>>    	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
>>    			conf->geo.raid_disks);
>>   =20
>>    	if (bio_data_dir(bio) =3D=3D READ)
>>    		raid10_read_request(mddev, bio, r10_bio);
>> @@ -1749,10 +1750,11 @@ static int raid10_handle_discard(struct mddev *m=
ddev, struct bio *bio)
>>    	r10_bio =3D mempool_alloc(conf->r10bio_pool, GFP_NOIO);
>>    	r10_bio->mddev =3D mddev;
>>    	r10_bio->state =3D 0;
>>    	r10_bio->sectors =3D 0;
>>    	r10_bio->read_slot =3D -1;
>> +	r10_bio->used_nr_devs =3D geo->raid_disks;
>>    	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks)=
;
>>    	wait_blocked_dev(mddev, r10_bio);
>>   =20
>>    	/*
>>    	 * For far layout it needs more than one r10bio to cover all regions=
.
>> @@ -3083,10 +3085,12 @@ static struct r10bio *raid10_alloc_init_r10buf(s=
truct r10conf *conf)
>>    	    test_bit(MD_RECOVERY_RESHAPE, &conf->mddev->recovery))
>>    		nalloc =3D conf->copies; /* resync */
>>    	else
>>    		nalloc =3D 2; /* recovery */
>>   =20
>> +	r10bio->used_nr_devs =3D nalloc;
>> +
>>    	for (i =3D 0; i < nalloc; i++) {
>>    		bio =3D r10bio->devs[i].bio;
>>    		rp =3D bio->bi_private;
>>    		bio_reset(bio, NULL, 0);
>>    		bio->bi_private =3D rp;
>> diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
>> index b711626a5db7..4751119f9770 100644
>> --- a/drivers/md/raid10.h
>> +++ b/drivers/md/raid10.h
>> @@ -125,10 +125,12 @@ struct r10bio {
>>    	struct bio		*master_bio;
>>    	/*
>>    	 * if the IO is in READ direction, then this is where we read
>>    	 */
>>    	int			read_slot;
>> +	/* Used to bound devs[] walks when the object is reused. */
>> +	unsigned int		used_nr_devs;
>>   =20
>>    	struct list_head	retry_list;
>>    	/*
>>    	 * if the IO is in WRITE direction, then multiple bios are used,
>>    	 * one for each copy.
>
