Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF1124B26;
	Sat, 14 Jun 2025 06:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749883378; cv=none; b=NvZIuMmgR1Rnn5SAYrVXEJghCiInOoZeDZ029JUmZfR4hnxFT1vLMTqOpExxfnRnq0c8VbYJPzu2hNe/lAoTsFmJkFwF6vgoxAsn9oUHpc+G2HHJb9GnkPqpkapzpldyaR9ib9NGjq1MO3gZNsQshTDx/ZNVX5ukI6lxYiyz3vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749883378; c=relaxed/simple;
	bh=4YqGbpV/g5u5p8esWq4nz+FafNFM8aKGbIiewSNmH5Q=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=lKs5KoL20sEevC1+Mb4dOCVmIQcqW2RSl2PWi3AyhZFlcXj0NplTYY8JcKU5GtkbxWcKLGD1zLKZBgItDU0nhnRgzOJQcT9AEHP+k7lvtEV5hH3QZ7DjTcU/9SX0inth9fU+7Y9SLK2XN5NiKSVrQjtC8lcb5QRve/vxNVFHvVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bK6CM2XtfzKHN13;
	Sat, 14 Jun 2025 14:42:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B1FAC1A12F8;
	Sat, 14 Jun 2025 14:42:53 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXvGDsGU1oqPbiPQ--.43722S3;
	Sat, 14 Jun 2025 14:42:53 +0800 (CST)
Subject: Re: [PATCH] md/raid5: unset WQ_CPU_INTENSIVE for raid5 unbound
 workqueue
To: Ryo Takakura <ryotkkr98@gmail.com>, song@kernel.org, tj@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250601013702.64640-1-ryotkkr98@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f8b3e248-4d37-9828-032b-33aa7b0f7724@huaweicloud.com>
Date: Sat, 14 Jun 2025 14:42:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250601013702.64640-1-ryotkkr98@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXvGDsGU1oqPbiPQ--.43722S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYx7kC6x804xWl14x267AKxVW8JVW5JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7
	xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
	FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr
	0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxv
	r21l42xK82IYc2Ij64vIr41l4c8EcI0Ec7CjxVAaw2AFwI0_JF0_Jw1l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
	VFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/06/01 9:37, Ryo Takakura Ð´µÀ:
> When specified with WQ_CPU_INTENSIVE, the workqueue doesn't
> participate in concurrency management. This behaviour is already
> accounted for WQ_UNBOUND workqueues given that they are assigned
> to their own worker threads.
> 
> Unset WQ_CPU_INTENSIVE as the use of flag has no effect when
> used with WQ_UNBOUND.
> 
> Signed-off-by: Ryo Takakura<ryotkkr98@gmail.com>
> ---

Applied to md-6.16

Thanks
Kuai

