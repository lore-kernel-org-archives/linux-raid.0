Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DC91FECBA
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 11:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768218018; cv=none; b=EH3rQB0CZ7tCWjpFdaqUU6Dul6zB3CpRyll+eyd0UtwBz4Y0O9P99Q9GCpt99yKsdc1Iy7VfNxi7uvLuYACNQCBnv1GqfKgG9zM4EhzmKU75QdD4MKvsilf0nIsJ+67hJZQ3nFKLwjjQTzpN5gM/o+/T7MULz+WAYol0hcKTtyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768218018; c=relaxed/simple;
	bh=kVTndz251iSBqriCPGPISo6WG9dIA05CSwLT0gay2Gw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=jyF6/r875E28YQBlT/AqQeVhzm/2ZWaIAMBdi80BIDUJNwKxxJeT1dGT38NBK5Mp6gTNzCsou78Y/frYbmPm/2EFxyADg93hMlHeYl8pmArRzcuW6qATrjDxrHsUBjAa+x9siu7k8VBnjT/YYCGJj57DJZvT2d/zxQNf501UuYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dqVmK2185zYQtM7
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 19:40:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 871FF40574
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 19:40:11 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXxfWW3WRpktwlDg--.64954S3;
	Mon, 12 Jan 2026 19:40:07 +0800 (CST)
Message-ID: <b8fdeafa-115b-9f63-6755-ae8621f826a9@huaweicloud.com>
Date: Mon, 12 Jan 2026 19:40:05 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 06/11] md: support to align bio to limits
From: Li Nan <linan666@huaweicloud.com>
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
References: <20260112042857.2334264-1-yukuai@fnnas.com>
 <20260112042857.2334264-7-yukuai@fnnas.com>
 <c1b71e5b-4a94-6b35-c0a6-f92bd1fa9dc4@huaweicloud.com>
In-Reply-To: <c1b71e5b-4a94-6b35-c0a6-f92bd1fa9dc4@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXxfWW3WRpktwlDg--.64954S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAF45GF4kZrW8CrW3Xr4fZrb_yoW5Gw15pF
	4kJFZxXryUJFn3Gw13tw1UuF9Yv348G3WDJr1xW3WUGF13Cr1qgF1UWrnYgryUGr4xWF1U
	Aw1jvFn7ur47trDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1_MaU
	UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/12 19:24, Li Nan 写道:
> 
> 
> 在 2026/1/12 12:28, Yu Kuai 写道:
>> For personalities that report optimal IO size, it indicates that users
>> can get the best IO bandwidth if they issue IO with this size. However
>> there is also an implicit condition that IO should also be aligned to the
>> optimal IO size.
>>
>> Currently, bio will only be split by limits, if bio offset is not aligned
>> to limits, then all split bio will not be aligned. This patch add a new
>> feature to align bio to limits first, and following patches will support
>> this for each personality if necessary.
>>
>> Link: 
>> https://lore.kernel.org/linux-raid/20260103154543.832844-7-yukuai@fnnas.com
>> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
>> Reviewed-by: Li Nan <linan122@huawei.com>
>> ---
>>   drivers/md/md.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   drivers/md/md.h |  2 ++
>>   2 files changed, 56 insertions(+)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 21b0bc3088d2..731ec800f5cb 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -428,6 +428,56 @@ bool md_handle_request(struct mddev *mddev, struct 
>> bio *bio)
>>   }
>>   EXPORT_SYMBOL(md_handle_request);
>> +static struct bio *__md_bio_align_to_limits(struct mddev *mddev,
>> +                         struct bio *bio)
>> +{
>> +    unsigned int max_sectors = mddev->gendisk->queue->limits.max_sectors;
>> +    sector_t start = bio->bi_iter.bi_sector;
>> +    sector_t end = start + bio_sectors(bio);
>> +    sector_t align_start;
>> +    sector_t align_end;
>> +    u32 rem;
>> +
>> +    /* calculate align_start = roundup(start, max_sectors) */
> 
> Can we use roundup_u64() here?
> 
>> +    align_start = start;
>> +    rem = sector_div(align_start, max_sectors);
>> +    /* already aligned */
>> +    if (!rem)
>> +        return bio;
>> +
>> +    align_start = start + max_sectors - rem;
>> +
>> +    /* calculate align_end = rounddown(end, max_sectors) */
> 
> Use div64_u64_rem() here seems better.

div64_u64_rem is same as sector_div. Please ignore it.

> 
>> +    align_end = end;
>> +    rem = sector_div(align_end, max_sectors);
>> +    align_end = end - rem;
>> +
>> +    /* bio is too small to split */
>> +    if (align_end <= align_start)
>> +        return bio;
>> +
>> +    return bio_submit_split_bioset(bio, align_start - start,
>> +                       &mddev->gendisk->bio_split);
>> +}
>> +

-- 
Thanks,
Nan

