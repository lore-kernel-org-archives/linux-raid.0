Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B42D224249;
	Sat, 31 Jan 2026 01:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769823951; cv=none; b=JOUm8h3hYnjN9TSE73CkKvnbGzHt5Azxaz6DFh3zN6LC/y4qpSdYmMFMgS6fz28iYi9vwe0A6Q9HanvpcQBjBp8c6TEVV+fLgy3YJ6Ns6tub/eZkwBNrOJKQz/vHKrFMAtKrUyf6vfVr+aytu0XnmxxFqNyTrhE10FssDPp1lr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769823951; c=relaxed/simple;
	bh=nIjhjI4ffp0wbH4ZNdETU8VceDsxEtvCF/+vfQtGfis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lIT3JIdh+FXpAd2QCKjnRJrD/kRnyULRMjuw6NZKgU+FYmSHS7ZN2Yx5ys9zSpBWBIH2HIdIJ9CWcZ5kwE7HKbIRBMiG/yHsFAx3So6wbRIvT2ch2dNqetmWAz5+xxPgFY5D7qgTkGvw+g+3XUYu3m0s8X2UOb/n+a/aZUJFCQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f2wgZ3xP1zKHLy6;
	Sat, 31 Jan 2026 09:45:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EBDCB40570;
	Sat, 31 Jan 2026 09:45:46 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvfJXn1pfo_dFg--.26823S3;
	Sat, 31 Jan 2026 09:45:46 +0800 (CST)
Message-ID: <9d522ca3-30ab-f86d-4e50-f29d780e148d@huaweicloud.com>
Date: Sat, 31 Jan 2026 09:45:45 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md/raid1: fix memory leak in raid1_run()
To: Zilin Guan <zilin@seu.edu.cn>, song@kernel.org
Cc: yukuai@fnnas.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, jianhao.xu@seu.edu.cn
References: <20260126071533.606263-1-zilin@seu.edu.cn>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260126071533.606263-1-zilin@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBnFvfJXn1pfo_dFg--.26823S3
X-Coremail-Antispam: 1UD129KBjvJXoW7JryrZr4fJFWkKr4fGFyUKFg_yoW8JrW3p3
	yrWa4avw45tr47uFWDZFWkuFy5Zw1xWFWj9Fy7J343XF1xGFW5Gay5WFyjgr1DZr1rXryY
	q3W5C3ykuayqgFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU90b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
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
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
	VFxhVjvjDU0xZFpf9x07UMnQUUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/26 15:15, Zilin Guan 写道:
> raid1_run() calls setup_conf() which registers a thread via
> md_register_thread(). If raid1_set_limits() fails, the previously
> registered thread is not unregistered, resulting in a memory leak
> of the md_thread structure and the thread resource itself.
> 
> Add md_unregister_thread() to the error path to properly cleanup
> the thread, which aligns with the error handling logic of other paths
> in this function.
> 
> Compile tested only. Issue found using a prototype static analysis tool
> and code review.
> 
> Fixes: 97894f7d3c29 ("md/raid1: use the atomic queue limit update APIs")
> Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
> ---
>   drivers/md/raid1.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 57d50465eed1..cc9914bd15c1 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3254,6 +3254,7 @@ static int raid1_run(struct mddev *mddev)
>   	if (!mddev_is_dm(mddev)) {
>   		ret = raid1_set_limits(mddev);
>   		if (ret) {
> +			md_unregister_thread(mddev, &conf->thread);
>   			if (!mddev->private)
>   				raid1_free(mddev, conf);
>   			return ret;

LGTM

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan

