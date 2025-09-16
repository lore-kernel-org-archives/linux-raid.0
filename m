Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDD413C9C4;
	Tue, 16 Sep 2025 06:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758004402; cv=none; b=C7MyPyWN81SI4lkzb7X4METdUR4Jw451U+mb+uxRjFmfZMSauKDnykS8C9+qC6B0BF74xCXWpSTjKTau2aaOlpk7X7tu8vJ9IVOxcuzpYzy2R8zNAwc51sM/t5jPvbLe9yPvmj4bJRD+5E5xTIpM7Weaiq3uPnVBQCKiMXv0XW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758004402; c=relaxed/simple;
	bh=eCQhwGTJzG/d/QQlLC9trO7/NTK4VpjOsnYkZamZlm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LjBnjYsvw8HqXbCSPnv2n0rMI/Fq4MHnwYooMjwoVWTHhSzVUwzZO3m7kpPCvw9GT4AQEfAe80Zk0mHOmAO+Y6fukO1jCK4Pj2EnJWd5Pc2VHW6AwAcCyqKkt/s5x9gEaLIYi4kjQEUGDAkfSeFCw8LP6q36qC2JF/bjiT6wB+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cQsXm414DzKHN7l;
	Tue, 16 Sep 2025 14:33:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 318541A06DF;
	Tue, 16 Sep 2025 14:33:13 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgCn8IylBMlokPO0Cg--.20108S3;
	Tue, 16 Sep 2025 14:33:10 +0800 (CST)
Message-ID: <dda37f0c-bf31-cc40-4c6e-9ad85333de9a@huaweicloud.com>
Date: Tue, 16 Sep 2025 14:33:09 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 2/2] md: allow configuring logical_block_size
To: Xiao Ni <xni@redhat.com>, Li Nan <linan666@huaweicloud.com>
Cc: corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, hare@suse.de,
 martin.petersen@oracle.com, bvanassche@acm.org, filipe.c.maia@gmail.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250911073144.42160-1-linan666@huaweicloud.com>
 <20250911073144.42160-3-linan666@huaweicloud.com>
 <CALTww2_z7UGXJ+ppYXrkAY8bpVrV9O3z0VfoaTOZtmX1-DXiZA@mail.gmail.com>
 <9041896d-e4f8-c231-e8ea-5d82f8d3b0d2@huaweicloud.com>
 <CALTww28y7D32SAeoGgv2HjFJW471AtTD-SG0yxed4ZCJSOCHUw@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CALTww28y7D32SAeoGgv2HjFJW471AtTD-SG0yxed4ZCJSOCHUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCn8IylBMlokPO0Cg--.20108S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWr18ZF1DKr45Gr48GFyxAFb_yoW5Xr18pF
	WkZ3W5GFnIgF1Utws2q3WkWa40qw4fKr48Wry5Jw1Uu3909FnI9r4xK3yjgFyjqr17ur12
	vr4qq3sxZF1j93DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPI14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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



在 2025/9/15 16:50, Xiao Ni 写道:
> On Mon, Sep 15, 2025 at 10:15 AM Li Nan <linan666@huaweicloud.com> wrote:
>>
>>
>>
>> 在 2025/9/15 8:33, Xiao Ni 写道:
>>> Hi Nan
>>>
>>> On Thu, Sep 11, 2025 at 3:41 PM <linan666@huaweicloud.com> wrote:
>>>>
>>>> From: Li Nan <linan122@huawei.com>
>>>>
>>>> Previously, raid array used the maximum logical_block_size (LBS) of
>>>> all member disks. Adding a larger LBS during disk at runtime could
>>>> unexpectedly increase RAID's LBS, risking corruption of existing
>>>> partitions.
>>>
>>> Could you describe more about the problem? It's better to give some
>>> test steps that can be used to reproduce this problem.
>>
>> Thanks for your review. I will add reproducer in the next version.
> 
> Thanks.
>>
>>>>
>>>> Simply restricting larger-LBS disks is inflexible. In some scenarios,
>>>> only disks with 512 LBS are available currently, but later, disks with
>>>> 4k LBS may be added to the array.
>>>>
>>>> Making LBS configurable is the best way to solve this scenario.
>>>> After this patch, the raid will:
>>>>     - stores LBS in disk metadata.
>>>>     - add a read-write sysfs 'mdX/logical_block_size'.
>>>>
>>>> Future mdadm should support setting LBS via metadata field during RAID
>>>> creation and the new sysfs. Though the kernel allows runtime LBS changes,
>>>> users should avoid modifying it after creating partitions or filesystems
>>>> to prevent compatibility issues.
>>>
>>> Because it only allows setting when creating an array. Can this be
>>> done automatically in kernel space?
>>>
>>> Best Regards
>>> Xiao
>>
>> The kernel defaults LBS to the max among all rdevs. When creating RAID
>> with mdadm, if mdadm doesn't set LBS explicitly, how does the kernel
>> learn the intended value?
>>
>> Gunaghao previously submitted a patch related to mdadm:
>> https://lore.kernel.org/all/3a9fa346-1041-400d-b954-2119c1ea001c@huawei.com/
> 
> Thanks for reminding me about this patch. First I still need to
> understand the problem. It may be a difficult thing for a user to


Thank you for your response.

Reproducer:
https://lore.kernel.org/all/3e26e8a3-e0c1-cd40-af79-06424fb2d54b@huaweicloud.com/

I will add it to messge log in the next version.

> choose the logcial block size. They don't know why they need to
> consider this value, right? If we only need a default value, the
> kernel space should be the right place?
> 

The scenario of our product is that they have a mix of 4k LBS and 512 LBS
disks. For most users, they do not need to modify the default values. This
is difficult to solve through default values.

> Regards
> Xiao
>>
>> --
>> Thanks,
>> Nan
>>
> 
> 
> .

-- 
Thanks,
Nan

