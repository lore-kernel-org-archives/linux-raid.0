Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDE31E231D
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 06:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746599301; cv=none; b=r/OJPcZhJ7rbv8s1RDEWNXz1wY14d4RMwQ4MwKn/o1FneULbNPmuCS+SwrDBh9Wwxvz9YWjFeW5fCt8SMb5XVlUX3je6pJC60r8Or+dloLLYSWZk+dioD3Lk8fUV4XzOB4qsBDTyKnt4pwrB0Ofm/7HUtqI07wSxqxQQTDg6HYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746599301; c=relaxed/simple;
	bh=zZIYP3RxNwblF2HeVXBuFCSk88UBZllqzbMKfHYdqfU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Xv/pNR77PIi4W6vW2ySx4K1n72Sb9xPb5cO4Yh93VQjpf5gSZRisKsgucIZtkEW4pj7uJoXXcKl2DlHp553+5rEsmhEiqybFQlR1bzEcgqtGdZ/IIxfnABZ2dedeVvncnWZlrvunppbnqj6nvkcO4lgQGAUk3fQmIKxItmg+/dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4Zslh060tzzKHLxP
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 14:28:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 991EF1A143F
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 14:28:15 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB32l5+_Rpoq8i3Lg--.40959S3;
	Wed, 07 May 2025 14:28:15 +0800 (CST)
Subject: Re: [PATCH 3/3] md: call del_gendisk in sync way
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai1@huaweicloud.com, ncroxon@redhat.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250507021415.14874-1-xni@redhat.com>
 <20250507021415.14874-4-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <46f9aee8-45e0-6a22-03b7-ad621835e4cf@huaweicloud.com>
Date: Wed, 7 May 2025 14:28:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250507021415.14874-4-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB32l5+_Rpoq8i3Lg--.40959S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw13JFW7Kw4UXrWxuF1xXwb_yoW8Kr18pa
	yqqFy3urWkt39FqrsrGa1kua4Yvw1ktrWkKryfGw4Sv3W2qr1UWF15Wr4qqFyjga93Cr4Y
	qa1UtFs8Xw1xGrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUG0PhUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/07 10:14, Xiao Ni Ð´µÀ:
> Now del_gendisk and put_disk are called asynchronously in workqueue work.
> The asynchronous way also has a problem that the device node can still
> exist after mdadm --stop command returns in a short window. So udev rule
> can open this device node and create the struct mddev in kernel again.
> 
> So put del_gendisk in ioctl path and still leave put_disk in
> md_kobj_release to avoid uaf.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c226747be9e3..a82778f6c31f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5718,19 +5718,30 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
>   	struct md_sysfs_entry *entry = container_of(attr, struct md_sysfs_entry, attr);
>   	struct mddev *mddev = container_of(kobj, struct mddev, kobj);
>   	ssize_t rv;
> +	struct kernfs_node *kn = NULL;
>   
>   	if (!entry->store)
>   		return -EIO;
>   	if (!capable(CAP_SYS_ADMIN))
>   		return -EACCES;
> +
> +	if (entry->store == array_state_store && cmd_match(page, "clear"))
> +		kn = sysfs_break_active_protection(kobj, attr);
> +
>   	spin_lock(&all_mddevs_lock);
>   	if (!mddev_get(mddev)) {
> +		if (kn)
> +			sysfs_unbreak_active_protection(kn);
>   		spin_unlock(&all_mddevs_lock);
>   		return -EBUSY;
>   	}
>   	spin_unlock(&all_mddevs_lock);
>   	rv = entry->store(mddev, page, length);
>   	mddev_put(mddev);
> +
> +	if (kn)
> +		sysfs_unbreak_active_protection(kn);
> +
>   	return rv;
>   }
>   
> @@ -5743,7 +5754,6 @@ static void md_kobj_release(struct kobject *ko)
>   	if (mddev->sysfs_level)
>   		sysfs_put(mddev->sysfs_level);
>   
> -	del_gendisk(mddev->gendisk);
>   	put_disk(mddev->gendisk);
>   }
>   
> @@ -6585,8 +6595,8 @@ static int do_md_stop(struct mddev *mddev, int mode)
>   		mddev->bitmap_info.offset = 0;
>   
>   		export_array(mddev);
> -
>   		md_clean(mddev);
> +		del_gendisk(mddev->gendisk);
>   	}

Refer to the comments in mddev_unlock, there are some special hacks, to
delay removing md_redundancy_group until releasing reconfig_mutex, and
looks like del_gendisk here will break that.

Thanks,
Kuai

>   	md_new_event();
>   	sysfs_notify_dirent_safe(mddev->sysfs_state);
> 

