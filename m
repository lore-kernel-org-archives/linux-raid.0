Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064456FC5
	for <linux-raid@vger.kernel.org>; Fri, 14 Feb 2025 01:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739495413; cv=none; b=lNR2eQW1opSWXw2dbWhir/J1s5o6h3XwOyVHo3VY/xER8fa+fNk/aeX5nkB3x5BX7muB6+eZq5kCnmDtuMeaUaF0S5Fcukfk1J1gD0JDIoNekDAA6VLZzki3/dHwNiVM0McECx6i96bc63/ZMfHXpFOyQScTccKcLVYMXiySIL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739495413; c=relaxed/simple;
	bh=uOjbiwCgW6q87a8dFbk/G4i0o6HhYPLT48wfg6S/q0U=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=S6djNPIq7Io3se+HYkS9pWu9F6kiJD31jAG3Fx9RnXqt1kR7zg9jVnE8AeBYzmHc0Wn9StiIgOr+XZHXS+hKxIPskZL4eDNENTcclpV8aKkd335pqQxCOH5dwpOc7ePqH4daMRzTV/qF9Sf4lesNKoOarm7rtRtwqREArOk+eAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YvDVF5MLLz4f3l2g
	for <linux-raid@vger.kernel.org>; Fri, 14 Feb 2025 09:09:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 287461A101A
	for <linux-raid@vger.kernel.org>; Fri, 14 Feb 2025 09:10:03 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgA3m1_pl65n3lcgDw--.27967S3;
	Fri, 14 Feb 2025 09:10:02 +0800 (CST)
Subject: Re: [PATCH] md/raid*: Fix the set_queue_limits implementations
To: Bart Van Assche <bvanassche@acm.org>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250212171108.3483150-1-bvanassche@acm.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <51de05b9-8803-7cab-de22-4aff7bbe6b18@huaweicloud.com>
Date: Fri, 14 Feb 2025 09:10:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250212171108.3483150-1-bvanassche@acm.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3m1_pl65n3lcgDw--.27967S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GFW8Kr15Zr4UuF1DKry5twb_yoWxurX_C3
	Zavr98K39Fyr1Ivwn8uw4xZFyIk3W8WwnrXF43K3y3Xr93GFZ5G3W0k34fCa4UZay5KF9x
	XFn2g34rA3s3XjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4AYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHD
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/



ÔÚ 2025/02/13 1:11, Bart Van Assche Ð´µÀ:
> queue_limits_cancel_update() must only be called if
> queue_limits_start_update() is called first. Remove the
> queue_limits_cancel_update() calls from the raid*_set_limits() functions
> because there is no corresponding queue_limits_start_update() call.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Fixes: c6e56cf6b2e7 ("block: move integrity information into queue_limits")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/md/raid0.c  | 4 +---
>   drivers/md/raid1.c  | 4 +---
>   drivers/md/raid10.c | 4 +---
>   3 files changed, 3 insertions(+), 9 deletions(-)
> [...]

Applied to md-6.14, thanks!

Kuai

