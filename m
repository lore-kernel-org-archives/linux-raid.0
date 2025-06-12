Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7FE22B5B8;
	Thu, 12 Jun 2025 11:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749727446; cv=none; b=MoqWjgW4RR/61UPwdgi8dEoG7X3hRKKwT7Ve+qYVdnBPtAg/eXZaLVTkkPCIZK7LpzTqk4GMptMZx+thV29dM3W8gEWB1dtMiCx4KGesnBCKCXoPZgB5k/44lBhEpqMTN1gRJDOrGVkoZsSkXn0Cpr0akaoi/5gxqPcmmn5Jvgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749727446; c=relaxed/simple;
	bh=b1dpQxEoPH0te7nskbJ5fWXIG13EjgExVWrw7POfxI4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qWd865xircWKp8HJtw6jzxZ80de7nwscDwBg9Zi5MtKtF6FAhCM3xqn893K3LG/GbZK9E4bjlT7j1KmKM9Ww34vZIGkKtE0yr0BDCF/V6SmiBsyTZdnlNY3l2b9W8hI994WWZ5YnhQQnxAG7HLEVwOx1bSVXhPCKaF5IO06Py0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bJ0Xg12mWzKHLvL;
	Thu, 12 Jun 2025 19:24:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 79E811A01A2;
	Thu, 12 Jun 2025 19:24:01 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2DPuEpoYIcnPQ--.22416S3;
	Thu, 12 Jun 2025 19:24:01 +0800 (CST)
Subject: Re: [PATCH v2] md/raid1: Fix stack memory use after return in
 raid1_reshape
To: Wang Jinchao <wangjinchao600@gmail.com>, Yu Kuai
 <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250611090203.271488-1-wangjinchao600@gmail.com>
 <5143c5c3-3a77-919f-0d38-8adb0e8923e9@huaweicloud.com>
 <06935480-a959-4e3f-8e41-286d7f54754a@gmail.com>
 <9c7d5e66-4f5f-b984-c291-f19c3d568b85@huaweicloud.com>
 <938b0969-cace-4998-8e4a-88d445c220b1@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8a876d8f-b8d1-46c0-d969-cbabb544eb03@huaweicloud.com>
Date: Thu, 12 Jun 2025 19:23:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <938b0969-cace-4998-8e4a-88d445c220b1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2DPuEpoYIcnPQ--.22416S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZrW3Zr48Wr4rGF1fGr15urg_yoW3urXEkF
	yqgrWIga4UX3Z7u343KF45XrZ8Ka18uryUCayUKFnxXFyvva9xuan2q34ftrWrWrWUJFn0
	9r9ru3yfZwsagjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/06/12 17:55, Wang Jinchao 写道:
> Now that we have the same information, I prefer patch-v1 before 
> refactoring raid1_reshape,
> because it’s really simple (only one line) and clearer to show the 
> backup and restore logic.
> Another reason is that v2 freezes the RAID longer than v1.
> Would you like me to provide a v3 patch combining the v2 explanation 
> with the v1 diff?
> Thanks for your reviewing.

I don't have preference here, feel free to do this.

BTW, I feel raid1_reshape can be better coding with following：

- covert r1bio_pool to use mempool_create_kmalloc_pool(use create
instead of init to get rid of the werid assigment);
- no need to reallocate pool_info;
- convert raid1_info to use krealloc;

Welcome if you are willing to, otherwise I'll find myself sometime.

Thanks,
Kuai

