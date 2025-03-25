Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD52714EC46;
	Tue, 25 Mar 2025 07:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742887634; cv=none; b=Xj3HQOeIo2mR8mJDSzkW2hW0Tac22sm+gHnVSI0BKeu128NLmkwdCx/jWRsi8ZrvFnWNPxc216ITE9PK5dx3ImL4dvpPMbwVvEQxSASz4PGDdElJeyTqwKsIxyzB+LWh8XDzYieiCM7ojMa6fqIgv8hmSk5NbsWqoHJVg8YMPu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742887634; c=relaxed/simple;
	bh=dp3Q86fPtgLnyc9HDmsZaQrdgwB9SX8s5wmrhdxLUss=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=bcFLbAm34nR1I1MZNje9rDsZqZdflFKetJQyUrXtMfNVPrCL9wMv1STC7p7l4/7SEWOCGQrP479UVHHzCY43p0ZKe1K7QZ862AehIDdGWQ/J2Vl2BM3c0RlOXJiQqGcsVwBf9QtB2OpauuDq2DP/nOzb0GEdy3/2J98CKPYQL7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZMM1K4HFkz4f3jYK;
	Tue, 25 Mar 2025 15:26:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 760F21A1192;
	Tue, 25 Mar 2025 15:27:08 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB32l7KWuJnOXAIHg--.35537S3;
	Tue, 25 Mar 2025 15:27:08 +0800 (CST)
Subject: Re: [PATCH] md/raid10: fix missing discard IO accounting
To: Coly Li <colyli@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, jgq516@gmail.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250325015746.3195035-1-yukuai1@huaweicloud.com>
 <brtjiiejckcekwq4racmjgpzq7dod5bg2t4csj7caevnl4pkqm@zaanpogvtvus>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <36f1f74b-4376-89f3-0690-09f36e05d6e1@huaweicloud.com>
Date: Tue, 25 Mar 2025 15:27:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <brtjiiejckcekwq4racmjgpzq7dod5bg2t4csj7caevnl4pkqm@zaanpogvtvus>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB32l7KWuJnOXAIHg--.35537S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw1kJrW8JFW5WF4UtF1UWrg_yoW8WFyDp3
	y2qFWYka1ru3yUuw4qqay5Ga4rt3yDJayayrWFgrWxAF9IgFW3AF15J3yrKwnFgr4agF10
	qFn7Kay7Ga4ayaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/03/25 15:04, Coly Li 写道:
> On Tue, Mar 25, 2025 at 09:57:46AM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> md_account_bio() is not called from raid10_handle_discard(), now that we
>> handle bitmap inside md_account_bio(), also fix missing
>> bitmap_startwrite for discard.
>>
>> Test whole disk discard for 20G raid10:
>>
>> Before:
>> Device   d/s     dMB/s   drqm/s  %drqm d_await dareq-sz
>> md0    48.00     16.00     0.00   0.00    5.42   341.33
>>
>> After:
>> Device   d/s     dMB/s   drqm/s  %drqm d_await dareq-sz
>> md0    68.00  20462.00     0.00   0.00    2.65 308133.65
>>
>> Fixes: 528bc2cf2fcc ("md/raid10: enable io accounting")
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> 
> Should we treat discard request as real I/O?
> 
> Normally IMHO discard request should not be counted as real data transfer,
> correct me if I am wrong.

Normally it's not, that's why discard IOs are accounted separately in
the block layer.

Also notice that discard should be treated as write, because after
discard, reading will get zero data.

Thanks,
Kuai

> 
> Thanks.
> 
> 
>> ---
>>   drivers/md/raid10.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 9d8516acf2fd..6ef65b4d1093 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1735,6 +1735,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>>   	 * The discard bio returns only first r10bio finishes
>>   	 */
>>   	if (first_copy) {
>> +		md_account_bio(mddev, &bio);
>>   		r10_bio->master_bio = bio;
>>   		set_bit(R10BIO_Discard, &r10_bio->state);
>>   		first_copy = false;
>> -- 
>> 2.39.2
>>
>>
> 

