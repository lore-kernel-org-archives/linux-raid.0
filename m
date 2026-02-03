Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BFB1C6FF5;
	Tue,  3 Feb 2026 08:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770106111; cv=none; b=QvrlrGKEy8taFFCLobSbtJaN49IJqiHMj4JiiFcnaQWgSH6aBFvb2e/77LMED9t4L+b/2hmvmJAE1R71TeGtYhSSDZDFpEAPwVe81/wN5iaGZUrKtzT0mBurTL9hWZJGTImuAWoJ7XgOgUg361G1QAgTni4l4kLz0vKEQ0pENJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770106111; c=relaxed/simple;
	bh=tZfxsyFi9AME1qLmcYul5SBUP/hASpMUnnFS7/CY/Hc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dXfeWaGRC9pN1Up9E1mTwUZezvH0+TUxG6oh8gEP7Hwc4UMYr0iZl2XZLYMNU2husHZI8JSEJCQUesgHGHg/eKUs6df/X6c6FthrBUSkzaV83lmIuTMJjGItW6GVU3DKKI3CJpd++ZhnPHRwfJna5pu4YZJOP6UqPCWGhKK15Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f4x1b6G6KzKHMgD;
	Tue,  3 Feb 2026 16:08:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4D2134058F;
	Tue,  3 Feb 2026 16:08:25 +0800 (CST)
Received: from [10.174.178.72] (unknown [10.174.178.72])
	by APP4 (Coremail) with SMTP id gCh0CgAXePj3rIFpHb1jGA--.20976S3;
	Tue, 03 Feb 2026 16:08:25 +0800 (CST)
Message-ID: <a1b70bef-27df-45d0-abbb-2d6b75ef5f4c@huaweicloud.com>
Date: Tue, 3 Feb 2026 16:08:23 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 0/5] md/raid1: introduce a new sync action to repair
 badblocks
To: Christoph Hellwig <hch@infradead.org>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com, xni@redhat.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 Zheng Qixing <zhengqixing@huawei.com>
References: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
 <aYGkSwDZTLLbjm6p@infradead.org>
From: Zheng Qixing <zhengqixing@huaweicloud.com>
In-Reply-To: <aYGkSwDZTLLbjm6p@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXePj3rIFpHb1jGA--.20976S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYV7kC6x804xWl14x267AKxVW8JVW5JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
	64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r
	1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kI
	c2xKxwCF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7AKxVWUtVW8ZwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJV
	WUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

Hi,

在 2026/2/3 15:31, Christoph Hellwig 写道:
> Just curious, but what kind of devices do you see that have
> permanent bad blocks at a fixed location that are not fixed by
> rewriting the sector?

The bad_blocks entries record sectors where I/O failed, which
indicates that the device-internal remapping did not succeed
at that time.

`rectify` does not assume a permanently bad or fixed LBA. Its
purpose is to trigger an additional rewrite, giving the underlying
device (e.g. FTL or firmware) another opportunity to perform its
own remapping.

