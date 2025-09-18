Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E3119E967;
	Thu, 18 Sep 2025 01:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758157236; cv=none; b=n37PTsEHEWUZ6O/AnPoZMkngAKefKgL+zOzKscetlVl3UIhgV0UJxspgAv/7UXGE2rPDtEFDRIMP1+EfP3piHTo4LDUDhkAIzcDorRY9D9XXTe0Ley0EuUdAj/T165BiZbLOl4l+PZvKvHeGplMywbSss+XgXJR2E5ERsyeerxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758157236; c=relaxed/simple;
	bh=M4qQwN81byNd7KyzgibXj2/hadZpXijceX5ZEfJ+5PI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UHoAT1dBCgTCZ95qhv43lhthk0acEGKdMTjrYMja5yUvNamcer1TgpiXxo9XB8cgjT6C+ghvE3eQMuXIppv8vgPvD5hkzZbeLh645UAmrid4TAZxp3djFV1f9YCfkd35++bt/itedMmYX+FOSihc+LK3ms8LCAR/Kr4Xy1jCR84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cRy402g9tzYQv7p;
	Thu, 18 Sep 2025 09:00:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 03D621A13C7;
	Thu, 18 Sep 2025 09:00:31 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCn8Y2tWctoND9+Cw--.3753S3;
	Thu, 18 Sep 2025 09:00:30 +0800 (CST)
Subject: Re: [PATCH v4 1/9] md/raid1,raid10: Set the LastDev flag when the
 configuration changes
To: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>,
 Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
 Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250915034210.8533-1-k@mgml.me>
 <20250915034210.8533-2-k@mgml.me>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b86ac820-7864-5ec0-fa19-2887d5b44c69@huaweicloud.com>
Date: Thu, 18 Sep 2025 09:00:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250915034210.8533-2-k@mgml.me>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCn8Y2tWctoND9+Cw--.3753S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GFy3KFWktr4rWw45Ary7KFg_yoWxtry3pa
	y8XFZIyF4DX3sxJanxXFWDuFWY9w4xt3y0kryxC3yxuasxKrW3GF4rGFyDXryDXFZ8Ar1r
	X3W5t3ykGFyjgFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2N
	tUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/09/15 11:42, Kenta Akagi Ð´µÀ:
> Currently, the LastDev flag is set on an rdev that failed a failfast
> metadata write and called md_error, but did not become Faulty. It is
> cleared when the metadata write retry succeeds. This has problems for
> the following reasons:
> 
> * Despite its name, the flag is only set during a metadata write window.
> * Unlike when LastDev and Failfast was introduced, md_error on the last
>    rdev of a RAID1/10 array now sets MD_BROKEN. Thus when LastDev is set,
>    the array is already unwritable.
> 
> A following commit will prevent failfast bios from breaking the array,
> which requires knowing from outside the personality whether an rdev is
> the last one. For that purpose, LastDev should be set on rdevs that must
> not be lost.
> 
> This commit ensures that LastDev is set on the indispensable rdev in a
> degraded RAID1/10 array.
> 
> Signed-off-by: Kenta Akagi <k@mgml.me>
> ---
>   drivers/md/md.c     |  4 +---
>   drivers/md/md.h     |  6 +++---
>   drivers/md/raid1.c  | 34 +++++++++++++++++++++++++++++++++-
>   drivers/md/raid10.c | 34 +++++++++++++++++++++++++++++++++-
>   4 files changed, 70 insertions(+), 8 deletions(-)
> 
After md_error() is serialized, why not check if rdev is the last rdev
from md_bio_failure_error() in patch 3 directly? I think it is cleaner
and code changes should be much less to add a new method like
pers->lastdev.

Thanks,
Kuai

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4e033c26fdd4..268410b66b83 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1007,10 +1007,8 @@ static void super_written(struct bio *bio)
>   		if (!test_bit(Faulty, &rdev->flags)
>   		    && (bio->bi_opf & MD_FAILFAST)) {
>   			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
> -			set_bit(LastDev, &rdev->flags);
>   		}
> -	} else
> -		clear_bit(LastDev, &rdev->flags);
> +	}
>   
>   	bio_put(bio);
>   
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 51af29a03079..ec598f9a8381 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -281,9 +281,9 @@ enum flag_bits {
>   				 * It is expects that no bad block log
>   				 * is present.
>   				 */
> -	LastDev,		/* Seems to be the last working dev as
> -				 * it didn't fail, so don't use FailFast
> -				 * any more for metadata
> +	LastDev,		/* This is the last working rdev.
> +				 * so don't use FailFast any more for
> +				 * metadata.
>   				 */
>   	CollisionCheck,		/*
>   				 * check if there is collision between raid1
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index bf44878ec640..32ad6b102ff7 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1733,6 +1733,33 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>   	seq_printf(seq, "]");
>   }
>   
> +/**
> + * update_lastdev - Set or clear LastDev flag for all rdevs in array
> + * @conf: pointer to r1conf
> + *
> + * Sets LastDev if the device is In_sync and cannot be lost for the array.
> + * Otherwise, clear it.
> + *
> + * Caller must hold ->device_lock.
> + */
> +static void update_lastdev(struct r1conf *conf)
> +{
> +	int i;
> +	int alive_disks = conf->raid_disks - conf->mddev->degraded;
> +
> +	for (i = 0; i < conf->raid_disks; i++) {
> +		struct md_rdev *rdev = conf->mirrors[i].rdev;
> +
> +		if (rdev) {
> +			if (test_bit(In_sync, &rdev->flags) &&
> +			    alive_disks == 1)
> +				set_bit(LastDev, &rdev->flags);
> +			else
> +				clear_bit(LastDev, &rdev->flags);
> +		}
> +	}
> +}
> +
>   /**
>    * raid1_error() - RAID1 error handler.
>    * @mddev: affected md device.
> @@ -1767,8 +1794,10 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>   		}
>   	}
>   	set_bit(Blocked, &rdev->flags);
> -	if (test_and_clear_bit(In_sync, &rdev->flags))
> +	if (test_and_clear_bit(In_sync, &rdev->flags)) {
>   		mddev->degraded++;
> +		update_lastdev(conf);
> +	}
>   	set_bit(Faulty, &rdev->flags);
>   	spin_unlock_irqrestore(&conf->device_lock, flags);
>   	/*
> @@ -1864,6 +1893,7 @@ static int raid1_spare_active(struct mddev *mddev)
>   		}
>   	}
>   	mddev->degraded -= count;
> +	update_lastdev(conf);
>   	spin_unlock_irqrestore(&conf->device_lock, flags);
>   
>   	print_conf(conf);
> @@ -3290,6 +3320,7 @@ static int raid1_run(struct mddev *mddev)
>   	rcu_assign_pointer(conf->thread, NULL);
>   	mddev->private = conf;
>   	set_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
> +	update_lastdev(conf);
>   
>   	md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
>   
> @@ -3427,6 +3458,7 @@ static int raid1_reshape(struct mddev *mddev)
>   
>   	spin_lock_irqsave(&conf->device_lock, flags);
>   	mddev->degraded += (raid_disks - conf->raid_disks);
> +	update_lastdev(conf);
>   	spin_unlock_irqrestore(&conf->device_lock, flags);
>   	conf->raid_disks = mddev->raid_disks = raid_disks;
>   	mddev->delta_disks = 0;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b60c30bfb6c7..dc4edd4689f8 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1983,6 +1983,33 @@ static int enough(struct r10conf *conf, int ignore)
>   		_enough(conf, 1, ignore);
>   }
>   
> +/**
> + * update_lastdev - Set or clear LastDev flag for all rdevs in array
> + * @conf: pointer to r10conf
> + *
> + * Sets LastDev if the device is In_sync and cannot be lost for the array.
> + * Otherwise, clear it.
> + *
> + * Caller must hold ->reconfig_mutex or ->device_lock.
> + */
> +static void update_lastdev(struct r10conf *conf)
> +{
> +	int i;
> +	int raid_disks = max(conf->geo.raid_disks, conf->prev.raid_disks);
> +
> +	for (i = 0; i < raid_disks; i++) {
> +		struct md_rdev *rdev = conf->mirrors[i].rdev;
> +
> +		if (rdev) {
> +			if (test_bit(In_sync, &rdev->flags) &&
> +			    !enough(conf, i))
> +				set_bit(LastDev, &rdev->flags);
> +			else
> +				clear_bit(LastDev, &rdev->flags);
> +		}
> +	}
> +}
> +
>   /**
>    * raid10_error() - RAID10 error handler.
>    * @mddev: affected md device.
> @@ -2013,8 +2040,10 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>   			return;
>   		}
>   	}
> -	if (test_and_clear_bit(In_sync, &rdev->flags))
> +	if (test_and_clear_bit(In_sync, &rdev->flags)) {
>   		mddev->degraded++;
> +		update_lastdev(conf);
> +	}
>   
>   	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>   	set_bit(Blocked, &rdev->flags);
> @@ -2102,6 +2131,7 @@ static int raid10_spare_active(struct mddev *mddev)
>   	}
>   	spin_lock_irqsave(&conf->device_lock, flags);
>   	mddev->degraded -= count;
> +	update_lastdev(conf);
>   	spin_unlock_irqrestore(&conf->device_lock, flags);
>   
>   	print_conf(conf);
> @@ -4159,6 +4189,7 @@ static int raid10_run(struct mddev *mddev)
>   	md_set_array_sectors(mddev, size);
>   	mddev->resync_max_sectors = size;
>   	set_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
> +	update_lastdev(conf);
>   
>   	if (md_integrity_register(mddev))
>   		goto out_free_conf;
> @@ -4567,6 +4598,7 @@ static int raid10_start_reshape(struct mddev *mddev)
>   	 */
>   	spin_lock_irq(&conf->device_lock);
>   	mddev->degraded = calc_degraded(conf);
> +	update_lastdev(conf);
>   	spin_unlock_irq(&conf->device_lock);
>   	mddev->raid_disks = conf->geo.raid_disks;
>   	mddev->reshape_position = conf->reshape_progress;
> 

