Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89C81DE8A5;
	Wed,  5 Mar 2025 06:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741156627; cv=none; b=MaMSEg2PHoqhRgzfkkGpmJgxTEaZNHuewsiyDxpfzoZoVq49IhjotXqPqI18sLAGXx+uDEZxHibH2YUXJc9g2Q/H1ys7bftGdN9c/ufU3CyJDw1QwwUaLbiyXaM0149NVDS0vOLxLUN8LxCbrHwMksoPKQTR2tgxgaCEQpmEjhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741156627; c=relaxed/simple;
	bh=JkVUBrWE/Pwx8kxyzAcLzgCYN4tFTy1Y16PJyFVSCkY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=a7wQXX3mxaYf1XGXYh9puVCr80okCuAdr0IixSMVQZ1pQZdR/5GrZAuOk6yag7RDtiN87esS4FcjL0fpFXcFx98O9GflD3RoLYoPXcT8HXn+47xrS6Ae/tqz+n+0Ypf0WEySfWwEKyj3dbvCJgf4KjJFA5J2Era632ne7/Fb1Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z72rh4WYwz4f3lfr;
	Wed,  5 Mar 2025 14:36:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 345311A0DE4;
	Wed,  5 Mar 2025 14:37:00 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCH618K8cdnN5RfFg--.57392S3;
	Wed, 05 Mar 2025 14:37:00 +0800 (CST)
Subject: Re: [PATCH v3 3/3] md/raid5: check for overlapping bad blocks before
 starting reshape
To: Doug V Johnson <dougvj@dougvj.net>
Cc: Doug Johnson <dougvj@gmail.com>, Song Liu <song@kernel.org>,
 "open list:SOFTWARE RAID (Multiple Disks) SUPPORT"
 <linux-raid@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <9d878dea7b1afa2472f8f583fd116e31@dougvj.net>
 <20250224090209.2077-1-dougvj@dougvj.net>
 <20250224090209.2077-3-dougvj@dougvj.net>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a9119707-4fa1-58cb-377c-63df67f88957@huaweicloud.com>
Date: Wed, 5 Mar 2025 14:36:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250224090209.2077-3-dougvj@dougvj.net>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH618K8cdnN5RfFg--.57392S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Wr13ur15Jr4rCryrWF1Utrb_yoW7Wrykp3
	yDJ3ZIqrWjgr1fXa43Z3yj9r1Fk3s7GrWUJ3y7Ga4UuFWfK34fGFs3WryUXFyxGry3Xr10
	qay3CrZF9F97Ka7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwx
	hLUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/02/24 17:02, Doug V Johnson Ð´µÀ:
> In addition to halting a reshape in progress when we encounter bad
> blocks, we want to make sure that we do not even attempt a reshape if we
> know before hand that there are too many overlapping bad blocks and we
> would have to stall the reshape.
> 
> To do this, we add a new internal function array_has_badblock() which
> first checks to see if there are enough drives with bad blocks for the
> condition to occur and if there are proceeds to do a simple O(n^2) check
> for overlapping bad blocks. If more overlaps are found than can be
> corrected for, we return 1 for the presence of bad blocks, otherwise 0
> 
> This function is invoked in raid5_start_reshape() and if there are bad
> blocks present, returns -EIO which is reported to userspace.
> 
> It's possible for bad blocks to be discovered or put in the metadata
> after a reshape has started, so we want to leave in place the
> functionality to detect and halt a reshape.
> 
> Signed-off-by: Doug V Johnson <dougvj@dougvj.net>
> ---
>   drivers/md/raid5.c | 94 ++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 94 insertions(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8b23109d6f37..4b907a674dd1 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8451,6 +8451,94 @@ static int check_reshape(struct mddev *mddev)
>   				     + mddev->delta_disks));
>   }
>   
> +static int array_has_badblock(struct r5conf *conf)
> +{
> +	/* Searches for overlapping bad blocks on devices that would result
> +	 * in an unreadable condition
> +	 */
> +	int i, j;
> +	/* First see if we even have bad blocks on enough drives to have a
> +	 * bad read condition
> +	 */
> +	int num_badblock_devs = 0;
> +
> +	for (i = 0; i < conf->raid_disks; i++) {
> +		if (rdev_has_badblock(conf->disks[i].rdev,
> +				      0, conf->disks[i].rdev->sectors))
		if (rdev->badblocks.count)

> +			num_badblock_devs++;
> +	}
> +	if (num_badblock_devs <= conf->max_degraded) {
> +		/* There are not enough devices with bad blocks to pose any
> +		 * read problem
> +		 */
> +		return 0;
> +	}
> +	pr_debug("%s: running overlapping bad block check",
> +		 mdname(conf->mddev));
> +	/* Do a more sophisticated check for overlapping regions */
> +	for (i = 0; i < conf->raid_disks; i++) {
> +		sector_t first_bad;
> +		int bad_sectors;
> +		sector_t next_check_s = 0;
> +		int next_check_sectors = conf->disks[i].rdev->sectors;
> +
> +		pr_debug("%s: badblock check: %i (s: %lu, sec: %i)",
> +			 mdname(conf->mddev), i,
> +			 (unsigned long)next_check_s, next_check_sectors);
> +		while (is_badblock(conf->disks[i].rdev,
> +				   next_check_s, next_check_sectors,
> +				   &first_bad,
> +				   &bad_sectors) != 0) {
> +			/* Align bad blocks to the size of our stripe */
> +			sector_t aligned_first_bad = first_bad &
> +				~((sector_t)RAID5_STRIPE_SECTORS(conf) - 1);
> +			int aligned_bad_sectors =
> +				max_t(int, RAID5_STRIPE_SECTORS(conf),
> +				      bad_sectors);
> +			int this_num_bad = 1;
For example, if first_bad is 0, bad_sectors is 512 in rdev0

> +
> +			pr_debug("%s: found blocks %i %lu -> %i",
> +				 mdname(conf->mddev), i,
> +				 (unsigned long)aligned_first_bad,
> +				 aligned_bad_sectors);
> +			for (j = 0; j < conf->raid_disks; j++) {
> +				sector_t this_first_bad;
> +				int this_bad_sectors;
> +
> +				if (j == i)
> +					continue;
> +				if (is_badblock(conf->disks[j].rdev,
> +						aligned_first_bad,
> +						aligned_bad_sectors,
> +						&this_first_bad,
> +						&this_bad_sectors)) {
And rdev1 has badblocks 0+256, rdev2 has badblocks 256+256.

If this array is a raid6 with max_degraded=2, then it's fine.

Perhaps a pseudocode loop like following?

  sector_t offset = 0;
  while (offset < dev_sectors) {
          len = dev_sectors - offset;
          bad_disks = 0;
          for (i = 0; i < conf->raid_disks; ++i) {
                  if (is_badblock(rdev, offset, len, &first_bad, 
&bad_sectors)) {
                          if (first_bad <= offset) {
                                  len = min(len, first_bad + bad_sectors 
  offset);
                                  bad_disks++;
                          } else {
                                  len = min(len, first_bad - offset);
                          }
                  }
          }

          if (bad_disks > max_degraded)
                  return false;

          offset += len;
  }

  return true;

Thanks,
Kuai

> +					this_num_bad++;
> +					pr_debug("md/raid:%s: bad block overlap dev %i: %lu %i",
> +						 mdname(conf->mddev), j,
> +						 (unsigned long)this_first_bad,
> +						 this_bad_sectors);
> +				}
> +			}
> +			if (this_num_bad > conf->max_degraded) {
> +				pr_debug("md/raid:%s: %i drives with unreadable sector(s) around %lu %i due to bad block list",
> +					 mdname(conf->mddev),
> +					 this_num_bad,
> +					 (unsigned long)first_bad,
> +					 bad_sectors);
> +				return 1;
> +			}
> +			next_check_s = first_bad + bad_sectors;
> +			next_check_sectors =
> +				next_check_sectors - (first_bad + bad_sectors);
> +			pr_debug("%s: badblock check: %i (s: %lu, sec: %i)",
> +				 mdname(conf->mddev), i,
> +				 (unsigned long)next_check_s,
> +				 next_check_sectors);
> +		}
> +	}
> +	return 0;
> +}
> +
>   static int raid5_start_reshape(struct mddev *mddev)
>   {
>   	struct r5conf *conf = mddev->private;
> @@ -8498,6 +8586,12 @@ static int raid5_start_reshape(struct mddev *mddev)
>   		return -EINVAL;
>   	}
>   
> +	if (array_has_badblock(conf)) {
> +		pr_warn("md/raid:%s: reshape not possible due to bad block list",
> +			mdname(mddev));
> +		return -EIO;
> +	}
> +
>   	atomic_set(&conf->reshape_stripes, 0);
>   	spin_lock_irq(&conf->device_lock);
>   	write_seqcount_begin(&conf->gen_lock);
> 

