Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0799214B07A;
	Tue, 10 Jun 2025 06:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749535944; cv=none; b=lYUy0vIMvMxV4VOpQpO1e3R7SOeDbWbMvCt8XJoE790QTijrRgGU8qGmEJGeYCU556Zq3IvhbYyQLUSZ9pha1FEj0s4j9IWBPEjh/RnII5qIHAQsqhcICKqRpCJ0UuT8UueAlxda23hvWPsyb28KSkUC+mCKgUBQcELIBj6lILo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749535944; c=relaxed/simple;
	bh=/Ko/+5AVkjjNrzb74E44MNM/JiW7S5+fHLZx4p63RH8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=GWbBq+0jcbCyRWO1NnwGK3eD3eZLXhiiTXksorVqy5ySQY0CYSBv5sDmt+xfjxeUxEFQJy6Oeqof8pts1TypU3ZOEjvVEhCHTLKR75OMSco2ZNwv9KE3w5P+lLAkx6HXqe/MaHYvh6e4IHadSLXr+349wcNXA5naD0QI5ZucOwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bGdjt43zJzKHN7f;
	Tue, 10 Jun 2025 14:12:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E3CF31A0FAE;
	Tue, 10 Jun 2025 14:12:16 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgC3Gl+_zEdosSVBPA--.47901S3;
	Tue, 10 Jun 2025 14:12:16 +0800 (CST)
Subject: Re: [PATCH] md/raid1: Fix use-after-free in reshape pool wait queue
To: Wang Jinchao <wangjinchao600@gmail.com>, Yu Kuai
 <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250609120155.204802-1-wangjinchao600@gmail.com>
 <698d1e9a-2fc0-fa6b-2f4c-55c5129cdf28@huaweicloud.com>
 <13a82dab-94c9-4616-90ff-17a8aa7bff81@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <43a47dfd-d0c8-3d1d-d9f9-0332434a84f2@huaweicloud.com>
Date: Tue, 10 Jun 2025 14:12:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <13a82dab-94c9-4616-90ff-17a8aa7bff81@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3Gl+_zEdosSVBPA--.47901S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWry5Zr1xJFyDCr17AFWDurg_yoW5CrWDpF
	48XrZ3GrW8Xw48Xr9Ik3WUtr9rGF43Za1UAr97G3W8Jr1UGw1vqrnrXr42gF1kJay8Zry2
	kwnYqw4Y9a1j9aUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUBVbkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/06/10 12:51, Wang Jinchao 写道:
> [  921.784898] [      C2] BUG: kernel NULL pointer dereference, address: 
> 0000000000000002
> [  921.784907] [      C2] #PF: supervisor instruction fetch in kernel mode
> [  921.784910] [      C2] #PF: error_code(0x0010) - not-present page
> [  921.784912] [      C2] PGD 0 P4D 0
> [  921.784915] [      C2] Oops: 0010 [#1] PREEMPT SMP NOPTI
> [  921.784919] [      C2] CPU: 2 PID: 1659 Comm: zds Kdump: loaded 
> Tainted: G     U  W   E      6.8.1-debug-0519 #49
> [  921.784922] [      C2] Hardware name: Default string Default 
> string/Default string, BIOS DNS9V011 12/24/2024
> [  921.784923] [      C2] RIP: 0010:0x2
> [  921.784929] [      C2] Code: Unable to access opcode bytes at 
> 0xffffffffffffffd8.
> [  921.784931] [      C2] RSP: 0000:ffffa3fac0220c70 EFLAGS: 00010087
> [  921.784933] [      C2] RAX: 0000000000000002 RBX: ffff8890539070d8 
> RCX: 0000000000000000
> [  921.784935] [      C2] RDX: 0000000000000000 RSI: 0000000000000003 
> RDI: ffffa3fac07dfc90
> [  921.784936] [      C2] RBP: ffffa3fac0220ca8 R08: 2557c7cc905cff00 
> R09: 0000000000000000
> [  921.784938] [      C2] R10: 0000000000000000 R11: 0000000000000000 
> R12: 000000008fa158a0
> [  921.784939] [      C2] R13: 2557c7cc905cfee8 R14: 0000000000000000 
> R15: 0000000000000000
> [  921.784941] [      C2] FS:  00007d8b034006c0(0000) 
> GS:ffff8891bf900000(0000) knlGS:0000000000000000
> [  921.784943] [      C2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  921.784945] [      C2] CR2: ffffffffffffffd8 CR3: 00000001097be000 
> CR4: 0000000000f50ef0
> [  921.784946] [      C2] PKRU: 55555554
> [  921.784948] [      C2] Call Trace:
> [  921.784949] [      C2]  <IRQ>
> [  921.784950] [      C2]  ? show_regs+0x6d/0x80
> [  921.784957] [      C2]  ? __die+0x24/0x80
> [  921.784960] [      C2]  ? page_fault_oops+0x156/0x4b0
> [  921.784964] [      C2]  ? mempool_free_slab+0x17/0x30
> [  921.784968] [      C2]  ? __slab_free+0x15d/0x2e0
> [  921.784971] [      C2]  ? do_user_addr_fault+0x2ee/0x6b0
> [  921.784975] [      C2]  ? exc_page_fault+0x83/0x1b0
> [  921.784979] [      C2]  ? asm_exc_page_fault+0x27/0x30
> [  921.784984] [      C2]  ? __wake_up_common+0x76/0xb0
> [  921.784987] [      C2]  __wake_up+0x37/0x70
> [  921.784990] [      C2]  mempool_free+0xaa/0xc0
> [  921.784993] [      C2]  raid_end_bio_io+0x97/0x130 [raid1]

This is NULL pointer dereference, not the same as UAF, please attach the
log in the next version(and probably remove the useless info like
timestamp and stack started with ?).

(...)

> This fix is simple enough.
> Alternatively, we could initialize conf->r1bio_pool directly, but that 
> would also require
> handling rollback in case the initialization fails.
> What would you suggest?

I'll suggest to use mempool_resize() and get rid of the werid assigment.

Thanks,
Kuai

