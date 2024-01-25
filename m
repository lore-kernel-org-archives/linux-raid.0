Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96ADB32C8E;
	Thu, 25 Jan 2024 11:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706183360; cv=none; b=aVMg5KKRrvYz+mCd7pLoOFnOBQCGqL9Rvam6pZZOwdGgHBI4/swiimhM7a2/o6XT9Rl1sh8D92ufuzZQaH5GDFlfFtQ9zetTSznb8qCv+8EEOMnVt9UBa56c0EzPTn6jfSqUDrv6hBpu9zSl35T7KtBV4mGhC0R4IFCRsIjCrPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706183360; c=relaxed/simple;
	bh=a51wMHyp9p9cQVXYs2hDxYUfcxrI91RuHY0/MM1hPcg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Hj4sVDu3PANY2fml+Eg6Qqfv5bIgDm6XbF0iMQy2OBX01Sx9SBCzngfHHBAStf2TPRLsOqc0JR+8ShFKssQYsB8m1l8hGr9X7DZurcXXectTt+JJpVl6fqeKC4LLXBw7K+1ZmEwwpUHQZwoSTRKzsGhmnYWNS2QH+RU7YHROuwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4TLJyC0vhfz4f3lD2;
	Thu, 25 Jan 2024 19:49:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 728AB1A0199;
	Thu, 25 Jan 2024 19:49:13 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX5g62SrJlKdC9Bw--.7991S3;
	Thu, 25 Jan 2024 19:49:11 +0800 (CST)
Subject: Re: [PATCH] Revert "Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING
 in raid5d""
To: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com, Dan Moulding <dan@danm.net>,
 stable@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240125082131.788600-1-song@kernel.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <626f3f93-7085-7bd4-2172-3f97fcf197c9@huaweicloud.com>
Date: Thu, 25 Jan 2024 19:49:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240125082131.788600-1-song@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX5g62SrJlKdC9Bw--.7991S3
X-Coremail-Antispam: 1UD129KBjvJXoWrtFW8Kr4rGw48ZF18KF1DGFg_yoW8Jr47pF
	yxCF45WrWkGr1xuas8A3yUZFWrZFs7Zr13Wr93tr48Jr4j9Fy2g3WxKrs3XF1jvrZa9FWq
	qFsxWryvya40yrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Zr0_Wr1UMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZa9-UUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/01/25 16:21, Song Liu Ð´µÀ:
> This reverts commit bed9e27baf52a09b7ba2a3714f1e24e17ced386d.
> 
> The original set [1][2] was expected to undo a suboptimal fix in [2], and
> replace it with a better fix [1]. However, as reported by Dan Moulding [2]
> causes an issue with raid5 with journal device.
> 
> Revert [2] for now to close the issue. We will follow up on another issue
> reported by Juxiao Bi, as [2] is expected to fix it. We believe this is a
> good trade-off, because the latter issue happens less freqently.
> 
> In the meanwhile, we will NOT revert [1], as it contains the right logic.
> 
> Reported-by: Dan Moulding<dan@danm.net>
> Closes:https://lore.kernel.org/linux-raid/20240123005700.9302-1-dan@danm.net/
> Fixes: bed9e27baf52 ("Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"")
> Cc:stable@vger.kernel.org  # v5.19+
> Cc: Junxiao Bi<junxiao.bi@oracle.com>
> Cc: Yu Kuai<yukuai3@huawei.com>
> Signed-off-by: Song Liu<song@kernel.org>
> 
> [1] commit d6e035aad6c0 ("md: bypass block throttle for superblock update")
> [2] commit bed9e27baf52 ("Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"")

LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

