Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE345201278
	for <linux-raid@vger.kernel.org>; Thu, 11 Sep 2025 06:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757571800; cv=none; b=nl2mDpNdlr86G5CsX6oTeXXmGu9NysXHKmcOcwMP8R2h9BjMaM3RKAH4clfinV9KIAZ1jiPcjjzA0JQsiJ51OP6mXiFImAzHfnYuPi6qYwC5OoAeFjg5dTRanD/DBe6joSTAF4mJJkLYFQgFnsZQySBNsMG2GAs6Ea3HR2CDZ14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757571800; c=relaxed/simple;
	bh=HReqm7r8UoANRj0E+BytMuUlXGNGcf6fDhR6GOW0fSk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mXGkOMwYBz3/7n50TCdwmNlOMM3oGDlQsc56bOBobaXoWs1h1/Y/SqT9g+HYaBD9hPvIz5H2vhYhCrWkSBgSSRXG5XFEzaKKPa6T0m9RWwrSmvTJDcl1I51CDkT9GGnM5DRcp+OWwhsqHMWriqzDsaEBkwLH7tpDQkGT7UnSPAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cMnYZ25xPzKHN8F
	for <linux-raid@vger.kernel.org>; Thu, 11 Sep 2025 14:23:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8F9041A0EF7
	for <linux-raid@vger.kernel.org>; Thu, 11 Sep 2025 14:23:14 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3QY7QasJoSUZ6CA--.14635S3;
	Thu, 11 Sep 2025 14:23:14 +0800 (CST)
Subject: Re: [PATCH v2] Factor out code into md_should_do_recovery()
To: Wu Guanghao <wuguanghao3@huawei.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, yangyun50@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <e62894c8-d916-94bc-ef48-3c60e6e1fc5d@huawei.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d668bc92-e59d-a571-fec7-4e3a6df24b66@huaweicloud.com>
Date: Thu, 11 Sep 2025 14:23:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <e62894c8-d916-94bc-ef48-3c60e6e1fc5d@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3QY7QasJoSUZ6CA--.14635S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYs7kC6x804xWl14x267AKxVWUJVW8JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
	64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r
	1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxAqzxv26xkF7I0En4kS14v26r126r1DMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7IU1QVy3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

在 2025/09/08 16:20, Wu Guanghao 写道:
> In md_check_recovery(), use new helper to make code cleaner.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Thanks

