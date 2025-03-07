Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A403BBF0
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 01:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741310815; cv=none; b=sYUjVFTVcHwjVpBweC1HtJl5UfVfx2Rzr/VEeeiYy77FbzyNrnQoXylewL31mcoW4DMRrQFFm8FIwKcH0/usHT1ywE3VApMCWW0agBSuI4cB2kha6yoHWSmGa3egWckCHK8y7m6G4aCMRaLVbzqwj6t0eYf+FiaoHyLVQuTDLpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741310815; c=relaxed/simple;
	bh=5ZjIS9EOH5EvPqqTAHR1JXKmImi2zPrK0aJfCZnNMow=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ZMX5SJ/Hvl2j8FxWQ5F+7qlcaKjD+xIYKq5jZQpHTw64LHulYlmc8jRIFiyRmziw/k+9Tig7+bGF8DFv1Vm9V1aBaMvODJxBo+7Uc8gaFoO5kszkwHJ+MaRKEYn6KLI8M1VBNvhIBRxyLPev6xR84UMge70JJWegTnVq19nCuZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z87S75PqMz4f3lgM
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 09:07:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5D43A1A0AA4
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 09:07:59 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3Wl_tRspnVawKFw--.17999S3;
	Fri, 07 Mar 2025 09:07:59 +0800 (CST)
Subject: Re: [PATCH md-6.15 V2 1/1] md/raid10: wait barrier before returning
 discard request with REQ_NOWAIT
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com, song@kernel.org, pmenzel@molgen.mpg.de,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250306094938.48952-1-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c9a4abca-7c0d-0ce1-e6ef-994d9146a5ab@huaweicloud.com>
Date: Fri, 7 Mar 2025 09:07:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250306094938.48952-1-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3Wl_tRspnVawKFw--.17999S3
X-Coremail-Antispam: 1UD129KBjvJXoWrZr4DCr13Jw13WryDZr13urg_yoW8Jr18pa
	ykKr1qkrZIkw1jya1DZFyY9FW5G34Dt3yYkryxKayruFy3ZF98G34rA398GF4kuryrGrWU
	JF1fJanxJF4YqF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/03/06 17:49, Xiao Ni Ð´µÀ:
> raid10_handle_discard should wait barrier before returning a discard bio
> which has REQ_NOWAIT. And there is no need to print warning calltrace
> if a discard bio has REQ_NOWAIT flag. Quality engineer usually checks
> dmesg and reports error if dmesg has warning/error calltrace.
> 
> Fixes: c9aa889b035f ("md: raid10 add nowait support")
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
> v2: add target version in title and add Fixes tag
>   drivers/md/raid10.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
Applied to md-6.15

Thanks!
Kuai
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 15b9ae5bf84d..7bbc04522f26 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1631,11 +1631,10 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>   	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
>   		return -EAGAIN;
>   
> -	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
> +	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
>   		bio_wouldblock_error(bio);
>   		return 0;
>   	}
> -	wait_barrier(conf, false);
>   
>   	/*
>   	 * Check reshape again to avoid reshape happens after checking
> 

