Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C18F1F417A
	for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 06:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745302909; cv=none; b=sJtbZjR6eRnigPUtHQ3QN4ImWQ43/ZqDTsdXGlpmxn9xPoyuC7Ql+1LuuYdQNMD24/3AGpj51WhOQvnKzNbtW/D2ZTKcBmjYvHAYW4BPtWuF5qBK0iDb2eHQSKlW47A4/nza8DrkTTL3eRDm4gOHVXdfLUUHlCcj3BQbqNS451w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745302909; c=relaxed/simple;
	bh=2O3TA9uqr560NsfKeg2brgXXISV0w4ma6PsU/cLCD/k=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HyUoVwhzCeXnZf8aZEYsx8dY7qUKuiI6xJDOANuiaT9guwzS5rlnmS4Uw5l3v1UhTOwBKIGOdc5eKEIVtWyix+TeovTyGF/0L23atNUBhp/rXHCH9K5HUsPlLZ81zdHoK/mWqiGVOUzQKqQFPc2Nk2+5YqfYq62SYQg8cFRPj4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZhXDt5qZYz4f3jYC
	for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 14:21:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B698C1A1A13
	for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 14:21:42 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXu190NQdoSWjYKA--.19663S3;
	Tue, 22 Apr 2025 14:21:42 +0800 (CST)
Subject: Re: [RFC PATCH 1/1] md: delete gendisk in ioctl path
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai1@huaweicloud.com, hch@lst.de,
 ming.lei@redhat.com, ncroxon@redhat.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250422032403.63057-1-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <707e58e8-12c4-ea92-393f-9fc707e097ac@huaweicloud.com>
Date: Tue, 22 Apr 2025 14:21:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250422032403.63057-1-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXu190NQdoSWjYKA--.19663S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuF17KF18Ar47Ww1DXrW7XFb_yoW5uF18pF
	W7GFWakr48Jw1jgay7Zw10grya9a1kXr4xJFZ7J34I93Z3Xr9rGas3Gr42gry2krWfZw18
	Xayjqr4kX3WkXrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUBVbkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/04/22 11:24, Xiao Ni Ð´µÀ:
> commit 777d0961ff95b ("fs: move the bdex_statx call to vfs_getattr_nosec")
> introduces a regression problem, like this:
> [ 1479.474440] INFO: task kdevtmpfs:506 blocked for more than 491 seconds.
> [ 1479.478569]  __wait_for_common+0x99/0x1c0
> [ 1479.478823]  ? __pfx_schedule_timeout+0x10/0x10
> [ 1479.479466]  __flush_workqueue+0x138/0x400
> [ 1479.479684]  md_alloc+0x21/0x370 [md_mod]
> [ 1479.479926]  md_probe+0x24/0x50 [md_mod]
> [ 1479.480150]  blk_probe_dev+0x62/0x90
> [ 1479.480368]  blk_request_module+0xf/0x70
> [ 1479.480604]  blkdev_get_no_open+0x5e/0xa0
> [ 1479.480809]  bdev_statx+0x1f/0xf0
> [ 1479.481364]  vfs_getattr_nosec+0x10a/0x120
> [ 1479.481602]  handle_remove+0x68/0x290
> [ 1479.481812]  ? __update_idle_core+0x23/0xb0
> [ 1479.482023]  devtmpfs_work_loop+0x10d/0x2a0
> [ 1479.482231]  ? __pfx_devtmpfsd+0x10/0x10
> [ 1479.482464]  devtmpfsd+0x2f/0x30
> 
> [ 1479.485397] INFO: task kworker/33:1:532 blocked for more than 491 seconds.
> [ 1479.535380]  __wait_for_common+0x99/0x1c0
> [ 1479.566876]  ? __pfx_schedule_timeout+0x10/0x10
> [ 1479.591156]  devtmpfs_submit_req+0x6e/0x90
> [ 1479.591389]  devtmpfs_delete_node+0x60/0x90
> [ 1479.591631]  ? process_sysctl_arg+0x270/0x2f0
> [ 1479.592256]  device_del+0x315/0x3d0
> [ 1479.592839]  ? mutex_lock+0xe/0x30
> [ 1479.593455]  del_gendisk+0x216/0x320
> [ 1479.593672]  md_kobj_release+0x34/0x40 [md_mod]
> [ 1479.594317]  kobject_cleanup+0x3a/0x130
> [ 1479.594562]  process_one_work+0x19d/0x3d0
> 
> Now del_gendisk and put_disk are called asynchronously in workqueue work.
> del_gendisk deletes device node by devtmpfs. devtmpfs tries to open this
> array again and it flush the workqueue at the bigging of open process. So
> a deadlock happens.
> 
> The asynchronous way also has a problem that the device node can still
> exist after mdadm --stop command returns in a short window. So udev rule
> can open this device node and create the struct mddev in kernel again.
> 
> So put del_gendisk in ioctl path and still leave put_disk in
> md_kobj_release to avoid uaf.
> 
> Fixes: 777d0961ff95 ("fs: move the bdex_statx call to vfs_getattr_nosec")
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9daa78c5fe33..c3f793296ccc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5746,7 +5746,6 @@ static void md_kobj_release(struct kobject *ko)
>   	if (mddev->sysfs_level)
>   		sysfs_put(mddev->sysfs_level);
>   
> -	del_gendisk(mddev->gendisk);
>   	put_disk(mddev->gendisk);
>   }
>   
> @@ -6597,6 +6596,8 @@ static int do_md_stop(struct mddev *mddev, int mode)
>   		md_clean(mddev);
>   		if (mddev->hold_active == UNTIL_STOP)
>   			mddev->hold_active = 0;
> +
> +		del_gendisk(mddev->gendisk);

I'm still trying to understand the problem here, however, this change
will break sysfs api md/array_state, do_md_stop will be called as well,
del_gendisk in this context will deadlock, because it will wait for all
sysfs writers, include itself, to be done.

Thanks,
Kuai

>   	}
>   	md_new_event();
>   	sysfs_notify_dirent_safe(mddev->sysfs_state);
> 

