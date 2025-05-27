Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC0422A4D8;
	Tue, 27 May 2025 07:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748332394; cv=none; b=M8ZKQuLsPyS0C5KRmT3bUV34y4iDLnVREkjwi1c3MFY82PnuPnDKy7D0sCtDZ/hqzOtSzKt5A4Z+6mdRKfM/HyFY5/pqKPE9Osp+lNE6SsobGVEhFl7C4EW4gURpbOcKQLrMVDMiPa698Zv3qJIv3BDfXHWWYcYj2jI+u0fc8t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748332394; c=relaxed/simple;
	bh=mIYmdNiseXJCzoKhPH9jmbDI1kSmDLkOHQwElgcM5kc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=RwNXycnyKcFziklo7lReEpz5/P0527w9rVVrz69MjI3cUeu+ixcZ789ZHQuhl8c33rOzej0N6GCpuhPpj4fNZEuv8A/VTSob+smYCUTA8gBSj1giJGfLYRi2CRrPC2xneMFQLJFw1Ma+LZoOlAcykqn0hg67W+QYz/54o7Anm0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4b64cj5074zKHMqc;
	Tue, 27 May 2025 15:53:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 245741A094F;
	Tue, 27 May 2025 15:53:08 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3W2BjbzVodFOdNg--.25410S3;
	Tue, 27 May 2025 15:53:07 +0800 (CST)
Subject: Re: [PATCH 07/23] md/md-bitmap: delay registration of bitmap_ops
 until creating bitmap
To: Hannes Reinecke <hare@suse.de>, Yu Kuai <yukuai1@huaweicloud.com>,
 hch@lst.de, xni@redhat.com, colyli@kernel.org, song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-8-yukuai1@huaweicloud.com>
 <d2fabdfd-229d-4043-ad27-61bac1e1f6d2@suse.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d95b41a0-c1aa-8b8b-d959-05e41eee3a7f@huaweicloud.com>
Date: Tue, 27 May 2025 15:53:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d2fabdfd-229d-4043-ad27-61bac1e1f6d2@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3W2BjbzVodFOdNg--.25410S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Jr4DGr47Ar17uF1kGr45Wrg_yoW7Zr48p3
	97JF98GrW5JrZ5Xw17JFyDuFyrXr1kJa4qqryxX3WUArnrJrn0qF45WF1vgr1UAw4xAr1U
	Aw15Jrsrur1UWF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/27 14:13, Hannes Reinecke 写道:
> On 5/24/25 08:13, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Currently bitmap_ops is registered while allocating mddev, this is fine
>> when there is only one bitmap_ops, however, after introduing a new
>> bitmap_ops, user space need a time window to choose which bitmap_ops to
>> use while creating new array.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/md.c | 86 +++++++++++++++++++++++++++++++------------------
>>   1 file changed, 55 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 4eb0c6effd5b..dc4b85f30e13 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -674,39 +674,50 @@ static void no_op(struct percpu_ref *r) {}
>>   static bool mddev_set_bitmap_ops(struct mddev *mddev)
>>   {
>> +    struct bitmap_operations *old = mddev->bitmap_ops;
>> +    struct md_submodule_head *head;
>> +
>> +    if (mddev->bitmap_id == ID_BITMAP_NONE ||
>> +        (old && old->head.id == mddev->bitmap_id))
>> +        return true;
>> +
>>       xa_lock(&md_submodule);
>> -    mddev->bitmap_ops = xa_load(&md_submodule, mddev->bitmap_id);
>> +    head = xa_load(&md_submodule, mddev->bitmap_id);
>>       xa_unlock(&md_submodule);
>> -    if (!mddev->bitmap_ops) {
>> -        pr_warn_once("md: can't find bitmap id %d\n", mddev->bitmap_id);
>> +    if (WARN_ON_ONCE(!head || head->type != MD_BITMAP)) {
>> +        pr_err("md: can't find bitmap id %d\n", mddev->bitmap_id);
>>           return false;
>>       }
>> +    if (old && old->group)
>> +        sysfs_remove_group(&mddev->kobj, old->group);
>> +
>> +    mddev->bitmap_ops = (void *)head;
>> +    if (mddev->bitmap_ops && mddev->bitmap_ops->group &&
>> +        sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
>> +        pr_warn("md: cannot register extra bitmap attributes for %s\n",
>> +            mdname(mddev));
>> +
>>       return true;
>>   }
>>   static void mddev_clear_bitmap_ops(struct mddev *mddev)
>>   {
>> +    if (mddev->bitmap_ops && mddev->bitmap_ops->group)
>> +        sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
>> +
>>       mddev->bitmap_ops = NULL;
>>   }
>>   int mddev_init(struct mddev *mddev)
>>   {
>> -    mddev->bitmap_id = ID_BITMAP;
>> -
>> -    if (!mddev_set_bitmap_ops(mddev))
>> -        return -EINVAL;
>> -
>>       if (percpu_ref_init(&mddev->active_io, active_io_release,
>> -                PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
>> -        mddev_clear_bitmap_ops(mddev);
>> +                PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
>>           return -ENOMEM;
>> -    }
>>       if (percpu_ref_init(&mddev->writes_pending, no_op,
>>                   PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
>> -        mddev_clear_bitmap_ops(mddev);
>>           percpu_ref_exit(&mddev->active_io);
>>           return -ENOMEM;
>>       }
>> @@ -734,6 +745,7 @@ int mddev_init(struct mddev *mddev)
>>       mddev->resync_min = 0;
>>       mddev->resync_max = MaxSector;
>>       mddev->level = LEVEL_NONE;
>> +    mddev->bitmap_id = ID_BITMAP;
>>       INIT_WORK(&mddev->sync_work, md_start_sync);
>>       INIT_WORK(&mddev->del_work, mddev_delayed_delete);
>> @@ -744,7 +756,6 @@ EXPORT_SYMBOL_GPL(mddev_init);
>>   void mddev_destroy(struct mddev *mddev)
>>   {
>> -    mddev_clear_bitmap_ops(mddev);
>>       percpu_ref_exit(&mddev->active_io);
>>       percpu_ref_exit(&mddev->writes_pending);
>>   }
>> @@ -6093,11 +6104,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
>>           return ERR_PTR(error);
>>       }
>> -    if (md_bitmap_registered(mddev) && mddev->bitmap_ops->group)
>> -        if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
>> -            pr_warn("md: cannot register extra bitmap attributes for 
>> %s\n",
>> -                mdname(mddev));
>> -
>>       kobject_uevent(&mddev->kobj, KOBJ_ADD);
>>       mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, 
>> "array_state");
>>       mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, 
>> "level");
> 
> But now you've killed udev event processing.
> Once the 'add' event is sent _all_ sysfs attributes must be present,
> otherwise you'll have a race condition where udev is checking for
> attributes which are present only later.
> 
> So when moving things around ensure to move the kobject_uevent() call, too.

I do not expect the bitmap entries are checked by udev, otherwise this
set can introduce regressions since the bitmap entries are no longer
existed after using the new biltmap.

And the above KOBJ_ADD uevent is used for mddev->kobj, right? In this
case, we're creating new entries under mddev->kobj, should this be
KOBJ_CHANGE?

Thanks,
Kuai

> 
> (ideally you would set the sysfs attributes when calling 'add_device()',
> but not sure if that's possible here.)
> 
> Cheers,
> 
> Hannes

