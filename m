Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0E923DE;
	Sat, 14 Jun 2025 06:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749883497; cv=none; b=XhIFvxFkRIj7w+s/A4KcXPzIt43RYT6axDm24LjQ4aEeRQsAD8Re26wQDVK5cr4DOAEdOvQA9U67ErUysO9pEsjEOw5M2S4cSPR756PGYC9X7x7BzlCtvvp4jzmrJx+gl6OJmAKzyTlPASBZgVpLkfNEjgIces8Qut+aZDvengI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749883497; c=relaxed/simple;
	bh=Jy1nSQ7r/pyShcJrvt4lMFfaq587W/OtliNaZYNxyRI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ssEcRsZrAdmYcz1vWNPUv4fzhY9ayZyBg3vdU6nlYDxtJ+3TiyCPn6jjmM5WeCQgLpGxcEAhupMZvcrYz62JnQnlrVJI1SHHvlEgEqPHxVLIjyQyPDjQP4Hu2isW4w+e+fwmAkQQHSTZWiyadx5n95wmtYh2JUPm1VpVkeXDmXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bK6Fc47H7zYQvlY;
	Sat, 14 Jun 2025 14:44:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8B6961A0AD5;
	Sat, 14 Jun 2025 14:44:51 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXu19iGk1oABvjPQ--.61665S3;
	Sat, 14 Jun 2025 14:44:51 +0800 (CST)
Subject: Re: [PATCH v3] md/raid1: Fix stack memory use after return in
 raid1_reshape
To: Wang Jinchao <wangjinchao600@gmail.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250612112901.3023950-1-wangjinchao600@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <09e06a94-5cb1-3afc-34b3-200becdc8e12@huaweicloud.com>
Date: Sat, 14 Jun 2025 14:44:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250612112901.3023950-1-wangjinchao600@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXu19iGk1oABvjPQ--.61665S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GFy8Zr1DJw1xKw4kWFyfZwb_yoWkuFbEga
	s8ta4furyYgFyrGFWjyryDZrWIka93AF1UGF1Ygrsxu3yFyrW7Zw4IvFy5Xr1fuw45Kr4U
	Ja1UW3WUAryj9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4AYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1yE_t
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/06/12 19:28, Wang Jinchao Ð´µÀ:
> In the raid1_reshape function, newpool is
> allocated on the stack and assigned to conf->r1bio_pool.
> This results in conf->r1bio_pool.wait.head pointing
> to a stack address.
> Accessing this address later can lead to a kernel panic.
> 
> Example access path:
> 
> raid1_reshape()
> {
> 	// newpool is on the stack
> 	mempool_t newpool, oldpool;
> 	// initialize newpool.wait.head to stack address
> 	mempool_init(&newpool, ...);
> 	conf->r1bio_pool = newpool;
> }
> 
> raid1_read_request() or raid1_write_request()
> {
> 	alloc_r1bio()
> 	{
> 		mempool_alloc()
> 		{
> 			// if pool->alloc fails
> 			remove_element()
> 			{
> 				--pool->curr_nr;
> 			}
> 		}
> 	}
> }
> 
> mempool_free()
> {
> 	if (pool->curr_nr < pool->min_nr) {
> 		// pool->wait.head is a stack address
> 		// wake_up() will try to access this invalid address
> 		// which leads to a kernel panic
> 		return;
> 		wake_up(&pool->wait);
> 	}
> }
> 
> Fix:
> reinit conf->r1bio_pool.wait after assigning newpool.
> 
> Signed-off-by: Wang Jinchao<wangjinchao600@gmail.com>
> ---

Applied to md-6.16, with a fix tag:
Fixes: afeee514ce7f ("md: convert to bioset_init()/mempool_init()")

Thanks,
Kuai

