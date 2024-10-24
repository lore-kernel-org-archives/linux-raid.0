Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAC4482EB;
	Thu, 24 Oct 2024 03:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729739304; cv=none; b=eemm60pDlFAOHtT9dnZLNXnn6Y1/MK42SjnyqkJ8N5rKrLELeUuqpNl12kzHydvEQ1sp84NWc1s/WboP2pPYz/MBarwm7Jys7cdsCpQlTLvg5k7Ah3tPQbJ5oZ18PdUxvYFb/efeZc9oQleEISUxEinvaNhO1lrxk1TkszR6chE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729739304; c=relaxed/simple;
	bh=CaMSAi9vUKO64fetahh6zHgIEDuIiyQkqUQ3Uto8qSc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=c1EOsZAo+cT6OMfh1Jsek2WqLSaxg36RBCdiH9+6PfoXw4BneHyC9P6lUJQIKeFt/iPQMYHL4H3zkq4JU/9L3bil+7KjZKPwGttiP6Pcepiuxoce5BWDtyTrodkbL3t2/d1TU4a9gTfmLyS8Z3WMrkDy2v8dSLkGqR2MKnIqNdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XYrSq2dtrz4f3lfy;
	Thu, 24 Oct 2024 11:07:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9BD951A0568;
	Thu, 24 Oct 2024 11:08:13 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAXTMgbuhlnG03SEw--.35506S3;
	Thu, 24 Oct 2024 11:08:13 +0800 (CST)
Subject: Re: [PATCH RFC 5/6] md/raid1: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-6-john.g.garry@oracle.com>
 <bc4c414c-a7aa-358b-71c1-598af05f005f@huaweicloud.com>
 <0161641d-daef-4804-b4d2-4a83f625bc77@oracle.com>
 <c03de5c7-20b8-3973-a843-fc010f121631@huaweicloud.com>
 <68d10e83-b196-4935-a350-464b82c30e44@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <169b94ae-8711-1821-75a7-7e3a600745e4@huaweicloud.com>
Date: Thu, 24 Oct 2024 11:08:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <68d10e83-b196-4935-a350-464b82c30e44@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXTMgbuhlnG03SEw--.35506S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar48KrW5Xw1kWFWkCF1DGFg_yoW8Xw4xp3
	48JFWxArW5JrW8ZF1UJw17ta4rAr1UXa45AF18W3WUJFsIqr90vF4UXryqgr18XF48Gr1U
	J3W8GFsxuF47JFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/



在 2024/10/23 19:21, John Garry 写道:
> On 23/09/2024 07:15, Yu Kuai wrote:
> 
> Hi Kuai,
> 
>>> iff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index 6c9d24203f39..c561e2d185e2 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -1383,6 +1383,10 @@ static void raid1_read_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>       if (max_sectors < bio_sectors(bio)) {
>>>           struct bio *split = bio_split(bio, max_sectors,
>>>                             gfp, &conf->bio_split);
>>> +        if (IS_ERR(split)) {
>>> +            raid_end_bio_io(r1_bio);
>>> +            return;
>>> +        }
>>
>> This way, BLK_STS_IOERR will always be returned, perhaps what you want
>> is to return the error code from bio_split()?
> 
> I am not sure on the best way to pass the bio_split() error code to 
> bio->bi_status.
> 
> I could just have this pattern:
> 
> bio->bi_status = errno_to_blk_status(err);
> set_bit(R1BIO_Uptodate, &r1_bio->state);
> raid_end_bio_io(r1_bio);
> 
I can live with this. :)

> Is there a neater way to do this?

Perhaps add a new filed 'status' in r1bio? And initialize it to
BLK_STS_IOERR;

Then replace:
set_bit(R1BIO_Uptodate, &r1_bio->state);
to:
r1_bio->status = BLK_STS_OK;

and change call_bio_endio:
bio->bi_status = r1_bio->status;

finially here:
r1_bio->status = errno_to_blk_status(err);
raid_end_bio_io(r1_bio);

Thanks,
Kuai

> 
> Thanks,
> John
> 
> 
> .
> 

