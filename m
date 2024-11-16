Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CCC624;
	Sat, 16 Nov 2024 03:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731729032; cv=none; b=DSIBaf5x5rRaSoE1rVOGCAdT22L6/rfsCPBNB2hO3hszeqNhcfXB5/9wKNDvYfVFv8WLUMUKkm4F/jT6RM1bL6x8jc5Fkd0AOZXayhfFJE5RmJdughqGyZpJB2bet+xi3YbEE8xRDJrzrh1DxVpw3B1BOsjLowlgsdMA68Utsl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731729032; c=relaxed/simple;
	bh=FKljwgLTPLLfEy9k9vlShafwIRGORg2aw9l0iiys8lc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=t+6pbu1PaODy0MWWmalt9cUIdKX9UPU8lepIPw1B5A3WIrPBsUdLzyQfnYDcxVkx6FKd54cJlfS7eQEyN6XTYmZmuM4+II4zgVkASex1NJKEiM6nv7my27Wy3PiCi5V0xlUJ1moWO/NGWsa3w0yQ+LIRrbAz/r8i8M2XrahJEcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xr0Jy3CqXz4f3jkk;
	Sat, 16 Nov 2024 11:50:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B4C2E1A0196;
	Sat, 16 Nov 2024 11:50:23 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHY4d9FjhnAx2rBw--.46507S3;
	Sat, 16 Nov 2024 11:50:23 +0800 (CST)
Subject: Re: [PATCH v4 5/5] md/raid10: Atomic write support
To: Song Liu <song@kernel.org>, John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 martin.petersen@oracle.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241112124256.4106435-1-john.g.garry@oracle.com>
 <20241112124256.4106435-6-john.g.garry@oracle.com>
 <CAPhsuW6nJGQMQsEzJFZasg4LuHb3Qf-+JRTgqjaBtbYj_uBNGQ@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <469d9b9b-dbc4-26c0-4ad6-ee97bba39d47@huaweicloud.com>
Date: Sat, 16 Nov 2024 11:50:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6nJGQMQsEzJFZasg4LuHb3Qf-+JRTgqjaBtbYj_uBNGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHY4d9FjhnAx2rBw--.46507S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tFykZw18KFykCr4rGFy5XFb_yoW5JrW5p3
	yqqa98Kr43tw48u3ZrXFW7ZayFgrs7KrWIkFZ3Ww1fXFy3ZryDJF4rJrWjgrn5ZF4fJry2
	q3Z0vrZruF4akFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v2
	6r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsU
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/16 2:19, Song Liu 写道:
> On Tue, Nov 12, 2024 at 4:43 AM John Garry <john.g.garry@oracle.com> wrote:
>>
>> Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes.
>>
>> For an attempt to atomic write to a region which has bad blocks, error
>> the write as we just cannot do this. It is unlikely to find devices which
>> support atomic writes and bad blocks.
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   drivers/md/raid10.c | 14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

One nit below:
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 8c7f5daa073a..a3936a67e1e8 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1255,6 +1255,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
>>          const enum req_op op = bio_op(bio);
>>          const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
>>          const blk_opf_t do_fua = bio->bi_opf & REQ_FUA;
>> +       const blk_opf_t do_atomic = bio->bi_opf & REQ_ATOMIC;
>>          unsigned long flags;
>>          struct r10conf *conf = mddev->private;
>>          struct md_rdev *rdev;
>> @@ -1273,7 +1274,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
>>          mbio->bi_iter.bi_sector = (r10_bio->devs[n_copy].addr +
>>                                     choose_data_offset(r10_bio, rdev));
>>          mbio->bi_end_io = raid10_end_write_request;
>> -       mbio->bi_opf = op | do_sync | do_fua;
>> +       mbio->bi_opf = op | do_sync | do_fua | do_atomic;
>>          if (!replacement && test_bit(FailFast,
>>                                       &conf->mirrors[devnum].rdev->flags)
>>                           && enough(conf, devnum))
>> @@ -1468,7 +1469,15 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>>                                  continue;
>>                          }
>>                          if (is_bad) {
>> -                               int good_sectors = first_bad - dev_sector;
>> +                               int good_sectors;
>> +
>> +                               if (bio->bi_opf & REQ_ATOMIC) {
>> +                                       /* We just cannot atomically write this ... */

Maybe mention that we can if there is at least one disk without any BB,
it's just benefit does not worth the complexity. And return the special
error code to let user retry without atomic write.

>> +                                       error = -EFAULT;
> 
> Is EFAULT the right error code here? I think we should return something
> covered by blk_errors?

The error code is passed to bio by:

bio->bi_status = errno_to_blk_status(error);

So, this is fine.
> 
> Other than this, 4/5 and 5/5 look good to me.
> 
> Thanks,
> Song
> 
> .
> 

