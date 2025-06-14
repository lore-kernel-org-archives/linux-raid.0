Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084C41EC014;
	Sat, 14 Jun 2025 06:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749883855; cv=none; b=c2pQvBlBm3ZagktqE1G9RqaSez5kC18nJims1WbVBKqR0KkoGkUeOrnQokiqHnIGwOCz+E7/BVhTYBoAxEPHVszB52U6rKcRmrmeBa2YYCJAAX3lm1ble+qeY59ogwOTrs1pZLNCPToAnGcU6jz5r1Njc2oKS8lpW6k6FxUaLNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749883855; c=relaxed/simple;
	bh=SO1IwcUlpkHvFquzT6VVmP6Q0aN+gQvE+EvqVBRwB24=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=U4xsRxQBrcKM3Nj+5pfzBLmUP2fuc6glEp2C23zFIrhvMvHzIXWe8JVOeDTddMxJeShQFpFCLuwYQKqS96f3P0B6wUXY3FAyw/i4WCNoPLTksbhRV2p7D45Fa3ALqC9hpPn0p+L/jygE7F6G315FkErvnLtXyKEafGYjAE0oz9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bK6Lz3VTNztQnC;
	Sat, 14 Jun 2025 14:49:31 +0800 (CST)
Received: from kwepemh100003.china.huawei.com (unknown [7.202.181.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 99873140154;
	Sat, 14 Jun 2025 14:50:42 +0800 (CST)
Received: from [10.174.178.72] (10.174.178.72) by
 kwepemh100003.china.huawei.com (7.202.181.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 14 Jun 2025 14:50:41 +0800
Message-ID: <34f22e12-62e7-4e0c-9fd2-b4bacd95a4fc@huawei.com>
Date: Sat, 14 Jun 2025 14:50:41 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid1,raid10: fix IO handle for REQ_NOWAIT
To: Paul Menzel <pmenzel@molgen.mpg.de>, Zheng Qixing
	<zhengqixing@huaweicloud.com>
CC: <song@kernel.org>, <yukuai3@huawei.com>, <linux-raid@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
References: <20250612132141.358202-1-zhengqixing@huaweicloud.com>
 <a67b2409-334b-4712-b31d-efcbd2e216f5@molgen.mpg.de>
From: Zheng Qixing <zhengqixing@huawei.com>
In-Reply-To: <a67b2409-334b-4712-b31d-efcbd2e216f5@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemh100003.china.huawei.com (7.202.181.85)

Hello Paul,


Please disregard the previous reply email, as it contained garbled text.


在 2025/6/13 16:02, Paul Menzel 写道:
> Dear Zheng,
>
>
> Thank you for the patch.
>
> Am 12.06.25 um 15:21 schrieb Zheng Qixing:
>> From: Zheng Qixing <zhengqixing@huawei.com>
>>
>> IO with REQ_NOWAIT should not set R1BIO_Uptodate when it fails,
>> and bad blocks should also be cleared when REQ_NOWAIT IO succeeds.
>
> It’d be great if you could add an explanation for the *should*. Why 
> should it not be done?
>
> Do you have a reproducer for this?
>

If we set R1BIO_Uptodate when IO with REQ_NOWAIT fails, the request will
return a success.

But actually it should return BLK_STS_IOERR or BLK_STS_AGAIN, right?


>> Fixes: 9f346f7d4ea7 ("md/raid1,raid10: don't handle IO error for 
>> REQ_RAHEAD and REQ_NOWAIT")
>> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
>> ---
>>   drivers/md/raid1.c  | 11 ++++++-----
>>   drivers/md/raid10.c |  9 +++++----
>>   2 files changed, 11 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 19c5a0ce5a40..a1cddd24b178 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -455,13 +455,13 @@ static void raid1_end_write_request(struct bio 
>> *bio)
>>       struct md_rdev *rdev = conf->mirrors[mirror].rdev;
>>       sector_t lo = r1_bio->sector;
>>       sector_t hi = r1_bio->sector + r1_bio->sectors;
>> -    bool ignore_error = !raid1_should_handle_error(bio) ||
>> -        (bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
>> +    bool discard_error = bio->bi_status && bio_op(bio) == 
>> REQ_OP_DISCARD;
>
> Excuse my ignorance. What is the difference between ignore and discard?


REQ_OP_DISCARD is a operation type while REQ_NOWAIT is just a request flag.

These two can be combined together. IO with REQ_NOWAIT can fail early, even

though the storage medium is fine. So, we better handle this type of
error specially.


I hope this clarifies your doubts.


>
>>       /*
>>        * 'one mirror IO has finished' event handler:
>>        */
>> -    if (bio->bi_status && !ignore_error) {
>> +    if (bio->bi_status && !discard_error &&
>> +        raid1_should_handle_error(bio)) {
>>           set_bit(WriteErrorSeen,    &rdev->flags);
>>           if (!test_and_set_bit(WantReplacement, &rdev->flags))
>>               set_bit(MD_RECOVERY_NEEDED, &
>> @@ -507,12 +507,13 @@ static void raid1_end_write_request(struct bio 
>> *bio)
>>            * check this here.
>>            */
>>           if (test_bit(In_sync, &rdev->flags) &&
>> -            !test_bit(Faulty, &rdev->flags))
>> +            !test_bit(Faulty, &rdev->flags) &&
>> +            (!bio->bi_status || discard_error))
>>               set_bit(R1BIO_Uptodate, &r1_bio->state);
>>             /* Maybe we can clear some bad blocks. */
>>           if (rdev_has_badblock(rdev, r1_bio->sector, 
>> r1_bio->sectors) &&
>> -            !ignore_error) {
>> +            !bio->bi_status) {
>>               r1_bio->bios[mirror] = IO_MADE_GOOD;
>>               set_bit(R1BIO_MadeGood, &r1_bio->state);
>>           }
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index b74780af4c22..1848947b0a6d 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -458,8 +458,8 @@ static void raid10_end_write_request(struct bio 
>> *bio)
>>       int slot, repl;
>>       struct md_rdev *rdev = NULL;
>>       struct bio *to_put = NULL;
>> -    bool ignore_error = !raid1_should_handle_error(bio) ||
>> -        (bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
>> +    bool discard_error = bio->bi_status && bio_op(bio) == 
>> REQ_OP_DISCARD;
>> +    bool ignore_error = !raid1_should_handle_error(bio) || 
>> discard_error;
>>         dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
>>   @@ -522,13 +522,14 @@ static void raid10_end_write_request(struct 
>> bio *bio)
>>            * check this here.
>>            */
>>           if (test_bit(In_sync, &rdev->flags) &&
>> -            !test_bit(Faulty, &rdev->flags))
>> +            !test_bit(Faulty, &rdev->flags) &&
>> +            (!bio->bi_status || discard_error))
>>               set_bit(R10BIO_Uptodate, &r10_bio->state);
>>             /* Maybe we can clear some bad blocks. */
>>           if (rdev_has_badblock(rdev, r10_bio->devs[slot].addr,
>>                         r10_bio->sectors) &&
>> -            !ignore_error) {
>> +            !bio->bi_status) {
>>               bio_put(bio);
>>               if (repl)
>>                   r10_bio->devs[slot].repl_bio = IO_MADE_GOOD;
>
>
> Kind regards,
>
> Paul


Regards,

Zheng


