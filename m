Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85201256C73;
	Fri, 13 Jun 2025 09:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749805893; cv=none; b=WZxLr1gM2y1umy0jjvmf26hiEHKjNhJM+zGGhRhfbGoJcOeKLXRiNTpdhiCu2kPoYSzCz9ft2wKc7hIrM0O6mQVjVXUwD2retgZ5cUvIU13Svz6NNwc6fTPcB3mGZtTNBJua/WQUwycj+eaTKZjdud/tdUS71pXISt8nnJNwsmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749805893; c=relaxed/simple;
	bh=i34cmjezwzO2f5jezewBTk/yp95zlDdQxhD7JbGGiXs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YuVy3MRZW7thdhtOt3qbS5B8ssaIbuZE1NcLhJvznsrGABv6KkGdRyxw3hlXlyxIoWUMziabYqxagvg7CSEGQYs24WqoCZJZmaKqOKEJexLn8x131fXDEndAwAAKE0Zsxpbu6URxL5JedydVSKVyoY9dgMveXBPkM8Eaae4KVRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bJYYD4n7JzYQvjG;
	Fri, 13 Jun 2025 17:11:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9F61D1A13EF;
	Fri, 13 Jun 2025 17:11:27 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB32l4+60todFqGPQ--.30169S3;
	Fri, 13 Jun 2025 17:11:27 +0800 (CST)
Subject: Re: [PATCH v3] md/raid1: Fix stack memory use after return in
 raid1_reshape
To: Wang Jinchao <wangjinchao600@gmail.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250612112901.3023950-1-wangjinchao600@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e7879f0b-9206-4e91-7d2d-d39ec64736b3@huaweicloud.com>
Date: Fri, 13 Jun 2025 17:11:25 +0800
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
X-CM-TRANSID:gCh0CgB32l4+60todFqGPQ--.30169S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GFy8Zr1DJw1xKw4kWFyfZwb_yoWkZrb_Ka
	s0ya4furWaqFyrKFW5ArWDZrWIkas5AF1UGF1Ygrsxua9YvrW7Xw40vFyDXr13u3yDKr4U
	Aa17W3WUAryq9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbx8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jjVb
	kUUUUU=
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
> Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
> ---
>   drivers/md/raid1.c | 1 +
>   1 file changed, 1 insertion(+)
> 

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

