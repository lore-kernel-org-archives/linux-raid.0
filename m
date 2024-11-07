Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECDE20EA5E
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 13:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730984682; cv=none; b=C70wxEBhozKredScLYamSAnQbqNuKeU4tdM67WSspbzqyKDyiPV3DDGogAcEafeP/4wVKekKZzFg3kB1otVCI8JahJBOVBp2BpDM6LQxXSRMt0Ddxy/8dGtfMct+LFd5OEBXgSLf1+iVyFgkl7Hg9BKUWJ0JSN1BzZaT348ZQaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730984682; c=relaxed/simple;
	bh=gKUkbdh6nr2gts5MeJm5RwQWIAq82yaHSXH45gl2tLc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=V2Fs04PGdosW0D+Rq19YMaxqCsCbylvjto+xMFFcJUlJschbxWFRjfXns6+nsVwEP+07id1g30lWbpx3CKjXtPCpAl366Z1Li5zhe5n4++hiXbfYJilNuHEtWLP++D1IbBvExIpUczx5l5sS/at/LIvj8/JIIPwqy4+t15PV5IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xkj2T5Msyz4f3n6G
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 21:04:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A1C531A018C
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 21:04:36 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBHI4fjuixnpA1zBA--.10616S3;
	Thu, 07 Nov 2024 21:04:36 +0800 (CST)
Subject: Re: [PATCH V2 0/3] mdadm: remove bitmap file support
To: Yu Kuai <yukuai1@huaweicloud.com>, mariusz.tkaczyk@linux.intel.com,
 linux-raid@vger.kernel.org
Cc: yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241107125839.310633-1-yukuai1@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d15a308f-51d0-8ed6-c209-dd6551bcfc24@huaweicloud.com>
Date: Thu, 7 Nov 2024 21:04:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241107125839.310633-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHI4fjuixnpA1zBA--.10616S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GrWDXry3Ww4DXF4kJF18Xwb_yoW3trb_tF
	yDCF95JFW7XFyrAFy3Xr4DA348Jr4jyw1UJF1DJFWjqr17Jr15Jr1UAw4jqry5Zr43Gr1U
	AryUZrW8Jr18AjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVkFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
	r21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUjuHq7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/11/07 20:58, Yu Kuai Ð´µÀ:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Changes in v2:
>   - remove patch 4;
> 
> Yu Kuai (3):
>    tests/05r1-re-add-nosuper: remove bitmap file test
>    mdadm: remove bitmap file support
>    mdadm: add support for new lockless bitmap

Dame, I wanted to remove patch 4, but actually, patch 1 was removed. :(
My bad.

My apologize for the noise.
Kuai
> 
>   Assemble.c                | 33 +-------------
>   Build.c                   | 35 +--------------
>   Create.c                  | 42 ++++-------------
>   Grow.c                    | 95 +++++----------------------------------
>   Incremental.c             | 37 +--------------
>   bitmap.c                  | 44 +++++++++---------
>   bitmap.h                  |  1 +
>   config.c                  | 17 ++++---
>   mdadm.c                   | 83 ++++++++++++++++------------------
>   mdadm.h                   | 19 +++++---
>   tests/05r1-re-add-nosuper |  5 +--
>   11 files changed, 113 insertions(+), 298 deletions(-)
> 

