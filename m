Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2507115624B;
	Tue, 23 Sep 2025 13:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758634627; cv=none; b=oiIeemOFEBCpiq6d+oAYhXEE3SASxkH0Q74atTeWX2oKH8+r+6Jtoeq+tbiSZWcatAMypiJOqJPGGromIRHYQuxp+AdeeL+Njd98ZDQzppHOJ9HYX/i7un/E4bMy4XYT/JDfyhghcow9IfkdQIcm252nDz3n5RLykMZANew44tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758634627; c=relaxed/simple;
	bh=qMvM6GackJrsHDWmHIH+1Z3+Ss9n2eyoirofAap5WWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Axjc4Vi77AWJcBvFxX2r1uwhM79sQJl8iEK3WaXgxbxm+Qxbdcj47jTIe2cH1F+ITA4MBmpfhGMWPYO69np1WB7+UCDYDOkMLNrTD2OpeJeiCI6xoGVJ97YXEmUOwpeyt7kXGMFIcKvLNJ9aEJQpMIXkGjvlT9nKzZ+eh+PBjbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cWLcS1Q5dzKHMr4;
	Tue, 23 Sep 2025 21:36:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 68ACB1A11AF;
	Tue, 23 Sep 2025 21:37:01 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgCXW2N7otJoQzg_Ag--.44743S3;
	Tue, 23 Sep 2025 21:37:01 +0800 (CST)
Message-ID: <b7fc02d2-7643-4bf1-1b15-c1ecdf883c87@huaweicloud.com>
Date: Tue, 23 Sep 2025 21:36:59 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v5 2/2] md: allow configuring logical block size
To: Xiao Ni <xni@redhat.com>, linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, hare@suse.de,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250918115759.334067-1-linan666@huaweicloud.com>
 <20250918115759.334067-3-linan666@huaweicloud.com>
 <CALTww2_4rEb9SojpVbwFy=ZEjUc0-4ECYZKYKgsay9XzDTs-cg@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CALTww2_4rEb9SojpVbwFy=ZEjUc0-4ECYZKYKgsay9XzDTs-cg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXW2N7otJoQzg_Ag--.44743S3
X-Coremail-Antispam: 1UD129KBjvJXoW3ArW7Gr4UAryfWF47JF1DJrb_yoW3Kw43pa
	97JFyakw1DXFyjyas7ZFyku3WYqw4xGFWDKry3Gw17Ar90krnF9F4fKFW5WFyqqrs3Aw12
	va1qgrn8uF9a9FJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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



在 2025/9/23 19:36, Xiao Ni 写道:
> Hi Li Nan
> 
> On Thu, Sep 18, 2025 at 8:08 PM <linan666@huaweicloud.com> wrote:
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
> 
> Thanks for the reproducer. I can reproduce it myself.
> 
>>
>> Simply restricting larger-LBS disks is inflexible. In some scenarios,
>> only disks with 512 bytes LBS are available currently, but later, disks
>> with 4KB LBS may be added to the array.
> 
> If we add a disk with 4KB LBS and configure it to 4KB by the sysfs
> interface, how can we make the partition table readable and avoid the
> problem mentioned above?
> 

Thanks for your review.

The main cause of partition loss is LBS changes. Therefore, we should 
specify a 4K LBS at creation time, instead of modifying LBS after the RAID 
is already in use. For example:

mdadm -C --logical-block-size=4096 ...

In this way, even if all underlying disks are 512-byte, the RAID will be
created with a 4096 LBS. Adding 4096-byte disks later will not cause any 
issues.

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
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>   Documentation/admin-guide/md.rst |  7 +++
>>   drivers/md/md.h                  |  1 +
>>   include/uapi/linux/raid/md_p.h   |  3 +-
>>   drivers/md/md-linear.c           |  1 +
>>   drivers/md/md.c                  | 75 ++++++++++++++++++++++++++++++++
>>   drivers/md/raid0.c               |  1 +
>>   drivers/md/raid1.c               |  1 +
>>   drivers/md/raid10.c              |  1 +
>>   drivers/md/raid5.c               |  1 +
>>   9 files changed, 90 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
>> index 1c2eacc94758..f5c81fad034a 100644
>> --- a/Documentation/admin-guide/md.rst
>> +++ b/Documentation/admin-guide/md.rst
>> @@ -238,6 +238,13 @@ All md devices contain:
>>        the number of devices in a raid4/5/6, or to support external
>>        metadata formats which mandate such clipping.
>>
>> +  logical_block_size
>> +     Configures the array's logical block size in bytes. This attribute
>> +     is only supported for RAID1, RAID5, RAID10 with 1.x meta. The value
> 
> s/RAID5/RAID456/g
> 

I will fix it later. Thanks.

>> +     should be written before starting the array. The final array LBS
>> +     will use the max value between this configuration and all rdev's LBS.
>> +     Note that LBS cannot exceed PAGE_SIZE.
>> +
>>     reshape_position
>>        This is either ``none`` or a sector number within the devices of
>>        the array where ``reshape`` is up to.  If this is set, the three
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index afb25f727409..b0147b98c8d3 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -432,6 +432,7 @@ struct mddev {
>>          sector_t                        array_sectors; /* exported array size */
>>          int                             external_size; /* size managed
>>                                                          * externally */
>> +       unsigned int                    logical_block_size;
>>          __u64                           events;
>>          /* If the last 'event' was simply a clean->dirty transition, and
>>           * we didn't write it to the spares, then it is safe and simple
>> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
>> index ac74133a4768..310068bb2a1d 100644
>> --- a/include/uapi/linux/raid/md_p.h
>> +++ b/include/uapi/linux/raid/md_p.h
>> @@ -291,7 +291,8 @@ struct mdp_superblock_1 {
>>          __le64  resync_offset;  /* data before this offset (from data_offset) known to be in sync */
>>          __le32  sb_csum;        /* checksum up to devs[max_dev] */
>>          __le32  max_dev;        /* size of devs[] array to consider */
>> -       __u8    pad3[64-32];    /* set to 0 when writing */
>> +       __le32  logical_block_size;     /* same as q->limits->logical_block_size */
>> +       __u8    pad3[64-36];    /* set to 0 when writing */
>>
>>          /* device state information. Indexed by dev_number.
>>           * 2 bytes per device
>> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
>> index 5d9b08115375..da8babb8da59 100644
>> --- a/drivers/md/md-linear.c
>> +++ b/drivers/md/md-linear.c
>> @@ -72,6 +72,7 @@ static int linear_set_limits(struct mddev *mddev)
>>
>>          md_init_stacking_limits(&lim);
>>          lim.max_hw_sectors = mddev->chunk_sectors;
>> +       lim.logical_block_size = mddev->logical_block_size;
>>          lim.max_write_zeroes_sectors = mddev->chunk_sectors;
>>          lim.io_min = mddev->chunk_sectors << 9;
>>          err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 40f56183c744..e0184942c8ec 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -1963,6 +1963,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
>>                  mddev->layout = le32_to_cpu(sb->layout);
>>                  mddev->raid_disks = le32_to_cpu(sb->raid_disks);
>>                  mddev->dev_sectors = le64_to_cpu(sb->size);
>> +               mddev->logical_block_size = le32_to_cpu(sb->logical_block_size);
>>                  mddev->events = ev1;
>>                  mddev->bitmap_info.offset = 0;
>>                  mddev->bitmap_info.space = 0;
>> @@ -2172,6 +2173,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
>>          sb->chunksize = cpu_to_le32(mddev->chunk_sectors);
>>          sb->level = cpu_to_le32(mddev->level);
>>          sb->layout = cpu_to_le32(mddev->layout);
>> +       sb->logical_block_size = cpu_to_le32(mddev->logical_block_size);
>>          if (test_bit(FailFast, &rdev->flags))
>>                  sb->devflags |= FailFast1;
>>          else
>> @@ -5900,6 +5902,66 @@ static struct md_sysfs_entry md_serialize_policy =
>>   __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
>>          serialize_policy_store);
>>
>> +static int mddev_set_logical_block_size(struct mddev *mddev,
>> +                               unsigned int lbs)
>> +{
>> +       int err = 0;
>> +       struct queue_limits lim;
>> +
>> +       if (queue_logical_block_size(mddev->gendisk->queue) >= lbs) {
>> +               pr_err("%s: incompatible logical_block_size %u, can not set\n",
>> +                      mdname(mddev), lbs);
> 
> Is it better to print the mddev's LBS and give the message "it can't
> set lbs smaller than mddev logical block size"?
> 

I agree. Let me improve this.

>> +               return -EINVAL;
>> +       }
>> +
>> +       lim = queue_limits_start_update(mddev->gendisk->queue);
>> +       lim.logical_block_size = lbs;
>> +       pr_info("%s: logical_block_size is changed, data may be lost\n",
>> +               mdname(mddev));
>> +       err = queue_limits_commit_update(mddev->gendisk->queue, &lim);
>> +       if (err)
>> +               return err;
>> +
>> +       mddev->logical_block_size = lbs;
>> +       return 0;
>> +}
>> +
>> +static ssize_t
>> +lbs_show(struct mddev *mddev, char *page)
>> +{
>> +       return sprintf(page, "%u\n", mddev->logical_block_size);
>> +}
>> +
>> +static ssize_t
>> +lbs_store(struct mddev *mddev, const char *buf, size_t len)
>> +{
>> +       unsigned int lbs;
>> +       int err = -EBUSY;
>> +
>> +       /* Only 1.x meta supports configurable LBS */
>> +       if (mddev->major_version == 0)
>> +               return -EINVAL;
> 
> It looks like it should check raid level here as doc mentioned above, right?

Yeah, kuai suggests supporting this feature only in 1.x meta.


-- 
Thanks,
Nan

