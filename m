Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECE42AE8C
	for <linux-raid@vger.kernel.org>; Tue,  8 Oct 2024 03:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728357651; cv=none; b=eiyoijpYTCroVMUwpURdsui/Pr03uwgnPGe1KSq+GEd7bhHnkEqTwSk2kSSDY8RFJ2MRbuuZaYMlqNWprkIYpZbsK9QzkI3s2ftQ2BWoBAW5D8rOGrJYjkSr4HkfpaWZ18Z5OMIrIA4enSa5J21HGvQVYuKGR7+LISaY7Qhb2Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728357651; c=relaxed/simple;
	bh=f4wBWZqiOwgNgxo8ZYMhH3kK24VU6bbbBMyvkkPCxSM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=eT8hUQL4BWOsqFneNJrcjVmKJw8cbAyUIJfIUBjXhxIujWvItsRfu09STow54n6M9x8nfs5aZsF1jEYFPofV1YhndPo4pi2C3PKyyh+cLrrTjSCi/UAldSebj1HABKYg+oXv1diTTE/vX4jRB2ugLTOeFKKjhsb8FRQwDIJn+EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XN1Vm13z8z4f3jk3
	for <linux-raid@vger.kernel.org>; Tue,  8 Oct 2024 11:20:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D6AD41A08FC
	for <linux-raid@vger.kernel.org>; Tue,  8 Oct 2024 11:20:43 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAXTMgJpQRnjt3wDQ--.32583S3;
	Tue, 08 Oct 2024 11:20:42 +0800 (CST)
Subject: Re: [PATCH] md: raid1 mixed RW performance improvement
To: Paul Luse <paulluselinux@gmail.com>, linux-raid@vger.kernel.org
Cc: paul.e.luse@intel.com, "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <20241004140514.20209-1-paulluselinux@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <117cb186-8ec0-2fad-7852-10a0c0406181@huaweicloud.com>
Date: Tue, 8 Oct 2024 11:20:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241004140514.20209-1-paulluselinux@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXTMgJpQRnjt3wDQ--.32583S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtw13ury5XF4xWr17Wr45Wrg_yoW3Jryrpa
	y0q3WrAw4UtryUZrn0ka1kGFySgw1rKFWIkFs7A34SvwsIqF98tFy8GF1Yvr18Cr9xGw17
	Xr15GrW5Cw10yFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrNtxDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/10/04 22:05, Paul Luse Ð´µÀ:
> While working on read_balance() earlier this year I realized that
> for nonrot media the primary disk selection criteria for RAID1 reads
> was to choose the disk with the least pending IO. At the same time it
> was noticed that rarely did this work out to a 50/50 split between
> the disks.  Initially I looked at a round-robin scheme however this
> proved to be too complex when taking into account concurrency.
> 
> That led to this patch.  Writes typically take longer than
> reads for nonrot media so choosing the disk with the least pending
> IO without knowing the mix of outstanding IO, reads vs writes, is not
> optimal.
> 
> This patch takes a very simple implantation approach to place more
> weight on writes vs reads when selecting a disk to read from.  Based
> on empirical testing of multiple drive vendors NVMe and SATA (some
> data included below) I found that weighing writes by 1.25x and rounding
> gave the best overall performance improvement.  The boost varies by
> drive, as do most drive dependent performance optimizations.  Kioxia
> gets the least benefit while Samsung gets the most.  I also confirmed
> no impact on pure read cases (or writes of course).  I left the total
> pending counter in place and simply added one specific to reads, there
> was no reason to count them separately especially given the additional
> complexity in the write path for tracking pending IO.
> 
> The fewer writes that are outstanding the less positive impact this
> patch has.  So the math works out well.  Here are the non-weighted
> and weighted values for looking at outstanding writes.  The first column
> is the unweighted value and the second is what is used with this patch.
> Until there are at least 4 pending, no change.  The more pending, the
> more the value is weighted which is perfect for how the drives behave.
> 
> 1 1
> 2 2
> 3 3
> 4 5
> 5 6
> 6 7
> 7 8
> 8 10
> 9 11
> 10 12
> 11 13
> 12 15
> 13 16
> 14 17
> 15 18
> 16 20
> 
> Below is performance data for the patch, 3 different NVMe drives
> and one SATA.
> 
> WD SATA: https://photos.app.goo.gl/1smadpDEzgLaa5G48
> WD NVMe: https://photos.app.goo.gl/YkTTcYfU8Yc8XWA58
> SamSung NVMe: https://photos.app.goo.gl/F6MvEfmbGtRyPUFz6
> Kioxia NVMe: https://photos.app.goo.gl/BAEhi8hUwsdTyj9y5
> 
> Signed-off-by: Paul Luse <paulluselinux@gmail.com>
> ---
>   drivers/md/md.h    |  9 +++++++++
>   drivers/md/raid1.c | 34 +++++++++++++++++++++++++---------
>   2 files changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 5d2e6bd58e4d..1a1040ec3c4a 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -162,6 +162,9 @@ struct md_rdev {
>   					 */
>   	};
>   
> +	atomic_t nr_reads_pending;      /* tracks only mirrored reads pending
> +					 * to support a performance optimization
> +					 */
>   	atomic_t	nr_pending;	/* number of pending requests.
>   					 * only maintained for arrays that
>   					 * support hot removal
> @@ -923,6 +926,12 @@ static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
>   	}
>   }
>   
> +static inline void mirror_rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
> +{
> +	atomic_dec(&rdev->nr_reads_pending);
> +	rdev_dec_pending(rdev, mddev);

I know that this will cause more code changes, will it make more sense
just to split writes and reads? With following apis:

rdev_inc_pending(rdev, rw);
rdev_dec_pending(rdev, rw);
rdev_pending(rdev);
rdev_rw_pending(rdev, rw);

Thanks,
Kuai

> +}
> +
>   extern const struct md_cluster_operations *md_cluster_ops;
>   static inline int mddev_is_clustered(struct mddev *mddev)
>   {
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f55c8e67d059..5315b46d2cca 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -394,7 +394,7 @@ static void raid1_end_read_request(struct bio *bio)
>   
>   	if (uptodate) {
>   		raid_end_bio_io(r1_bio);
> -		rdev_dec_pending(rdev, conf->mddev);
> +		mirror_rdev_dec_pending(rdev, conf->mddev);
>   	} else {
>   		/*
>   		 * oops, read error:
> @@ -584,6 +584,7 @@ static void update_read_sectors(struct r1conf *conf, int disk,
>   	struct raid1_info *info = &conf->mirrors[disk];
>   
>   	atomic_inc(&info->rdev->nr_pending);
> +	atomic_inc(&info->rdev->nr_reads_pending);
>   	if (info->next_seq_sect != this_sector)
>   		info->seq_start = this_sector;
>   	info->next_seq_sect = this_sector + len;
> @@ -760,9 +761,11 @@ struct read_balance_ctl {
>   	int readable_disks;
>   };
>   
> +#define WRITE_WEIGHT 2
>   static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
>   {
>   	int disk;
> +	int nonrot = READ_ONCE(conf->nonrot_disks);
>   	struct read_balance_ctl ctl = {
>   		.closest_dist_disk      = -1,
>   		.closest_dist           = MaxSector,
> @@ -774,7 +777,7 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
>   	for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
>   		struct md_rdev *rdev;
>   		sector_t dist;
> -		unsigned int pending;
> +		unsigned int total_pending, reads_pending;
>   
>   		if (r1_bio->bios[disk] == IO_BLOCKED)
>   			continue;
> @@ -787,7 +790,21 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
>   		if (ctl.readable_disks++ == 1)
>   			set_bit(R1BIO_FailFast, &r1_bio->state);
>   
> -		pending = atomic_read(&rdev->nr_pending);
> +		total_pending = atomic_read(&rdev->nr_pending);
> +		if (nonrot) {
> +			/* for nonrot we weigh writes slightly heavier than
> +			 * reads when deciding disk based on pending IOs as
> +			 * writes typically take longer
> +			 */
> +			reads_pending = atomic_read(&rdev->nr_reads_pending);
> +			if (total_pending > reads_pending) {
> +				int writes;
> +
> +				writes = total_pending - reads_pending;
> +				writes += (writes >> WRITE_WEIGHT);
> +				total_pending = writes + reads_pending;
> +			}
> +		}
>   		dist = abs(r1_bio->sector - conf->mirrors[disk].head_position);
>   
>   		/* Don't change to another disk for sequential reads */
> @@ -799,7 +816,7 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
>   			 * Add 'pending' to avoid choosing this disk if
>   			 * there is other idle disk.
>   			 */
> -			pending++;
> +			total_pending++;
>   			/*
>   			 * If there is no other idle disk, this disk
>   			 * will be chosen.
> @@ -807,8 +824,8 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
>   			ctl.sequential_disk = disk;
>   		}
>   
> -		if (ctl.min_pending > pending) {
> -			ctl.min_pending = pending;
> +		if (ctl.min_pending > total_pending) {
> +			ctl.min_pending = total_pending;
>   			ctl.min_pending_disk = disk;
>   		}
>   
> @@ -831,8 +848,7 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
>   	 * disk is rotational, which might/might not be optimal for raids with
>   	 * mixed ratation/non-rotational disks depending on workload.
>   	 */
> -	if (ctl.min_pending_disk != -1 &&
> -	    (READ_ONCE(conf->nonrot_disks) || ctl.min_pending == 0))
> +	if (ctl.min_pending_disk != -1 && (nonrot || ctl.min_pending == 0))
>   		return ctl.min_pending_disk;
>   	else
>   		return ctl.closest_dist_disk;
> @@ -2622,7 +2638,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>   		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
>   	}
>   
> -	rdev_dec_pending(rdev, conf->mddev);
> +	mirror_rdev_dec_pending(rdev, conf->mddev);
>   	sector = r1_bio->sector;
>   	bio = r1_bio->master_bio;
>   
> 

