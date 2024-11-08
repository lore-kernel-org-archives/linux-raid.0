Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902B51401B
	for <linux-raid@vger.kernel.org>; Fri,  8 Nov 2024 01:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731030224; cv=none; b=hV3JKqAIcp5MafLbpIcdgJp5bA7LCKpyW3Jif3QW3ZXeUPVvlmdcS0t1UaeIkAnjX/lpfQihLJMHFSB93O0tbW7Yn7LTa8zuHMHs9mGYWQwr6REDCUbAc/HLPljdGDdCSXkL4EmyWWDy+AGeR/qy6Nu5z+eNFLn9C18Qp9J8M7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731030224; c=relaxed/simple;
	bh=0PmKv3caWeD6+ZntTlNwSzi2tRIIrFJmultiJP461zA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=C08mr93KX+vU+U7ZNvlkFLQeOBwTXO7CJ39amb4Txu6IeQelPRRPZoCvG6mL8toPcw9u0NWAHN6bkbkDWMIwjW/aLZNhNw4UiQwQ4GnPVLV2yxpKxoG1VRPsjjQ5uCtK6UEG2h+9n2sE7uUchjaHWA1Ik4/xbblKYRoRPwNtzTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xl1tP6R2Gz4f3kKT
	for <linux-raid@vger.kernel.org>; Fri,  8 Nov 2024 09:43:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CEC7B1A0194
	for <linux-raid@vger.kernel.org>; Fri,  8 Nov 2024 09:43:38 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHYobIbC1ne9ulBA--.26491S3;
	Fri, 08 Nov 2024 09:43:37 +0800 (CST)
Subject: Re: [PATCH] MAINTAINERS: Make Yu Kuai co-maintainer of md/raid
 subsystem
To: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241108014112.2098079-1-song@kernel.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <bba125d7-b4f4-f5cd-4190-11012e21e63c@huaweicloud.com>
Date: Fri, 8 Nov 2024 09:43:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241108014112.2098079-1-song@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHYobIbC1ne9ulBA--.26491S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtF1rZrW7Ar1rCF4kZF47Arb_yoW3CFXEkF
	WxurWfXFn3JFW2g348ur92vr4Fkw4fGr4xXasFy347Xa4Dtr95tw4Dt393Aw17Wr93Wayk
	A3WfXrsxKrW3XjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb48FF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbWCJPUUUU
	U==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/11/08 9:41, Song Liu Ð´µÀ:
> In the past couple years, Yu Kuai has been making solid contributions
> to md/raid subsystem. Make Yu Kuai a co-maintainer.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Thanks
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e9659a5a7fb3..eeaa9f59dfe3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -21303,7 +21303,7 @@ F:	include/linux/property.h
>   
>   SOFTWARE RAID (Multiple Disks) SUPPORT
>   M:	Song Liu <song@kernel.org>
> -R:	Yu Kuai <yukuai3@huawei.com>
> +M:	Yu Kuai <yukuai3@huawei.com>
>   L:	linux-raid@vger.kernel.org
>   S:	Supported
>   Q:	https://patchwork.kernel.org/project/linux-raid/list/
> 

