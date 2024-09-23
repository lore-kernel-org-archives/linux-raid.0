Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296C02F26;
	Mon, 23 Sep 2024 06:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727072147; cv=none; b=f4Bu0cRfjAp3vEen+ez1aXdrBfUsoIhcH1NDveGvbksw0kR1xPz/jC252lY54recTaNFN5G/H760qKCtc7SauhmXVs14FEwkbj/iyHFhUMqE0WWJ3buyBhBmjoTgDQY+oDBgd1GgUGwofg+hl3Po9j8OnMmln9vbNHcnoXDCMoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727072147; c=relaxed/simple;
	bh=SDK5WAPvFQbd6TXK5jrk7iXs9dzKjQKBFUw2MueBtgE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=XV4gfp39HBoVNTVsD+HMt6DFh/FwCiNY/D/QAwn5+3DQZ+dLhm7voa+XrNuMIIqWJzC3fGPHBtERU0oIAP3bhf8ILO8cC19m2g2fvMOIz2pj/62oFgAWLKUCmfNg0vBDZDCdOz8chQF6x/rHANqtNQz7ObC9ITfN7A2n62/rGWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XBt5L1w04z4f3kvm;
	Mon, 23 Sep 2024 14:15:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 177B51A0C3F;
	Mon, 23 Sep 2024 14:15:35 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXysaFB_Fmq7NsCA--.30384S3;
	Mon, 23 Sep 2024 14:15:34 +0800 (CST)
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
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c03de5c7-20b8-3973-a843-fc010f121631@huaweicloud.com>
Date: Mon, 23 Sep 2024 14:15:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <0161641d-daef-4804-b4d2-4a83f625bc77@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXysaFB_Fmq7NsCA--.30384S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr4UXF4rurWkCFW3AFyUtrb_yoW8Ary8pr
	1ktFy5CrWUGrW8Cw17Xw4jya4Fyr1UJ3W5Ary0qa18ArnrJF9FqrWUXr1qgF1Y9r4xGF1j
	qr18WFsxuFy7JFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/



在 2024/09/20 18:04, John Garry 写道:
> On 20/09/2024 07:58, Yu Kuai wrote:
>> Hi,
>>
>> 在 2024/09/19 17:23, John Garry 写道:
>>> Add proper bio_split() error handling. For any error, call
>>> raid_end_bio_io() and return;
>>>
>>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>>> ---
>>>   drivers/md/raid1.c | 8 ++++++++
>>>   1 file changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
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
> Yeah, I would like to return that error code, so maybe I can encode it 
> in the master_bio directly or pass as an arg to raid_end_bio_io().

That's fine, however, I think the change can introduce problems in some
corner cases, for example there is a rdev with badblocks and a slow rdev
with full copy. Currently raid1_read_request() will split this bio to
read some from fast rdev, and read the badblocks region from slow rdev.

We need a new branch in read_balance() to choose a rdev with full copy.

Thanks,
Kuai

> 
> Thanks,
> John
> 
> .
> 

