Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B6B15990F
	for <linux-raid@vger.kernel.org>; Tue,  2 Apr 2024 17:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712078432; cv=none; b=EGn6h2g8SY/0pgtniDqsCPvyenREw9ZNeKHyE1YauWjkwngr298+/HsngfhbNw6zf0FOWzJD5fKDCmkbUXAB0wLRMgkWaRP4iHKdKNK/RrHAbvPtL7zP3k0RF+OcSwy2qfMMut8pwpU4zJUq86RA+hTrhLOIWly3EeyCy5UN9/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712078432; c=relaxed/simple;
	bh=f6+WTkSj7xBPt+V690J+DytSjZb+bZ76SJQyNDciXbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mC5qzZMSg81wkWr303ZUFVEX21TLgJYv38zLJhO1/ZhncsWTqgA5wR1jK5aLAfGKD2mgvN4/DoT+sHJRqPtaJ/yJ9nigL8ilMJx/FcmkhUR4Zs1deIc/OrHxWT69YwRbpXHzsfzSDCuAayHn/rEvakqlV8I2ljMtNTulRpdITQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.2] (ip5f5af32f.dynamic.kabel-deutschland.de [95.90.243.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 6958061E5FE01;
	Tue,  2 Apr 2024 19:19:26 +0200 (CEST)
Message-ID: <72abd26e-11f1-49ec-8c77-6d876a63c409@molgen.mpg.de>
Date: Tue, 2 Apr 2024 19:19:24 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 1/2] md/raid5: optimize RAID5 performance.
To: Yiming Xu <teddyxym@outlook.com>
Cc: linux-raid@vger.kernel.org, paul.e.luse@intel.com, firnyee@gmail.com,
 song@kernel.org, hch@infradead.org
References: <SJ0PR10MB574146BF65CC516F253B2DADD83E2@SJ0PR10MB5741.namprd10.prod.outlook.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <SJ0PR10MB574146BF65CC516F253B2DADD83E2@SJ0PR10MB5741.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Shushu,

Thank you for your patch. Some comments and nits.

Please do *not* send it to <majordomo@vger.kernel.org>.

Please also do not add a dot/period at the end of the commit message 
summary. (A more specific one would be nice too.)


Am 02.04.24 um 19:05 schrieb Yiming Xu:
> From: Shushu Yi <firnyee@gmail.com>
> 
> <changelog>

Please remove.

> Optimized by using fine-grained locks, customized data structures, and

Imperative mood: Optimize

> scattered address space. Achieves significant improvements in both
> throughput and latency.
> 
> This patch attempts to maximize thread-level parallelism and reduce
> CPU suspension time caused by lock contention. On a system with four
> PCIe 4.0 SSDs, we achieved increased overall storage throughput by
> 89.4% and decreases the 99.99th percentile I/O latency by 85.4%.
> 
> Seeking feedback on the approach and any addition information regarding
> Required performance testing before submitting a formal patch.
> 
> Note: this work has been published as a paper, and the URL is
> (https://www.hotstorage.org/2022/camera-ready/hotstorage22-5/pdf/
> hotstorage22-5.pdf)

A more elaborate description is needed.

> Co-developed-by: Yiming Xu <teddyxym@outlook.com>
> Signed-off-by: Yiming Xu <teddyxym@outlook.com>
> Signed-off-by: Shushu Yi <firnyee@gmail.com>
> Tested-by: Paul Luse <paul.e.luse@intel.com>
> ---
> V1 -> V2: Cleaned up coding style and divided into 2 patches (HemiRAID
> and ScalaRAID corresponding to the paper mentioned above). This part is
> HemiRAID, which increased the number of stripe locks to 128.
> 
>   drivers/md/raid5.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 9b5a7dc3f2a0..d26da031d203 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -501,7 +501,7 @@ struct disk_info {
>    * and creating that much locking depth can cause
>    * problems.
>    */
> -#define NR_STRIPE_HASH_LOCKS 8
> +#define NR_STRIPE_HASH_LOCKS 128
>   #define STRIPE_HASH_LOCKS_MASK (NR_STRIPE_HASH_LOCKS - 1)
>   
>   struct r5worker {

Is it intentional, that you only increased the number value of the 
macro? The comment above also suggests that bigger numbers might cause 
problems.


Kind regards,

Paul
