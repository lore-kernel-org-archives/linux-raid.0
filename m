Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047171531F9
	for <linux-raid@vger.kernel.org>; Fri, 30 Aug 2024 07:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725003427; cv=none; b=uheI/WqJR29LzCn0j0AOT3EBnIUFhB9qhssaGhgEdGLovnqrq/SBPtsfyiSPXKyxxL1PkFkN98gYu2EMhtmTxBaKlgK7Dy7pJCO0saEvm6rmAmeLQaKD1Dhr0ghB18QX+cNZvuQt9ZQHAZl8yNoZhJi/FdxTd/GJSO1VsyaKB90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725003427; c=relaxed/simple;
	bh=2fGNwf2EbJk0TpvBfY9EIrnWiYn/Ru8Krj2Eq0d9nFU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ApT9GTJs3+D+uRqXqStV6vk9PTEw4qGFyYiXS6fVVNAJVWVx1dASYs3NYHsAonOO0UFLZ2pRcqDlqYU+iipsBjj4xv4EyqR+4U5S186a6CvN5ABZENl+DlY3wLDn6Bx7rBB1XJfjxTxsGv/0goWjzrTocXHzwgbPFzGxPdt97jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Ww92Q3bxlz4f3jMP
	for <linux-raid@vger.kernel.org>; Fri, 30 Aug 2024 15:36:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 360421A150F
	for <linux-raid@vger.kernel.org>; Fri, 30 Aug 2024 15:37:01 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB3n4WZdtFmoZd_DA--.50187S3;
	Fri, 30 Aug 2024 15:36:59 +0800 (CST)
Subject: Re: [PATCH 1/1] [PATCH V2 md-6.12 1/1] md: add new_level sysfs
 interface
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240829100133.74242-1-xni@redhat.com>
 <cafa231e-8ad8-05d2-80c0-f90c1b509bd1@huaweicloud.com>
 <CALTww2-dV0WTHfZANoXJro-Vx19WeA2m-NLFm1F0bCzd=jC3oQ@mail.gmail.com>
 <193d4bb3-3738-710e-7763-7bdc812a910f@huaweicloud.com>
 <CALTww2_D3A9r0ZRXfMYBQnHMyuYua_ynaHg=CTyVbEtRCZ84Ow@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4e4a2d04-a986-ef45-1452-59090580a1f8@huaweicloud.com>
Date: Fri, 30 Aug 2024 15:36:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww2_D3A9r0ZRXfMYBQnHMyuYua_ynaHg=CTyVbEtRCZ84Ow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3n4WZdtFmoZd_DA--.50187S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWxCry5Gw15try3ZF4ktFb_yoWrKF1rpa
	y5tF15Jr4DJry7JrnFqw1vkF9Ikw18Jry5Z3srJw17Awn0qF1xKw4rJrs8CFy8Wry5Ar42
	vr4UGFyfW3WrKFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/08/29 21:48, Xiao Ni 写道:
> On Thu, Aug 29, 2024 at 9:34 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2024/08/29 21:13, Xiao Ni 写道:
>>> On Thu, Aug 29, 2024 at 8:24 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>>
>>>> Hi,
>>>>
>>>> 在 2024/08/29 18:01, Xiao Ni 写道:
>>>>> This interface is used to update new level during reshape progress.
>>>>> Now it doesn't update new level during reshape. So it can't know the
>>>>> new level when systemd service mdadm-grow-continue runs. And it can't
>>>>> finally change to new level.
>>>>
>>> Hi Kuai
>>>
>>>> I'm not sure why updaing new level during reshape. Will this corrupt
>>>> data in the array completely?
>>>
>>> There is no data corruption.
>>>
>>>
>>>>>
>>>>> mdadm -CR /dev/md0 -l6 -n4 /dev/loop[0-3]
>>>>> mdadm --wait /dev/md0
>>>>> mdadm /dev/md0 --grow -l5 --backup=backup
>>>>> cat /proc/mdstat
>>>>> Personalities : [raid6] [raid5] [raid4] [raid0] [raid1] [raid10]
>>>>> md0 : active raid6 loop3[3] loop2[2] loop1[1] loop0[0]
>>>>
>>>> The problem is that level is still 6 after mddev --grow -l5? I don't
>>>> understand yet why this is related to update new level during reshape.
>>>> :)
>>>
>>> mdadm --grow command returns once reshape starts when specifying
>>> backup file. And it needs mdadm-grow-continue service to monitor the
>>> reshape progress. It doesn't record the new level when running `mdadm
>>> --grow`. So mdadm-grow-continue doesn't know the new level and it
>>> can't change to new level after reshape finishes. This needs userspace
>>> patch to work together.
>>> https://www.spinics.net/lists/raid/msg78081.html
>>
>> Hi,
>>
>> Got it. Then I just wonder, what kind of content are stored in the
>> backup file, why don't store the 'new level' in it as well, after
>> reshape finishes, can mdadm use the level api to do this?
> 
> The backup file has a superblock too and the content is the data from
> the raid. The service monitors reshape progress and controls it. It
> copies the data from raid to backup file, and then it reshapes. Now we
> usually don't care about it because the data offset can change and it
> has free space. For situations where the data offset can't be changed,
> it needs to write the data to the region where it is read from. If
> there is a power down or something else, the backup file can avoid
> data corruption.
> 
> It should be right to update the new level in md during reshape. If
> not, the new level is wrong.

Thanks for the explanation, I still need to investigate more about
detals, I won't object to the new sysfs api, however, I'll suggest
consider this as the final choice.

Thanks,
Kuai
> 
> Best Regards
> Xiao
>>
>> Thanks,
>> Kuai
>>
>>>
>>> Best Regards
>>>
>>> Xiao
>>>>
>>>> Thanks,
>>>> Kuai
>>>>
>>>>>
>>>>> The case 07changelevels in mdadm can trigger this problem. Now it can't
>>>>> run successfully. This patch is used to fix this. There is also a
>>>>> userspace patch set that work together with this patch to fix this problem.
>>>>>
>>>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>>>> ---
>>>>> V2: add detail about test information
>>>>>     drivers/md/md.c | 29 +++++++++++++++++++++++++++++
>>>>>     1 file changed, 29 insertions(+)
>>>>>
>>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>>> index d3a837506a36..3c354e7a7825 100644
>>>>> --- a/drivers/md/md.c
>>>>> +++ b/drivers/md/md.c
>>>>> @@ -4141,6 +4141,34 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
>>>>>     static struct md_sysfs_entry md_level =
>>>>>     __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
>>>>>
>>>>> +static ssize_t
>>>>> +new_level_show(struct mddev *mddev, char *page)
>>>>> +{
>>>>> +     return sprintf(page, "%d\n", mddev->new_level);
>>>>> +}
>>>>> +
>>>>> +static ssize_t
>>>>> +new_level_store(struct mddev *mddev, const char *buf, size_t len)
>>>>> +{
>>>>> +     unsigned int n;
>>>>> +     int err;
>>>>> +
>>>>> +     err = kstrtouint(buf, 10, &n);
>>>>> +     if (err < 0)
>>>>> +             return err;
>>>>> +     err = mddev_lock(mddev);
>>>>> +     if (err)
>>>>> +             return err;
>>>>> +
>>>>> +     mddev->new_level = n;
>>>>> +     md_update_sb(mddev, 1);
>>>>> +
>>>>> +     mddev_unlock(mddev);
>>>>> +     return len;
>>>>> +}
>>>>> +static struct md_sysfs_entry md_new_level =
>>>>> +__ATTR(new_level, 0664, new_level_show, new_level_store);
>>>>> +
>>>>>     static ssize_t
>>>>>     layout_show(struct mddev *mddev, char *page)
>>>>>     {
>>>>> @@ -5666,6 +5694,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
>>>>>
>>>>>     static struct attribute *md_default_attrs[] = {
>>>>>         &md_level.attr,
>>>>> +     &md_new_level.attr,
>>>>>         &md_layout.attr,
>>>>>         &md_raid_disks.attr,
>>>>>         &md_uuid.attr,
>>>>>
>>>>
>>>
>>>
>>>
>>> .
>>>
>>
> 
> 
> .
> 

