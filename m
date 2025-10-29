Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4094315F;
	Wed, 29 Oct 2025 02:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761705363; cv=none; b=Ez3nkgwqEWjHafKRN5eCWPkcvAQvkSjVwJCeyeOgrLamxvSkXujohyEpqv18ZZow2FrOwXAjgek5KYhF1bKfbYk0IAgaArHj2Qmk6HYzop9tep9QhBVKo8IDjEJUSgu9JZBPoRYlaftUr8LhBW+26efZjSQ2rTO1skorAwT1Iyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761705363; c=relaxed/simple;
	bh=LOllrG/Bx+zcYx1gHD6OWzs68YgnkIafwljzhqiLcAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OUDd/lxalhsglakOYZFu9lG2VtBpq/3/FxGKiUd6r2RFIl7oeyKs0Z3qVzBh+dD+cSl7+cpUOsCrC06VcLkFQjcU4OAKRcc+AatWnH8RVo2MDUNBCoy1HT4aA4zxN26KtIU/yKzbxqJSils6NmamvwXN1lRShpl/uyUBgtKYWKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cxBD36GxFzKHMRQ;
	Wed, 29 Oct 2025 10:34:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 61C291A17E4;
	Wed, 29 Oct 2025 10:35:57 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnESLfQFpseLfBw--.40536S3;
	Wed, 29 Oct 2025 10:35:57 +0800 (CST)
Message-ID: <c23c005e-ac94-bc99-1469-138e5707e65b@huaweicloud.com>
Date: Wed, 29 Oct 2025 10:35:55 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v7 2/4] md: init bioset in mddev_init
To: yukuai@fnnas.com, corbet@lwn.net, song@kernel.org, hare@suse.de,
 xni@redhat.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, linan666@huaweicloud.com, yangerkun@huawei.com,
 yi.zhang@huawei.com
References: <20251027072915.3014463-1-linan122@huawei.com>
 <20251027072915.3014463-3-linan122@huawei.com>
 <69829383-8212-473b-9346-d093d33f1d27@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <69829383-8212-473b-9346-d093d33f1d27@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnESLfQFpseLfBw--.40536S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WFyUXF1DCr1UKr4kGFyxAFb_yoW8Kr4kpa
	yfGFyakr4ktrW29w13tF1q93WYqa1xtFWjkr4xAw18Zas2vr48KF1Ygr40qryDC3yxuF48
	X3W8u390g3WrAw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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



在 2025/10/28 20:01, Yu Kuai 写道:
> Hi,
> 
> 在 2025/10/27 15:29, linan122@huawei.com 写道:
>> From: Li Nan <linan122@huawei.com>
>>
>> IO operations may be needed before md_run(), such as updating metadata
>> after writing sysfs. Without bioset, this triggers a NULL pointer
>> dereference as below:
>>
>>    BUG: kernel NULL pointer dereference, address: 0000000000000020
>>    Call Trace:
>>     md_update_sb+0x658/0xe00
>>     new_level_store+0xc5/0x120
>>     md_attr_store+0xc9/0x1e0
>>     sysfs_kf_write+0x6f/0xa0
>>     kernfs_fop_write_iter+0x141/0x2a0
>>     vfs_write+0x1fc/0x5a0
>>     ksys_write+0x79/0x180
>>     __x64_sys_write+0x1d/0x30
>>     x64_sys_call+0x2818/0x2880
>>     do_syscall_64+0xa9/0x580
>>     entry_SYSCALL_64_after_hwframe+0x4b/0x53
>>
>> Reproducer
>> ```
>>     mdadm -CR /dev/md0 -l1 -n2 /dev/sd[cd]
>>     echo inactive > /sys/block/md0/md/array_state
>>     echo 10 > /sys/block/md0/md/new_level
>> ```
>>
>> Fixes: d981ed841930 ("md: Add new_level sysfs interface")
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>    drivers/md/md.c | 74 +++++++++++++++++++++++++------------------------
>>    1 file changed, 38 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index f6fd55a1637b..51f0201e4906 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -730,6 +730,8 @@ static void mddev_clear_bitmap_ops(struct mddev *mddev)
>>    
>>    int mddev_init(struct mddev *mddev)
>>    {
>> +	int err = 0;
>> +
>>    	if (!IS_ENABLED(CONFIG_MD_BITMAP))
>>    		mddev->bitmap_id = ID_BITMAP_NONE;
>>    	else
>> @@ -741,8 +743,26 @@ int mddev_init(struct mddev *mddev)
>>    
>>    	if (percpu_ref_init(&mddev->writes_pending, no_op,
>>    			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
>> -		percpu_ref_exit(&mddev->active_io);
>> -		return -ENOMEM;
>> +		err = -ENOMEM;
>> +		goto exit_acitve_io;
>> +	}
>> +
>> +	if (!bioset_initialized(&mddev->bio_set)) {
>> +		err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
> 
> mddev_init() can only be called once for one mddev, no need to test if bioset
> is initialized here.
> 

I will fix it in next version. Thanks for your review.

>> +		if (err)
>> +			goto exit_writes_pending;
>> +	}
>> +	if (!bioset_initialized(&mddev->sync_set)) {
> 
> same here.
> 

-- 
Thanks,
Nan

