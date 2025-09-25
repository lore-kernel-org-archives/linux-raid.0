Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E40D21ADA7;
	Thu, 25 Sep 2025 08:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758789523; cv=none; b=RnJhbOVYa9P6HdkZq/oyYrAaPAd9g9M2sJrFtjdkvsrB9UzSPsdjgqi+6vbukZDN60dv/D0YLKZZxJbWujwmDI/7nMqhGQwFqJI5TbAa+PCqnog/Xh92mdzQ0P+Q1vLkRtTJwjlcMv0t9pyRizZLW84B9sOZ45rnmT1i3/hW9S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758789523; c=relaxed/simple;
	bh=W4JNNSojzyAIs40tutEjtd/AaCxG6rQ6Ubs/37VJsiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VfPvWxP/c6LyZrBnT3APog7tgp7TnxLbECkfdMPjK3Lv5j72goyr5As9HHe24Dl9/NmwWS/p52QNJ3yIV6CberZsG46zDji15BaW7CW7XrYHaiyNA6As3c+IjticYGey+rHxucP0bzZrttVmFxGCUCk3ERPho8dMxxQp2nDExIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cXRv54jbLzYQtrY;
	Thu, 25 Sep 2025 16:38:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9B6751A0C36;
	Thu, 25 Sep 2025 16:38:34 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgD3CGGJ_9Ro2TkJAw--.52343S3;
	Thu, 25 Sep 2025 16:38:34 +0800 (CST)
Message-ID: <f54f4915-956b-895b-0e14-02c41b7b633e@huaweicloud.com>
Date: Thu, 25 Sep 2025 16:38:33 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v5 2/2] md: allow configuring logical block size
To: Xiao Ni <xni@redhat.com>, Li Nan <linan666@huaweicloud.com>
Cc: corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, hare@suse.de,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250918115759.334067-1-linan666@huaweicloud.com>
 <20250918115759.334067-3-linan666@huaweicloud.com>
 <CALTww2_4rEb9SojpVbwFy=ZEjUc0-4ECYZKYKgsay9XzDTs-cg@mail.gmail.com>
 <b7fc02d2-7643-4bf1-1b15-c1ecdf883c87@huaweicloud.com>
 <CALTww2_knuDVWLtVzrqcuLH5dmiyMqkAaZr2DB_ZpCYPQsYH0A@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CALTww2_knuDVWLtVzrqcuLH5dmiyMqkAaZr2DB_ZpCYPQsYH0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3CGGJ_9Ro2TkJAw--.52343S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw1UurWxWF15Xw1DXry5urg_yoW8tryfpF
	ZxW3W5KwnrJF1jya9FqF48KF15K3y8JFW8XryrJry7u3s8KFnF9rn7K3s8KFWjqrn3Cw17
	Zw4jgFZxZryS9aUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPI14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7
	AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUA
	xhLUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/23 22:06, Xiao Ni 写道:
> On Tue, Sep 23, 2025 at 9:37 PM Li Nan <linan666@huaweicloud.com> wrote:
>>
>>
>>
>> 在 2025/9/23 19:36, Xiao Ni 写道:
>>> Hi Li Nan
>>>
>>> On Thu, Sep 18, 2025 at 8:08 PM <linan666@huaweicloud.com> wrote:
>>>>
>>>> From: Li Nan <linan122@huawei.com>
>>>>
>>>> Previously, raid array used the maximum logical block size (LBS)
>>>> of all member disks. Adding a larger LBS disk at runtime could
>>>> unexpectedly increase RAID's LBS, risking corruption of existing
>>>> partitions. This can be reproduced by:
>>>>
>>>> ```
>>>>     # LBS of sd[de] is 512 bytes, sdf is 4096 bytes.
>>>>     mdadm -CRq /dev/md0 -l1 -n3 /dev/sd[de] missing --assume-clean
>>>>
>>>>     # LBS is 512
>>>>     cat /sys/block/md0/queue/logical_block_size
>>>>
>>>>     # create partition md0p1
>>>>     parted -s /dev/md0 mklabel gpt mkpart primary 1MiB 100%
>>>>     lsblk | grep md0p1
>>>>
>>>>     # LBS becomes 4096 after adding sdf
>>>>     mdadm --add -q /dev/md0 /dev/sdf
>>>>     cat /sys/block/md0/queue/logical_block_size
>>>>
>>>>     # partition lost
>>>>     partprobe /dev/md0
>>>>     lsblk | grep md0p1
>>>> ```
>>>
>>> Thanks for the reproducer. I can reproduce it myself.
>>>
>>>>
>>>> Simply restricting larger-LBS disks is inflexible. In some scenarios,
>>>> only disks with 512 bytes LBS are available currently, but later, disks
>>>> with 4KB LBS may be added to the array.
>>>
>>> If we add a disk with 4KB LBS and configure it to 4KB by the sysfs
>>> interface, how can we make the partition table readable and avoid the
>>> problem mentioned above?
>>>
>>
> 
> Hi
> 
>> Thanks for your review.
>>
>> The main cause of partition loss is LBS changes. Therefore, we should
>> specify a 4K LBS at creation time, instead of modifying LBS after the RAID
>> is already in use. For example:
>>
>> mdadm -C --logical-block-size=4096 ...
>>
>> In this way, even if all underlying disks are 512-byte, the RAID will be
>> created with a 4096 LBS. Adding 4096-byte disks later will not cause any
>> issues.
> 
> It can work. But it looks strange to me to set LBS to 4096 but all
> devices' LBS is 512 bytes. I don't reject it anyway :)
> 
In this scenario, there doesn't seem to be a better way. Do you have any
suggestions?

-- 
Thanks,
Nan

