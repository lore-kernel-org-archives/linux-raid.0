Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D46F1DF75C;
	Mon, 18 Aug 2025 00:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755478575; cv=none; b=IDY6r5dS8NWmyNDsQlFIQCZw/+GhzXN/bEiociytIJTX04NhJqtc/jLVn7kqKsPF7JasmNW8DU5R3SepWDMwVW7K4TuCfSuH9u8UKkcWXz7VeP9btpq3UtSIelxMqbaAQPLy7qCnprt5ad5TipBGsJLha1i4NLpWshR3dNzFCIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755478575; c=relaxed/simple;
	bh=lQQXRYy245OiG2IPuYscDsZGqJXrQUjtXiEFU+b6U5I=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PjXmWJnGltEGjeh3PN3e6I5Gj72uQhujnHM5dKzW8OYAVScY29PRp937AOE7hJ/l/r5zObNQgPC1aIcebZccqFSIV/VQtw4mmMBUiKSJohI3OizuFW56/HQC+KPkreMcdIVrTk8M/EEmu2IVMpNoyKVZGMb3tsDVq9RCtKGaAUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c4vR84Jr9zKHMVF;
	Mon, 18 Aug 2025 08:56:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 03CF81A1797;
	Mon, 18 Aug 2025 08:56:04 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDnrxAieqJoRB0yEA--.17918S3;
	Mon, 18 Aug 2025 08:56:03 +0800 (CST)
Subject: Re: [PATCH] md/raid5-ppl: Fix invalid context sleep in
 ppl_io_unit_finished() on PREEMPT_RT
To: Yunseong Kim <ysk@kzalloc.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250817113114.1335810-3-ysk@kzalloc.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <acd0a040-18ce-05f5-4896-ad24dda6fb00@huaweicloud.com>
Date: Mon, 18 Aug 2025 08:56:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250817113114.1335810-3-ysk@kzalloc.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnrxAieqJoRB0yEA--.17918S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CFy5XFW7Wry7Cry7XF1kZrb_yoW8uryUpF
	WrWF9Iv3WkXrsYqwsFk3WIkrWfta1Igry7Cw45uwn7ArZ8XryxJr17Jr9xGryqqF4xJrW8
	Xa4UJa9xCrsxA37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2N
	tUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/08/17 19:31, Yunseong Kim Ð´µÀ:
> The function ppl_io_unit_finished() uses a local_irq_save()/spin_lock()
> sequence. On a PREEMPT_RT enabled kernel, spin_lock() can sleep. Calling it
> with interrupts disabled creates an atomic context where sleeping is
> forbidden.
> 
What? I believe spin_lock can never sleep.

> Ensuring that the interrupt state is managed atomically with the lock
> itself. The change is applied to both the 'log->io_list_lock' and
> 'ppl_conf->no_mem_stripes_lock' critical sections within the function.
> 
> Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
> ---
>   drivers/md/raid5-ppl.c | 12 ++++--------
>   1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> index 56b234683ee6..650bd59ead72 100644
> --- a/drivers/md/raid5-ppl.c
> +++ b/drivers/md/raid5-ppl.c
> @@ -553,15 +553,13 @@ static void ppl_io_unit_finished(struct ppl_io_unit *io)
>   
>   	pr_debug("%s: seq: %llu\n", __func__, io->seq);
>   
> -	local_irq_save(flags);
> -
> -	spin_lock(&log->io_list_lock);
> +	spin_lock_irqsave(&log->io_list_lock, flags);
>   	list_del(&io->log_sibling);
> -	spin_unlock(&log->io_list_lock);
> +	spin_unlock_irqrestore(&log->io_list_lock, flags);
>   
>   	mempool_free(io, &ppl_conf->io_pool);
>   
> -	spin_lock(&ppl_conf->no_mem_stripes_lock);
> +	spin_lock_irqsave(&ppl_conf->no_mem_stripes_lock, flags);

Please notice, local_irq_save + spin_lock is the same as
spin_lock_irqsave, I don't think your changes have any functonal
chagnes.

Thanks,
Kuai

>   	if (!list_empty(&ppl_conf->no_mem_stripes)) {
>   		struct stripe_head *sh;
>   
> @@ -571,9 +569,7 @@ static void ppl_io_unit_finished(struct ppl_io_unit *io)
>   		set_bit(STRIPE_HANDLE, &sh->state);
>   		raid5_release_stripe(sh);
>   	}
> -	spin_unlock(&ppl_conf->no_mem_stripes_lock);
> -
> -	local_irq_restore(flags);
> +	spin_unlock_irqrestore(&ppl_conf->no_mem_stripes_lock, flags);
>   
>   	wake_up(&conf->wait_for_quiescent);
>   }
> 

