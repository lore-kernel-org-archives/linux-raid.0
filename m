Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BC514A4E1
	for <linux-raid@vger.kernel.org>; Tue, 25 Jun 2024 09:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719307516; cv=none; b=uOzMRLupfLQdZaFkg/8CCzkVPmPphZUe/8qhnd43cYH8KoSyKruifcBsl2Xu0q6LFNNTXIgws2dUqXmbMeZu830dmNsePhAkdFzaEU7jAHoVMS+NC3hxMw1mhy4XtgubeVryXxB3+ZcD6eybVjEc5PSNl65b+OxdQghV+lOMn0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719307516; c=relaxed/simple;
	bh=buHwwvquZbPW1FyleTQRjd8TirrsXmTcaNbiVjCr3ak=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YHGlPtNoqp5QcZGu/oZRQyfCmve/hF2s1fgRVKAd3dpwgbNGEJEhHZIgd+qd9M6AumRJvTec4nFLvgK0wJPSE3U0yhVaBSgmdm5DCvaxXMru44foUZ9nuc0D9EBtcowZwwTxVBmK9jDbzWWQliDxqcTHt8+GwWtTCsMj87qZQRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4W7fYp55x3z4f3jtL
	for <linux-raid@vger.kernel.org>; Tue, 25 Jun 2024 17:25:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id C1EAF1A0572
	for <linux-raid@vger.kernel.org>; Tue, 25 Jun 2024 17:25:09 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP2 (Coremail) with SMTP id Syh0CgCH74T0jHpmMQUsAQ--.64149S3;
	Tue, 25 Jun 2024 17:25:09 +0800 (CST)
Subject: Re: MD: Long delay for container drive removal
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <814ff6ee-47a2-4ba0-963e-cf256ee4ecfa@linux.intel.com>
 <24cf4b0e-2cb5-4b50-8867-f7feadaf367d@linux.intel.com>
 <20240624091410.00007100@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <47380797-6bc5-e075-e062-2fb11891929f@huaweicloud.com>
Date: Tue, 25 Jun 2024 17:25:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240624091410.00007100@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCH74T0jHpmMQUsAQ--.64149S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4DZrWxWFyDWF18GFW8Xrb_yoWrZr13pF
	W7Ja4FkrWUJr1Ika4vqw18ZF4Yyw1xArW5Wr93W345ZFn8Ar10vF10kFsI9FZI9aykKan0
	vF18Xasrua4YkaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/06/24 15:14, Mariusz Tkaczyk Ð´µÀ:
> On Thu, 20 Jun 2024 14:43:50 +0200
> Mateusz Kusiak <mateusz.kusiak@linux.intel.com> wrote:
> 
>> On 18.06.2024 16:24, Mateusz Kusiak wrote:
>>> Hi all,
>>> we have an issue submitted for SLES15SP6 that is caused by huge delays when
>>> trying to remove drive from a container.
>>>
>>> The scenario is as follows:
>>> 1. Create two drive imsm container
>>> # mdadm --create --run /dev/md/imsm --metadata=imsm --raid-devices=2
>>> /dev/nvme[0-1]n1 2. Remove single drive from container
>>> # mdadm /dev/md127 --remove /dev/nvme0n1
>>>
>>> The problem is that drive removal may take up to 7 seconds, which causes
>>> timeouts for other components that are mdadm dependent.
>>>
>>> We narrowed it down to be MD related. We tested this with inbox mdadm-4.3
>>> and mdadm-4.2 on SP6 and delay time is pretty much the same. SP5 is free of
>>> this issue.
>>>
>>> I also tried RHEL 8.9 and drive removal is almost instant.
>>>
>>> Is it default behavior now, or should we treat this as an issue?
>>>
>>> Thanks,
>>> Mateusz
>>>    
>>
>> I dug into this more. I retested this on:
>> - Ubuntu 24.04 with inbox kernel 6.6.0: No reproduction
>> - RHEL 9.4 with usptream kernel: 6.9.5-1: Got reproduction
>> (Note that SLES15SP6 comes with 6.8.0-rc4 inbox)
>>
>> I plugged into mdadm with gdb and found out that ioctl call in
>> hot_remove_disk() fails and it's causing a delay. The function looks as
>> follows:
>>
>> int hot_remove_disk(int mdfd, unsigned long dev, int force)
>> {
>> 	int cnt = force ? 500 : 5;
>> 	int ret;
>>
>> 	/* HOT_REMOVE_DISK can fail with EBUSY if there are
>> 	 * outstanding IO requests to the device.
>> 	 * In this case, it can be helpful to wait a little while,
>> 	 * up to 5 seconds if 'force' is set, or 50 msec if not.
>> 	 */
>> 	while ((ret = ioctl(mdfd, HOT_REMOVE_DISK, dev)) == -1 &&
>> 	       errno == EBUSY &&
>> 	       cnt-- > 0)
>> 		sleep_for(0, MSEC_TO_NSEC(10), true);
>>
>> 	return ret;
>> }
>> ... if it fails, then it defaults to removing drive via sysfs call.
>>
>> Looks like a kernel ioctl issue...
>>
> 
> Hello,
> I investigated this. Looks like HOT_REMOVE_DRIVE ioctl almost always failed for
> raid with no raid personality. At some point it was allowed but it was blocked
> 6 years ago in c42a0e2675 (this id leads to merge commit, so giving title "md:
> fix NULL dereference of mddev->pers in remove_and_add_spares()").
> 
> And that explains why we have outdated comment in mdadm:
> 
> 		if (err && errno == ENODEV) {
> 			/* Old kernels rejected this if no personality
> 			 * is registered */
> 
> I'm working to make it fixed in mdadm (for kernels with this hang), I will
> remove ioctl call for external containers:
> https://github.com/md-raid-utilities/mdadm/pull/31
> 
> On HOT_REMOVE_DRIVE ioctl path, there is a wait for clearing MD_RECOVERY_NEEDED
> flag with timeout set to 5 seconds. When I disabled this for arrays
> with no personality- it fixes issue. However, I'm not sure if it is right fix. I
> would expect to not set MD_RECOVERY_NEEDED for arrays with no MD personality.
> Kuai and Song could you please advice?
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c0426a6d2fd1..bd1cedeb105b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7827,7 +7827,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t
> mode, return get_bitmap_file(mddev, argp);
>          }
> 
> -       if (cmd == HOT_REMOVE_DISK)
> +       if (cmd == HOT_REMOVE_DISK && mddev->pers)

This patch will work, however, I'm afraid this can't fix the problem
thoroughly, because this is called without 'reconfig_mutex', and
mddev->pers can be set later before hot_remove_disk().

After taking a look at the commit 90f5f7ad4f38, which introducing the
waiting, was trying to wait for a failed device to be removed by
md_check_recovery().  However, this doen't make sense now, because
remove_and_add_spares() is called diretcly from hot_remove_disk(),
hence failed device can be removed directly from ioctl, without
md_check_recovery().

The only thining to prevent a failed device to be removed from array
wound be MD_RECOVERY_RUNNING, however, we can't wait for this falg to be
cleared, hence I'll suggest to revert this patch.

Thanks,
Kuai

>                  /* need to ensure recovery thread has run */
>                  wait_event_interruptible_timeout(mddev->sb_wait,
>                                                   !test_bit(MD_RECOVERY_NEEDED,
> 
> 
> Thanks,
> Mariusz
> 
> .
> 

