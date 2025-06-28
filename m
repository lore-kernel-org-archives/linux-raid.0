Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2749A136A;
	Sat, 28 Jun 2025 03:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751080722; cv=none; b=aTbr6C03yswKqMaWwbfJxraBRBz3W5v4ORhBMRxWlXBz7o4WNusMZJsa8gy+q3a/T7xOdbjlWiIAI7vtE4AStR7NGkuDNgrLojIz904tQLI6bxWsEsoqQ4OBInQ278K7Ir6VHqYAr7UWrw56yP31CjVd+OOT927YSL55eYFufqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751080722; c=relaxed/simple;
	bh=LMjdSbGA/e6LNTP0yF+ViIgHEHwfBXX1Z3SHNAIhB1A=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=LUJMcyAlweNJTsllQ09ps3rO4pBAeuuE/fjmQJkXHgR5pGuvuaEEnn6CIY32FWjccKB2X00y6GiI3q3DGnING6p0kURZcQVrrjNGd4UaQyqh2pN4UFF/a3PKl/LLe+wvuq0C94SOliHDygjl/APcIvns5ZJ25OX/x1edH8sBzBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bTd1C2yMSzYQtdR;
	Sat, 28 Jun 2025 11:18:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4E1BF1A058E;
	Sat, 28 Jun 2025 11:18:38 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2ANX19oMHuGQw--.61366S3;
	Sat, 28 Jun 2025 11:18:38 +0800 (CST)
Subject: Re: [PATCH v3 2/2] md/raid1: remove struct pool_info and related code
To: Wang Jinchao <wangjinchao600@gmail.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250624015604.70309-1-wangjinchao600@gmail.com>
 <20250624015604.70309-2-wangjinchao600@gmail.com>
 <20250624015604.70309-3-wangjinchao600@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ea599d7b-c992-5e02-6b35-f7b8d9352c0c@huaweicloud.com>
Date: Sat, 28 Jun 2025 11:18:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250624015604.70309-3-wangjinchao600@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2ANX19oMHuGQw--.61366S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Xw15Zr1fWFy7JF4xtFy3twb_yoWxKrb_AF
	yrtFyxXr18GF1xGFy7Wr47Zry0y3yFgr4jka1UtF45X3ZxZr98Gr1DJrW3Xr4j9FZrtr45
	AFyDJw18Ar97ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbx8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UtR6
	wUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/06/24 9:55, Wang Jinchao Ð´µÀ:
> The struct pool_info was originally introduced mainly to support reshape
> operations, serving as a parameter for mempool_init() when raid_disks
> changes. Now that mempool_create_kmalloc_pool() is sufficient for this
> purpose, struct pool_info and its related code are no longer needed.
> 
> Remove struct pool_info and all associated code.
> 
> Signed-off-by: Wang Jinchao<wangjinchao600@gmail.com>
> ---
>   drivers/md/raid1.c | 49 +++++++++++++---------------------------------
>   drivers/md/raid1.h | 20 -------------------
>   2 files changed, 14 insertions(+), 55 deletions(-)

Nice cleanup.
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

