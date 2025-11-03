Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027F12FE57F;
	Mon,  3 Nov 2025 12:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762173151; cv=none; b=FvYB2cGOPovwziyRnKSI3KGpzwIZYwO62S9K/f8IUCTMoRQ+Go/LHb4UqNryRiYdiBA9NFfcrZQei73wEDqeP3eQsigwhmiXpMAqAnydRfG8QeQPDpTfKRuC49DbZiEpGRfdVVFN63ryiylmSpRNvGifCCESJJyZ85UNjVveWqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762173151; c=relaxed/simple;
	bh=BRK0cw9ek/vbKWWU/5WFuFTQq8paZP6l279Uni3ApLk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ir7yK7Q09BPC7kVNveNOCcwsY3O05iuSYYqvd07PbLQFC8Ek5exaj+d5X8zX7qSLck8ls1GFFJbIc1Q7Fu42OgsbxdZ4+0uQveRf+nzMGmrHW+u6ZUDDuQUf+CgkWP4oH0bFjTSN7Y3hUlVdKuFRAR0cMgTPJNTan/dETOs7FKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d0WF15DN8zKHMWQ;
	Mon,  3 Nov 2025 20:32:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 082FB1A0F40;
	Mon,  3 Nov 2025 20:32:26 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgCn_UXXoAhpp45JCg--.38025S3;
	Mon, 03 Nov 2025 20:32:25 +0800 (CST)
Message-ID: <2d4c41f5-6886-98a3-8ccc-54d8a4f89fdc@huaweicloud.com>
Date: Mon, 3 Nov 2025 20:32:23 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v8 2/4] md: init bioset in mddev_init
To: Xiao Ni <xni@redhat.com>, linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai@fnnas.com, hare@suse.de,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20251030062807.1515356-1-linan666@huaweicloud.com>
 <20251030062807.1515356-3-linan666@huaweicloud.com>
 <CALTww28LKk6bH4tuEA4DD3uAJScCVAQUBn0d0JYu3AvVjxetzQ@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CALTww28LKk6bH4tuEA4DD3uAJScCVAQUBn0d0JYu3AvVjxetzQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCn_UXXoAhpp45JCg--.38025S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GryUCr1DAFW5CrW3Jr1UJrb_yoW7Kr1xpa
	yxJas8Kr4kJFWagry2qF1vg3WFqr1xtF4DtrW7ur1rAan2yr4kKF1Ygr48ZrykC3yvka1r
	Ww18XFZxuF15ur7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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



在 2025/11/3 9:23, Xiao Ni 写道:
> On Thu, Oct 30, 2025 at 2:36 PM <linan666@huaweicloud.com> wrote:
>>
>> From: Li Nan <linan122@huawei.com>
>>
>> IO operations may be needed before md_run(), such as updating metadata
>> after writing sysfs. Without bioset, this triggers a NULL pointer
>> dereference as below:
>>
>>   BUG: kernel NULL pointer dereference, address: 0000000000000020
>>   Call Trace:
>>    md_update_sb+0x658/0xe00
>>    new_level_store+0xc5/0x120
>>    md_attr_store+0xc9/0x1e0
>>    sysfs_kf_write+0x6f/0xa0
>>    kernfs_fop_write_iter+0x141/0x2a0
>>    vfs_write+0x1fc/0x5a0
>>    ksys_write+0x79/0x180
>>    __x64_sys_write+0x1d/0x30
>>    x64_sys_call+0x2818/0x2880
>>    do_syscall_64+0xa9/0x580
>>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>>
>> Reproducer
>> ```
>>    mdadm -CR /dev/md0 -l1 -n2 /dev/sd[cd]
>>    echo inactive > /sys/block/md0/md/array_state
>>    echo 10 > /sys/block/md0/md/new_level
>> ```
>>
> 
> Hi Li Nan
> 
>> mddev_init() can only be called once per mddev, no need to test if bioset
>> has been initialized anymore.
> 
> The patch looks good to me. But I don't understand the message here.
> This patch changes the alloc/free bioset positions. What's the meaning
> of "no need to test if bioset has been initialized anymore"?
> 
> Regards
> Xiao

Hi Xiao

Thanks for your review.

Sorry for causing any misunderstanding.
Old code:
-	if (!bioset_initialized(&mddev->bio_set)) {
-		err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);

New code:
+	err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);

bioset_initialized() is removed. Can I describe it as:
   mddev_init() can only be called once per mddev, thus bioset_initialized()
can be removed.

>>
>> Fixes: d981ed841930 ("md: Add new_level sysfs interface")
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>   drivers/md/md.c | 69 +++++++++++++++++++++++--------------------------
>>   1 file changed, 33 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index f6fd55a1637b..dffc6a482181 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -730,6 +730,8 @@ static void mddev_clear_bitmap_ops(struct mddev *mddev)
>>
>>   int mddev_init(struct mddev *mddev)
>>   {
>> +       int err = 0;
>> +
>>          if (!IS_ENABLED(CONFIG_MD_BITMAP))
>>                  mddev->bitmap_id = ID_BITMAP_NONE;
>>          else
>> @@ -741,10 +743,23 @@ int mddev_init(struct mddev *mddev)
>>
>>          if (percpu_ref_init(&mddev->writes_pending, no_op,
>>                              PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
>> -               percpu_ref_exit(&mddev->active_io);
>> -               return -ENOMEM;
>> +               err = -ENOMEM;
>> +               goto exit_acitve_io;
>>          }
>>
>> +       err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
>> +       if (err)
>> +               goto exit_writes_pending;
>> +
>> +       err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
>> +       if (err)
>> +               goto exit_bio_set;
>> +
>> +       err = bioset_init(&mddev->io_clone_set, BIO_POOL_SIZE,
>> +                         offsetof(struct md_io_clone, bio_clone), 0);
>> +       if (err)
>> +               goto exit_sync_set;
>> +
>>          /* We want to start with the refcount at zero */
>>          percpu_ref_put(&mddev->writes_pending);
>>
>> @@ -773,11 +788,24 @@ int mddev_init(struct mddev *mddev)
>>          INIT_WORK(&mddev->del_work, mddev_delayed_delete);
>>
>>          return 0;
>> +
>> +exit_sync_set:
>> +       bioset_exit(&mddev->sync_set);
>> +exit_bio_set:
>> +       bioset_exit(&mddev->bio_set);
>> +exit_writes_pending:
>> +       percpu_ref_exit(&mddev->writes_pending);
>> +exit_acitve_io:
>> +       percpu_ref_exit(&mddev->active_io);
>> +       return err;
>>   }
>>   EXPORT_SYMBOL_GPL(mddev_init);
>>
>>   void mddev_destroy(struct mddev *mddev)
>>   {
>> +       bioset_exit(&mddev->bio_set);
>> +       bioset_exit(&mddev->sync_set);
>> +       bioset_exit(&mddev->io_clone_set);
>>          percpu_ref_exit(&mddev->active_io);
>>          percpu_ref_exit(&mddev->writes_pending);
>>   }
>> @@ -6393,29 +6421,9 @@ int md_run(struct mddev *mddev)
>>                  nowait = nowait && bdev_nowait(rdev->bdev);
>>          }
>>
>> -       if (!bioset_initialized(&mddev->bio_set)) {
>> -               err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
>> -               if (err)
>> -                       return err;
>> -       }
>> -       if (!bioset_initialized(&mddev->sync_set)) {
>> -               err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
>> -               if (err)
>> -                       goto exit_bio_set;
>> -       }
>> -
>> -       if (!bioset_initialized(&mddev->io_clone_set)) {
>> -               err = bioset_init(&mddev->io_clone_set, BIO_POOL_SIZE,
>> -                                 offsetof(struct md_io_clone, bio_clone), 0);
>> -               if (err)
>> -                       goto exit_sync_set;
>> -       }
>> -
>>          pers = get_pers(mddev->level, mddev->clevel);
>> -       if (!pers) {
>> -               err = -EINVAL;
>> -               goto abort;
>> -       }
>> +       if (!pers)
>> +               return -EINVAL;
>>          if (mddev->level != pers->head.id) {
>>                  mddev->level = pers->head.id;
>>                  mddev->new_level = pers->head.id;
>> @@ -6426,8 +6434,7 @@ int md_run(struct mddev *mddev)
>>              pers->start_reshape == NULL) {
>>                  /* This personality cannot handle reshaping... */
>>                  put_pers(pers);
>> -               err = -EINVAL;
>> -               goto abort;
>> +               return -EINVAL;
>>          }
>>
>>          if (pers->sync_request) {
>> @@ -6554,12 +6561,6 @@ int md_run(struct mddev *mddev)
>>          mddev->private = NULL;
>>          put_pers(pers);
>>          md_bitmap_destroy(mddev);
>> -abort:
>> -       bioset_exit(&mddev->io_clone_set);
>> -exit_sync_set:
>> -       bioset_exit(&mddev->sync_set);
>> -exit_bio_set:
>> -       bioset_exit(&mddev->bio_set);
>>          return err;
>>   }
>>   EXPORT_SYMBOL_GPL(md_run);
>> @@ -6784,10 +6785,6 @@ static void __md_stop(struct mddev *mddev)
>>          mddev->private = NULL;
>>          put_pers(pers);
>>          clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>> -
>> -       bioset_exit(&mddev->bio_set);
>> -       bioset_exit(&mddev->sync_set);
>> -       bioset_exit(&mddev->io_clone_set);
>>   }
>>
>>   void md_stop(struct mddev *mddev)
>> --
>> 2.39.2
>>
> 
> 
> .

-- 
Thanks,
Nan

