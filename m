Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B047E0E8;
	Tue, 27 May 2025 07:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748331830; cv=none; b=J3jVwE5CMGal4V1YGzgRHdxoicR8vCSO720WHDHCYz0NY8Q030zwuzx9C5prsT2CpeIi36tZDz3pp2s71EdP9vzH75NmXLHM/pGATWKKdnvFbiQFKrWXTWKIqeM5OdeelDMxZw2WaDLAD4McMB0sr07Y8u/9/z2/B+2f1MhFSt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748331830; c=relaxed/simple;
	bh=uOIQWxx1FMjiCMOoHKlT1HRSlgvh/v+9hL5fU7Vwxt4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=EeUn6UBvM5HeAsRCp22qPfyQq4y0bh51VxL7pyuiMWPSOhaGtLC9N8AwnFGS2MAMNyxmn7O6msOizqyFTzX0Yfu7CfNsLgzAoDL3PyJBYq317wNb23dq4+vKqznV0fX4gPqKU8PJRdrcnlbdp/YpGlA858PWftR4SRXWO2AUDf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4b64PK6Krrz4f3jJK;
	Tue, 27 May 2025 15:43:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 272711A1524;
	Tue, 27 May 2025 15:43:43 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl8tbTVozqGcNg--.28192S3;
	Tue, 27 May 2025 15:43:42 +0800 (CST)
Subject: Re: [PATCH 06/23] md/md-bitmap: add a new sysfs api bitmap_type
To: Hannes Reinecke <hare@suse.de>, Yu Kuai <yukuai1@huaweicloud.com>,
 hch@lst.de, xni@redhat.com, colyli@kernel.org, song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-7-yukuai1@huaweicloud.com>
 <23b75e25-fa2f-4d12-8d96-6de01e43ad49@suse.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <beeed703-ed7d-2973-c403-c74994962cb0@huaweicloud.com>
Date: Tue, 27 May 2025 15:43:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <23b75e25-fa2f-4d12-8d96-6de01e43ad49@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHKl8tbTVozqGcNg--.28192S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKryDtF4kWw1DWF1DGF1fXrb_yoWxKrWkpF
	4kJFW5GFW5Jrn3Jr17JryDZFy5Xr1UJayqqr1xXa45GF47Zr4qgF15WF1qgr1UGr48Jr1U
	Ar1UXrnrur17XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/27 14:10, Hannes Reinecke 写道:
> On 5/24/25 08:13, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> The api will be used by mdadm to set bitmap_ops while creating new array
>> or assemble array, prepare to add a new bitmap.
>>
>> Currently available options are:
>>
>> cat /sys/block/md0/md/bitmap_type
>> none [bitmap]
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   Documentation/admin-guide/md.rst | 73 ++++++++++++++----------
>>   drivers/md/md.c                  | 96 ++++++++++++++++++++++++++++++--
>>   drivers/md/md.h                  |  2 +
>>   3 files changed, 135 insertions(+), 36 deletions(-)
>>
> [ .. ]
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 311e52d5173d..4eb0c6effd5b 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -672,13 +672,18 @@ static void active_io_release(struct percpu_ref 
>> *ref)
>>   static void no_op(struct percpu_ref *r) {}
>> -static void mddev_set_bitmap_ops(struct mddev *mddev, enum 
>> md_submodule_id id)
>> +static bool mddev_set_bitmap_ops(struct mddev *mddev)
>>   {
>>       xa_lock(&md_submodule);
>> -    mddev->bitmap_ops = xa_load(&md_submodule, id);
>> +    mddev->bitmap_ops = xa_load(&md_submodule, mddev->bitmap_id);
>>       xa_unlock(&md_submodule);
>> -    if (!mddev->bitmap_ops)
>> -        pr_warn_once("md: can't find bitmap id %d\n", id);
>> +
>> +    if (!mddev->bitmap_ops) {
>> +        pr_warn_once("md: can't find bitmap id %d\n", mddev->bitmap_id);
>> +        return false;
>> +    }
>> +
>> +    return true;
>>   }
>>   static void mddev_clear_bitmap_ops(struct mddev *mddev)
>> @@ -688,8 +693,10 @@ static void mddev_clear_bitmap_ops(struct mddev 
>> *mddev)
>>   int mddev_init(struct mddev *mddev)
>>   {
>> -    /* TODO: support more versions */
>> -    mddev_set_bitmap_ops(mddev, ID_BITMAP);
>> +    mddev->bitmap_id = ID_BITMAP;
>> +
>> +    if (!mddev_set_bitmap_ops(mddev))
>> +        return -EINVAL;
>>       if (percpu_ref_init(&mddev->active_io, active_io_release,
>>                   PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
>> @@ -4155,6 +4162,82 @@ new_level_store(struct mddev *mddev, const char 
>> *buf, size_t len)
>>   static struct md_sysfs_entry md_new_level =
>>   __ATTR(new_level, 0664, new_level_show, new_level_store);
>> +static ssize_t
>> +bitmap_type_show(struct mddev *mddev, char *page)
>> +{
>> +    struct md_submodule_head *head;
>> +    unsigned long i;
>> +    ssize_t len = 0;
>> +
>> +    if (mddev->bitmap_id == ID_BITMAP_NONE)
>> +        len += sprintf(page + len, "[none] ");
>> +    else
>> +        len += sprintf(page + len, "none ");
>> +
>> +    xa_lock(&md_submodule);
>> +    xa_for_each(&md_submodule, i, head) {
>> +        if (head->type != MD_BITMAP)
>> +            continue;
>> +
>> +        if (mddev->bitmap_id == head->id)
>> +            len += sprintf(page + len, "[%s] ", head->name);
>> +        else
>> +            len += sprintf(page + len, "%s ", head->name);
>> +    }
>> +    xa_unlock(&md_submodule);
>> +
>> +    len += sprintf(page + len, "\n");
>> +    return len;
>> +}
>> +
>> +static ssize_t
>> +bitmap_type_store(struct mddev *mddev, const char *buf, size_t len)
>> +{
>> +    struct md_submodule_head *head;
>> +    enum md_submodule_id id;
>> +    unsigned long i;
>> +    int err;
>> +
>> +    if (mddev->bitmap_ops)
>> +        return -EBUSY;
>> +
> Why isn't this protected by md_submodule lock?
> The lock is taken when updating ->bitmap_ops, so I would
> have expected it to be taken when checking it ...

The design is that when bitmap is created, user can no longer set
bitmap_id, and it's right without the protecting there will be race
window.

> 
>> +    err = kstrtoint(buf, 10, &id);
>> +    if (!err) {
>> +        if (id == ID_BITMAP_NONE) {
>> +            mddev->bitmap_id = id;
>> +            return len;
>> +        }
>> +
>> +        xa_lock(&md_submodule);
>> +        head = xa_load(&md_submodule, id);
>> +        xa_unlock(&md_submodule);
>> +
>> +        if (head && head->type == MD_BITMAP) {
>> +            mddev->bitmap_id = id;
>> +            return len;
>> +        }
>> +    }
>> +
>> +    if (cmd_match(buf, "none")) {
>> +        mddev->bitmap_id = ID_BITMAP_NONE;
>> +        return len;
>> +    }
>> +
> That is odd coding. The 'if (!err)' condition above might
> fall through to here, but then we already now that it cannot
> match 'none'.

The first kstrtoint() is trying to convert the input string to int id,
looks like I missed return -EINVAL if the id can't be found in
md_submodule.

> Please invert the logic, first check for 'none', and only
> call kstroint if the match failed.

Sure, this sounds better.

Thanks for the review!
Kuai

> 
>> +    xa_lock(&md_submodule);
>> +    xa_for_each(&md_submodule, i, head) {
>> +        if (head->type == MD_BITMAP && cmd_match(buf, head->name)) {
>> +            mddev->bitmap_id = head->id;
>> +            xa_unlock(&md_submodule);
>> +            return len;
>> +        }
>> +    }
>> +    xa_unlock(&md_submodule);
>> +    return -ENOENT;
>> +}
>> +
>> +static struct md_sysfs_entry md_bitmap_type =
>> +__ATTR(bitmap_type, 0664, bitmap_type_show, bitmap_type_store);
>> +
>>   static ssize_t
>>   layout_show(struct mddev *mddev, char *page)
>>   {
>> @@ -5719,6 +5802,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, 
>> serialize_policy_show,
>>   static struct attribute *md_default_attrs[] = {
>>       &md_level.attr,
>>       &md_new_level.attr,
>> +    &md_bitmap_type.attr,
>>       &md_layout.attr,
>>       &md_raid_disks.attr,
>>       &md_uuid.attr,
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 13e3f9ce1b79..bf34c0a36551 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -40,6 +40,7 @@ enum md_submodule_id {
>>       ID_CLUSTER,
>>       ID_BITMAP,
>>       ID_LLBITMAP,    /* TODO */
>> +    ID_BITMAP_NONE,
>>   };
>>   struct md_submodule_head {
>> @@ -565,6 +566,7 @@ struct mddev {
>>       struct percpu_ref        writes_pending;
>>       int                sync_checkers;    /* # of threads checking 
>> writes_pending */
>> +    enum md_submodule_id        bitmap_id;
>>       void                *bitmap; /* the bitmap for the device */
>>       struct bitmap_operations    *bitmap_ops;
>>       struct {
> 
> Cheers,
> 
> Hannes

