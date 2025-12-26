Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36F51448D5;
	Fri, 26 Dec 2025 06:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766730849; cv=none; b=Gq1zv2Zrz4hkPvTZn3i4NYTU7F2H/1BccNu+vNS0/HLpwW/86K80+jFFkXYYobucMALbdjvptQXbuB/vxY9u3QI0//QStp5h5nkBuK/COJ8xgCUuBNmE2gVJzP6uMeEjte+uSr2LqBkXkNCdhu/p2avRlF5dYcDmnVVL5Kyf5LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766730849; c=relaxed/simple;
	bh=9MIdazXnMQlHAvltCRk+2EyaZIIznSjcMYtaLY0s88g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HB8ycIH9NBSFiQv2cTgP440vZwedGFtKS+WeubAZ146baXq8as06J2G+EUxz2hMLzET4aQNiStZjwWFe0vnKBqw3on3XBIJmyfN/6cPXq7DmCvDq0VYUCxWz+nqmduHNfPa/WqSZ4z8WXbthnBWwWUx/exI/sYFXsWR9mcp2QI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dcwmf2vkYzKHLtk;
	Fri, 26 Dec 2025 14:33:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DD4CE40590;
	Fri, 26 Dec 2025 14:34:00 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgBHp_dXLE5pn84YBg--.9786S3;
	Fri, 26 Dec 2025 14:34:00 +0800 (CST)
Message-ID: <958c80df-2d34-37fd-4849-a313d1a2a1c1@huaweicloud.com>
Date: Fri, 26 Dec 2025 14:33:59 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 03/11] md: merge mddev serialize_policy into
 mddev_flags
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, filippo@debian.org, colyli@fnnas.com
References: <20251124063203.1692144-1-yukuai@fnnas.com>
 <20251124063203.1692144-4-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251124063203.1692144-4-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHp_dXLE5pn84YBg--.9786S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYP7kC6x804xWl14x267AKxVW8JVW5JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY
	6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr
	0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxG
	rwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxAqzxv26xkF7I0En4kS14
	v26r126r1DMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2Iq
	xVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42
	IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY
	6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aV
	CY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1VOJ7UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/11/24 14:31, Yu Kuai 写道:
> There is not need to use a separate field in struct mddev, there are no
> functional changes.
> 
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/md-bitmap.c |  4 ++--
>   drivers/md/md.c        | 20 ++++++++++++--------
>   drivers/md/md.h        |  4 ++--
>   drivers/md/raid0.c     |  3 ++-
>   drivers/md/raid1.c     |  4 ++--
>   drivers/md/raid5.c     |  3 ++-
>   6 files changed, 22 insertions(+), 16 deletions(-)
> 


LGTM

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan

