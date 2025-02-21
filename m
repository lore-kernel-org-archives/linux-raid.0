Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A940B288B1;
	Fri, 21 Feb 2025 01:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740101280; cv=none; b=oPT4v4sS3Iu8tyGNWYP0e+l6UXKMmREZXnNcOlWIAQLe7k5B85FfXrUmMwrm99f96nmipbhSbvK8xAJJ1ChwKW8x27XI7jKcIOzafFuh6JZyA1Et4BWHwzIX4d4mnHvpubou4SXfaAJ1p6lY7ZBhLaSNxLynpvwpGgfWpUiz0ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740101280; c=relaxed/simple;
	bh=lQq0ttJjnW//LXZSgipUY+T8kMfxxK3nRLvz98+CNIM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=dGbJCPl/xB5yySMs2JgdVGzVvwQIdcElLu8PD+eOuUMbZoaJ+Ineq8uRpP20GO0Srv2wm1tsMiPgWu3Krl413keBX9XYrUAvs2A3hzJ4Jb/3XNs8TiVqP+Uq7TfFZYbpv8CIzK3k42V5R5rYr6nm4haSRK3oHlzm6QVynVreEp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YzXYj4wz6z4f3jqb;
	Fri, 21 Feb 2025 09:27:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0C0F31A0DB0;
	Fri, 21 Feb 2025 09:27:54 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3Wl+Y1rdnkwrDEQ--.63559S3;
	Fri, 21 Feb 2025 09:27:53 +0800 (CST)
Subject: Re: [BUG] possible race between md_free_disk and md_notify_reboot
To: Guillaume Morin <guillaume@morinfr.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <ad286d5c-fd60-682f-bd89-710a79a710a0@huaweicloud.com>
 <82BF5B2B-7508-47DB-9845-8A5F19E0D0E5@morinfr.org>
 <53e93d6e-7b73-968b-c5f2-92d1b124ecd5@huawei.com>
 <Z7alWBZfQLlP-EO7@bender.morinfr.org>
 <1e288eb5-c67b-c9ca-c57e-2855b18785b1@huaweicloud.com>
 <6748f138-ad52-b7c5-ac53-1c7fa6fab9b7@huaweicloud.com>
 <Z7cwexr7tLRIOlNx@bender.morinfr.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <40203778-f217-6789-9c83-ebed3720627b@huaweicloud.com>
Date: Fri, 21 Feb 2025 09:27:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Z7cwexr7tLRIOlNx@bender.morinfr.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3Wl+Y1rdnkwrDEQ--.63559S3
X-Coremail-Antispam: 1UD129KBjvJXoWxur18WFyUWw4rWr4xWryUWrg_yoW5Gr1rpF
	4kJFZ5AFyDJrWrJry7Jw1DuryrZw18t34DCrW7GF18Ar1UXr1jqr13Xr4jgr1DGw48Xr1U
	tw1Utr15ZryUJrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
	r21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvj
	DU0xZFpf9x0JUBVbkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/02/20 21:39, Guillaume Morin 写道:
> On 20 Feb 19:55, Yu Kuai wrote:
>>
>>> I just take a quick look, the problem looks obviously to me, see how
>>> md_seq_show() handle the iteration.
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 465ca2af1e6e..7c7a58f618c1 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -9911,8 +9911,11 @@ static int md_notify_reboot(struct notifier_block
>>> *this,
>>>                           mddev_unlock(mddev);
>>>                   }
>>>                   need_delay = 1;
>>> -               mddev_put(mddev);
>>> -               spin_lock(&all_mddevs_lock);
>>> +
>>> +               spin_lock(&all_mddevs_lock)
>>> +               if (atomic_dec_and_test(&mddev->active))
>>> +                       __mddev_put(mddev);
>>> +
>>>           }
>>>           spin_unlock(&all_mddevs_lock);
>>
>> While cooking the patch, this is not enough, list_for_each_entry_safe()
>> should be replaced with list_for_each_entry() as well.
>>
>> Will send the patch soon, with:
>>
>> Reported-by: Guillaume Morin <guillaume@morinfr.org>
> 
> Thank you! I just saw the patch and we are going to test it and let you
> know.
> 
> The issue with the next pointer seems to be fixed with your change.
> Though I am still unclear how the 2nd potential issue I mentioned -
> where the current item would be freed concurrently by mddev_free() - is
> prevented. I am not finding anything in the code that seems to prevent a
> concurrent call to mddev_free() for the current item in the
> list_for_each_entry() loop (and therefore accessing mddev after the
> kfree()).
> 
> I understand that we are getting a reference through the active atomic
> in mddev_get() under the lock in md_notify_reboot() but how is that
> preventing mddev_free() from freeing the mddev as soon as we release the
> all_mddevs_lock in the loop?
> 
> I am not not familiar with this code so I am most likely missing
> osmething but if you had the time to explain, that would be very
> helpful.

I'm not quite sure what you're confused. mddev lifetime are both
protected by lock and reference.

In this case:

hold lock
get first mddev
release lock
// handle first mddev

hold lock
release mddev
get next mddev
release lock
-> mddev can be freed now
// handle the next mddev
...

Thanks,
Kuai

> 
> TIA
> 
> Guillaume.
> 

