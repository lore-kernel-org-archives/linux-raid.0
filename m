Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC26F202C5B
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 12:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741091662; cv=none; b=XxV5+NXAgOQun6aFo1OPZIA2N+V1oQ8jzUl3aOuh5c9/XXaMeZVt9GLib5vA5pTx7VKok4Ny9wv88ZiiPRvloCBAs773XRj8RrWkwTWdVm2oQfZfkHwGABtc3UMBQMV72P76OCwyVVPC9Uh5gwllLm0Di7WxMyaR2eOw1SAVh/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741091662; c=relaxed/simple;
	bh=JPmXins3N5MB3zNzxZn+laxuEDeokiJSQbAcPb0fJno=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YJWN1zfO2fagmmboqfqIeZeSFfWluINV7zelNpxvOT7hb2WLUw/wv9hgL6bDRqeMhtQwgXMoR8sn94nrwFN+EOV9GY7apx90OqUVtaIdNZxPuA5Mk/f9JMBhSdVIhiHnKBe2SdaeB/9i8q0RfhXHltsfC8o0McvAtkz8hWLSAJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z6ZqP6wBGz4f3jYG
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 20:33:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0F4BF1A06D7
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 20:34:16 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgC3Gl9H88ZnNJ0WFg--.46252S3;
	Tue, 04 Mar 2025 20:34:15 +0800 (CST)
Subject: Re: [PATCH 1/1] md/raid10: wait barrier before returning discard
 request with REQ_NOWAIT
To: Xiao Ni <xni@redhat.com>, Paul Menzel <pmenzel@molgen.mpg.de>
Cc: yukuai1@huaweicloud.com, song@kernel.org, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250304104159.19102-1-xni@redhat.com>
 <2c14d833-12ce-42ef-80ba-a02c5e489195@molgen.mpg.de>
 <CALTww2_101s+zoe42oMkDYQ5pq=Kg=PJKciPhv+d9Kjzvb4+UQ@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <32eb3557-ac39-37d0-c65e-f4875fff8980@huaweicloud.com>
Date: Tue, 4 Mar 2025 20:34:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww2_101s+zoe42oMkDYQ5pq=Kg=PJKciPhv+d9Kjzvb4+UQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3Gl9H88ZnNJ0WFg--.46252S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KF4rJw47urWDZF1DuF45ZFb_yoW8tF4Upa
	97K3WqyFWDA34jkanFv3WYvrW5KayDJrWjvF97Kw48ZF9IqF9xJay5Ars0kFn5uryrG3y2
	q3W8J39xGF1Yya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUG0PhUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/03/04 20:22, Xiao Ni 写道:
> On Tue, Mar 4, 2025 at 7:03 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>>
>> Dear Xiao,
>>
>>
>> Thank you for your patch. A minor thing, I’d add a verb to the
>> summary/title:
> 
> Thanks for pointing out this.
> 
>>
>>> Add wait barrier before …
>>
>> Am 04.03.25 um 11:41 schrieb Xiao Ni:
>>> raid10_handle_discard should wait barrier before returning a discard bio
>>> which has REQ_NOWAIT. And there is no need to print warning calltrace
>>> if a discard bio has REQ_NOWAIT flag. Quality engineer usually checks
>>> dmesg and reports error if dmesg has warning/error calltrace.
>>
>> As written in the other thread, please add, why the warning is not
>> useful. Somebody added that warning probably with some reason.
> 
> For me, it's overkilled to print a warning calltrace if one bio has
> REQ_NOWAIT flag. It's a normal request rather than a dangerous thing
> happens, right? If we want to print some logs, we can use pr_info
> rather than WARN_ON_ONCE.

Just take a look at block layer and other drivers, there is no such
warn in this case. And I think you can add a fixtag:

c9aa889b035f ("md: raid10 add nowait support")

This commit just forbid discard with REQ_NOWAIT in raid10.

BTW, I think the abouve checking can be removed as well:

         if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
                 return -EAGAIN;

Thanks,
Kuai

> 
> Best Regards
> Xiao
> 
>>
>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>> ---
>>>    drivers/md/raid10.c | 3 +--
>>>    1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>> index 15b9ae5bf84d..7bbc04522f26 100644
>>> --- a/drivers/md/raid10.c
>>> +++ b/drivers/md/raid10.c
>>> @@ -1631,11 +1631,10 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>>>        if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
>>>                return -EAGAIN;
>>>
>>> -     if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
>>> +     if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
>>>                bio_wouldblock_error(bio);
>>>                return 0;
>>>        }
>>> -     wait_barrier(conf, false);
>>>
>>>        /*
>>>         * Check reshape again to avoid reshape happens after checking
>>
>>
>> Kind regards,
>>
>> Paul
>>
> 
> 
> .
> 

