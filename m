Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0344F256C83;
	Thu, 11 Sep 2025 06:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757571026; cv=none; b=otNk0V9Ej9cxgS9FEg2vwOHYkFhDDCu+AfOeYOgEWfNb7J7AZbnrTU7sqxnh1gJwNSqCG8KR9tn2Blguxr8QtoVsvAh0TJdP5UPi9y57d0DxPnPd20I5uzo86TWoIDTxcgR5+VdrV6rrdfsvY0MpGKA4AKXNy8OUWtq9Zn6XUrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757571026; c=relaxed/simple;
	bh=96tYRv/WqcuuqiaQcYtdx9NTcTMadTXSNn/TNA94QIw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qDXt7lw/cVyAKzxxnfXH+j1mPM9trWdO0k/Pgx4qfrFnPUyycY3jci3S82RTLHsanfF+KorfAsqmIDJKSGw/xnCNTKkoViArsPQEoPoIYyxvTJyD8lTXpb/BYTlOpq989Su4Op7ulTHic3RWKj0vyk66ITVd1NhznwpgvcZhlEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cMnGj74CfzYQvXQ;
	Thu, 11 Sep 2025 14:10:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7E0791A0ADA;
	Thu, 11 Sep 2025 14:10:20 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3QY7KZ8Jo0kB5CA--.14407S3;
	Thu, 11 Sep 2025 14:10:20 +0800 (CST)
Subject: Re: [PATCH] md/raid1: skip recovery of already synced areas
To: linan666@huaweicloud.com, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250910082544.271923-1-linan666@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <eaae71c1-8723-8f49-5bd8-01a1e67152be@huaweicloud.com>
Date: Thu, 11 Sep 2025 14:10:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250910082544.271923-1-linan666@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3QY7KZ8Jo0kB5CA--.14407S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tF13Jw48Wr1fAFyDur45KFg_yoW8tFWfpa
	13Ja4a939rJa13Aa4kXryUGa4Fy34fGrW7Gr13W343X3s8GFyDWF4kXFy5WFyDJF13Za1j
	q3ykXrW5uFyYgFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUBVbkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/09/10 16:25, linan666@huaweicloud.com Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> When a new disk is added during running recovery, the kernel may
> restart recovery from the beginning of the device and submit write
> io to ranges that have already been synchronized.
> 
> Reproduce:
>    mdadm -CR /dev/md0 -l1 -n3 /dev/sda missing missing
>    mdadm --add /dev/md0 /dev/sdb
>    sleep 10
>    cat /proc/mdstat	# partially synchronized
>    mdadm --add /dev/md0 /dev/sdc
>    cat /proc/mdstat	# start from 0
>    iostat 1 sdb sdc	# sdb has io, too
> 
> If 'rdev->recovery_offset' is ahead of the current recovery sector,
> read from that device instead of issuing a write. It prevents
> unnecessary writes while still preserving the chance to back up data
> if it is the last copy.
> 
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/raid1.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 3e422854cafb..ac5a9b73157a 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2894,7 +2894,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
>   		    test_bit(Faulty, &rdev->flags)) {
>   			if (i < conf->raid_disks)
>   				still_degraded = true;
> -		} else if (!test_bit(In_sync, &rdev->flags)) {
> +		} else if (!test_bit(In_sync, &rdev->flags) &&
> +			   rdev->recovery_offset <= sector_nr) {
>   			bio->bi_opf = REQ_OP_WRITE;
>   			bio->bi_end_io = end_sync_write;
>   			write_targets ++;
> @@ -2903,6 +2904,9 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
>   			sector_t first_bad = MaxSector;
>   			sector_t bad_sectors;
>   
> +			if (!test_bit(In_sync, &rdev->flags))
> +				good_sectors = min(rdev->recovery_offset - sector_nr,
> +						   (u64)good_sectors);
>   			if (is_badblock(rdev, sector_nr, good_sectors,
>   					&first_bad, &bad_sectors)) {
>   				if (first_bad > sector_nr)
> 

This patch looks correct, however, I took a long time to go through all
the details, and there is still the same problem in the case new disk is
added during resync.

Perhaps this is a good time to cleanup raid1_sync_request() now, just
don't mess resync and recover together in the same code path with lots
of special handling.

Thanks,
Kuai

