Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B04118A6CF;
	Fri, 26 Dec 2025 03:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766720818; cv=none; b=IF1IKmtaZquESjM95aF56uijLm/A0820EZDc7j6HF2zk5sc0OX9pzXjRKAc74smm/Aqxd/FizIpDb4AL8uF5Hf/IqEH1m6PtleZ7rPmZt8XR+E5/ujr4Cf+XXj3v5biPVZ6iQQ/kymm2bSZ6k5MiOo2LVOW91ABqpWZW5jO1fqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766720818; c=relaxed/simple;
	bh=Bb/bfs+hkDS4nWua+0Z4MWC5/0QFQuXrxUL/kcINM7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WOS9z1Tgy4tVJ2HUoC8KM8+xBf08Bc7ELahjpyswPoGu0Q2Re5TxazpT1VoNwOmi00hybtN7z9Iy8CuSjVbVBvqlqP1HlvdMYISI9UtElUu/6EuSzuTAFaN7ZQ3NQd6gAPfzrfLVw0wFwx1VNv9DjG8kLvYjiF2DQJIgsSeAe4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dcs3Q6KSbzYQtLW;
	Fri, 26 Dec 2025 11:46:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4731840570;
	Fri, 26 Dec 2025 11:46:52 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgDXOPkqBU5pSeoKBg--.6667S3;
	Fri, 26 Dec 2025 11:46:52 +0800 (CST)
Message-ID: <4ab60d6d-5b4d-ab81-33ed-931638ffa8e4@huaweicloud.com>
Date: Fri, 26 Dec 2025 11:46:50 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 02/11] md: merge mddev faillast_dev into mddev_flags
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, filippo@debian.org, colyli@fnnas.com
References: <20251124063203.1692144-1-yukuai@fnnas.com>
 <20251124063203.1692144-3-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251124063203.1692144-3-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOPkqBU5pSeoKBg--.6667S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Ww1xZryDXF17WFykuF4rZrb_yoW7Xry7pa
	1kJF90y3yUJa45JF13AFWDuayFq3Wa9rWqkFZxZ34kuF1rXryUGFs8GayUJryDAF4Fya4x
	Xr15Gr4DCFyFgw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Yb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjxUwGQDUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/11/24 14:31, Yu Kuai 写道:
> There is not need to use a separate field in struct mddev, there are no
> functional changes.
> 
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/md.c     | 10 ++++++----
>   drivers/md/md.h     |  3 ++-
>   drivers/md/raid0.c  |  3 ++-
>   drivers/md/raid1.c  |  4 ++--
>   drivers/md/raid10.c |  4 ++--
>   drivers/md/raid5.c  |  5 ++++-
>   6 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b49fdee11a03..5dcfd0371090 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5864,11 +5864,11 @@ __ATTR(consistency_policy, S_IRUGO | S_IWUSR, consistency_policy_show,
>   
>   static ssize_t fail_last_dev_show(struct mddev *mddev, char *page)
>   {
> -	return sprintf(page, "%d\n", mddev->fail_last_dev);
> +	return sprintf(page, "%d\n", test_bit(MD_FAILLAST_DEV, &mddev->flags));
>   }
>   
>   /*
> - * Setting fail_last_dev to true to allow last device to be forcibly removed
> + * Setting MD_FAILLAST_DEV to allow last device to be forcibly removed
>    * from RAID1/RAID10.
>    */
>   static ssize_t
> @@ -5881,8 +5881,10 @@ fail_last_dev_store(struct mddev *mddev, const char *buf, size_t len)
>   	if (ret)
>   		return ret;
>   
> -	if (value != mddev->fail_last_dev)
> -		mddev->fail_last_dev = value;
> +	if (value)
> +		set_bit(MD_FAILLAST_DEV, &mddev->flags);
> +	else
> +		clear_bit(MD_FAILLAST_DEV, &mddev->flags);
>   
>   	return len;
>   }
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b4c9aa600edd..297a104fba88 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -341,6 +341,7 @@ struct md_cluster_operations;
>    * @MD_BROKEN: This is used to stop writes and mark array as failed.
>    * @MD_DELETED: This device is being deleted
>    * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
> + * @MD_FAILLAST_DEV: Allow last rdev to be removed.
>    *
>    * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
>    */
> @@ -358,6 +359,7 @@ enum mddev_flags {
>   	MD_DO_DELETE,
>   	MD_DELETED,
>   	MD_HAS_SUPERBLOCK,
> +	MD_FAILLAST_DEV,
>   };
>   
>   enum mddev_sb_flags {
> @@ -625,7 +627,6 @@ struct mddev {
>   	/* The sequence number for sync thread */
>   	atomic_t sync_seq;
>   
> -	bool	fail_last_dev:1;
>   	bool	serialize_policy:1;
>   };
>   
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 47aee1b1d4d1..012d8402af28 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -27,7 +27,8 @@ module_param(default_layout, int, 0644);
>   	 (1L << MD_JOURNAL_CLEAN) |	\
>   	 (1L << MD_FAILFAST_SUPPORTED) |\
>   	 (1L << MD_HAS_PPL) |		\
> -	 (1L << MD_HAS_MULTIPLE_PPLS))
> +	 (1L << MD_HAS_MULTIPLE_PPLS) |	\
> +	 (1L << MD_FAILLAST_DEV))
>   
>   /*
>    * inform the user of the raid configuration
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 57d50465eed1..98b5c93810bb 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1746,7 +1746,7 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>    *	- &mddev->degraded is bumped.
>    *
>    * @rdev is marked as &Faulty excluding case when array is failed and
> - * &mddev->fail_last_dev is off.
> + * MD_FAILLAST_DEV is not set.
>    */
>   static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>   {
> @@ -1759,7 +1759,7 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>   	    (conf->raid_disks - mddev->degraded) == 1) {
>   		set_bit(MD_BROKEN, &mddev->flags);
>   
> -		if (!mddev->fail_last_dev) {
> +		if (!test_bit(MD_FAILLAST_DEV, &mddev->flags)) {
>   			conf->recovery_disabled = mddev->recovery_disabled;
>   			spin_unlock_irqrestore(&conf->device_lock, flags);
>   			return;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 84be4cc7e873..09328e032f14 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1990,7 +1990,7 @@ static int enough(struct r10conf *conf, int ignore)
>    *	- &mddev->degraded is bumped.
>    *
>    * @rdev is marked as &Faulty excluding case when array is failed and
> - * &mddev->fail_last_dev is off.
> + * MD_FAILLAST_DEV is not set.
>    */
>   static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>   {
> @@ -2002,7 +2002,7 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>   	if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk)) {
>   		set_bit(MD_BROKEN, &mddev->flags);
>   
> -		if (!mddev->fail_last_dev) {
> +		if (!test_bit(MD_FAILLAST_DEV, &mddev->flags)) {
>   			spin_unlock_irqrestore(&conf->device_lock, flags);
>   			return;
>   		}
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index cdbc7eba5c54..74f6729864fa 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -56,7 +56,10 @@
>   #include "md-bitmap.h"
>   #include "raid5-log.h"
>   
> -#define UNSUPPORTED_MDDEV_FLAGS	(1L << MD_FAILFAST_SUPPORTED)
> +#define UNSUPPORTED_MDDEV_FLAGS		\
> +	((1L << MD_FAILFAST_SUPPORTED) |	\
> +	 (1L << MD_FAILLAST_DEV))
> +
>   
>   #define cpu_to_group(cpu) cpu_to_node(cpu)
>   #define ANY_GROUP NUMA_NO_NODE
LGTM

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan

