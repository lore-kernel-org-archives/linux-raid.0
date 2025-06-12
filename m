Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265B124BC1A;
	Thu, 12 Jun 2025 13:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749735121; cv=none; b=mSJPGobn4I7RoqiNxUELoLDPyDvGZFaPuXWfjTg9UJ96Cuiw8PhtvOlfGbSwhIV/7dpDBTN/LYqDlVdkPO19JjwfjUgIY95PfZr46B9a88RIxAW6/AbMWG+QNX1Dg6BOT8d/2NFp8blfjg5Vv70xb3bDEQisJJ816pb6PXo0amM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749735121; c=relaxed/simple;
	bh=4XBTR3tXMk0mlSGr5EFbcGAWpRYuEk2tcJuT9EI25Ig=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Mm6gOAs3eZTAAii4KC+tzoVb1KoFDQnzpuvFLg+a4mbnS49H5VMYHzlJUWFmzQDlgr/dWqzNwDh3HTMQdm6e2AKaDVLen8nLoR3D2hLmy7AcWObuAw/A124+Bvv+RdVBvObmEuc6R0WMU7Ocbz9OOzwJmHTbMXyTqYSXW6GcQxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bJ3NH4qgPzKHNQV;
	Thu, 12 Jun 2025 21:31:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0AE571A1AAE;
	Thu, 12 Jun 2025 21:31:58 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXvGDM1kpoSLwwPQ--.18023S3;
	Thu, 12 Jun 2025 21:31:57 +0800 (CST)
Subject: Re: [PATCH] md/raid1,raid10: fix IO handle for REQ_NOWAIT
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, zhengqixing@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250612132141.358202-1-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <db90914c-fc75-736b-1e48-012896a5aed7@huaweicloud.com>
Date: Thu, 12 Jun 2025 21:31:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250612132141.358202-1-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXvGDM1kpoSLwwPQ--.18023S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYs7kC6x804xWl14x267AKxVW8JVW5JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
	64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r
	1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxAqzxv26xkF7I0En4kS14v26r126r1DMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/06/12 21:21, Zheng Qixing Ð´µÀ:
> From: Zheng Qixing<zhengqixing@huawei.com>
> 
> IO with REQ_NOWAIT should not set R1BIO_Uptodate when it fails,
> and bad blocks should also be cleared when REQ_NOWAIT IO succeeds.
> 
> Fixes: 9f346f7d4ea7 ("md/raid1,raid10: don't handle IO error for REQ_RAHEAD and REQ_NOWAIT")
> Signed-off-by: Zheng Qixing<zhengqixing@huawei.com>
> ---
>   drivers/md/raid1.c  | 11 ++++++-----
>   drivers/md/raid10.c |  9 +++++----
>   2 files changed, 11 insertions(+), 9 deletions(-)

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

