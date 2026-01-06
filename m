Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AE232F747;
	Tue,  6 Jan 2026 13:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767705876; cv=none; b=Ik5tUW/EgxtuBkiBgr5qtRiQ0O/X6yV4L1981lBGhfOJRZSXOuXA5yXw5jW+xgUS0XR64lbCkTlxmMY+jjduq+rBcrt98Yy58qlZt/CDRp2+pNyoi2wBgUTfHy1S/fzlWdNs7Oheb6xal1fUvd5MY/EnPvpYT7+A6B4sB/e4yYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767705876; c=relaxed/simple;
	bh=Gb5vWKr4EIFFQ6MancJ54emzuGH/PvEpmJH6VcSNRY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nZZYWC9LY7OipaUt3f9a1pjJHQU0XK7J9ZY2s7x6cEhegjR4AjafkGTOER3xks0WieXw4r0BcJiNktylbxuugIHZhed8CrAVnf5CG8Q0PnTs0KLvXUD/aNc2VV/TrimmTvZLzVxiJD1ihha4ZYtqcdVOeFIuqITTJeSuonNdmdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dlsLS2HHdzYQv0h;
	Tue,  6 Jan 2026 21:23:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DA9F14056F;
	Tue,  6 Jan 2026 21:24:28 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAHZ_cKDV1pBPddCw--.5915S3;
	Tue, 06 Jan 2026 21:24:28 +0800 (CST)
Message-ID: <966113b2-3c5b-92e0-4c8d-12acb731b485@huaweicloud.com>
Date: Tue, 6 Jan 2026 21:24:26 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC PATCH 3/5] md: simplify sync action print in status_resync
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
 yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com, linan122@h-partners.com
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
 <20251231070952.1233903-4-zhengqixing@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251231070952.1233903-4-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHZ_cKDV1pBPddCw--.5915S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tr13GrWkJF43tF1ktF4DCFg_yoW8AF1UpF
	WSyF98ZrW8JFWft3y2y34UZFWrCr1UKry2yFy3u34rAFnagas5KFyq93WDWryDG3sYva1Y
	qa4kGF45CFWjkw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBSb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E
	8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82
	IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC2
	0s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMI
	IF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF
	0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87
	Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7OJ5DUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/12/31 15:09, Zheng Qixing 写道:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> No functional change, just code cleanup to make it easier to add new
> sync actions later.
> 
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   drivers/md/md.c | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 52e09a9a9288..9eeab5258189 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8684,6 +8684,8 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
>   	sector_t rt, curr_mark_cnt, resync_mark_cnt;
>   	int scale, recovery_active;
>   	unsigned int per_milli;
> +	enum sync_action action;
> +	const char *sync_action_name;
>   
>   	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
>   	    test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> @@ -8765,13 +8767,13 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
>   			seq_printf(seq, ".");
>   		seq_printf(seq, "] ");
>   	}
> -	seq_printf(seq, " %s =%3u.%u%% (%llu/%llu)",
> -		   (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)?
> -		    "reshape" :
> -		    (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)?
> -		     "check" :
> -		     (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ?
> -		      "resync" : "recovery"))),
> +
> +	action = md_sync_action(mddev);
> +	if (action == ACTION_RECOVER)
> +		sync_action_name = "recovery";

Why not use md_sync_action_name for ACTION_RECOVER?

> +	else
> +		sync_action_name = md_sync_action_name(action);
> +	seq_printf(seq, " %s =%3u.%u%% (%llu/%llu)", sync_action_name,
>   		   per_milli/10, per_milli % 10,
>   		   (unsigned long long) resync/2,
>   		   (unsigned long long) max_sectors/2);

-- 
Thanks,
Nan

