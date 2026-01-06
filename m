Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEA031B808;
	Tue,  6 Jan 2026 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767707030; cv=none; b=qGg246uBxKXjO3QP0c5gOsCO225urojmPWXuEbMA0UnOseKCnGYufewtHVt7B6D3P+TlVCS24tT9GKRbTcY0/VJEiDmVAaTMWZIqFQTtYsVcux2+mmlqPX7wNr1ZH2mo2ylfRAhXg5QgIIAvoma9iTWtPvBoJFW6QKq8xkQJ//I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767707030; c=relaxed/simple;
	bh=tc+Mu9IzEpEsXmvdCeRG18qIzwwkQrtxTx+KT6OxaIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D8CCAgCiUIRW7FBdYHvdvj30SAM7De2JQK7X4HkLN9LcGO5kLEJRdPmeefcCHUFHJeG5HbZD14RUP2XZevKPZl3IJ+axXhApP8pV480q2g7gDdUY/K8gScFO6e/PFcQOWZRBRsCIGd27u/9OfdWhrZ9zXwa2hh0G0+qXY+Wn9PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dlsmh5tG6zYQvCy;
	Tue,  6 Jan 2026 21:42:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 664E640576;
	Tue,  6 Jan 2026 21:43:45 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPmPEV1p1o9fCw--.12538S3;
	Tue, 06 Jan 2026 21:43:45 +0800 (CST)
Message-ID: <905c81d3-a235-dd36-e17b-37acb8a6128b@huaweicloud.com>
Date: Tue, 6 Jan 2026 21:43:43 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC PATCH 5/5] md/raid1: introduce rectify action to repair
 badblocks
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
 yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com, linan122@h-partners.com
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
 <20251231070952.1233903-6-zhengqixing@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251231070952.1233903-6-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPmPEV1p1o9fCw--.12538S3
X-Coremail-Antispam: 1UD129KBjvAXoWfZw4DCr47uryrGw15Aw4ktFb_yoW8ZFy3Ao
	Z3Gr129F1rXry3Zryaqw13tF4fua98J3yfA3WrurZ8Cr12qw4Y9r4xGrZxXry3KF4agrWU
	X3sFqr40vF4Syw48n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYu7kC6x804xWl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG
	8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2js
	IE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02
	628vn2kIc2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw2
	8IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4l
	x2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrw
	CI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI
	42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z2
	80aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8bdb5UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/12/31 15:09, Zheng Qixing 写道:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> Add support for repairing known badblocks in RAID1. When disks
> have known badblocks (shown in sysfs bad_blocks), data can be
> read from other healthy disks in the array and written to repair
> the badblock areas and clear it in bad_blocks.
> 
> echo rectify > sync_action can trigger this action.
> 
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   drivers/md/md.c    |  80 ++++++++++--
>   drivers/md/md.h    |  16 +++
>   drivers/md/raid1.c | 308 ++++++++++++++++++++++++++++++++++++++++++++-
>   drivers/md/raid1.h |   1 +
>   4 files changed, 394 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d2f136706f6c..f5844cfb78fc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -74,6 +74,7 @@ static const char *action_name[NR_SYNC_ACTIONS] = {
>   	[ACTION_RECOVER]	= "recover",
>   	[ACTION_CHECK]		= "check",
>   	[ACTION_REPAIR]		= "repair",
> +	[ACTION_RECTIFY]	= "rectify",
>   	[ACTION_RESHAPE]	= "reshape",
>   	[ACTION_FROZEN]		= "frozen",
>   	[ACTION_IDLE]		= "idle",
> @@ -665,6 +666,29 @@ void mddev_put(struct mddev *mddev)
>   	spin_unlock(&all_mddevs_lock);
>   }
>   
> +static int raid1_badblocks_precheck(struct mddev *mddev)

This is a modification in md.c, do not use raid1_* for function names.

> +{
> +	struct md_rdev *rdev;
> +	int valid_disks = 0;
> +	int ret = -EINVAL;
> +
> +	if (mddev->level != 1) {
> +		pr_err("md/raid1:%s requires raid1 array\n", mdname(mddev));
> +		return -EINVAL;
> +	}

Return error at sysfs write time, and add a comment explaining why other
level are not supported.

> +
> +	rdev_for_each(rdev, mddev) {
> +		if (rdev->raid_disk < 0 ||
> +		    test_bit(Faulty, &rdev->flags))
> +			continue;
> +		valid_disks++;
> +	}
> +	if (valid_disks >= 2)
> +		ret = 0;
> +
> +	return ret;
> +}
> +
>   static int __handle_requested_sync_action(struct mddev *mddev,
>   					  enum sync_action action)
>   {
> @@ -684,9 +708,23 @@ static int __handle_requested_sync_action(struct mddev *mddev,
>   static int handle_requested_sync_action(struct mddev *mddev,
>   					enum sync_action action)
>   {
> +	int ret;
> +
>   	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
>   		return -EBUSY;
> -	return __handle_requested_sync_action(mddev, action);
> +
> +	switch (action) {
> +	case ACTION_RECTIFY:
> +		ret = raid1_badblocks_precheck(mddev);
> +		if (ret)
> +			return ret;
> +		set_bit(MD_RECOVERY_BADBLOCKS_RECTIFY, &mddev->recovery);
> +		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
> +		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> +		return 0;
> +	default:
> +		return __handle_requested_sync_action(mddev, action);
> +	}
>   }
>   
>   static enum sync_action __get_recovery_sync_action(struct mddev *mddev)
> @@ -700,21 +738,34 @@ static enum sync_action __get_recovery_sync_action(struct mddev *mddev)
>   
>   static enum sync_action get_recovery_sync_action(struct mddev *mddev)
>   {
> +	if (test_bit(MD_RECOVERY_BADBLOCKS_RECTIFY, &mddev->recovery))
> +		return ACTION_RECTIFY;
>   	return __get_recovery_sync_action(mddev);
>   }
>   
>   static void init_recovery_position(struct mddev *mddev)
>   {
>   	mddev->resync_min = 0;
> +	mddev->rectify_min = 0;
> +}

As mentioned in patch 1, can we directly reuse resync_min?

> +
> +static inline void clear_badblock_md_flags(struct mddev *mddev)
> +{
> +	clear_bit(MD_RECOVERY_BADBLOCKS_RECTIFY, &mddev->recovery);
>   }

No need to factor.

>   
>   static void set_requested_position(struct mddev *mddev, sector_t value)
>   {
> -	mddev->resync_min = value;
> +	if (test_bit(MD_RECOVERY_BADBLOCKS_RECTIFY, &mddev->recovery))
> +		mddev->rectify_min = value;
> +	else
> +		mddev->resync_min = value;
>   }
>   
>   static sector_t get_requested_position(struct mddev *mddev)
>   {
> +	if (test_bit(MD_RECOVERY_BADBLOCKS_RECTIFY, &mddev->recovery))
> +		return mddev->rectify_min;
>   	return mddev->resync_min;
>   }
>   
> @@ -5154,7 +5205,10 @@ enum sync_action md_sync_action(struct mddev *mddev)
>   	if (test_bit(MD_RECOVERY_RECOVER, &recovery))
>   		return ACTION_RECOVER;
>   
> -	/* MD_RECOVERY_CHECK must be paired with MD_RECOVERY_REQUESTED. */
> +	/*
> +	 * MD_RECOVERY_CHECK/MD_RECOVERY_BADBLOCKS_RECTIFY must be

Add spaces on both sides of '/'.

> +	 * paired with MD_RECOVERY_REQUESTED.
> +	 */
>   	if (test_bit(MD_RECOVERY_SYNC, &recovery))
>   		return get_recovery_sync_action(mddev);
>   
> @@ -5319,6 +5373,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
>   			break;
>   		case ACTION_RESHAPE:
>   		case ACTION_RECOVER:
> +		case ACTION_RECTIFY:
>   		case ACTION_CHECK:
>   		case ACTION_REPAIR:
>   		case ACTION_RESYNC:
> @@ -5344,6 +5399,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
>   			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>   			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   			break;
> +		case ACTION_RECTIFY:
>   		case ACTION_CHECK:
>   		case ACTION_REPAIR:
>   			ret = handle_requested_sync_action(mddev, action);
> @@ -9362,6 +9418,7 @@ static sector_t md_sync_max_sectors(struct mddev *mddev,
>   {
>   	switch (action) {
>   	case ACTION_RESYNC:
> +	case ACTION_RECTIFY:
>   	case ACTION_CHECK:
>   	case ACTION_REPAIR:
>   		atomic64_set(&mddev->resync_mismatches, 0);
> @@ -9414,6 +9471,7 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
>   	struct md_rdev *rdev;
>   
>   	switch (action) {
> +	case ACTION_RECTIFY:
>   	case ACTION_CHECK:
>   	case ACTION_REPAIR:
>   		return get_requested_position(mddev);
> @@ -10039,6 +10097,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
>   		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
>   		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
>   		clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
> +		clear_badblock_md_flags(mddev);
>   
>   		/* Start new recovery. */
>   		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> @@ -10096,10 +10155,14 @@ static void md_start_sync(struct work_struct *ws)
>   	if (spares && md_bitmap_enabled(mddev, true))
>   		mddev->bitmap_ops->write_all(mddev);
>   
> -	name = test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
> -			"reshape" : "resync";
> -	rcu_assign_pointer(mddev->sync_thread,
> -			   md_register_thread(md_do_sync, mddev, name));
> +	if (!is_badblocks_recovery_requested(mddev) ||
> +	    !raid1_badblocks_precheck(mddev)) {
> +		name = test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
> +				"reshape" : "resync";
> +		rcu_assign_pointer(mddev->sync_thread,
> +				   md_register_thread(md_do_sync, mddev, name));
> +	}
> +
>   	if (!mddev->sync_thread) {
>   		pr_warn("%s: could not start resync thread...\n",
>   			mdname(mddev));
> @@ -10127,6 +10190,7 @@ static void md_start_sync(struct work_struct *ws)
>   	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
>   	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
>   	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> +	clear_badblock_md_flags(mddev);
>   	mddev_unlock(mddev);
>   	/*
>   	 * md_start_sync was triggered by MD_RECOVERY_NEEDED, so we should
> @@ -10341,6 +10405,7 @@ void md_check_recovery(struct mddev *mddev)
>   			clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
>   			clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
>   			clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> +			clear_badblock_md_flags(mddev);
>   			wake_up(&resync_wait);
>   		}
>   
> @@ -10391,6 +10456,7 @@ void md_reap_sync_thread(struct mddev *mddev)
>   	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
>   	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
>   	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> +	clear_badblock_md_flags(mddev);
>   	clear_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
>   	/*
>   	 * We call mddev->cluster_ops->update_size here because sync_size could
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 6a4af4a1959c..58f320b19bba 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -98,6 +98,13 @@ enum sync_action {
>   	 * are inconsistent data,
>   	 */
>   	ACTION_REPAIR,
> +	/*
> +	 * Represent by MD_RECOVERY_SYNC | MD_RECOVERY_REQUESTED |
> +	 * MD_RECOVERY_BADBLOCKS_RECTIFY, start when user echo "rectify"
> +	 * to sysfs api sync_action, used to repair the badblocks acked
> +	 * in bad table;
> +	 */
> +	ACTION_RECTIFY,
>   	/*
>   	 * Represent by MD_RECOVERY_RESHAPE, start when new member disk is added
>   	 * to the conf, notice that this is different from spares or
> @@ -524,6 +531,7 @@ struct mddev {
>   	sector_t			resync_offset;
>   	sector_t			resync_min;	/* user requested sync
>   							 * starts here */
> +	sector_t			rectify_min;
>   	sector_t			resync_max;	/* resync should pause
>   							 * when it gets here */
>   
> @@ -664,6 +672,8 @@ enum recovery_flags {
>   	MD_RESYNCING_REMOTE,
>   	/* raid456 lazy initial recover */
>   	MD_RECOVERY_LAZY_RECOVER,
> +	/* try to repair acked badblocks*/
> +	MD_RECOVERY_BADBLOCKS_RECTIFY,
>   };
>   
>   enum md_ro_state {
> @@ -1016,6 +1026,12 @@ static inline void mddev_unlock_and_resume(struct mddev *mddev)
>   	mddev_resume(mddev);
>   }
>   
> +static inline bool is_badblocks_recovery_requested(struct mddev *mddev)
> +{
> +	return test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
> +	       test_bit(MD_RECOVERY_BADBLOCKS_RECTIFY, &mddev->recovery);
> +}
> +
>   struct mdu_array_info_s;
>   struct mdu_disk_info_s;
>   
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 00120c86c443..f304161bc0ce 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -176,7 +176,8 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
>   	 * If this is a user-requested check/repair, allocate
>   	 * RESYNC_PAGES for each bio.
>   	 */
> -	if (test_bit(MD_RECOVERY_REQUESTED, &conf->mddev->recovery))
> +	if (test_bit(MD_RECOVERY_REQUESTED, &conf->mddev->recovery) &&
> +	    !is_badblocks_recovery_requested(conf->mddev))
>   		need_pages = conf->raid_disks * 2;
>   	else
>   		need_pages = 1;
> @@ -2380,6 +2381,301 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
>   	put_sync_write_buf(r1_bio);
>   }
>   
> +static void end_rectify_read(struct bio *bio)
> +{
> +	struct r1bio *r1_bio = get_resync_r1bio(bio);
> +	struct r1conf *conf = r1_bio->mddev->private;
> +	struct md_rdev *rdev;
> +	struct bio *next_bio;
> +	bool all_fail = true;
> +	int i;
> +
> +	update_head_pos(r1_bio->read_disk, r1_bio);
> +
> +	if (!bio->bi_status) {
> +		set_bit(R1BIO_Uptodate, &r1_bio->state);
> +		goto out;
> +	}
> +
> +	for (i = r1_bio->read_disk + 1; i < conf->raid_disks; i++) {
> +		rdev = conf->mirrors[i].rdev;
> +		if (!rdev || test_bit(Faulty, &rdev->flags))
> +			continue;
> +
> +		next_bio = r1_bio->bios[i];
> +		if (next_bio->bi_end_io == end_rectify_read) {
> +			next_bio->bi_opf &= ~MD_FAILFAST;
> +			r1_bio->read_disk = i;
> +			all_fail = false;
> +			break;
> +		}
> +	}
> +
> +	if (unlikely(all_fail)) {
> +		md_done_sync(r1_bio->mddev, r1_bio->sectors);
> +		md_sync_error(r1_bio->mddev);
> +		put_buf(r1_bio);
> +		return;
> +	}
> +out:
> +	reschedule_retry(r1_bio);
> +}
> +
> +static void end_rectify_write(struct bio *bio)
> +{
> +	struct r1bio *r1_bio = get_resync_r1bio(bio);
> +
> +	if (atomic_dec_and_test(&r1_bio->remaining)) {
> +		/*
> +		 * Rectify only attempts to clear acked bad
> +		 * blocks, and it does not set bad blocks in
> +		 * cases of R1BIO_WriteError.
> +		 * Here we reuse R1BIO_MadeGood flag, which
> +		 * does not guarantee that all write I/Os
> +		 * actually succeeded.
> +		 */
> +		set_bit(R1BIO_MadeGood, &r1_bio->state);
> +		reschedule_retry(r1_bio);
> +	}
> +}
> +
> +static void submit_rectify_read(struct r1bio *r1_bio)
> +{
> +	struct bio *bio;
> +
> +	bio = r1_bio->bios[r1_bio->read_disk];
> +	bio->bi_opf &= ~MD_FAILFAST;
> +	bio->bi_status = 0;
> +	submit_bio_noacct(bio);
> +}
> +
> +static void rectify_request_write(struct mddev *mddev, struct r1bio *r1_bio)
> +{
> +	struct r1conf *conf = mddev->private;
> +	struct bio *wbio = NULL;
> +	int wcnt = 0;
> +	int i;
> +
> +	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
> +		submit_rectify_read(r1_bio);
> +		return;
> +	}
> +
> +	atomic_set(&r1_bio->remaining, 0);
> +	for (i = 0; i < conf->raid_disks; i++) {
> +		wbio = r1_bio->bios[i];
> +		if (wbio->bi_end_io == end_rectify_write) {
> +			atomic_inc(&r1_bio->remaining);
> +			wcnt++;
> +			submit_bio_noacct(wbio);
> +		}
> +	}
> +
> +	if (unlikely(!wcnt)) {
> +		md_done_sync(r1_bio->mddev, r1_bio->sectors);
> +		put_buf(r1_bio);
> +	}
> +}
> +
> +static void handle_rectify_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
> +{
> +	struct md_rdev *rdev;
> +	struct bio *bio;
> +	int i;
> +
> +	for (i = 0; i < conf->raid_disks; i++) {
> +		rdev = conf->mirrors[i].rdev;
> +		bio = r1_bio->bios[i];
> +		if (bio->bi_end_io == NULL)
> +			continue;
> +
> +		if (!bio->bi_status && bio->bi_end_io == end_rectify_write &&
> +		    test_bit(R1BIO_MadeGood, &r1_bio->state)) {
> +			rdev_clear_badblocks(rdev, r1_bio->sector,
> +					     r1_bio->sectors, 0);
> +		}
> +	}
> +
> +	md_done_sync(r1_bio->mddev, r1_bio->sectors);
> +	put_buf(r1_bio);
> +}
> +
> +static void handle_sync_write(struct mddev *mddev, struct r1bio *r1_bio)
> +{
> +	if (test_bit(R1BIO_BadBlocksRectify, &r1_bio->state))
> +		rectify_request_write(mddev, r1_bio);
> +	else
> +		sync_request_write(mddev, r1_bio);
> +}
> +
> +static void __handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio);
> +static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
> +{
> +	if (test_bit(R1BIO_BadBlocksRectify, &r1_bio->state))
> +		handle_rectify_write_finished(conf, r1_bio);
> +	else
> +		__handle_sync_write_finished(conf, r1_bio);
> +}
> +
> +static sector_t get_badblocks_sync_sectors(struct mddev *mddev, sector_t sector_nr,
> +					   int *skipped, unsigned long *bad_disks)
> +{
> +	struct r1conf *conf = mddev->private;
> +	sector_t nr_sectors = mddev->dev_sectors - sector_nr;
> +	bool all_faulty = true;
> +	struct md_rdev *rdev;
> +	bool good = false;
> +	int i;
> +
> +	*skipped = 0;
> +	for (i = 0; i < conf->raid_disks; i++) {
> +		sector_t first_bad;
> +		sector_t bad_sectors;
> +
> +		rdev = conf->mirrors[i].rdev;
> +		if (!rdev || test_bit(Faulty, &rdev->flags))
> +			continue;
> +
> +		all_faulty = false;
> +		if (is_badblock(rdev, sector_nr, nr_sectors, &first_bad, &bad_sectors)) {
> +			if (first_bad <= sector_nr) {
> +				set_bit(i, bad_disks);
> +				nr_sectors = min(nr_sectors, first_bad + bad_sectors - sector_nr);
> +			} else {
> +				good  = true;
> +				nr_sectors = min(nr_sectors, first_bad - sector_nr);
> +			}
> +		} else {
> +			good  = true;
> +		}
> +	}
> +
> +	if (all_faulty) {
> +		*skipped = 1;
> +		return 0;
> +	}
> +
> +	if (!good || !bitmap_weight(bad_disks, conf->raid_disks))
> +		*skipped = 1;
> +
> +	/* make sure nr_sectors won't go across barrier unit boundary */
> +	return align_to_barrier_unit_end(sector_nr, nr_sectors);
> +}
> +
> +static sector_t get_next_sync_sector(struct mddev *mddev, sector_t sector_nr,
> +				     int *skipped, unsigned long *bad_disks)
> +{
> +	sector_t nr_sectors;
> +
> +	nr_sectors = get_badblocks_sync_sectors(mddev, sector_nr,
> +						skipped, bad_disks);
> +	if (!(*skipped) && nr_sectors > RESYNC_PAGES * (PAGE_SIZE >> 9))
> +		nr_sectors = RESYNC_PAGES * (PAGE_SIZE >> 9);
> +	return nr_sectors;
> +}
> +
> +static struct r1bio *raid1_alloc_init_r1buf(struct r1conf *conf);
> +static struct r1bio *init_sync_badblocks_r1bio(struct mddev *mddev,
> +					       sector_t sector_nr,
> +					       sector_t nr_sectors,
> +					       unsigned long *bad_disks)
> +{
> +	struct r1conf *conf = mddev->private;
> +	struct r1bio *r1_bio;
> +	struct md_rdev *rdev;
> +	int page_idx = 0;
> +	struct bio *bio;
> +	int i;
> +
> +	r1_bio = raid1_alloc_init_r1buf(conf);
> +	r1_bio->mddev = mddev;
> +	r1_bio->sector = sector_nr;
> +	r1_bio->sectors = nr_sectors;
> +	r1_bio->state = 0;
> +	r1_bio->read_disk = -1;
> +	set_bit(R1BIO_IsSync, &r1_bio->state);
> +	set_bit(R1BIO_BadBlocksRectify, &r1_bio->state);
> +
> +	for (i = 0; i < conf->raid_disks; i++) {
> +		rdev = conf->mirrors[i].rdev;
> +		if (!rdev || test_bit(Faulty, &rdev->flags))
> +			continue;
> +
> +		if (r1_bio->read_disk < 0 && !test_bit(i, bad_disks))
> +			r1_bio->read_disk = i;
> +
> +		bio = r1_bio->bios[i];
> +		if (test_bit(i, bad_disks)) {
> +			bio->bi_opf = REQ_OP_WRITE;
> +			bio->bi_end_io = end_rectify_write;
> +		} else {
> +			bio->bi_opf = REQ_OP_READ;
> +			bio->bi_end_io = end_rectify_read;
> +		}
> +
> +		atomic_inc(&rdev->nr_pending);
> +		bio->bi_iter.bi_sector = sector_nr + rdev->data_offset;
> +		bio_set_dev(bio, rdev->bdev);
> +		if (test_bit(FailFast, &rdev->flags))
> +			bio->bi_opf |= MD_FAILFAST;
> +	}
> +
> +	if (unlikely(r1_bio->read_disk < 0)) {
> +		put_buf(r1_bio);
> +		return NULL;
> +	}
> +
> +	while (nr_sectors > 0 && page_idx < RESYNC_PAGES) {
> +		int len = nr_sectors << 9 < PAGE_SIZE ?
> +			  nr_sectors << 9 : PAGE_SIZE;
> +		struct resync_pages *rp;
> +
> +		for (i = 0; i < conf->raid_disks; i++) {
> +			bio = r1_bio->bios[i];
> +			rp = get_resync_pages(bio);
> +			__bio_add_page(bio, resync_fetch_page(rp, page_idx), len, 0);
> +		}
> +
> +		nr_sectors -= len >> 9;
> +		page_idx++;
> +	}
> +
> +	return r1_bio;
> +}
> +
> +static sector_t __badblocks_rectify(struct mddev *mddev, sector_t sector_nr,
> +				    sector_t nr_sectors,
> +				    unsigned long *bad_disks)
> +{
> +	struct r1bio *r1_bio;
> +
> +	r1_bio = init_sync_badblocks_r1bio(mddev, sector_nr,
> +					   nr_sectors, bad_disks);
> +	if (!r1_bio)
> +		return 0;
> +
> +	submit_rectify_read(r1_bio);
> +	return nr_sectors;
> +}

No need to factor.

> +
> +static sector_t do_sync_badblocks_rectify(struct mddev *mddev,
> +					  sector_t sector_nr, int *skipped)
> +{
> +	DECLARE_BITMAP(bad_disks, MAX_RAID_DISKS);
> +	struct r1conf *conf = mddev->private;
> +	sector_t nr_sectors;
> +
> +	bitmap_zero(bad_disks, MAX_RAID_DISKS);
> +	nr_sectors = get_next_sync_sector(mddev, sector_nr, skipped, bad_disks);
> +
> +	if (*skipped) {
> +		lower_barrier(conf, sector_nr);
> +		return nr_sectors;
> +	}
> +
> +	return __badblocks_rectify(mddev, sector_nr, nr_sectors, bad_disks);
> +}
> +
>   /*
>    * This is a kernel thread which:
>    *
> @@ -2554,7 +2850,7 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
>   	return ok;
>   }
>   
> -static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
> +static void __handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
>   {
>   	int m;
>   	int s = r1_bio->sectors;
> @@ -2728,7 +3024,7 @@ static void raid1d(struct md_thread *thread)
>   			    test_bit(R1BIO_WriteError, &r1_bio->state))
>   				handle_sync_write_finished(conf, r1_bio);
>   			else
> -				sync_request_write(mddev, r1_bio);
> +				handle_sync_write(mddev, r1_bio);
>   		} else if (test_bit(R1BIO_MadeGood, &r1_bio->state) ||
>   			   test_bit(R1BIO_WriteError, &r1_bio->state))
>   			handle_write_finished(conf, r1_bio);
> @@ -2837,7 +3133,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
>   	/* before building a request, check if we can skip these blocks..
>   	 * This call the bitmap_start_sync doesn't actually record anything
>   	 */
> -	if (!md_bitmap_start_sync(mddev, sector_nr, &sync_blocks, true) &&
> +	if (!is_badblocks_recovery_requested(mddev) &&
> +	    !md_bitmap_start_sync(mddev, sector_nr, &sync_blocks, true) &&
>   	    !conf->fullsync && !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
>   		/* We can skip this block, and probably several more */
>   		*skipped = 1;
> @@ -2863,6 +3160,9 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
>   	if (raise_barrier(conf, sector_nr))
>   		return 0;
>   
> +	if (is_badblocks_recovery_requested(mddev))
> +		return do_sync_badblocks_rectify(mddev, sector_nr, skipped);
> +
>   	r1_bio = raid1_alloc_init_r1buf(conf);
>   
>   	/*
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index c98d43a7ae99..6ca8bf808d69 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -184,6 +184,7 @@ enum r1bio_state {
>   	R1BIO_MadeGood,
>   	R1BIO_WriteError,
>   	R1BIO_FailFast,
> +	R1BIO_BadBlocksRectify,
>   };
>   
>   static inline int sector_to_idx(sector_t sector)

-- 
Thanks,
Nan

