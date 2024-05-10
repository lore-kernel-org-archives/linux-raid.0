Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E9E3233
	for <linux-raid@vger.kernel.org>; Fri, 10 May 2024 01:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715302811; cv=none; b=KjhZ6G9LaQiveRiue39qXx81ve0BQh4Z4SEfIZku0KiqiTvUAtREWj+ZjWJKGLOq1f9C0x8Yjeo4IfqvO1P+wtxx4LE+8PVE1nyCRSppAG4VI3K1Jz7P7vPXikkCRtZronyf0mHQkByauDnSWck9onoF4Blh6FENuFU939EnNwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715302811; c=relaxed/simple;
	bh=a8XbLk+hZX4Abey6giUGqIz1+ejlffqOStAHPoyfDFM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ez6CHMmTacqpH6KdHFWolbXZ7JjrFcT0BmdCRlytfr2rViJaekiQNz1q70vZ4HcU6nW03SgFo3ZA3dke+QLPWHCmajVZPKapjxTDScvAgcYiOME7jUpN5XaKPRCvxc6yEmJmmzqoPY1yTW2mBkG7Q8YaRVYitCIL1wh2inwLx+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vb9XD3zvCz4f3jHn
	for <linux-raid@vger.kernel.org>; Fri, 10 May 2024 08:59:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id E9B811A1143
	for <linux-raid@vger.kernel.org>; Fri, 10 May 2024 09:00:04 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBXKBGTcT1mZBPyMA--.48934S3;
	Fri, 10 May 2024 09:00:04 +0800 (CST)
Subject: Re: [PATCH v4] md: generate CHANGE uevents for md device
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: Kinga Stefaniuk <kinga.stefaniuk@intel.com>, linux-raid@vger.kernel.org,
 song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20240509122026.30015-1-kinga.stefaniuk@intel.com>
 <680e7843-db81-0dae-3e6e-5274fdb78f4f@huaweicloud.com>
 <20240509173316.0000067b@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4287380b-68a4-25ba-c7ad-a0727e7e4b7f@huaweicloud.com>
Date: Fri, 10 May 2024 09:00:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240509173316.0000067b@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBXKBGTcT1mZBPyMA--.48934S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr1xZw4rKw4rKrykCFykXwb_yoW8KryrpF
	yYgF13KF1kJF1Fvws0vw10g3yxCr1kWr95Xry3G34ak345Xr1fWFWxKa1YkFZ8Zr97Ka1j
	vayjqF98WryUtFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/05/09 23:33, Mariusz Tkaczyk Ð´µÀ:
> On Thu, 9 May 2024 21:09:12 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>>>    static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
>>>    static atomic_t md_event_count;
>>> -void md_new_event(void)
>>> +void md_new_event(struct mddev *mddev)
>>>    {
>>>    	atomic_inc(&md_event_count);
>>>    	wake_up(&md_event_waiters);
>>> +	schedule_work(&mddev->uevent_work);
>>
>> This doesn't look correct, if uevent_work is queued already and not
>> running yet, this will do nothing, which means uevent will be missing.
>> Looks like you want to generate as much uevent as md_new_event() is
>> called, or you maybe don't care about this?
> 
> I think we don't need to care. I meant that we don't need perfect mechanism.
> If there will be two events queued then probably userspace will be busy
> handling first one so the second one will be unnoticed anyway. Perhaps, we
> should left comment?

I'm not sure, for example:

1) user remove a device, wait for uevent;
2) a event is triggered by other context, while the device is not
removed yet;
3) user receive a event, then how do user side handle this case?

And if we really don't care about this case, comment will be good.

> 
>>
>> By the way, since we're here, will it be better to add some uevent
>> description in detail as well? for example:
>>
>> After add a new disk by mdadm, use kobject_uevent_env() and pass in
>> additional string like "add <disk> to array/conf".
>>
>> And many other events.
>>
> 
> Could you please elaborate more? I don't understand why this comment is
> connected to new disk, potentially CHANGE uevent can be generated in more
> scenarios, like rebuild/resync/reshape end, level change, starting raid array,
> stopping raid array (I just briefly looked where md_new_event() is called). I
> think that it is correct because those changes are real CHANGE of mddevice
> state. Also, there is a comment below md_new_event():

Yes, this is just an example for add device. I mean all other events
should be attached with proper string as well. So that if user just 
remove a disk, it can wait for the CHANGE event with the additional
string like "remove xxx".

Thanks,
Kuai

> 
>   * Events are:
>   *  start array, stop array, error, add device, remove device,
>   *  start build, activate spare
> 
> Thanks,
> Mariusz
> 
> .
> 

