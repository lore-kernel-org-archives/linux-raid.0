Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3012519882F
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 08:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730967556; cv=none; b=K8yGgWKgGlzqY5gQJ0jbFgaefiHX+Ke2PZl5Nu0RLoh5UJtWyprSRTx6thC21rfg4gI8PANW5m+NS9lye+8Ta0LQNclw/a75CjdFamuAJt40nSSv8XuwLtJQU0rciF+T3olh7pX/uUuT+mDlkv7Vtc61T+nHCXDDJ8J3uPLMXog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730967556; c=relaxed/simple;
	bh=m4+HbPl4Ka87+c18fq6dglPpsXOwsT6zTAOfGOlx8lI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=tXAwSXdK0Swrs4HHfKOGdyiI0U4X6xHA9zMIGofuzdwuwc+bjwmfbgYtjxHylgYvIxZHsGtxPosCQ2e/sVCc7I1RnEzFAWvXxdS42PVVLftQwD6XRmh9LYC+ha2CnmgXSJhVosQtHNP/cNZnejWeOSNRoVGLxT/+C1Fz0EKyjWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XkZjF6ppPz4f3kq8
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 16:18:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D81801A018D
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 16:19:10 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXc4f9dyxnHP1fBA--.64938S3;
	Thu, 07 Nov 2024 16:19:10 +0800 (CST)
Subject: Re: [PATCH mdadm/master v2 0/4] remove bitmap file support and
 reserve major number for lockless bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>, mariusz.tkaczyk@linux.intel.com,
 linux-raid@vger.kernel.org
Cc: yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241107081347.1947132-1-yukuai1@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <00ca05a7-188f-a45e-bf70-8b8a5fc4d3ac@huaweicloud.com>
Date: Thu, 7 Nov 2024 16:19:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241107081347.1947132-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXc4f9dyxnHP1fBA--.64938S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtw1UJw1kAry8AFykKw4DJwb_yoWfZFgEkF
	yDAFZ5JFW7XFyrAFy7Xr4DZ3yUJr4jyw1UJF1DJFWIqr17Jr13Jr1UA3yjqr1rXr47Gr17
	AryUG348Jr10yjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUSNtxUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi, all!

the title "mdadm/master v2" is used in downstream, and I forgot to
remove it, please ignore it and this is the fist version of the set.

Thanks,
Kuai

ÔÚ 2024/11/07 16:13, Yu Kuai Ð´µÀ:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Yu Kuai (4):
>    tests/04update-uuid: remove bitmap file test
>    tests/05r1-re-add-nosuper: remove bitmap file test
>    mdadm: remove bitmap file support
>    mdadm: add support for new lockless bitmap
> 
>   Assemble.c                | 33 +-------------
>   Build.c                   | 35 +--------------
>   Create.c                  | 40 ++++-------------
>   Grow.c                    | 95 +++++----------------------------------
>   Incremental.c             | 37 +--------------
>   bitmap.c                  | 44 +++++++++---------
>   bitmap.h                  |  1 +
>   config.c                  | 17 ++++---
>   mdadm.c                   | 83 ++++++++++++++++------------------
>   mdadm.h                   | 19 +++++---
>   tests/04update-uuid       | 34 --------------
>   tests/05r1-re-add-nosuper |  5 +--
>   12 files changed, 112 insertions(+), 331 deletions(-)
> 

