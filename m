Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59601EE01B;
	Thu, 20 Feb 2025 11:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740052528; cv=none; b=lh1KwVSVmIA2HMJatf5XV1z2CKbFtGW+Ag/3MIvsv39oUygZqMGZxSpZhapUH9+x2U7hINQKxI2V4hV51NE0MvONCpT9w+e1gt1dAAlBAaWT9s5AIwT9P+oJt3ZtyWilFifXqF7vb67hkAnIuRG37fO5/NhCXSGPjotFhCuMC+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740052528; c=relaxed/simple;
	bh=Ff+J4nhissGW/HsxnmSTk5OwvjE7yZEQW/HdeRKavPo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=GmiVHVmxInY1CSRpgv1ijwcyDDcgkdsm/fbK5NmaiohcvQERqhOop7WVvrP/iunQDG3G0wH0iCBjoF4+v7npuujWwCjtLZyjm3jW6taPq1HUtjUjMNkC1JPPAcVpK4SQ8ssaxwpnmSuS/vLEztqQiGzFvgQ2bzUTZaMzNqaODh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YzBWx4mpDz4f3jcm;
	Thu, 20 Feb 2025 19:54:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4F0AD1A16A8;
	Thu, 20 Feb 2025 19:55:15 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl8hGLdncWGMEQ--.55453S3;
	Thu, 20 Feb 2025 19:55:15 +0800 (CST)
Subject: Re: [BUG] possible race between md_free_disk and md_notify_reboot
To: Yu Kuai <yukuai1@huaweicloud.com>, Guillaume Morin <guillaume@morinfr.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <ad286d5c-fd60-682f-bd89-710a79a710a0@huaweicloud.com>
 <82BF5B2B-7508-47DB-9845-8A5F19E0D0E5@morinfr.org>
 <53e93d6e-7b73-968b-c5f2-92d1b124ecd5@huawei.com>
 <Z7alWBZfQLlP-EO7@bender.morinfr.org>
 <1e288eb5-c67b-c9ca-c57e-2855b18785b1@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6748f138-ad52-b7c5-ac53-1c7fa6fab9b7@huaweicloud.com>
Date: Thu, 20 Feb 2025 19:55:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1e288eb5-c67b-c9ca-c57e-2855b18785b1@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl8hGLdncWGMEQ--.55453S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WryfWryUtFy7tFyfCFWDtwb_yoW8tFyDpF
	WkXF4UCryUJry8J34UJr4DuFyrtr1UJw4DJr1xW3WUJr1DJrnFqr13Xr1qgr1jqa18Jr15
	ta1UKryUZr1UJ37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/02/20 12:06, Yu Kuai 写道:
> Hi,
> 
> 在 2025/02/20 11:45, Guillaume Morin 写道:
>> On 20 Feb 11:19, Yu Kuai wrote:
>>>
>>> Hi,
>>>
>>> 在 2025/02/20 11:05, Guillaume Morin 写道:
>>>> how it was guaranteed that mddev_get() would fail as mddev_free() 
>>>> does not check or synchronize with the active atomic
>>>
>>> Please check how mddev is freed, start from mddev_put(). There might be
>>> something wrong, but it's not what you said.
>>
>> I will take a look. Though if you're confident that this logic protects
>> any uaf, that makes sense to me.
>>
>> However as I mentioned this is not what the crash was about (I mentioned
>> the UAF in passing). The GPF seems to be about deleting the _next_
>> pointer while iterating over all mddevs. The mddev_get on the
>> current item is not going to help with this.
>>
> 
> You don't need to emphasize this, it is still speculate without solid
> theoretical analysis. The point about mddev_get() is that it's done
> inside the lock, it shoud gurantee continue iterating should be fine.
> 
> I just take a quick look, the problem looks obviously to me, see how
> md_seq_show() handle the iteration.
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 465ca2af1e6e..7c7a58f618c1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9911,8 +9911,11 @@ static int md_notify_reboot(struct notifier_block 
> *this,
>                          mddev_unlock(mddev);
>                  }
>                  need_delay = 1;
> -               mddev_put(mddev);
> -               spin_lock(&all_mddevs_lock);
> +
> +               spin_lock(&all_mddevs_lock)
> +               if (atomic_dec_and_test(&mddev->active))
> +                       __mddev_put(mddev);
> +
>          }
>          spin_unlock(&all_mddevs_lock);

While cooking the patch, this is not enough, list_for_each_entry_safe()
should be replaced with list_for_each_entry() as well.

Will send the patch soon, with:

Reported-by: Guillaume Morin <guillaume@morinfr.org>

Thanks,
Kuai
> 
> 
> Thanks,
> Kuai
> 
> .
> 

