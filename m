Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A9E2FC031
	for <linux-raid@vger.kernel.org>; Mon, 29 Sep 2025 12:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759149891; cv=none; b=VnbjmYrbCP62IlaFWeABIHl9yhFCTsSQUwBkHsG/YoYhpSJsucMJTLTYGmZhOM58e+YXmcO4byvqFpB/SsFHh26iEUDTREsZZ0aQ+1Qp+FMglyJ9Ij47On8BvMXLDtKIYftIUgFB9B3xhAAg/50/GaFp5gNHLx3ML0S21SKf2yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759149891; c=relaxed/simple;
	bh=3jbK7iYUpEOCjoY/I37c0pBLiqI/mrFhLHHoMXzNf+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f1SqDHOHCOMwQHDmT98cuUIP8TiCDgGRqFuuz18KVU1uWDaWSW4sbB2jSft3AvgQ1MJY4XJKvbx2YzTzO2Nkyl+bkM4ZPWSKMk1+Qm1l/KDKW4EXNVlrNjCLr24ziXgut8ypTl2zi+HF87SvWPHZe+Um2vQSzb/I+oluzc2NZZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cb19960szzYQtwR
	for <linux-raid@vger.kernel.org>; Mon, 29 Sep 2025 20:44:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C4F291A1675
	for <linux-raid@vger.kernel.org>; Mon, 29 Sep 2025 20:44:45 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgA3+mE8f9poij7gBA--.27387S3;
	Mon, 29 Sep 2025 20:44:45 +0800 (CST)
Message-ID: <1613bd46-b757-6b4b-c891-bfb5184afbed@huaweicloud.com>
Date: Mon, 29 Sep 2025 20:44:44 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/1] md: delete mddev kobj before deleting gendisk kobj
To: Xiao Ni <xni@redhat.com>, yukuai1@huaweicloud.com
Cc: song@kernel.org, linux-raid@vger.kernel.org
References: <20250928012424.61370-1-xni@redhat.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250928012424.61370-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3+mE8f9poij7gBA--.27387S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww18JrWUCw1rKrWkKw1DAwb_yoW8ZFWrpr
	WrXFW5t3y5JrWakwnrW397WF15Zw1vyrykKFWak34Sva47Xr1DWF1rKFW0gF1DC393XF4j
	va1UXws3Jr1UKFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUb0PfJUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

Hi,

在 2025/9/28 9:24, Xiao Ni 写道:
> In sync del gendisk path, it deletes gendisk first and the directory
> /sys/block/md is removed. Then it releases mddev kobj in a delayed work.
> If we enable debug log in sysfs_remove_group, we can see the debug log
> 'sysfs group bitmap not found for kobject md'. It's the reason that the
> parent kobj has been deleted, so it can't find parent directory.
> 
> In creating path, it allocs gendisk first, then adds mddev kobj. So it
> should delete mddev kobj before deleting gendisk.
> 
> Before commit 9e59d609763f ("md: call del_gendisk in control path"), it
> releases mddev kobj first. If the kobj hasn't been deleted, it does clean
> job and deletes the kobj. Then it calls del_gendisk and releases gendisk

Looking at this part of the code, is this referring to:

kobject_cleanup
  if (kobj->state_in_sysfs)
   __kobject_del(kobj)

> kobj. So it doesn't need to call kobject_del to delete mddev kobj. After
> this patch, in sync del gendisk path, the sequence changes. So it needs
> to call kobject_del to delete mddev kobj.
> 
> After this patch, the sequence is:
> 1. kobject del mddev kobj
> 2. del_gendisk deletes gendisk kobj
> 3. mddev_delayed_delete releases mddev kobj
> 4. md_kobj_release releases gendisk kobj
> 
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4e033c26fdd4..07e48faa87e0 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -887,8 +887,10 @@ void mddev_unlock(struct mddev *mddev)
>   		 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
>   		 * doesn't need to check MD_DELETED when getting reconfig lock
>   		 */
> -		if (test_bit(MD_DELETED, &mddev->flags))
> +		if (test_bit(MD_DELETED, &mddev->flags)) {
> +			kobject_del(&mddev->kobj);
>   			del_gendisk(mddev->gendisk);
> +		}
>   	}
>   }
>   EXPORT_SYMBOL_GPL(mddev_unlock);

-- 
Thanks,
Nan

