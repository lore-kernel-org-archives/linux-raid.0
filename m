Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74ECA31618C;
	Thu, 29 Jan 2026 03:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769657211; cv=none; b=ejm0L8xhy1ItXEWIygOfdw3IEsPL7dKNxmy5mwbpBQFE/uqJ7osji6Q+O3d1vptexh4FR5j4uT7WOhX10e/RdfaWMbyH84Hv1ymELyML2mogJW6Iw5W7BPnADBXOYMJfgjTB82kr+bzJ0pIBxgtsvaH5+Qkr1tFHmDT7O415OLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769657211; c=relaxed/simple;
	bh=3mJziTbjEti0LvFuAONlRQQ3eBeR/29fszrJ06MJ1DA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OmDpA5S38M4ZHhf77U2o6AswXr5rMm66hH0XKjqFG2za15HPloK6kurgV5Xhd4tjgRcD8z/jBTv9FByYWGTYK3hgaODHSh6kcFnimpUQeRUlN73QlASYmooP3eWHYsCBibBKoKfQWHgUdBwu7rNLTVqLcYHWdLAx83s04LPmGXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f1l0T4lrLzYQtgP;
	Thu, 29 Jan 2026 11:26:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EDF9D40575;
	Thu, 29 Jan 2026 11:26:39 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgC3ZPVu03ppGDj2FQ--.32594S3;
	Thu, 29 Jan 2026 11:26:39 +0800 (CST)
Message-ID: <faa1075a-009c-e2c4-b76a-99352fd46e07@huaweicloud.com>
Date: Thu, 29 Jan 2026 11:26:38 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/3] lib/raid6: Divide the raid6 algorithm selection
 process into two parts
To: sunliming@linux.dev, song@kernel.org, yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 sunliming <sunliming@kylinos.cn>
References: <20260128104923.338443-1-sunliming@linux.dev>
 <20260128104923.338443-2-sunliming@linux.dev>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260128104923.338443-2-sunliming@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3ZPVu03ppGDj2FQ--.32594S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXw45Gr4DXw13Kr1UWF13twb_yoW7Gr13pw
	4xt3Wavr4kXrWS93srJFs0vr9a9r4fGw1agrnxC3s3J3sYqr98Xw47t34UCr9xJr92qw1U
	Xr18Zr4UKw4jk37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9jb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvf
	C2KfnxnUUI43ZEXa7IU1d-PUUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/28 18:49, sunliming@linux.dev 写道:
> From: sunliming <sunliming@kylinos.cn>
> 
> Divide the RAID6 algorithm selection process into two parts: fast selection
> and benchmark selection. To prepare for the asynchronous processing of
> the benchmark phase.
> 
> Signed-off-by: sunliming <sunliming@kylinos.cn>
> ---
>   lib/raid6/algos.c | 76 +++++++++++++++++++++++++++++++----------------
>   1 file changed, 51 insertions(+), 25 deletions(-)
> 
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index 799e0e5eac26..ac6a77b0ae1d 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -134,7 +134,7 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
>   static inline const struct raid6_recov_calls *raid6_choose_recov(void)
>   {
>   	const struct raid6_recov_calls *const *algo;
> -	const struct raid6_recov_calls *best;
> +	const struct raid6_recov_calls *best = NULL;
>   
>   	for (best = NULL, algo = raid6_recov_algos; *algo; algo++)
>   		if (!best || (*algo)->priority > best->priority)
> @@ -152,24 +152,44 @@ static inline const struct raid6_recov_calls *raid6_choose_recov(void)
>   	return best;
>   }
>   
> -static inline const struct raid6_calls *raid6_choose_gen(
> -	void *(*const dptrs)[RAID6_TEST_DISKS], const int disks)
> +/* Quick selection: selects the first valid algorithm. */
> +static inline const struct raid6_calls *raid6_choose_gen_fast(void)
> +{
> +	const struct raid6_calls *const *algo;
> +	const struct raid6_calls *best = NULL;
> +
> +	for (algo = raid6_algos; *algo; algo++) {
> +		if ((*algo)->valid && !(*algo)->valid())
> +			continue;
This logic is odd. We should select the highest-priority algorithm
instead of the first one. This was introduced by commit be85f93ae2df
("lib/raid6: add option to skip algorithm benchmarking").

After fix, this logic is identical to raid6_choose_recov(). Could we reuse
it after renaming the function?


> +
> +		best = *algo;
> +		break;
> +	}
> +
> +	if (best) {
> +		raid6_call = *best;
> +		pr_info("raid6: skipped pq benchmark and selected %s\n",
> +			best->name);
> +	} else {
> +		pr_err("raid6: No valid algorithm found even for fast selection!\n");
> +	}
> +
> +	return best;
> +}
> +
> +static inline const struct raid6_calls *raid6_gen_benchmark(
> +		void *(*const dptrs)[RAID6_TEST_DISKS], const int disks)
>   {
>   	unsigned long perf, bestgenperf, j0, j1;
>   	int start = (disks>>1)-1, stop = disks-3;	/* work on the second half of the disks */
>   	const struct raid6_calls *const *algo;
> -	const struct raid6_calls *best;
> +	const struct raid6_calls *best = NULL;
>   
>   	for (bestgenperf = 0, best = NULL, algo = raid6_algos; *algo; algo++) {
>   		if (!best || (*algo)->priority >= best->priority) {
>   			if ((*algo)->valid && !(*algo)->valid())
>   				continue;
>   
> -			if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK)) {
> -				best = *algo;
> -				break;
> -			}
> -
>   			perf = 0;
>   
>   			preempt_disable();
> @@ -200,12 +220,6 @@ static inline const struct raid6_calls *raid6_choose_gen(
>   
>   	raid6_call = *best;
>   
> -	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK)) {
> -		pr_info("raid6: skipped pq benchmark and selected %s\n",
> -			best->name);
> -		goto out;
> -	}
> -
>   	pr_info("raid6: using algorithm %s gen() %ld MB/s\n",
>   		best->name,
>   		(bestgenperf * HZ * (disks - 2)) >>
> @@ -235,16 +249,11 @@ static inline const struct raid6_calls *raid6_choose_gen(
>   	return best;
>   }
>   
> -
>   /* Try to pick the best algorithm */
>   /* This code uses the gfmul table as convenient data set to abuse */
> -
> -int __init raid6_select_algo(void)
> +static int raid6_choose_gen_benmark(const struct raid6_calls **gen_best)
>   {
>   	const int disks = RAID6_TEST_DISKS;
> -
> -	const struct raid6_calls *gen_best;
> -	const struct raid6_recov_calls *rec_best;
>   	char *disk_ptr, *p;
>   	void *dptrs[RAID6_TEST_DISKS];
>   	int i, cycle;
> @@ -269,14 +278,31 @@ int __init raid6_select_algo(void)
>   	if ((disks - 2) * PAGE_SIZE % 65536)
>   		memcpy(p, raid6_gfmul, (disks - 2) * PAGE_SIZE % 65536);
>   
> -	/* select raid gen_syndrome function */
> -	gen_best = raid6_choose_gen(&dptrs, disks);
> +	*gen_best = raid6_gen_benchmark(&dptrs, disks);
> +
> +	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
> +
> +	return 0;
> +}
> +
> +int __init raid6_select_algo(void)
> +{
> +	int ret;
> +	const struct raid6_calls *gen_best = NULL;
> +	const struct raid6_recov_calls *rec_best = NULL;
> +
> +	/* select raid gen_syndrome functions */
> +	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK))
> +		gen_best = raid6_choose_gen_fast();
> +	else {
> +		ret = raid6_choose_gen_benmark(&gen_best);

'gen_best' is meaningless, use 'ret' directly. The input parameter of 
raid6_choose_gen_benchmark() can be modified to void.

> +		if (ret < 0)
> +			return ret;
> +	}
>   
>   	/* select raid recover functions */
>   	rec_best = raid6_choose_recov();
>   
> -	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
> -
>   	return gen_best && rec_best ? 0 : -EINVAL;
>   }
>   

-- 
Thanks,
Nan

