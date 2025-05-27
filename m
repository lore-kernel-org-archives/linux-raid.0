Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FAA16F841;
	Tue, 27 May 2025 08:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748333032; cv=none; b=It+wXIWCIOXDAUAA2jY1PJ9oKfpUa/xw+d5tjRrO86/ZDmXBIA52CCGeHhGCxExMNI7cNjjUrPvSFoFnpgun99k7bQDJ95Su/CwxjQRgYN2wd3nfasodKS35nxvf3FzFxhAWKs4qf2L8NANQfzpyaKIbUWgKDDoADzRYegYk1+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748333032; c=relaxed/simple;
	bh=ESHuVTrp+zD7KCJNAsBiTIPJxxySJ2aqqY36GgXQE24=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=pUt2AQn52wO1qH/Osx48korrDlf20jA1wHaOfTMMAffmjTz6djzHuAdytw0BnJgRiOs/j4R4/zF4kx3F0vtpbKCB7B0gi/TKiyB3mGUNaU6Q5Q20te9/jQ6s9sozpOKX1CdSIunnXt4ejTqRXFdfvNPAQSzuCsHStF67YUO/YNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4b64rT1z3Pz4f3jLy;
	Tue, 27 May 2025 16:03:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 852561A1518;
	Tue, 27 May 2025 16:03:46 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3Wl_hcTVoBB6eNg--.22750S3;
	Tue, 27 May 2025 16:03:46 +0800 (CST)
Subject: Re: [PATCH 11/23] md/md-bitmap: make method bitmap_ops->daemon_work
 optional
To: Hannes Reinecke <hare@suse.de>, Yu Kuai <yukuai1@huaweicloud.com>,
 hch@lst.de, xni@redhat.com, colyli@kernel.org, song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-12-yukuai1@huaweicloud.com>
 <a1691267-304d-4a3f-898b-2f8901031d2c@suse.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c7e108a6-c788-d3d9-346c-9db134ae9ae2@huaweicloud.com>
Date: Tue, 27 May 2025 16:03:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a1691267-304d-4a3f-898b-2f8901031d2c@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3Wl_hcTVoBB6eNg--.22750S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZr4UXF47GFyUAFWruFy8Xwb_yoWfWrc_u3
	4rAF9Ikr17tFsava12kanxZrZxXr4rC34jqayUtryjq3s5X34DWF9rZ3sFv3yxJFWrA3W7
	CrZxW342yrsrujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb_Ma5UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/27 14:19, Hannes Reinecke 写道:
> On 5/24/25 08:13, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> daemon_work() will be called by daemon thread, on the one hand, daemon
>> thread doesn't have strict wake-up time; on the other hand, too much
>> work are put to daemon thread, like handle sync IO, handle failed
>> or specail normal IO, handle recovery, and so on. Hence daemon thread
>> may be too busy to clear dirty bits in time.
>>
>> Make bitmap_ops->daemon_work() optional and following patches will use
>> separate async work to clear dirty bits for the new bitmap.
>>
> Why not move it to a workqueue in general?
> The above argument is valid even for the current implementation, no?

Yes, and however, I'll prefer not to touch current implementaion :(
This is trivial comparing to other flaws like global spinlock.

Thanks,
Kuai

> 
> Cheers,
> 
> Hannes

