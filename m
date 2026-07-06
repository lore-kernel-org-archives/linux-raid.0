Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A40E3F44E3
	for <linux-raid@vger.kernel.org>; Mon,  6 Jul 2026 11:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783337756; cv=none; b=CP08PnZiO+ByzJJJOZfCn1GOVHg6XXvqH5mySg9H6IkgYNp2vI9s5wa9Pjc1MAZLP2FSkQRCUvMy/F4l59ROlsKFgfuHg5MIFEHwRz3erVMCs4m+LWL3Q77VmPTMFbyz9isWDnibB8IYtmR0P7B+PJRmLdAYvHGFaqr0RyXzmxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783337756; c=relaxed/simple;
	bh=hCzKh7+OnS1XF53C7I8CTn81usasqlc3LwzJQgV0sVo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Ok88KWd9Blu7FXqjgKoZMjUlXYXm+JXYXHnGxXBtdrlzwIQHLcEMvYqXTgjjklzGk0popWcf+40P83c62aCG10Lt8AovqiXlEyJiugacQ/GX9QmIrNEi+sgyRb3+ga2GwJSObJkNcD0q3vt7fw48Wcg8FYQ6nGC/IUMB+FiXgOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F5UusZHG; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F5UusZHG"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493bb510ce4so22016245e9.1
        for <linux-raid@vger.kernel.org>; Mon, 06 Jul 2026 04:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783337754; x=1783942554; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZVnuaoQHXzg0auu5bmPMaWnWzbZUreNJrNRtm/ox0Aw=;
        b=F5UusZHGDv/mU34TXG8qYIoZFa4tV4j9HR8kIUPJwjaeZ2AmsmpBoiXF1IFxcMjYGy
         911BcXpJQuVJl/jOsE0bdWMwjH1yAUFGEAFj8h/IQRVau0j38aJbwgG8jkziHR0EraOP
         Be57rtjP5lZI7B76rjmvcOVqcZOx7MEV8UEeDS2WcxkNTRH04vTME8fFZ/2Oo9yrtaXx
         F2F0BfbEzOygV6aBISpA+vCb0atqLviXcTR3hpcjprWrkGt0WOelD7e6v8FerVNNWS65
         2DUZlxHHrgaJ9qZId4LUw0hSIT/PYkzLea+CAVWMbRoIoemiyFzqc4B+zt/hf7xC1up5
         Brug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783337754; x=1783942554;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZVnuaoQHXzg0auu5bmPMaWnWzbZUreNJrNRtm/ox0Aw=;
        b=ccDKiOJvyrQnWVWtInroDA//rb4HLwCnC95YIFXlAAcsIrKsEDtqQynM8WyYfqRMEO
         RIgfuxaYriIW7nhl6EKAzncR0sd1Ao8luELrbBlS7E5fE7expDbL5NsMaH8Ckn71yBRi
         FuCWX/f9WaH3JYEivUTpDM3ME3P/3OmCIPJv0A3ZqorSqdyrfCeMaSl8fJo1AiO7kQ4K
         85eke+zOamYnUbjlRebqT0Optx/p6nWLpBK3rXHlyWUgyM36CT22jxeUcLfErHAs5Tsi
         UufwMRtn/bvv2NuvXqb8VxD5vIowNHJJdrvIdK6qfOfQUwHrT6of+HLaXmSg4OrFOIDT
         DK7Q==
X-Gm-Message-State: AOJu0YyT/SoW+B0CtoIXzauhnxIfV1Bf1WF5H87OfTRux59ABHMslavM
	sxGLH7jozUHM1uLxfARGB9TTFE/+djcItsnC9F40+aUnhltLsE1zYw+r53dQTQ==
X-Gm-Gg: AfdE7cnWws/d8T0M1HplRWq4b8Alnr2vAkNS6kXDb+4uPR+dmKSir+S1tvvPB4k1i5N
	UO0bMVfm438bDncYb/MrGtzrz5BB3mkOxM4NAyj4mzTXVop5mqdbmtwBExCP1q/5gKqYCwjrPxQ
	ALC/8mXF+fYlEnldBQiYNbkoYJg0iu+GBpEkEIW37ZUw3IpiNZuzXmpe+R52h84vLF9gIQLZ5NQ
	gBXsjpzEamDh1WXJcb700QmX41b6sxWcOVyIhcsj56c53wDgz3O8A0EMCdxXV9dpiFJu2VnZsEH
	ri5qQcAsrY0Msx+ZeUxrx6KFgfzo3cx7bFCXlMj7DSsaQ3hboDFvz0tP6Lb+/nM+CxQQ8l/EyOM
	4di+ny6+s1a9S5v5CLgdg7BkB/trfoYvP+N+QorDodMcUbP8rmCFmDA6V5Usu+uKa68ivQt9GNP
	S5IMIGAaQndxSeiqwXsX3ABJ9Hc5f/7VvelkjJ+Zmo63NqCcldSs3Z4z9C
X-Received: by 2002:a05:600c:4e04:b0:493:c634:952 with SMTP id 5b1f17b1804b1-493df0379f7mr819425e9.7.1783337753356;
        Mon, 06 Jul 2026 04:35:53 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([195.72.110.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493cce11497sm300307925e9.12.2026.07.06.04.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 04:35:52 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: John Garry <john.g.garry@oracle.com>, song@kernel.org, yukuai@fygo.io,
 magiclinan@didiglobal.com, xiao@kernel.org, axboe@kernel.dk,
 vverma@digitalocean.com, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 2/7] md/raid1: advertise atomic write limits and
 handle runtime constraints
In-Reply-To: <856abedc-d2f3-4248-9583-4d7e1a11abc1@oracle.com>
References: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
 <20260628142420.1051027-3-abd.masalkhi@gmail.com>
 <7cbaaca3-4eb5-434d-a13f-f9574c9f977b@oracle.com>
 <m2se64zak9.fsf@gmail.com>
 <856abedc-d2f3-4248-9583-4d7e1a11abc1@oracle.com>
Date: Mon, 06 Jul 2026 13:35:50 +0200
Message-ID: <m2pl1073l5.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Jul 03, 2026 at 09:28 +0100, John Garry wrote:
> On 30/06/2026 09:39, Abd-Alrhman Masalkhi wrote:
>> 
>> Hi John,
>> 
>> On Mon, Jun 29, 2026 at 15:48 +0100, John Garry wrote:
>>> On 28/06/2026 15:24, Abd-Alrhman Masalkhi wrote:
>>>> Atomic writes in RAID1 must fit within a single barrier unit. Advertise
>>>> this restriction through the queue limits by setting
>>>> atomic_write_hw_unit_max to BARRIER_UNIT_SECTOR_SIZE so that bios which
>>>> would cross a barrier-unit boundary are rejected by the block layer
>>>> before reaching MD.
>>>>
>>>> A bio that passes block-layer validation may still become unserviceable
>>>> within RAID1 due to bad blocks or write-behind constraints. In the former
>>>> case, complete the bio with EIO. In the latter case, disable
>>>> write-behind rather than failing the bio with EIO.
>>>>
>>>> Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
>>>> Fixes: a4c55c902670 ("md/raid1: simplify raid1_write_request() error handling")
>>>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>>>> ---
>>>> Changes in v2:
>>>>    - Drop the early atomic write split check from raid1_write_request().
>>>>    - Advertise the atomic write size limit via queue limits.
>>>>    - Disable write-behind instead of failing atomic writes when the
>>>>      BIO_MAX_VECS limit is encountered.
>>>>    - Link to v1: https://urldefense.com/v3/__https://lore.kernel.org/linux-raid/20260623072456.333437-3-abd.masalkhi@gmail.com/__;!!ACWV5N9M2RV99hQ!LbMSGSClRi0PNBqQti5ZNWGDVjDd34-7saYEAwNyBNjpNTjEA7veqM5RHG8KB1QiscarW4UaIefjm19ywSImtIgh$
>>>> ---
>>>>    drivers/md/raid1.c | 36 +++++++++++++++++++-----------------
>>>>    1 file changed, 19 insertions(+), 17 deletions(-)
>>>>
>>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>>> index afe2ca96ad8c..f322048ab3c2 100644
>>>> --- a/drivers/md/raid1.c
>>>> +++ b/drivers/md/raid1.c
>>>> @@ -1522,6 +1522,7 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>>>>    	int first_clone;
>>>>    	bool write_behind = false;
>>>>    	bool nowait = bio->bi_opf & REQ_NOWAIT;
>>>> +	bool atomic = bio->bi_opf & REQ_ATOMIC;
>>>>    	bool is_discard = op_is_discard(bio->bi_opf);
>>>>    	sector_t sector = bio->bi_iter.bi_sector;
>>>>    
>>>> @@ -1603,20 +1604,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>>>>    			}
>>>>    			if (is_bad) {
>>>>    				int good_sectors;
>>>> -
>>>> -				/*
>>>> -				 * We cannot atomically write this, so just
>>>> -				 * error in that case. It could be possible to
>>>> -				 * atomically write other mirrors, but the
>>>> -				 * complexity of supporting that is not worth
>>>> -				 * the benefit.
>>>> -				 */
>>>> -				if (bio->bi_opf & REQ_ATOMIC) {
>>>> -					bio->bi_status = BLK_STS_NOTSUPP;
>>>> -					bio_endio(bio);
>>>> -					goto err_dec_pending;
>>>> -				}
>>>> -
>>>>    				good_sectors = first_bad - sector;
>>>>    				if (good_sectors < max_sectors)
>>>>    					max_sectors = good_sectors;
>>>> @@ -1633,10 +1620,24 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>>>>    	 * at a time and thus needs a new bio that can fit the whole payload
>>>>    	 * this bio in page sized chunks.
>>>>    	 */
>>>> -	if (write_behind && mddev->bitmap)
>>>> -		max_sectors = min_t(int, max_sectors,
>>>> -				    BIO_MAX_VECS * (PAGE_SIZE >> 9));
>>>> +	if (write_behind && mddev->bitmap) {
>>>> +		if (atomic && max_sectors > BIO_MAX_VECS * (PAGE_SIZE >> 9))
>>>
>>> where does BIO_MAX_VECS * (PAGE_SIZE >> 9) even come from?
>>>
>> 
>> BIO_MAX_VECS * (PAGE_SIZE >> 9) defines the maximum size supported by
>> write-behind. The write-behind copy (alloc_behind_master_bio) uses a
>> single bio, which can hold at most BIO_MAX_VECS pages, making this the
>> largest payload it can carry. With a 4 KiB PAGE_SIZE, that corresponds
>> to 256 pages, or 1 MiB (2048 sectors).
>> This patch changes the behavior for atomic writes that exceed this
>> limit. Instead of failing the write with -EIO when the number of sectors
>> must be reduced, it disables write-behind and proceeds with the atomic
>> write.
>> 
>>>> +			/*
>>>> +			 * Atomic writes cannot be split, so disable
>>>> +			 * write-behind.
>>>> +			 */
>>>> +			write_behind = false;
>
> It's a bit poor to have write_behind initially = false, then allow it to 
> be set = true, and then later be set = false. Can this be improved?
>

Yes, I agree that setting write_behind to true and then resetting it to
false later is not ideal. I will rework this.


>>>> +		else
>>>> +			max_sectors = min_t(int, max_sectors,
>>>> +					    BIO_MAX_VECS * (PAGE_SIZE >> 9));
>>>> +	}
>>>> +
>>>>    	if (max_sectors < bio_sectors(bio)) {
>>>> +		if (atomic) {
>>>> +			bio_io_error(bio);
>>>> +			goto err_dec_pending;
>>>> +		}
>>>> +
>>>>    		bio = bio_submit_split_bioset(bio, max_sectors,
>>>>    					      &conf->bio_split);
>>>>    		if (!bio)
>>>> @@ -3229,6 +3230,7 @@ static int raid1_set_limits(struct mddev *mddev)
>>>>    	lim.max_write_zeroes_sectors = 0;
>>>>    	lim.max_hw_wzeroes_unmap_sectors = 0;
>>>>    	lim.logical_block_size = mddev->logical_block_size;
>>>> +	lim.atomic_write_hw_unit_max = BARRIER_UNIT_SECTOR_SIZE;
>>>
>>> This BARRIER_UNIT_SECTOR_SIZE is a bit like chunk sectors, no? I am just
>>> wondering if we just should set it to chunk sectors =
>>> BARRIER_UNIT_SECTOR_SIZE
>>>
>>> I assume that it affects more than Reads and writes, e.g. discard also.
>>>
>> 
>> BARRIER_UNIT_SECTOR_SIZE is the resync barrier-bucket, not the layout
>> chunk size. Unless I'm missing something, using
>> atomic_write_hw_unit_max seems more appropriate than using the chunk
>> size. That way, the limit only applies to atomic writes instead of
>> affecting other operations such.
>
> well it seems to be that everything in the driver is split over 
> BARRIER_UNIT_SECTOR_SIZE, so is in effect a chunk size.
>
> Note that atomic_write_hw_unit_max is going to be small always compared 
> to BARRIER_UNIT_SECTOR_SIZE.
>
> However, can you check the blk stacking code to make sure that this does 
> as you want? As I remember, for stacking we take the atomic write limits 
> of the first bottom device and then stack the other bottom devices and I 
> don't think that setting atomic_write_hw_unit_max in this way has an 
> impact - see blk_stack_atomic_writes_limits()
>

I checked blk_stack_atomic_writes_limits(), and you are right: setting
atomic_write_hw_unit_max here alone does not have the intended effect on
the final stacked device.

Also, since atomic_write_hw_unit_max is expected to always be smaller
than BARRIER_UNIT_SECTOR_SIZE, it seems that there is no need to set an
additional atomic write limit in raid1, or even to set
atomic_write_hw_unit_max at all. Is that what you mean?

>> 
>>>>    	lim.features |= BLK_FEAT_ATOMIC_WRITES;
>>>>    	lim.features |= BLK_FEAT_PCI_P2PDMA;
>>>>    	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>>>
>> 
>

-- 
Best Regards,
Abd-Alrhman
