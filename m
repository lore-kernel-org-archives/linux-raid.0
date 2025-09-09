Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B6721B9F6
	for <linux-raid@vger.kernel.org>; Tue,  9 Sep 2025 01:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757379612; cv=none; b=q+uoxhQh/tKARf1DB3aujDU4lQ1/I+kJy1JcVfpwSwGAD7E8yU+2+6nJw2oAjgDAob/t8Sl83mgENiVFwFPsJxNjnuqjCJB9HteZSBTAKmj/Ihze8EVESnzTWUOIhiXI9nU7QMITiQtXPlbdV6vNgmfn4H1nu8Qo7vr11okZW2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757379612; c=relaxed/simple;
	bh=FgDckqrQSLAzhl8Iow40sXTxdpPEqJ919FNiqyO7t/E=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=oRIH2tVgYwfkL11f2Fm0XhWMf5ZT6852sCUtP/5DVOVoRGJBRA9kQT5F3XuJ9EKlTSFfM49/NaL42164AMb16msbujs5Q0EihTV6x0EaLwkrpDwsWGZy+KNpQSVDmykn7D0n1wnpqyH+BXlp1W9Tl6I4JkWMqBHgtwKEpwc4c0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cLQTf0NvvzKHMf7
	for <linux-raid@vger.kernel.org>; Tue,  9 Sep 2025 09:00:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3621F1A2207
	for <linux-raid@vger.kernel.org>; Tue,  9 Sep 2025 09:00:06 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY0UfL9opEV8Bw--.17929S3;
	Tue, 09 Sep 2025 09:00:06 +0800 (CST)
Subject: Re: [PATCH] md: Fix recovery hang when sync_action is set to frozen
To: Meir Elisha <meir.elisha@volumez.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250908140806.153159-1-meir.elisha@volumez.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <59772acf-a9e5-7aa0-80fe-62f0476f22b5@huaweicloud.com>
Date: Tue, 9 Sep 2025 09:00:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250908140806.153159-1-meir.elisha@volumez.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY0UfL9opEV8Bw--.17929S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ury3CrWfXF17GF4Dury5CFg_yoW8ZFW8pa
	93AFn0kr18AFWavFZrJa45ZFWrZr10yFW7GrW3Ww4fZrn8Kw4UGa4UuF1UXryDta4vva1x
	t340qry3XF1UGw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/09/08 22:08, Meir Elisha Ð´µÀ:
> When a RAID array is recovering and sync_action is set to "frozen",
> the recovery process hangs indefinitely. This occurs because
> wait_event() calls in md_do_sync() were missing the MD_RECOVERY_INTR
> check.
> 
> Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
> ---
>   drivers/md/md.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1de550108756..1b14beef87fc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9475,7 +9475,8 @@ void md_do_sync(struct md_thread *thread)
>   			    )) {
>   			/* time to update curr_resync_completed */
>   			wait_event(mddev->recovery_wait,
> -				   atomic_read(&mddev->recovery_active) == 0);
> +				   atomic_read(&mddev->recovery_active) == 0 ||
> +				   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>   			mddev->curr_resync_completed = j;
>   			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
>   			    j > mddev->resync_offset)
> @@ -9581,7 +9582,8 @@ void md_do_sync(struct md_thread *thread)
>   				 * The faster the devices, the less we wait.
>   				 */
>   				wait_event(mddev->recovery_wait,
> -					   !atomic_read(&mddev->recovery_active));
> +					   !atomic_read(&mddev->recovery_active) ||
> +					   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>   			}
>   		}
>   	}
> @@ -9592,7 +9594,8 @@ void md_do_sync(struct md_thread *thread)
>   	 * this also signals 'finished resyncing' to md_stop
>   	 */
>   	blk_finish_plug(&plug);
> -	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
> +	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active) ||
> +		   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>   
>   	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>   	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
> 

This patch doesn't make sense, recovery_active should be zero when all
resync IO are done. MD_RECOVERY_INTR just tell sycn_thread to stop
issuing new sync IO.

Thanks,
Kuai

