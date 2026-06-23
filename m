Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBC43CF200
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 08:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782205125; cv=none; b=YDCZ9gx9CAJ8HR/xIdRW+PvHiykGPNCoTGgo5cW/MyfxwKY2FwdTomFvYNxqWY4iBm9s+NvEOqwlWrhBuKa/WsfyAn56hL3MhkzmcYlD1Dq36/ycQFSQJ70r65T+GssMRo9PLIQLLqfgI/NitBSXi/sEtY2mJMTCGgQ1ALLTQeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782205125; c=relaxed/simple;
	bh=qArELvSMIvKx3t6SAdwPmzpyFChXOkvJCDhmRXMqSKE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mUReIyN64b3XZLFmc+mZNasLrzHZBapFp4dxQtRM6+41tMzQ6xM8E1wvoS+3O4GKXcHp/XxLjhlklsClQka/RmNUwFxXfrikRVGPCOuZEM5a/YJ1ELxV5CWb1BaBymddUBw1ro7DUmCeqc2YPzZHhcvfK42dwJFdA+P+oBSFOmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a3GV4V/2; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a3GV4V/2"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490b64c8311so50725885e9.3
        for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 01:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782205121; x=1782809921; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lv6CEjq9f2VZhtR1rXcK+CNNiiZi+/kRwYG0q3o9JWI=;
        b=a3GV4V/212I8d+P3MnBLwDEytTbBaypRhGATwtTVaZn47FP0eTyA0e7pfHvp1IUpkO
         hy0I9NEXZwV887KkprlRM5UkkaK+hzy8PLXIEO9xOTuPFPK1Z8k6l2O6QAALg3gBPXkT
         fJ9JeauVEhOsA3CmX6VYOnYuADbAjG+alqkVhpfyP2unKonThCmRoydoMC0IjXUGdh4Y
         Zw7xTpxoHmtB3gBrXi6d8ZY9NDHZT9R007C4Q26qcfWHxr2o5lDxd7jHibFFQ+RFAVBf
         F76RHO+9lMTi1TtDXceaT+e+v6C+NQmoB1hNPzW0nj7SOJbzBGMhkmlO6Y9yjSRXps6q
         nr9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782205121; x=1782809921;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lv6CEjq9f2VZhtR1rXcK+CNNiiZi+/kRwYG0q3o9JWI=;
        b=MPiySpQmpB7kSkCFF0mBBtxyOte1I0613GePh0Ox3dRZHb4dlLEprU1qiMIWp3A/SL
         dNOO8wt7ISNDj5j3CaqNnuldI6oAT7RBgOASD2fMPH5cfYshHfiIQazsbFiUZS+ROP2o
         Fwjb2xbvq8OP2o9SUYe1Lhcr0+QvtE4zMUkoSM/qdnGSLm/lmIziv9NX0u4v0GyvQaIy
         gfbkai2E+GO7JY8U5vzHyMKb/00Hr2eWgpFkuQX6cU+zYy2Chwk3gZVD3AVlpE7Y7uJu
         idTeAbv6/jf9pK0ObcF1MJZqTrwHp2Q1xmGH4bTSnpAr7gQWtgN4PCnqcY7w5zHGcuHv
         5txw==
X-Gm-Message-State: AOJu0YzIsUT1hstB5xTz0H375NVvgi74i5rXslfl5502aV27WuRsCGZA
	zmc8lyWOYKL8GdpyJDc5FQh5Y5w6QKYdIK0HxEdH7mesU8FZpKQc1E8k
X-Gm-Gg: AfdE7ckRf4T7VH9sFX5aavVkvifTskygDHqHkdMpfolbf9Bu3+/3qy7RUU/sfHsXeXk
	aDtejMIS/hnG3RPXOUWYaK5sgACUP8s1NB5MHqluF03kG25N9hAjt95ps+kz8L5xxqZS9tFx0r3
	TaPEPoz+kEzG71QMIvyuo31xTyQwZoUxvvUFk9k9/fHRhPC3bjns98ng/TS7dXUKfui8/C5sXDK
	lm5Sdrp+zqqF/tkMxF+DxdpkHl0ZqsKy/xPQt83LmhJUbIyOoxkq8EKFLOVgT4xiL3+NrBGlRFE
	cMqxAiizHQ6HzyTv6BJbSmyUkO+e0SByb24XqvtKfPXgzhM189GlJ8Bl4gXo96YotWAMMlTDzzn
	lo7lC9X9bt9xLqN4INCo8iF0xVbyCSnvmJnsp/Y8OefnGsMBtUFV3TVcSqzZpk5VR0TBPa1at5l
	K058JkKTO41nqDwYrIkidHuIKoaDwtil+4gYVjW4oflkkXPw==
X-Received: by 2002:a05:600c:c494:b0:48f:d612:3c59 with SMTP id 5b1f17b1804b1-49240e05938mr292509715e9.9.1782205121240;
        Tue, 23 Jun 2026 01:58:41 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([141.2.113.173])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4666cea9581sm31881265f8f.0.2026.06.23.01.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 01:58:40 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: John Garry <john.g.garry@oracle.com>, song@kernel.org, yukuai@fygo.io,
 magiclinan@didiglobal.com, xiao@kernel.org, axboe@kernel.dk,
 martin.petersen@oracle.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] md/raid1: handle atomic writes that require splitting
In-Reply-To: <ba67f3ef-45cb-41c0-b4ea-fa0a22508cdc@oracle.com>
References: <20260623072456.333437-1-abd.masalkhi@gmail.com>
 <20260623072456.333437-3-abd.masalkhi@gmail.com>
 <ba67f3ef-45cb-41c0-b4ea-fa0a22508cdc@oracle.com>
Date: Tue, 23 Jun 2026 10:58:39 +0200
Message-ID: <m2se6d1vls.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Jun 23, 2026 at 09:11 +0100, John Garry wrote:
> On 23/06/2026 08:24, Abd-Alrhman Masalkhi wrote:
>> If a request already requires splitting when entering
>> raid1_write_request(), the current code allows it to proceed until it
>> eventually reaches the split path. 
>
> The block layer should catch invalid atomic writes in 
> submit_bio_noacct() -> blk_validate_atomic_write_op_size() before we 
> even get as far as the md atomic write handling. Having the check in 
> bio_submit_split_bioset() is really just a fail-safe for the block layer 
> not catching invalid atomic writes or the atomic writes queue limits not 
> being properly calculated.
The request size itself satisfies the currently advertised atomic write
limits, so blk_validate_atomic_write_op_size() allows it. The problem
is that RAID1 may further restrict atomic writes to a single barrier
unit via align_to_barrier_unit_end(). Therefore a request that crosses
a barrier-unit boundary can still reach raid1_write_request() with
max_sectors < bio_sectors(bio).

If the barrier-unit restriction should instead be advertised through the
atomic write queue limits, then I agree the block layer could reject
such requests earlier and the RAID1 entry check would become
unnecessary.

However, there are also cases where max_sectors is reduced later within
raid1_write_request(), for example when bad blocks are present on some
mirrors (or due to other RAID1-specific constraints such as write-behind
limits). Those reductions depend on RAID1 runtime state and mirror
health, so they are not readily visible to the block layer during atomic
write validation. In those cases RAID1 still needs to detect that the
atomic write can no longer be serviced as requested and fail it
appropriately.

>
>> Along the way, the bio may instead
>> fail due to other conditions and return a different status, even though
>> the request was invalid as an atomic write from the beginning.
>> 
>> Additionally, an otherwise valid atomic write may later require
>> splitting because bad blocks reduce the writable range or because
>> write-behind constraints reduce the maximum writable size. In these
>> cases, the bio currently completes with either EINVAL or ENOTSUPP,
>> whereas it should complete with EIO instead.
>> 
>> Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
>> Fixes: a4c55c902670 ("md/raid1: simplify raid1_write_request() error handling")
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>>   drivers/md/raid1.c | 25 +++++++++++--------------
>>   1 file changed, 11 insertions(+), 14 deletions(-)
>> 
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 86d4f224ffb1..8386d37343a4 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1511,9 +1511,15 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>>   	int first_clone;
>>   	bool write_behind = false;
>>   	bool nowait = bio->bi_opf & REQ_NOWAIT;
>> +	bool atomic = bio->bi_opf & REQ_ATOMIC;
>>   	bool is_discard = op_is_discard(bio->bi_opf);
>>   	sector_t sector = bio->bi_iter.bi_sector;
>>   
>> +	if (atomic && max_sectors != bio_sectors(bio)) {
>> +		bio_endio_status(bio, BLK_STS_INVAL);
>> +		return false;
>> +	}
>> +
>>   	if (mddev_is_clustered(mddev) &&
>>   	    mddev->cluster_ops->area_resyncing(mddev, WRITE, sector,
>>   					       bio_end_sector(bio))) {
>> @@ -1592,20 +1598,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>>   			}
>>   			if (is_bad) {
>>   				int good_sectors;
>> -
>> -				/*
>> -				 * We cannot atomically write this, so just
>> -				 * error in that case. It could be possible to
>> -				 * atomically write other mirrors, but the
>> -				 * complexity of supporting that is not worth
>> -				 * the benefit.
>> -				 */
>> -				if (bio->bi_opf & REQ_ATOMIC) {
>> -					bio->bi_status = BLK_STS_NOTSUPP;
>
> what baseline are you using here? This looks different to linux-next 22 
> june and linus' master branch
>
I'm basing this series on Song's md tree, specifically the md-7.2
branch.

>> -					bio_endio(bio);
>> -					goto err_dec_pending;
>> -				}
>> -
>>   				good_sectors = first_bad - sector;
>>   				if (good_sectors < max_sectors)
>>   					max_sectors = good_sectors;
>> @@ -1626,6 +1618,11 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>>   		max_sectors = min_t(int, max_sectors,
>>   				    BIO_MAX_VECS * (PAGE_SIZE >> 9));
>>   	if (max_sectors < bio_sectors(bio)) {
>> +		if (atomic) {
>> +			bio_io_error(bio);
>> +			goto err_dec_pending;
>> +		}
>> +
>>   		bio = bio_submit_split_bioset(bio, max_sectors,
>>   					      &conf->bio_split);
>>   		if (!bio)
>

-- 
Best Regards,
Abd-Alrhman
