Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77C853363;
	Tue, 19 Nov 2024 10:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732013923; cv=none; b=W8xv4H056Ybnq391hoqIw69BVIxsLyCPaWl0oRO7vkAtyANV2CxkqQRzIEKE9xl+aPzTKZB+yzbvGIZoDt8rjboO8wGSnvu3oEU6x8QsnFHC97SKnylqnLcSKMOcvsh3wq68PRLS7g4Db2A3kFtOLWAfmC7W+jX6O58qcLSJEDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732013923; c=relaxed/simple;
	bh=FUSqZDJHoRw+PHiln9GR281TCUN6GqZJPbMR0e7jqYg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BU+tVqxnOeTX1DdIctc5BsCbiGK44csbAere7Kur1iEDKNLxBZmZmEXrFfny6/zCKCZOJEhsaT2JbofvFbyOPjmYISEC0un79z89Vfer0Lj1Vpf8GH/KQj1RS84Xu7wlSfiotRXvMxCSgBW7mHozQAZcqz6AQ8uvH+pyyVafe4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Xt1gb4L5xz4f3jcn;
	Tue, 19 Nov 2024 18:58:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 189061A07B6;
	Tue, 19 Nov 2024 18:58:38 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCnzoJcbzxn8RXpCA--.16515S3;
	Tue, 19 Nov 2024 18:58:37 +0800 (CST)
Subject: Re: [PATCH md-6.13 4/5] md/raid5: implement pers->bitmap_sector()
To: Jack Wang <jinpu.wang@ionos.com>, yukuai1@huaweicloud.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 song@kernel.org, xni@redhat.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241118114157.355749-6-yukuai1@huaweicloud.com>
 <20241119094929.148060-1-jinpu.wang@ionos.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <adf796b9-2443-d29a-f4ac-fb9b8a657f93@huaweicloud.com>
Date: Tue, 19 Nov 2024 18:58:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241119094929.148060-1-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnzoJcbzxn8RXpCA--.16515S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKw4Utw4DXFW7Zw1xJF1xuFg_yoW3GwcEga
	s8ZFyDKw17JF1qyFsY9r43ta1fCa1fJryDJFy0qa12g345WFs8GFWku34Iq3y5uw4rurn5
	Ar93C34akw129jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j
	6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
	r21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
	73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/11/19 17:49, Jack Wang Ð´µÀ:
> Hi Kuai,
> 
> Thanks for the patchset, as you mentioned both both hung problem regarding raid5
> bitmap, just want to get confirmation, will this patchset fix the hung or just a
> performance improvement/code cleanup?

I'm hoping both. :)

After review, I'll CC related folks and see if they can comfirm this
will fix the hang problem.
> 
> 
> In patch4, as you removed the set/clear bit STRIPE_BITMAP_PENDING, I think you
> should also remove the test_bit line in stripe_can_batch, also the definition
> enum in raif5.h and the few lines in comments in __add_stripe_bio, same for the
> line in break_stripe_batch_list.

Yes, and I assume you mean patch 5.

Thanks,
Kuai

> 
> 
> Regards!
> Jinpu Wang @ IONOS
> 
> 
> .
> 

