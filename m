Received: from mail-108-mta65.mxroute.com (mail-108-mta65.mxroute.com [136.175.108.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374243A1B6
	for <linux-raid@vger.kernel.org>; Tue, 18 Feb 2025 03:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739850336; cv=none; b=XG/ZXXgBhsoHDpIFFxbUlP70H20J98MEs06WFIjQ9HV6hW4Gva/i0cvx1DZGxEOK0lsT05dnKPIlYqK5+qS/lTXK8fEmOCa0XUFJUJUt6WHId7jTqX8qWOsX0ODtlaVPC7gi9OmJzZG8mev0R8RaQTRu8YKOFDUmjenDAoVo93I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739850336; c=relaxed/simple;
	bh=Z/LHmpug6mo4aeB94Ypuiu6MxuP5hkW76yjodYvxPcY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=N2ThM/86vwYwdeYyY7OT3iftQdLvjOxcD6tQC60ARh4+yDawltcwg3FOVZR+WTyuxEtSbsI8LR6CH5LHqNAqhRQofYVlgGjLMZgLQfsQe64wmD6rD+wyhXOKipWoLAWjawjwFfAXXQ9Y20a+fX/ytyerf48YyR9bVCYIQmiA83o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=V88Qynw7; arc=none smtp.client-ip=136.175.108.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="V88Qynw7"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta65.mxroute.com (ZoneMTA) with ESMTPSA id 19517248a3e000310e.008
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 18 Feb 2025 03:40:25 +0000
X-Zone-Loop: 383ffa67919a1d4cbd07f2860fe31ab044be2e230679
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:
	References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=d24NILsFbm5QEOjhOdI0kZQA7pO2m1fI1x27Z+Eryls=; b=V88Qynw7M1t27hMhlyFvTDccXj
	k81RcP3UWajvLVNeA7B8iGu8kpiNE4rD4SQ42kozeLysFctPG/LRYp5xQkj33Eu4e+bG0SmaVlQJq
	NZrHl7wdBjWhLWeQbMXSGDDaP2r/EkCH6oIgbF8mA4SpGg7ON6zK9IcbtbIijzAtNYxtdlVjWGHt7
	iSsZvy9i/dKyqhaOdB7FpwC+P4LZL8/DHt/tskfAWabLJxIyx51vXq+7Ub+/u5soCl4jUUKHOl/EH
	NQQa73xWMesyWxvetglyInYWHrIIZqpAjgulflysP6wJyemgksTGOuATExgY0VVqBME+WlobyGZ9u
	B2BYpryA==;
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Glass Su <glass.su@suse.com>,  song@kernel.org,
  linux-raid@vger.kernel.org,  linux-kernel@vger.kernel.org,
  yi.zhang@huawei.com,  yangerkun@huawei.com,  "yukuai (C)"
 <yukuai3@huawei.com>
Subject: Re: [PATCH md-6.15 2/7] md: only include md-cluster.h if necessary
In-Reply-To: <c8cd970f-8b2a-bb7c-b0ad-4e11fd6bae9d@huaweicloud.com> (Yu Kuai's
	message of "Tue, 18 Feb 2025 10:40:55 +0800")
References: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
	<20250215092225.2427977-3-yukuai1@huaweicloud.com>
	<E136E905-430C-40B4-B69A-7FC9B8CF3C47@suse.com>
	<c8cd970f-8b2a-bb7c-b0ad-4e11fd6bae9d@huaweicloud.com>
User-Agent: mu4e 1.12.7; emacs 29.4
Date: Tue, 18 Feb 2025 11:40:16 +0800
Message-ID: <h64r6hun.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org

On Tue 18 Feb 2025 at 10:40, Yu Kuai <yukuai1@huaweicloud.com>=20
wrote:

> Hi,
>
> =E5=9C=A8 2025/02/17 18:20, Glass Su =E5=86=99=E9=81=93:
>>
>>> On Feb 15, 2025, at 17:22, Yu Kuai <yukuai1@huaweicloud.com>=20
>>> wrote:
>>>
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>
>>> md-cluster is only supportted by raid1 and raid10, there is no=20
>>> need to
>>> include md-cluster.h for other personalities.
>>>
>>> Also move APIs that is only used in md-cluster.c from md.h to
>>> md-cluster.h.
>>>
>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> Reviewed-by: Su Yue <glass.su@suse.com>
>
> Thanks for the review! Any ideas for the remaining patches?
>
Just did slight tests for md cluster. Sent RVB for remaining=20
patches.
Thanks for taking care of md cluster.

--
Su
> Kuai
>
>>> ---
>>> drivers/md/md-bitmap.c  | 2 ++
>>> drivers/md/md-cluster.h | 7 +++++++
>>> drivers/md/md.h         | 7 -------
>>> drivers/md/raid1.c      | 1 +
>>> drivers/md/raid10.c     | 1 +
>>> 5 files changed, 11 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>>> index 23c09d22fcdb..71aa7dc80e26 100644
>>> --- a/drivers/md/md-bitmap.c
>>> +++ b/drivers/md/md-bitmap.c
>>> @@ -29,8 +29,10 @@
>>> #include <linux/buffer_head.h>
>>> #include <linux/seq_file.h>
>>> #include <trace/events/block.h>
>>> +
>>> #include "md.h"
>>> #include "md-bitmap.h"
>>> +#include "md-cluster.h"
>>>
>>> #define BITMAP_MAJOR_LO 3
>>> /* version 4 insists the bitmap is in little-endian order
>>> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
>>> index 470bf18ffde5..6c7aad00f5da 100644
>>> --- a/drivers/md/md-cluster.h
>>> +++ b/drivers/md/md-cluster.h
>>> @@ -35,4 +35,11 @@ struct md_cluster_operations {
>>> void (*update_size)(struct mddev *mddev, sector_t=20
>>> old_dev_sectors);
>>> };
>>>
>>> +extern int register_md_cluster_operations(const struct=20
>>> md_cluster_operations *ops,
>>> + struct module *module);
>>> +extern int unregister_md_cluster_operations(void);
>>> +extern int md_setup_cluster(struct mddev *mddev, int nodes);
>>> +extern void md_cluster_stop(struct mddev *mddev);
>>> +extern void md_reload_sb(struct mddev *mddev, int raid_disk);
>>> +
>>> #endif /* _MD_CLUSTER_H */
>>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>>> index def808064ad8..c9bc70e6d5b4 100644
>>> --- a/drivers/md/md.h
>>> +++ b/drivers/md/md.h
>>> @@ -19,7 +19,6 @@
>>> #include <linux/wait.h>
>>> #include <linux/workqueue.h>
>>> #include <trace/events/block.h>
>>> -#include "md-cluster.h"
>>>
>>> #define MaxSector (~(sector_t)0)
>>>
>>> @@ -845,11 +844,6 @@ static inline void safe_put_page(struct=20
>>> page *p)
>>>
>>> extern int register_md_personality(struct md_personality *p);
>>> extern int unregister_md_personality(struct md_personality=20
>>> *p);
>>> -extern int register_md_cluster_operations(const struct=20
>>> md_cluster_operations *ops,
>>> - struct module *module);
>>> -extern int unregister_md_cluster_operations(void);
>>> -extern int md_setup_cluster(struct mddev *mddev, int nodes);
>>> -extern void md_cluster_stop(struct mddev *mddev);
>>> extern struct md_thread *md_register_thread(
>>> void (*run)(struct md_thread *thread),
>>> struct mddev *mddev,
>>> @@ -906,7 +900,6 @@ extern void md_idle_sync_thread(struct=20
>>> mddev *mddev);
>>> extern void md_frozen_sync_thread(struct mddev *mddev);
>>> extern void md_unfrozen_sync_thread(struct mddev *mddev);
>>>
>>> -extern void md_reload_sb(struct mddev *mddev, int raid_disk);
>>> extern void md_update_sb(struct mddev *mddev, int force);
>>> extern void mddev_create_serial_pool(struct mddev *mddev,=20
>>> struct md_rdev *rdev);
>>> extern void mddev_destroy_serial_pool(struct mddev *mddev,
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index 9d57a88dbd26..e55db07e43d4 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -36,6 +36,7 @@
>>> #include "md.h"
>>> #include "raid1.h"
>>> #include "md-bitmap.h"
>>> +#include "md-cluster.h"
>>>
>>> #define UNSUPPORTED_MDDEV_FLAGS \
>>> ((1L << MD_HAS_JOURNAL) | \
>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>> index efe93b979167..3df39b2399b2 100644
>>> --- a/drivers/md/raid10.c
>>> +++ b/drivers/md/raid10.c
>>> @@ -24,6 +24,7 @@
>>> #include "raid10.h"
>>> #include "raid0.h"
>>> #include "md-bitmap.h"
>>> +#include "md-cluster.h"
>>>
>>> /*
>>>   * RAID10 provides a combination of RAID0 and RAID1=20
>>>   functionality.
>>> -- 2.39.2
>>>
>>>
>> .
>>
