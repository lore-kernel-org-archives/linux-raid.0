Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1781D63D6
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 08:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730794472; cv=none; b=TrMvYZVhotq2yxtgdV+250kNM4BQrX447GR+u2MYe9szK8wiQsUFm87KCC9popxSMtc+fScCc4M7rZ8vlrPbx0fV98PpgtWxcILl5tc33nfeEbYVRucALgjhM/ftUfk2zSWcAH9zuKCutyXmHHU2vZpHgVoFWpooWcLGQx4hc/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730794472; c=relaxed/simple;
	bh=qpxfQ5DUwgO8bqMzYxoB2M3oHL3EAa0lNSOHKAakAsI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=h8QHv/rN6KgwckP3r5bmxL15G+wtewQhG1Rf8dYyWv7XHLjWmQdvZ4DZ+qKnpWXoo7pkV8HK8AaEk+a9UbN2Enm6wk2r7AsKnGOhE+ke/b1UzXq+Pw7dqCtCnGDJ0zNZVMJJ/K8KmeQsWn2ZMyYEqkKFGWIUCmf/vsG9SnEgHl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XjLhf5t98z4f3kK8
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 16:14:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A42781A0568
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 16:14:23 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB3U4ff0ylnF3SgAw--.58988S3;
	Tue, 05 Nov 2024 16:14:23 +0800 (CST)
Subject: Re: [PATCH RFC 1/1] md: Use pers->quiesce in mddev_suspend
To: Xiao Ni <xni@redhat.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20241105075733.66101-1-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e906cf48-1f2b-8d69-43f5-2a02bcd13346@huaweicloud.com>
Date: Tue, 5 Nov 2024 16:14:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241105075733.66101-1-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3U4ff0ylnF3SgAw--.58988S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw1UWry7uryxuw43Xr1rCrg_yoW8WFyDp3
	97t3Z8C34UtFyYk34UA34q934Yqw18KrZIy3y7u3sYywnxKws3W343Wan8XrsFkFySvw4Y
	va1rt348u3Wv9rDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWHqcUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/11/05 15:57, Xiao Ni Ð´µÀ:
> One customer reports a bug: raid5 is hung when changing thread cnt
> while resync is running. The stripes are all in conf->handle_list
> and new threads can't handle them.
> 
> Commit b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removes
> pers->quiesce from mddev_suspend/resume, then we can't guarantee sync
> requests finish in suspend operation. One personality knows itself the
> best. So pers->quiesce is a proper way to let personality quiesce.

Do you mean that other than normal IO, raid5 expects sync IO to be done
as well by mddev_suspend()? If so, we'd better add some comments as
well.

Thanks,
Kuai

> 
> Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 67108c397c5a..7409ecb2df68 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -482,6 +482,9 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
>   		return err;
>   	}
>   
> +	if (mddev->pers)
> +		mddev->pers->quiesce(mddev, 1);
> +
>   	/*
>   	 * For raid456, io might be waiting for reshape to make progress,
>   	 * allow new reshape to start while waiting for io to be done to
> @@ -514,6 +517,9 @@ static void __mddev_resume(struct mddev *mddev, bool recovery_needed)
>   	percpu_ref_resurrect(&mddev->active_io);
>   	wake_up(&mddev->sb_wait);
>   
> +	if (mddev->pers)
> +		mddev->pers->quiesce(mddev, 0);
> +
>   	if (recovery_needed)
>   		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	md_wakeup_thread(mddev->thread);
> 

