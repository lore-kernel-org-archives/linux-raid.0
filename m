Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C0B2E3390
	for <linux-raid@vger.kernel.org>; Thu, 13 Mar 2025 03:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741834879; cv=none; b=BQOACmg1w55GUiNlEsYyN8tHfn22XfVUEuhrHhCi8I7iku2GyY4gjwbAO4PRkWdS83/7Ic1NFZcNE6IqIXuh8AybnvCrKgD5+jbHdakrpOnYiVWRdvDhON6GSwSoSgnebw1GDhXsc7UPFO3quPFy5yPh5LJylg+oSQwvKZn4fiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741834879; c=relaxed/simple;
	bh=SNbpIIB/8IJv/aiC8VBYNxIGZHBIjvBlEsrY0ASFzb8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=muISH/sJhgGAtmKIrAsLIYtI1k3vgV1BUyxLoQZVF670EWlWujdHKh5b7nCD3m961WuoYW2SsNARU+XM7Wv/6Wb0vNknZhjWm17zxu8a4IXCJR5fOXyZlz3sHbFCqaxgoYiDK9kC2AHqGs1wGN8pzpTk2nfiLRLpiUcbsmoviZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZCsh20CgDz4f3lgM
	for <linux-raid@vger.kernel.org>; Thu, 13 Mar 2025 11:00:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DFF291A06DC
	for <linux-raid@vger.kernel.org>; Thu, 13 Mar 2025 11:01:13 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3W2B3StJnIjVbGQ--.45913S3;
	Thu, 13 Mar 2025 11:01:12 +0800 (CST)
Subject: Re: [GIT PULL] md-6.15-20250312
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk,
 linux-raid@vger.kernel.org, song@kernel.org
Cc: xni@redhat.com, glass.su@suse.com, zhengqixing@huawei.com,
 linan122@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250313022445.2229190-1-yukuai1@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0cd0d493-0ee9-4757-609c-4aab6711af34@huaweicloud.com>
Date: Thu, 13 Mar 2025 11:01:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250313022445.2229190-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3W2B3StJnIjVbGQ--.45913S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCr47GFy3uw4xKr4rKr17ZFb_yoW5ur45pF
	y3JFy3Zry5J3s7Wa13ArWv9FyFyw1xXrWUJ343A3yfKasY9FWkJa1UJF95Ar9FgFy3JrnF
	qw1UG398u3Z5J3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU13ku3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/03/13 10:24, Yu Kuai Ð´µÀ:
> Hi Jens,
> 
> Please consider pulling the following changes for md-6.15 on your
> for-6.15/block branch, this pull request contains:
> 
> - fix recovery can preempt resync (Li Nan)
> - fix md-bitmap IO limit (Su Yue)
> - fix raid10 discard with REQ_NOWAIT (Xiao Ni)
> - fix raid1 memory leak (Zheng Qixing)
> - fix mddev uaf (Yu Kuai)
> - fix raid1,raid10 IO flags (Yu Kuai)
> - some refactor and cleanup (Yu Kuai)
> 
> Thanks,
> Kuai
> 
Due to:
7e5102dd99f3 ("md: improve return types of badblocks handling functions")

There is a minor conflict in:
c594de0455b3 ("md: don't export md_cluster_ops")

Conflict resolution:

  diff --git a/drivers/md/md.h b/drivers/md/md.h
-index f9e0f0d390f1..873f33e2a1f6 100644
+index e46c0cb191e3..6c50cd5fbea2 100644
  --- a/drivers/md/md.h
  +++ b/drivers/md/md.h
-@@ -320,6 +320,7 @@ extern int rdev_set_badblocks(struct md_rdev *rdev, 
sector_t s, int sectors,
- extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int 
sectors,
-                               int is_new);
+@@ -320,6 +320,7 @@ extern bool rdev_set_badblocks(struct md_rdev 
*rdev, sector_t s, int sectors,
+ extern void rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int 
sectors,
+                                int is_new);
   struct md_cluster_info;
  +struct md_cluster_operations;

Please let me know if I should send a new pr.

Thanks,
Kuai

> The following changes since commit a052bfa636bb763786b9dc13a301a59afb03787a:
> 
>    block: refactor rq_qos_wait() (2025-02-11 13:04:11 -0700)
> 
> are available in the Git repository at:
>    https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.15-20250312
> 
> for you to fetch changes up to 3db4404435397a345431b45f57876a3df133f3b4:
> 
>    md/raid10: wait barrier before returning discard request with REQ_NOWAIT (2025-03-06 22:34:20 +0800)
> 
> ----------------------------------------------------------------
> Li Nan (1):
>        md: ensure resync is prioritized over recovery
> 
> Su Yue (1):
>        md/md-bitmap: fix wrong bitmap_limit for clustermd when write sb
> 
> Xiao Ni (1):
>        md/raid10: wait barrier before returning discard request with REQ_NOWAIT
> 
> Yu Kuai (10):
>        md: merge common code into find_pers()
>        md: only include md-cluster.h if necessary
>        md: introduce struct md_submodule_head and APIs
>        md: switch personalities to use md_submodule_head
>        md/md-cluster: cleanup md_cluster_ops reference
>        md: don't export md_cluster_ops
>        md: switch md-cluster to use md_submodle_head
>        md: fix mddev uaf while iterating all_mddevs list
>        md/raid5: merge reshape_progress checking inside get_reshape_loc()
>        md/raid1,raid10: don't ignore IO flags
> 
> Zheng Qixing (1):
>        md/raid1: fix memory leak in raid1_run() if no active rdev
> 
>   drivers/md/md-bitmap.c  |  14 ++-
>   drivers/md/md-cluster.c |  18 ++-
>   drivers/md/md-cluster.h |   6 +
>   drivers/md/md-linear.c  |  15 ++-
>   drivers/md/md.c         | 295 ++++++++++++++++++++++++------------------------
>   drivers/md/md.h         |  48 +++++---
>   drivers/md/raid0.c      |  18 +--
>   drivers/md/raid1-10.c   |   4 +-
>   drivers/md/raid1.c      |  46 ++++----
>   drivers/md/raid10.c     |  52 ++++-----
>   drivers/md/raid5.c      |  91 ++++++++++-----
>   11 files changed, 338 insertions(+), 269 deletions(-)
> 
> .
> 

