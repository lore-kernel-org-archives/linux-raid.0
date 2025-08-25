Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689B71E51EF;
	Mon, 25 Aug 2025 01:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756085206; cv=none; b=kWSKs199w3pm6XWqQ2kPsVAJFSzQx207ghcRevLJdLXxoBsArixi0pqmR+W9nXodTah7jQabsuN7oOUSdMyHfrszOQw+Guv+GQmv9BLNIpja1+4hY0iL+WW9G7nZ2ri+yPwdzpq65ZOQKFR8dupf8lwhgIBvSASwtoPn5ScXXDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756085206; c=relaxed/simple;
	bh=MjM3E1fMUfhIiHX863olH1swQuF+aVBgHon8JdgGek8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lRRB4u//hpwfi4bXYuaqVSKcOOo0HM9oOmEBKyG/seS317R8piYIgdI1t9l40A0P4f8p/1pKph/GdWPF6jKurSUq4MoKEFW5wCfxtFv2pY7y/seXcU4LeYRSE9RxEUaBqakBpiaJKoMUfnDcciAAxQrYC9qiVz5a6ADVq2D3MO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c9CnF6Sg9zKHMjb;
	Mon, 25 Aug 2025 09:26:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7ED351A165F;
	Mon, 25 Aug 2025 09:26:41 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgCn8Y3Pu6towJLJAA--.52610S3;
	Mon, 25 Aug 2025 09:26:41 +0800 (CST)
Message-ID: <c103d14a-16a2-0703-232e-774eb18f21d9@huaweicloud.com>
Date: Mon, 25 Aug 2025 09:26:39 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 3/3] md: Fix the return value of mddev_stack_new_rdev
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linan666@huaweicloud.com
Cc: song@kernel.org, yukuai3@huawei.com, hare@suse.de, axboe@kernel.dk,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 bvanassche@acm.org, hch@infradead.org, filipe.c.maia@gmail.com,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250719083119.1068811-1-linan666@huaweicloud.com>
 <20250719083119.1068811-4-linan666@huaweicloud.com>
 <yq1bjp1ge13.fsf@ca-mkp.ca.oracle.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <yq1bjp1ge13.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCn8Y3Pu6towJLJAA--.52610S3
X-Coremail-Antispam: 1UD129KBjvdXoWruFy3Cw47Jr4xXFy8Wr4kZwb_yoWxuFb_Wr
	9293Z7K34IyFZ7CF1akF47X392qay8Gr1fJFykJrsxXr95JFs5XryS93s3u3yxGr93tr4Y
	9rs3ua47GwnxujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbqxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwACI402YVCY1x02628vn2kIc2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14
	v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQV
	y7UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/7/31 13:01, Martin K. Petersen 写道:
> 
>> In mddev_stack_new_rdev(), if the integrity profile check fails, it
>> returns -ENXIO, which means "No such device or address". This is
>> inaccurate and can mislead users. Change it to return -EINVAL.
> 
>> Fixes: c6e56cf6b2e7 ("block: move integrity information into queue_limits")
> 
> Returning -ENXIO predates the above commit by many, many years. Changing
> the return value might break applications which rely on the original
> behavior.
> 
> In case of a stacking failure, an appropriate message is logged and the
> function returns an errno. How is that misleading?
> 

Thanks for your review, I will delete it in v3.

-- 
Thanks,
Nan

