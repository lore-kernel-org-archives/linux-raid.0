Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED7523C8C7;
	Mon,  3 Nov 2025 13:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762175350; cv=none; b=lSKYyzoMXHvOWQvlscIb+kTtWn5clFAY44Wmx4OZ0nok8sOqbd7MdC9KlkFBcrFqkLXbH7ZXJ1LUamRzXIbAv/rFhj3Wf3wgDUFry+i72o9/pj9DdR9aKYahNQksbqUA6izU7S9aR2IOw/Hup9v2A8O1z+PdIsIcXYVqzLJXFIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762175350; c=relaxed/simple;
	bh=7KvR314VMB5Enl4K70H6igKocHuGjGVkYQF17lVy9F8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iYlOWCliCBYlyucZvBPANu13rRmrjWqZ2Bo1N+FfUCGAGovBcQKAMhZ0Bo02Hyp/Z8O7WVZ2FHXUImp4UCf+uD+31EiAeO6IaYizC8z7nJb/NSz+PtOiIbG+j5ZvSdEFTXQmjFr569yqbkdl4mNAqIwT1OMf71jm83TnMhOfpCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d0X386QgqzYQthc;
	Mon,  3 Nov 2025 21:08:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 4F3DC1A0F86;
	Mon,  3 Nov 2025 21:09:06 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgCH3UVwqQhpQGxMCg--.38718S3;
	Mon, 03 Nov 2025 21:09:06 +0800 (CST)
Message-ID: <358b8933-952e-0e4b-e708-c40ca98ae7d7@huaweicloud.com>
Date: Mon, 3 Nov 2025 21:09:04 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v8 4/4] md: allow configuring logical block size
To: Xiao Ni <xni@redhat.com>, linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai@fnnas.com, hare@suse.de,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20251030062807.1515356-1-linan666@huaweicloud.com>
 <20251030062807.1515356-5-linan666@huaweicloud.com>
 <CALTww28r_bicJ_4jcxQ7MB2hLVX5nAZkY3tuM7q7HY_D2beHFA@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CALTww28r_bicJ_4jcxQ7MB2hLVX5nAZkY3tuM7q7HY_D2beHFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCH3UVwqQhpQGxMCg--.38718S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJr45XFW8GrW8Zr18Ar1DJrb_yoW5JrW8pF
	Z3ua15Kwn7XF1Yka9rAF1kKFWrK3yxWayxJry5Jr17Z34DCr9F9r4fK348K3WUXr13C34j
	va17KFyFvFna9aUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPa14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7
	AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	WUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU
	OmhFUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/11/3 11:11, Xiao Ni 写道:
> On Thu, Oct 30, 2025 at 2:36 PM <linan666@huaweicloud.com> wrote:
>>
>> From: Li Nan <linan122@huawei.com>
>>
>> Previously, raid array used the maximum logical block size (LBS)
>> of all member disks. Adding a larger LBS disk at runtime could
>> unexpectedly increase RAID's LBS, risking corruption of existing
>> partitions. This can be reproduced by:
>>
>> ```
>>    # LBS of sd[de] is 512 bytes, sdf is 4096 bytes.
>>    mdadm -CRq /dev/md0 -l1 -n3 /dev/sd[de] missing --assume-clean
>>
>>    # LBS is 512
>>    cat /sys/block/md0/queue/logical_block_size
>>
>>    # create partition md0p1
>>    parted -s /dev/md0 mklabel gpt mkpart primary 1MiB 100%
>>    lsblk | grep md0p1
>>
>>    # LBS becomes 4096 after adding sdf
>>    mdadm --add -q /dev/md0 /dev/sdf
>>    cat /sys/block/md0/queue/logical_block_size
>>
>>    # partition lost
>>    partprobe /dev/md0
>>    lsblk | grep md0p1
>> ```
>>
>> Simply restricting larger-LBS disks is inflexible. In some scenarios,
>> only disks with 512 bytes LBS are available currently, but later, disks
>> with 4KB LBS may be added to the array.
>>
>> Making LBS configurable is the best way to solve this scenario.
>> After this patch, the raid will:
>>    - store LBS in disk metadata
>>    - add a read-write sysfs 'mdX/logical_block_size'
>>
>> Future mdadm should support setting LBS via metadata field during RAID
>> creation and the new sysfs. Though the kernel allows runtime LBS changes,
>> users should avoid modifying it after creating partitions or filesystems
>> to prevent compatibility issues.
>>
>> Only 1.x metadata supports configurable LBS. 0.90 metadata inits all
>> fields to default values at auto-detect. Supporting 0.90 would require
>> more extensive changes and no such use case has been observed.
>>
>> Note that many RAID paths rely on PAGE_SIZE alignment, including for
>> metadata I/O. A larger LBS than PAGE_SIZE will result in metadata
>> read/write failures. So this config should be prevented.
>>
>> Signed-off-by: Li Nan <linan122@huawei.com >
> Hi Li Nan
> 

Hi Xiao,

Thanks for your review.

> The problem can't be fixed if there is no user space (mdadm) patch, right?
> 

Yeah, mdadm should update same time. And Guanghao will send a mdadm patch
later.

> The patch Looks good to me.
> Reviewed-by: Xiao Ni <xni@redhat.com>
> 

Sorry for the trouble. I sent the v9 with some changes to the
Documentation. Could you please review v9 patch when you have time?

> 
> .


-- 
Thanks,
Nan

