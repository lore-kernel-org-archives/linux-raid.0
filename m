Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A5713AD26;
	Tue, 18 Feb 2025 02:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739846471; cv=none; b=Jj+7ct0mvrYVwRzSutOpidiMEqficE9+EW+r+Mvkryxu06NDwtroXjeMy1HRWHzQC7xhBze1srAjnP2t2MTmnPQFF5hLUCA+gYwaEWqm3YZPyhe4MM29/XMNd1rd/RV4BRXNe1qiydh2rdrKpRQ5EiuMpHtCTRg6LpTXEAXbujg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739846471; c=relaxed/simple;
	bh=ddB4Ie1Thyo7pC2LluU7FJXKvtLAu7a/2Z0RXaTzPa4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ER5wWiOPVMsfQrm0jjTp6iEHP/nX4Ibr4FOZherlz8O3BvB4GchUUaqyOVOoiMQaSExeWcS1LlHW9TplxQGSg9ZLQIxNlMCVH3bJi42HPbve9FpjyzF6JZb1ay/KAaYqamFutsUlLsYYavW9xwhiXggCVhBaLawgvpn+Qccs5nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YxkKN5qX5z4f3jqM;
	Tue, 18 Feb 2025 10:40:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 124931A06D7;
	Tue, 18 Feb 2025 10:40:57 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3Wl8387Nnae2lEA--.14875S3;
	Tue, 18 Feb 2025 10:40:56 +0800 (CST)
Subject: Re: [PATCH md-6.15 2/7] md: only include md-cluster.h if necessary
To: Glass Su <glass.su@suse.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
 <20250215092225.2427977-3-yukuai1@huaweicloud.com>
 <E136E905-430C-40B4-B69A-7FC9B8CF3C47@suse.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c8cd970f-8b2a-bb7c-b0ad-4e11fd6bae9d@huaweicloud.com>
Date: Tue, 18 Feb 2025 10:40:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <E136E905-430C-40B4-B69A-7FC9B8CF3C47@suse.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3Wl8387Nnae2lEA--.14875S3
X-Coremail-Antispam: 1UD129KBjvJXoWxArWfuF1fKrW7Zw18ArW8JFb_yoWrCF15pa
	1qya45Cw45JrWUWw1UZF9rZa45K3s3KrW0kryfJ34SvF9IgF9rGF4qgF98Cr1DCFW3GFnF
	v3Wjg3Z8urnYqrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa
	73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/02/17 18:20, Glass Su Ð´µÀ:
> 
> 
>> On Feb 15, 2025, at 17:22, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> md-cluster is only supportted by raid1 and raid10, there is no need to
>> include md-cluster.h for other personalities.
>>
>> Also move APIs that is only used in md-cluster.c from md.h to
>> md-cluster.h.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> 
> Reviewed-by: Su Yue <glass.su@suse.com>

Thanks for the review! Any ideas for the remaining patches?

Kuai

>> ---
>> drivers/md/md-bitmap.c  | 2 ++
>> drivers/md/md-cluster.h | 7 +++++++
>> drivers/md/md.h         | 7 -------
>> drivers/md/raid1.c      | 1 +
>> drivers/md/raid10.c     | 1 +
>> 5 files changed, 11 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index 23c09d22fcdb..71aa7dc80e26 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -29,8 +29,10 @@
>> #include <linux/buffer_head.h>
>> #include <linux/seq_file.h>
>> #include <trace/events/block.h>
>> +
>> #include "md.h"
>> #include "md-bitmap.h"
>> +#include "md-cluster.h"
>>
>> #define BITMAP_MAJOR_LO 3
>> /* version 4 insists the bitmap is in little-endian order
>> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
>> index 470bf18ffde5..6c7aad00f5da 100644
>> --- a/drivers/md/md-cluster.h
>> +++ b/drivers/md/md-cluster.h
>> @@ -35,4 +35,11 @@ struct md_cluster_operations {
>> void (*update_size)(struct mddev *mddev, sector_t old_dev_sectors);
>> };
>>
>> +extern int register_md_cluster_operations(const struct md_cluster_operations *ops,
>> + struct module *module);
>> +extern int unregister_md_cluster_operations(void);
>> +extern int md_setup_cluster(struct mddev *mddev, int nodes);
>> +extern void md_cluster_stop(struct mddev *mddev);
>> +extern void md_reload_sb(struct mddev *mddev, int raid_disk);
>> +
>> #endif /* _MD_CLUSTER_H */
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index def808064ad8..c9bc70e6d5b4 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -19,7 +19,6 @@
>> #include <linux/wait.h>
>> #include <linux/workqueue.h>
>> #include <trace/events/block.h>
>> -#include "md-cluster.h"
>>
>> #define MaxSector (~(sector_t)0)
>>
>> @@ -845,11 +844,6 @@ static inline void safe_put_page(struct page *p)
>>
>> extern int register_md_personality(struct md_personality *p);
>> extern int unregister_md_personality(struct md_personality *p);
>> -extern int register_md_cluster_operations(const struct md_cluster_operations *ops,
>> - struct module *module);
>> -extern int unregister_md_cluster_operations(void);
>> -extern int md_setup_cluster(struct mddev *mddev, int nodes);
>> -extern void md_cluster_stop(struct mddev *mddev);
>> extern struct md_thread *md_register_thread(
>> void (*run)(struct md_thread *thread),
>> struct mddev *mddev,
>> @@ -906,7 +900,6 @@ extern void md_idle_sync_thread(struct mddev *mddev);
>> extern void md_frozen_sync_thread(struct mddev *mddev);
>> extern void md_unfrozen_sync_thread(struct mddev *mddev);
>>
>> -extern void md_reload_sb(struct mddev *mddev, int raid_disk);
>> extern void md_update_sb(struct mddev *mddev, int force);
>> extern void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev);
>> extern void mddev_destroy_serial_pool(struct mddev *mddev,
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 9d57a88dbd26..e55db07e43d4 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -36,6 +36,7 @@
>> #include "md.h"
>> #include "raid1.h"
>> #include "md-bitmap.h"
>> +#include "md-cluster.h"
>>
>> #define UNSUPPORTED_MDDEV_FLAGS \
>> ((1L << MD_HAS_JOURNAL) | \
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index efe93b979167..3df39b2399b2 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -24,6 +24,7 @@
>> #include "raid10.h"
>> #include "raid0.h"
>> #include "md-bitmap.h"
>> +#include "md-cluster.h"
>>
>> /*
>>   * RAID10 provides a combination of RAID0 and RAID1 functionality.
>> -- 
>> 2.39.2
>>
>>
> 
> .
> 

