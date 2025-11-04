Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2AE25A631;
	Tue,  4 Nov 2025 02:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762224735; cv=none; b=W43bfmHsdpuo/6CPhzQXo1uWpsj3m+2vCuetEpSDN9zkxrtaKoy8k4sLT26u0ANLWD2qh9r0uP7eKQnm8uOrKRRyd0IZyG4b6GT4RurARiVuVBUwO0O3QjavlGMxEEwiE2HP5dXeZRYSyNAgtMcr0MXMkLu4m/aLRtZZVxmea7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762224735; c=relaxed/simple;
	bh=J9X2QbpjrNn7X2+YQ1pXJAJznMvevW1ogJBYEpC2aMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KsfSCDWMhI1iX6E70gAKWHg2c9TlyqyYy9iTAz2l6k/KpMVdod3tZir5I+bpzXn+GIwMj6iJB9sf26C6lfQKgKIZFGCLMXsNrmp6vkQYh74neiCInE0OCykhIJosg58GEPiNGn/zi2EcOqV3gUnpArCOrPKiUUmnagIpRp2bwnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d0tJp2XnnzYQtkJ;
	Tue,  4 Nov 2025 10:51:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id AF00A1A07BD;
	Tue,  4 Nov 2025 10:52:08 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgBXrERWaglpPnGNCg--.48839S3;
	Tue, 04 Nov 2025 10:52:08 +0800 (CST)
Message-ID: <a660478f-b146-05ec-a3f4-f86457b096d0@huaweicloud.com>
Date: Tue, 4 Nov 2025 10:52:06 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v9 4/5] md: add check_new_feature module parameter
To: Xiao Ni <xni@redhat.com>, linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai@fnnas.com, hare@suse.de,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20251103125757.1405796-1-linan666@huaweicloud.com>
 <20251103125757.1405796-5-linan666@huaweicloud.com>
 <CALTww29-7U=o=RzS=pfo-zqLYY_O2o+PXw-8PLXqFRf=wdthvQ@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CALTww29-7U=o=RzS=pfo-zqLYY_O2o+PXw-8PLXqFRf=wdthvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBXrERWaglpPnGNCg--.48839S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZF1UXr45Xw1DXFykZw1rXrb_yoW5AF1Upa
	y8GF1avrW7Jr12ya1vqr1UuryrJ3yxKrWUKry5Ja4xZ3W5Kr93ArWakFWFgr9Fvry5Zr1I
	vF4UZ3Wfu3ZFyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPI14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7
	AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQ
	vtAUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/11/4 9:47, Xiao Ni 写道:
> On Mon, Nov 3, 2025 at 9:06 PM <linan666@huaweicloud.com> wrote:
>>
>> From: Li Nan <linan122@huawei.com>
>>
>> Raid checks if pad3 is zero when loading superblock from disk. Arrays
>> created with new features may fail to assemble on old kernels as pad3
>> is used.
>>
>> Add module parameter check_new_feature to bypass this check.
>>
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>   drivers/md/md.c | 12 +++++++++---
>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index dffc6a482181..5921fb245bfa 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -339,6 +339,7 @@ static int start_readonly;
>>    */
>>   static bool create_on_open = true;
>>   static bool legacy_async_del_gendisk = true;
>> +static bool check_new_feature = true;
>>
>>   /*
>>    * We have a system wide 'event count' that is incremented
>> @@ -1850,9 +1851,13 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
>>          }
>>          if (sb->pad0 ||
>>              sb->pad3[0] ||
>> -           memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(sb->pad3[1])))
>> -               /* Some padding is non-zero, might be a new feature */
>> -               return -EINVAL;
>> +           memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(sb->pad3[1]))) {
>> +               pr_warn("Some padding is non-zero on %pg, might be a new feature\n",
>> +                       rdev->bdev);
>> +               if (check_new_feature)
>> +                       return -EINVAL;
>> +               pr_warn("check_new_feature is disabled, data corruption possible\n");
>> +       }
>>
>>          rdev->preferred_minor = 0xffff;
>>          rdev->data_offset = le64_to_cpu(sb->data_offset);
>> @@ -10704,6 +10709,7 @@ module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
>>   module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
>>   module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
>>   module_param(legacy_async_del_gendisk, bool, 0600);
>> +module_param(check_new_feature, bool, 0600);
>>
>>   MODULE_LICENSE("GPL");
>>   MODULE_DESCRIPTION("MD RAID framework");
>> --
>> 2.39.2
>>
> 
> Hi
> 
> Thanks for finding this problem in time. The default of this kernel
> module is true. I don't think people can check new kernel modules
> after updating to a new kernel. They will find the array can't
> assemble and report bugs. You already use pad3, is it good to remove
> the check about pad3 directly here?
> 
> By the way, have you run the regression tests?
> 
> Regards
> Xiao
> 
> 
> .

Hi Xiao.

Thanks for your review.

Deleting this check directly is risky. For example, in configurable LBS:
if user sets LBS to 4K, the LBS of a RAID array assembled on old kernel
becomes 512. Forcing use of this array then risks data loss -- the
original issue this feature want to solve.

Future features may also have similar risks, so instead of deleting this
check directly, I chose to add a module parameter to give users a choice.
What do you think?

-- 
Thanks,
Nan

