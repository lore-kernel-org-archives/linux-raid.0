Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2299FBF0;
	Mon, 22 Sep 2025 01:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758504283; cv=none; b=E6RYJpT15eAYJl2wggOOYhn1QFHeD6rJ+rx6hGJdit1cDqOQYkl94RYAbpzT+krA1XrhL6Bct4uxkuT6uY/nN41AnNdfMzBfM4fYuC9wICTNacxRgghhIfHPqumDAdmgh0/akP/+SSuUdYN0+x5o9K0wcfJcpRJly7KUE7v9A5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758504283; c=relaxed/simple;
	bh=u7I54J6dlUtVrzTSG2aWj3ZgdTbbaoQj6MaWlqSJ0aM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=vGDNKhs6AXwNUPIKQJLzsfb4rAY1GrSyGfL+/03KOJMUzgWJUzIzIig0vF6LmUiYcPg4y935L/i24nmyXPqEzRjy31DpQlPJP/ahatxyzUZ3Ftyb2V7gB/fLa6Cb+/J7SJkCAbi/a8bB61BvHKY0ZEUt6TRD6G0hU2bHIG51MAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cVQPm4q1XzKHMVb;
	Mon, 22 Sep 2025 09:24:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A85261A0EED;
	Mon, 22 Sep 2025 09:24:31 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHi2NNpdBorvCUAQ--.16078S3;
	Mon, 22 Sep 2025 09:24:31 +0800 (CST)
Subject: Re: [PATCH 1/7] md: factor error handling out of md_done_sync into
 helper
To: linan666@huaweicloud.com, song@kernel.org, neil@brown.name,
 namhyung@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250917093508.456790-1-linan666@huaweicloud.com>
 <20250917093508.456790-2-linan666@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9da425ac-1a9b-29f8-f390-7aea0033a08c@huaweicloud.com>
Date: Mon, 22 Sep 2025 09:24:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250917093508.456790-2-linan666@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHi2NNpdBorvCUAQ--.16078S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GFy5Ww15Gr1UZrW7GF4UArb_yoW3XrgE9F
	Z29Fyftr4xXF1xXFy5WrnavrWUCF4qqF1UXF9FqrW5Xw13XFy8GF1kK3yrX3WrXFZrZr15
	AFyjyFW8AryIyjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/09/17 17:35, linan666@huaweicloud.com Ð´µÀ:
> From: Li Nan<linan122@huawei.com>
> 
> The 'ok' parameter in md_done_sync() is redundant for most callers that
> always pass 'true'. Factor error handling logic into a separate helper
> function md_sync_error() to eliminate unnecessary parameter passing and
> improve code clarity.
> 
> No functional changes introduced.
> 
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/md.h     |  3 ++-
>   drivers/md/md.c     | 17 ++++++++++-------
>   drivers/md/raid1.c  | 17 ++++++++---------
>   drivers/md/raid10.c | 11 ++++++-----
>   drivers/md/raid5.c  | 14 ++++++++------
>   5 files changed, 34 insertions(+), 28 deletions(-)

LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

