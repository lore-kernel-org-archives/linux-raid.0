Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0841DE8BB
	for <linux-raid@vger.kernel.org>; Tue, 30 Jun 2026 08:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782808780; cv=none; b=hF5YvpkQQHJmwhUpqND0sSpiF9VIT5XgXHrvG8eGhXGwye5VHPl2hN2jcRY2VdVEMH1xEY9Mb0MIZU+SYB/Et3FpwVOfaIpAldVv7Gggssc1ikhKZDVlJHT9aunyh8O8ss/VCkI5IVTmRgNLAmvtzfBrGRBNixietIsQxHjgqNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782808780; c=relaxed/simple;
	bh=nk1SuMr8/7XigAlohRNbSpX0vVJqn/+ae9Y2cBmpQ84=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZVskSBnhOPHzBXg2Se0I2zfhHtm9ssHjSBk/vnJezl/bfwZuxw8P9Ckkao1JrYSNAs7kmg5D44T/OfJDBJYVnEPMdJzcKrkdcYlcezQEIfsy8fWxi+RIyDGrawpe9wfJlxLsDrM7O+eohewgAm6aRTHQXXx42fbpnnLXoKLDq0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OSUMW8os; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OSUMW8os"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49270caa5c0so33087845e9.3
        for <linux-raid@vger.kernel.org>; Tue, 30 Jun 2026 01:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782808776; x=1783413576; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=07Zjugs28X7mQA/ysZ3DBSDjZ3etII5V3AX1NHliDV4=;
        b=OSUMW8oszm6AFTLIXQmy/7v5vbs987C4Wye5ODarxtcgRVR7jyCrcCxGTpaYhalEKF
         V9daJbIJFkIU2yLDJiaabGjvXL2OmQqvWtnzSELaaw7JbCnYhagu9KTU19Kh2VKyivnG
         jVLyj5+DxkXyMw1rBivU2RqVtfVsXhu2w5fzfE9a7CwNVAKXAmNwgQslBWvd4Rax20m5
         rJbDRWZQqj4+Epsdrkz3lON1S4+3Q3A4ZKnv92/W8+7yuQznX6iO6/IkQtxEY8tWXEaZ
         PLmeStQLoj0EV+femvnNxU3znt5aG8em4K46YZxrh30MZ5cHqUv17xrcfbPmKj9mmCVH
         D/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782808776; x=1783413576;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=07Zjugs28X7mQA/ysZ3DBSDjZ3etII5V3AX1NHliDV4=;
        b=kLVs8kaXY4Oa9ghEU0d1/N/lMJtOEG6YtXnYEaiPW2pn9aJADsA+hWQaG/2rmfUkYK
         ZRD59yGeVg1o3GU6A8PsybIBaFD6vsrZ0Dz/IVgNZn05GA4O6o/xLWP11TXDwhwEjiEv
         JRfRelh7xGvqItJ+q5RSBP6nc+oJ9rj0SRE+qBXCq3kZILtQClvJLuIVz9q+AuiUJPoF
         YCCnlLLOkAIJ4pKj/nq6aA21/5Zo8z1iEzx/Bus314n7oPitjj0eTI7Ckgk1o85H6XSb
         QcaduSdwTbSUePoOV7BZN+PGK55ACyvTaE9dBXaNIznAPr0Qa/LLzWaioPmBYjMdHOlR
         AqFg==
X-Gm-Message-State: AOJu0YypyQ0T8rpKHbZplQuOVytshEh/cF+wnD/UIytfKokq357EXE3P
	+lKQ0YP+Eob/LN0m/Wc+RYDBToHsDUEnDfuxghWHPYyn3bBHEo4b7bLL+P+7Wg==
X-Gm-Gg: AfdE7clGCiEX2xOJ3TgBfGiKKrJCwt7fQc0jDIiXYFLzutaxxAaUdZ3sTOe+1dhsqtk
	ZxTpC7BPa3ix/NbQKp1drYrzuHB+QHxCeZqN4ooZKaQHScX4W12muqF9wCGo4Tfa/Upytvl7+gp
	MN2mMTqK53VAXHqykhe0EjBbfTp4egF32sXp/yKfyfIz7tFsOQacnE0M246kRz6Sz67UetoRa1X
	4SGIGgPbKU4oeYAchxeNtE93wmcJM0JEWJLujxZkgUx1fejxzcZJX9TSOU1euNXHMJVq0nj1g7i
	FHCTLK8kUuD639W0O2DLmqeRkE1hFLXj78XxRtinwfiWH4cZAnTZn+B/0XzNuEgV2yItTsMI6oB
	MnbaDDgevEJr/0FBa/XfhUji/2Bkz6v5KRIyj4ZhuxBlbZy5lzWWpPPEKJpHqkDpBPPKTSXBN65
	4NVr0/TqCzsAd3EMt/OYJtkgbdtus94BWBTFLuhCKR0oT7TrWZXNTZ5yBn
X-Received: by 2002:a05:600c:4f90:b0:490:e974:e006 with SMTP id 5b1f17b1804b1-493b82b625dmr38535625e9.29.1782808775623;
        Tue, 30 Jun 2026 01:39:35 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([141.2.113.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493b8d0bbbcsm59964435e9.13.2026.06.30.01.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 01:39:35 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: John Garry <john.g.garry@oracle.com>, song@kernel.org, yukuai@fygo.io,
 magiclinan@didiglobal.com, xiao@kernel.org, axboe@kernel.dk,
 vverma@digitalocean.com, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 2/7] md/raid1: advertise atomic write limits and
 handle runtime constraints
In-Reply-To: <7cbaaca3-4eb5-434d-a13f-f9574c9f977b@oracle.com>
References: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
 <20260628142420.1051027-3-abd.masalkhi@gmail.com>
 <7cbaaca3-4eb5-434d-a13f-f9574c9f977b@oracle.com>
Date: Tue, 30 Jun 2026 10:39:34 +0200
Message-ID: <m2se64zak9.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Hi John,

On Mon, Jun 29, 2026 at 15:48 +0100, John Garry wrote:
> On 28/06/2026 15:24, Abd-Alrhman Masalkhi wrote:
>> Atomic writes in RAID1 must fit within a single barrier unit. Advertise
>> this restriction through the queue limits by setting
>> atomic_write_hw_unit_max to BARRIER_UNIT_SECTOR_SIZE so that bios which
>> would cross a barrier-unit boundary are rejected by the block layer
>> before reaching MD.
>> 
>> A bio that passes block-layer validation may still become unserviceable
>> within RAID1 due to bad blocks or write-behind constraints. In the former
>> case, complete the bio with EIO. In the latter case, disable
>> write-behind rather than failing the bio with EIO.
>> 
>> Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
>> Fixes: a4c55c902670 ("md/raid1: simplify raid1_write_request() error handling")
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>> Changes in v2:
>>   - Drop the early atomic write split check from raid1_write_request().
>>   - Advertise the atomic write size limit via queue limits.
>>   - Disable write-behind instead of failing atomic writes when the
>>     BIO_MAX_VECS limit is encountered.
>>   - Link to v1: https://urldefense.com/v3/__https://lore.kernel.org/linux-raid/20260623072456.333437-3-abd.masalkhi@gmail.com/__;!!ACWV5N9M2RV99hQ!LbMSGSClRi0PNBqQti5ZNWGDVjDd34-7saYEAwNyBNjpNTjEA7veqM5RHG8KB1QiscarW4UaIefjm19ywSImtIgh$
>> ---
>>   drivers/md/raid1.c | 36 +++++++++++++++++++-----------------
>>   1 file changed, 19 insertions(+), 17 deletions(-)
>> 
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index afe2ca96ad8c..f322048ab3c2 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1522,6 +1522,7 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>>   	int first_clone;
>>   	bool write_behind = false;
>>   	bool nowait = bio->bi_opf & REQ_NOWAIT;
>> +	bool atomic = bio->bi_opf & REQ_ATOMIC;
>>   	bool is_discard = op_is_discard(bio->bi_opf);
>>   	sector_t sector = bio->bi_iter.bi_sector;
>>   
>> @@ -1603,20 +1604,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
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
>> -					bio_endio(bio);
>> -					goto err_dec_pending;
>> -				}
>> -
>>   				good_sectors = first_bad - sector;
>>   				if (good_sectors < max_sectors)
>>   					max_sectors = good_sectors;
>> @@ -1633,10 +1620,24 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>>   	 * at a time and thus needs a new bio that can fit the whole payload
>>   	 * this bio in page sized chunks.
>>   	 */
>> -	if (write_behind && mddev->bitmap)
>> -		max_sectors = min_t(int, max_sectors,
>> -				    BIO_MAX_VECS * (PAGE_SIZE >> 9));
>> +	if (write_behind && mddev->bitmap) {
>> +		if (atomic && max_sectors > BIO_MAX_VECS * (PAGE_SIZE >> 9))
>
> where does BIO_MAX_VECS * (PAGE_SIZE >> 9) even come from?
>

BIO_MAX_VECS * (PAGE_SIZE >> 9) defines the maximum size supported by
write-behind. The write-behind copy (alloc_behind_master_bio) uses a
single bio, which can hold at most BIO_MAX_VECS pages, making this the
largest payload it can carry. With a 4 KiB PAGE_SIZE, that corresponds
to 256 pages, or 1 MiB (2048 sectors).
This patch changes the behavior for atomic writes that exceed this
limit. Instead of failing the write with -EIO when the number of sectors
must be reduced, it disables write-behind and proceeds with the atomic
write.

>> +			/*
>> +			 * Atomic writes cannot be split, so disable
>> +			 * write-behind.
>> +			 */
>> +			write_behind = false;
>> +		else
>> +			max_sectors = min_t(int, max_sectors,
>> +					    BIO_MAX_VECS * (PAGE_SIZE >> 9));
>> +	}
>> +
>>   	if (max_sectors < bio_sectors(bio)) {
>> +		if (atomic) {
>> +			bio_io_error(bio);
>> +			goto err_dec_pending;
>> +		}
>> +
>>   		bio = bio_submit_split_bioset(bio, max_sectors,
>>   					      &conf->bio_split);
>>   		if (!bio)
>> @@ -3229,6 +3230,7 @@ static int raid1_set_limits(struct mddev *mddev)
>>   	lim.max_write_zeroes_sectors = 0;
>>   	lim.max_hw_wzeroes_unmap_sectors = 0;
>>   	lim.logical_block_size = mddev->logical_block_size;
>> +	lim.atomic_write_hw_unit_max = BARRIER_UNIT_SECTOR_SIZE;
>
> This BARRIER_UNIT_SECTOR_SIZE is a bit like chunk sectors, no? I am just 
> wondering if we just should set it to chunk sectors = 
> BARRIER_UNIT_SECTOR_SIZE
>
> I assume that it affects more than Reads and writes, e.g. discard also.
>

BARRIER_UNIT_SECTOR_SIZE is the resync barrier-bucket, not the layout
chunk size. Unless I'm missing something, using
atomic_write_hw_unit_max seems more appropriate than using the chunk
size. That way, the limit only applies to atomic writes instead of
affecting other operations such.

>>   	lim.features |= BLK_FEAT_ATOMIC_WRITES;
>>   	lim.features |= BLK_FEAT_PCI_P2PDMA;
>>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>

-- 
Best Regards,
Abd-Alrhman
