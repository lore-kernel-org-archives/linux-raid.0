Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DB8263C8E;
	Thu, 14 Aug 2025 07:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755155392; cv=none; b=SHNFxDvDuBHClzLplOtiUV9GYtIIuumbqpJuaeuy4YSxAJeeYRwFZkOeS/sMjn9NnAk9Id2EEZX7FqZOTJWyoa51KD6lzpPg1ZkuGPNdXD4kvhe13te6ewiNrCReh2lJwdS+6dP94DUqYSbMamhFuCfATWHBSipltiFfknt/KTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755155392; c=relaxed/simple;
	bh=2Lk5BSkpkJF6QE40B8XjsHaMYPOlGnnnWrCRtmcpeuc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qtuvF2gsYotV0oiwpAApZ9Eaf1nSY24P5CzOW8aUn4UPPivyUCzPyt7+9oljLvO3bmwPjgsDn2KfEz1TwYdjFpG2SPRLSPhQJbuHE5ah99wXR0W/6ub8/VbUrnWP9RR2/o3JhRaKHcBL4ZrkOEjaOZY+cyd3FqAUNtixp2z+7xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c2bwC59CkzYQv69;
	Thu, 14 Aug 2025 15:09:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 548921A0BC1;
	Thu, 14 Aug 2025 15:09:46 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgD3chO4i51oBUaIDg--.12039S3;
	Thu, 14 Aug 2025 15:09:46 +0800 (CST)
Message-ID: <0e94be00-769c-dab0-a14c-a49c137e054c@huaweicloud.com>
Date: Thu, 14 Aug 2025 15:09:44 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 1/2] md: add helper rdev_needs_recovery()
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
 yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 pmenzel@molgen.mpg.de, yi.zhang@huawei.com, yangerkun@huawei.com,
 houtao1@huawei.com, zhengqixing@huawei.com
References: <20250814015721.3764005-1-zhengqixing@huaweicloud.com>
 <20250814015721.3764005-2-zhengqixing@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250814015721.3764005-2-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3chO4i51oBUaIDg--.12039S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ary8Ar48XrWkXr18Kr15Jwb_yoW8tF15pa
	yIqFy3WryDZry7W3WDXFn8GFyFga18Kr4Ikry7Ga47Xa9xKr1qgay8Ca45X34DAFWFva1Y
	va45Xa1fuF1UWw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBSb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E
	8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82
	IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC2
	0s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMI
	IF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF
	0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87
	Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFDGOUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/8/14 9:57, Zheng Qixing 写道:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> Add a helper for checking if an rdev needs recovery.
> 
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac85ec73a409..4663e172864e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4835,6 +4835,14 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
>   static struct md_sysfs_entry md_metadata =
>   __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
>   
> +static bool rdev_needs_recovery(struct md_rdev *rdev, sector_t sectors)
> +{
> +	return !test_bit(Journal, &rdev->flags) &&
> +	       !test_bit(Faulty, &rdev->flags) &&
> +	       !test_bit(In_sync, &rdev->flags) &&
> +	       rdev->recovery_offset < sectors;
> +}
> +

Every caller is already checking 'rdev->raid_disk >= 0'. Should we move it
into rdev_needs_recovery()?

>   enum sync_action md_sync_action(struct mddev *mddev)
>   {
>   	unsigned long recovery = mddev->recovery;
> @@ -8969,10 +8977,7 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
>   		rcu_read_lock();
>   		rdev_for_each_rcu(rdev, mddev)
>   			if (rdev->raid_disk >= 0 &&
> -			    !test_bit(Journal, &rdev->flags) &&
> -			    !test_bit(Faulty, &rdev->flags) &&
> -			    !test_bit(In_sync, &rdev->flags) &&
> -			    rdev->recovery_offset < start)
> +			    rdev_needs_recovery(rdev, start))
>   				start = rdev->recovery_offset;
>   		rcu_read_unlock();
>   
> @@ -9333,10 +9338,7 @@ void md_do_sync(struct md_thread *thread)
>   				rdev_for_each_rcu(rdev, mddev)
>   					if (rdev->raid_disk >= 0 &&
>   					    mddev->delta_disks >= 0 &&
> -					    !test_bit(Journal, &rdev->flags) &&
> -					    !test_bit(Faulty, &rdev->flags) &&
> -					    !test_bit(In_sync, &rdev->flags) &&
> -					    rdev->recovery_offset < mddev->curr_resync)
> +					    rdev_needs_recovery(rdev, mddev->curr_resync))
>   						rdev->recovery_offset = mddev->curr_resync;
>   				rcu_read_unlock();
>   			}

-- 
Thanks,
Nan

