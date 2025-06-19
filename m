Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CD3265CBA;
	Thu, 19 Jun 2025 09:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750323731; cv=none; b=qg4rf0XTuSDuAlRjFDVFpqvetraalOMxNMlbgsplXcbmD+gcedx4MXUFumfwKMgLTijfaEZny02G80bGoB+vAPIVVfEafswppErTZ5sJN7d3+WQOKfXNWZcXvvQLLeK5bHFw0PQutJhjRSaE6V02Fq37f2yJProp7OFkHGa4gDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750323731; c=relaxed/simple;
	bh=/SrVutFJMi1XQKScdI4S6xcHhXEXLISliQsvVljZrOU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PmO0AEe6CcGUuQR1WaVZxtBSyAXJare4dzg+KHjoasFB7sE0xLIjrsziDaXQM4N37Sb6ZbCDYR31fF1A5L/aO9/P/Pw23+9XstonZRyzELV0VbDYHdY7EvLxlQHMfL93HzkbXsezj7DWqtLRm0sPbQI00LFAgdV3G+HRm1TeBL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bNF3d4MBzzYQw3h;
	Thu, 19 Jun 2025 17:02:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8A5351A084E;
	Thu, 19 Jun 2025 17:02:04 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2AK0lNo8DL0Pw--.61434S3;
	Thu, 19 Jun 2025 17:02:04 +0800 (CST)
Subject: Re: [PATCH] md/raid1: change r1conf->r1bio_pool to a pointer type
To: Wang Jinchao <wangjinchao600@gmail.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250618114120.130584-1-wangjinchao600@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <60ab8135-b22b-169e-cfbe-19abf7257d88@huaweicloud.com>
Date: Thu, 19 Jun 2025 17:02:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250618114120.130584-1-wangjinchao600@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2AK0lNo8DL0Pw--.61434S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYs7kC6x804xWl14x267AKxVWUJVW8JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
	64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r
	1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxAqzxv26xkF7I0En4kS14v26r126r1DMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/06/18 19:41, Wang Jinchao Ð´µÀ:
> In raid1_reshape(), newpool is a stack variable.
> mempool_init() initializes newpool->wait with the stack address.
> After assigning newpool to conf->r1bio_pool, the wait queue
> need to be reinitialized, which is not ideal.
> 
> Change raid1_conf->r1bio_pool to a pointer type and
> replace mempool_init() with mempool_create() to
> avoid referencing a stack-based wait queue.

Can you also switch to kmalloc pool in this patch?

Thanks,
Kuai

