Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408D13FC3;
	Mon,  7 Apr 2025 01:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743989303; cv=none; b=j6bllwfyp5aE7DzpUTDGQ+rd5HgY7cm/u/AnUHaWkq2UmGVUrPULrdsH2RQH1sDPLUsWi+M7+yQQbEuYnk0d1YWUIz0AD8uxG3f6wS+npD5KUIYFgTAzcsZrHCOMznvqDkanl7M4RNwITlBAc6Og0PAG17b8yvyOC6F5lZ/4SRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743989303; c=relaxed/simple;
	bh=8CfLDbKuh5+ZoxMWcl20u+RCFvy8oYza47qfogj25xU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HXhDovx22j+Bv9NgFWwjhzIo5YEAZ9kK4KJWt6/cRUQkkotS1UYTuNzEZyrlhrM49qhMvPhzcpBHjuR8hALtHVaIoVw+ttKf/3Wg1WlokGYlNPPMk5tzdrpKMGv+QgSST+k9muNAy/q5N8NSMqQI8v0CJyprjBibVCNAxrq4gls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZWB1k68HHz4f3jtP;
	Mon,  7 Apr 2025 09:09:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C3E031A058E;
	Mon,  7 Apr 2025 09:09:32 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgA3m1_IJfNnypPxIg--.52167S3;
	Mon, 07 Apr 2025 09:09:30 +0800 (CST)
Subject: Re: [PATCH RFC v2 00/14] md: introduce a new lockless bitmap
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
 <20250404092739.GA14046@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1b4e3ddc-be1b-8266-13c1-5654c4c79e9b@huaweicloud.com>
Date: Mon, 7 Apr 2025 09:09:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250404092739.GA14046@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3m1_IJfNnypPxIg--.52167S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtw45tr13AFykKFy7tw47urg_yoWxKrcEkF
	43WryrGwn7A342gan7Kr1fZrs5K34UJF93trZ2qFy3Ww1fAF1fAa9akr95A3ZxJ3Z3trZr
	KF1DJrWDXr129jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbmsjUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/04/04 17:27, Christoph Hellwig Ð´µÀ:
> On Fri, Mar 28, 2025 at 02:08:39PM +0800, Yu Kuai wrote:
>> 1) user must apply the following mdadm patch, and then llbitmap can be
>> enabled by --bitmap=lockless
>> https://lore.kernel.org/all/20250327134853.1069356-1-yukuai1@huaweicloud.com/
>> 2) this set is cooked on the top of my other set:
>> https://lore.kernel.org/all/20250219083456.941760-1-yukuai1@huaweicloud.com/
> 
> I tried to create a tree to review the entire thing but failed.  Can you
> please also provide a working git branch?

Of course, here is the branch:

https://git.kernel.org/pub/scm/linux/kernel/git/yukuai/linux.git/log/?h=md-6.15

Thanks,
Kuai

> 
> .
> 

