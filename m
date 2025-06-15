Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50251805E;
	Sun, 15 Jun 2025 09:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749979290; cv=none; b=MFBNwbX6X2v7ezxyv3M6Qwg2jIL3gGf+J6VwStxTbtjCuZx63WK/CGQW3lGUXExEOfaLJpIFE8D+h54LKh9uk4xKsU+Q4sz5zfmzEZag361d4+fsuqVpsHWkmXSJL9W3okmam4qmrdiTujhHBOaXnrIIitlr45gwNP2kEUloQOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749979290; c=relaxed/simple;
	bh=NYRg38DlRuC27rhN7ZN90EJBRZhZEvpPBUvP4s6LemE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KOKA1VzNYU3wXMRQWzzFHvUHOQvkaQLSPHJjoYJeEBhjLjgRmRG7ElIEMxbFFNh+ZIf88YhG+2UIChW9jZNsPi9tBnUYrqn/ApULN8vnepfwBdGALV9z5ZA6E4V+P4ObXBWIjZS4M67dObBVBpeAMHVTgmSg+bq2Mk4IbJBhnU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.2.111] (p5b13a758.dip0.t-ipconnect.de [91.19.167.88])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2790D61E64787;
	Sun, 15 Jun 2025 11:20:33 +0200 (CEST)
Message-ID: <ffd3b5f4-4a43-4f5b-b53a-1849f4b2fb71@molgen.mpg.de>
Date: Sun, 15 Jun 2025 11:20:31 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid1,raid10: fix IO handle for REQ_NOWAIT
To: Zheng Qixing <zhengqixing@huawei.com>,
 Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20250612132141.358202-1-zhengqixing@huaweicloud.com>
 <a67b2409-334b-4712-b31d-efcbd2e216f5@molgen.mpg.de>
 <34f22e12-62e7-4e0c-9fd2-b4bacd95a4fc@huawei.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <34f22e12-62e7-4e0c-9fd2-b4bacd95a4fc@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Zheng,


Am 14.06.25 um 08:50 schrieb Zheng Qixing:

> Please disregard the previous reply email, as it contained garbled text.

Thank you for noticing this, and resending.

> 在 2025/6/13 16:02, Paul Menzel 写道:

>> Am 12.06.25 um 15:21 schrieb Zheng Qixing:
>>> From: Zheng Qixing <zhengqixing@huawei.com>
>>>
>>> IO with REQ_NOWAIT should not set R1BIO_Uptodate when it fails,
>>> and bad blocks should also be cleared when REQ_NOWAIT IO succeeds.
>>
>> It’d be great if you could add an explanation for the *should*. Why 
>> should it not be done?
>>
>> Do you have a reproducer for this?
> 
> If we set R1BIO_Uptodate when IO with REQ_NOWAIT fails, the request will
> return a success.

Understood. So no command to check for this automatically on a test system.

For the explanation, I guess my problem is, that I was not familiar with 
REQ_NOWAIT, which means that it fails for blocked IO. (If I am correct.)

> But actually it should return BLK_STS_IOERR or BLK_STS_AGAIN, right?

Sorry, I do not know. Hopefully the maintainers can answer this.

>>> Fixes: 9f346f7d4ea7 ("md/raid1,raid10: don't handle IO error for REQ_RAHEAD and REQ_NOWAIT")
>>> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
>>> ---
>>>   drivers/md/raid1.c  | 11 ++++++-----
>>>   drivers/md/raid10.c |  9 +++++----
>>>   2 files changed, 11 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index 19c5a0ce5a40..a1cddd24b178 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -455,13 +455,13 @@ static void raid1_end_write_request(struct bio *bio)
>>>       struct md_rdev *rdev = conf->mirrors[mirror].rdev;
>>>       sector_t lo = r1_bio->sector;
>>>       sector_t hi = r1_bio->sector + r1_bio->sectors;
>>> -    bool ignore_error = !raid1_should_handle_error(bio) ||
>>> -        (bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
>>> +    bool discard_error = bio->bi_status && bio_op(bio) == REQ_OP_DISCARD;
>>
>> Excuse my ignorance. What is the difference between ignore and discard?
> 
> REQ_OP_DISCARD is a operation type while REQ_NOWAIT is just a request flag.
> 
> These two can be combined together. IO with REQ_NOWAIT can fail early, even
> though the storage medium is fine. So, we better handle this type of
> error specially.
> 
> I hope this clarifies your doubts.

Sorry about being not clear enough. My question was more about changing 
the naming of the variable.

>>>       /*
>>>        * 'one mirror IO has finished' event handler:
>>>        */
>>> -    if (bio->bi_status && !ignore_error) {
>>> +    if (bio->bi_status && !discard_error &&
>>> +        raid1_should_handle_error(bio)) {
>>>           set_bit(WriteErrorSeen,    &rdev->flags);
>>>           if (!test_and_set_bit(WantReplacement, &rdev->flags))
>>>               set_bit(MD_RECOVERY_NEEDED, &
>>> @@ -507,12 +507,13 @@ static void raid1_end_write_request(struct bio *bio)
>>>            * check this here.
>>>            */
>>>           if (test_bit(In_sync, &rdev->flags) &&
>>> -            !test_bit(Faulty, &rdev->flags))
>>> +            !test_bit(Faulty, &rdev->flags) &&
>>> +            (!bio->bi_status || discard_error))
>>>               set_bit(R1BIO_Uptodate, &r1_bio->state);
>>>             /* Maybe we can clear some bad blocks. */
>>>           if (rdev_has_badblock(rdev, r1_bio->sector, r1_bio->sectors) &&
>>> -            !ignore_error) {
>>> +            !bio->bi_status) {
>>>               r1_bio->bios[mirror] = IO_MADE_GOOD;
>>>               set_bit(R1BIO_MadeGood, &r1_bio->state);
>>>           }
>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>> index b74780af4c22..1848947b0a6d 100644
>>> --- a/drivers/md/raid10.c
>>> +++ b/drivers/md/raid10.c
>>> @@ -458,8 +458,8 @@ static void raid10_end_write_request(struct bio *bio)
>>>       int slot, repl;
>>>       struct md_rdev *rdev = NULL;
>>>       struct bio *to_put = NULL;
>>> -    bool ignore_error = !raid1_should_handle_error(bio) ||
>>> -        (bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
>>> +    bool discard_error = bio->bi_status && bio_op(bio) == REQ_OP_DISCARD;
>>> +    bool ignore_error = !raid1_should_handle_error(bio) || discard_error;
>>>         dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
>>>   @@ -522,13 +522,14 @@ static void raid10_end_write_request(struct bio *bio)
>>>            * check this here.
>>>            */
>>>           if (test_bit(In_sync, &rdev->flags) &&
>>> -            !test_bit(Faulty, &rdev->flags))
>>> +            !test_bit(Faulty, &rdev->flags) &&
>>> +            (!bio->bi_status || discard_error))
>>>               set_bit(R10BIO_Uptodate, &r10_bio->state);
>>>             /* Maybe we can clear some bad blocks. */
>>>           if (rdev_has_badblock(rdev, r10_bio->devs[slot].addr,
>>>                         r10_bio->sectors) &&
>>> -            !ignore_error) {
>>> +            !bio->bi_status) {
>>>               bio_put(bio);
>>>               if (repl)
>>>                   r10_bio->devs[slot].repl_bio = IO_MADE_GOOD;


Kind regards,

Paul


PS: As it’s two hunks only connected through REQ_NOWAIT, maybe make it 
two commits: one for raid1 and one for raid10? Feel free to ignore.
