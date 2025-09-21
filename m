Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48631400E
	for <linux-raid@vger.kernel.org>; Sun, 21 Sep 2025 06:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758435438; cv=none; b=cDoXTM5DM6jWozKqWVaVOPsyZwKeNsCJ0cYyNWgJsoJ9fwBntYn39O3Kz5R8fanAH+BB6QQesLcW4QWLfCaRQW6L7vU6qJirxDWzejZKOi0ULNLgF4rFBjNTiLrmzTZhIJV8KWCf3K1PNcRgRGOGWP3UJ3PiO8eg+XEuD53JmLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758435438; c=relaxed/simple;
	bh=0CJPR6qhUH15SjAy41wS/r95Pfv0PiWQpanyvZDxjL4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=AENBNheHdWkqBmr60msPi5MoVjfHhNY4KByO4DYJFnhYK8jQEmZqjUpdLR6G+qYk0eYx9mHOMffYK/Lq8GSgC8qHp9qtL9vFcDjkNGJ0dCUkJaPLJ/c9dg84pdBkZEdYmfbXEWVr28FhobSIEQCqoFkSXXuzSPVOYFDHZBhDgC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fwd.mgml.me; spf=pass smtp.mailfrom=fwd.mgml.me; dkim=pass (2048-bit key) header.d=fwd.mgml.me header.i=@fwd.mgml.me header.b=fs+WlYJX; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fwd.mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fwd.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fwd.mgml.me header.i=@fwd.mgml.me header.b="fs+WlYJX"
Received: from NEET (p3764165-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.15.205.165])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58L6BceS030967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 21 Sep 2025 15:11:38 +0900 (JST)
	(envelope-from k@fwd.mgml.me)
DKIM-Signature: a=rsa-sha256; bh=GDoaPi4bnmEsH7oEQnuScwlwvzM73xLasDQf6Sgl42I=;
        c=relaxed/relaxed; d=fwd.mgml.me;
        h=Message-ID:Date:From:Subject:To;
        s=rs20250919; t=1758435098; v=1;
        b=fs+WlYJXCmIuzFrmu7Tlm8LtB4WlapQ74LSoXxI1C3yJbqJY235li5IbrPrMZRm2
         i3t9rkxOCYYix1Lxe4N5kedwja1Ptj0MVjYWB3de5SEOaFQO7nlkrv/6H6X55rYl
         0CpcAIZrLmZLI+4y/njcDznHZoY9fQWYrzUUMmlnp3iTdTLnO6I/uXzh9ThtvYwi
         qsjEBYsl6vQrEfvKY9JoFvuwvVbTqDxDY94jJeLxNnZdMjy2+utIrREL3VmIyw2a
         fGPyKWA/jOslaTp7oCj/EoSUNyCxA3rZGyGojXdm6CrIygBm6nyUOeoFg8ri2y4o
         IZrJzCw/jwzZSRyaEskj4w==
Message-ID: <a8c19056-4245-4e70-bde1-774a84e36d62@fwd.mgml.me>
Date: Sun, 21 Sep 2025 15:11:37 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kenta Akagi <k@fwd.mgml.me>
Subject: Re: [PATCH v4 2/9] md: serialize md_error()
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>, Kenta Akagi <k@fwd.mgml.me>
References: <20250915034210.8533-1-k@mgml.me>
 <20250915034210.8533-3-k@mgml.me>
 <d42ef125-3c47-3524-140c-0df76ea85c12@huaweicloud.com>
Content-Language: en-US
In-Reply-To: <d42ef125-3c47-3524-140c-0df76ea85c12@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/09/18 10:04, Yu Kuai wrote:
> Hi,
> 
> 在 2025/09/15 11:42, Kenta Akagi 写道:
>> md_error is mainly called when a bio fails, so it can run in parallel.
>> Each personality’s error_handler locks with device_lock, so concurrent
>> calls are safe.
>>
>> However, RAID1 and RAID10 require changes for Failfast bio error handling,
>> which needs a special helper for md_error. For that helper to work, the
>> regular md_error must also be serialized.
>>
>> The helper function md_bio_failure_error for failfast will be introduced
>> in a subsequent commit.
>>
>> This commit serializes md_error for all RAID personalities. While
>> unnecessary for RAID levels other than 1 and 10, it has no performance
>> impact as it is a cold path.
>>
>> Signed-off-by: Kenta Akagi <k@mgml.me>
>> ---
>>   drivers/md/md.c | 10 +++++++++-
>>   drivers/md/md.h |  4 ++++
>>   2 files changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 268410b66b83..5607578a6db9 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -705,6 +705,7 @@ int mddev_init(struct mddev *mddev)
>>       atomic_set(&mddev->openers, 0);
>>       atomic_set(&mddev->sync_seq, 0);
>>       spin_lock_init(&mddev->lock);
>> +    spin_lock_init(&mddev->error_handle_lock);
> 
> Instead of introduing a new lock, can we use device_lock directly?
> it's held inside pers->error_handler() now, just move it forward
> to md_error().

It seems possible. In all personalities, both the caller and the callee
of md_error() appear to have no dependency on device_lock.
I will move device_lock to mddev and use it.

Thanks,
Akagi
> 
> Thanks,
> Kuai
> 
>>       init_waitqueue_head(&mddev->sb_wait);
>>       init_waitqueue_head(&mddev->recovery_wait);
>>       mddev->reshape_position = MaxSector;
>> @@ -8262,7 +8263,7 @@ void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **threadp)
>>   }
>>   EXPORT_SYMBOL(md_unregister_thread);
>>   -void md_error(struct mddev *mddev, struct md_rdev *rdev)
>> +void _md_error(struct mddev *mddev, struct md_rdev *rdev)
>>   {
>>       if (!rdev || test_bit(Faulty, &rdev->flags))
>>           return;
>> @@ -8287,6 +8288,13 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>>           queue_work(md_misc_wq, &mddev->event_work);
>>       md_new_event();
>>   }
>> +
>> +void md_error(struct mddev *mddev, struct md_rdev *rdev)
>> +{
>> +    spin_lock(&mddev->error_handle_lock);
>> +    _md_error(mddev, rdev);
>> +    spin_unlock(&mddev->error_handle_lock);
>> +}
>>   EXPORT_SYMBOL(md_error);
>>     /* seq_file implementation /proc/mdstat */
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index ec598f9a8381..5177cb609e4b 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -619,6 +619,9 @@ struct mddev {
>>       /* The sequence number for sync thread */
>>       atomic_t sync_seq;
>>   +    /* Lock for serializing md_error */
>> +    spinlock_t            error_handle_lock;
>> +
>>       bool    has_superblocks:1;
>>       bool    fail_last_dev:1;
>>       bool    serialize_policy:1;
>> @@ -901,6 +904,7 @@ extern void md_write_start(struct mddev *mddev, struct bio *bi);
>>   extern void md_write_inc(struct mddev *mddev, struct bio *bi);
>>   extern void md_write_end(struct mddev *mddev);
>>   extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
>> +void _md_error(struct mddev *mddev, struct md_rdev *rdev);
>>   extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
>>   extern void md_finish_reshape(struct mddev *mddev);
>>   void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>>
> 
> 

