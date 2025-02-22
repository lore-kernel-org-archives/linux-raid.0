Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF555374C4;
	Sat, 22 Feb 2025 01:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740187308; cv=none; b=tKa6XdATMixM/jAQJvw/DV9JGC44b4bLbqnqQysFUafb0XBSS89nTiARgl8bfenIESqkGLdVkpDKFCZZaeOW+U+yJ0MbAZ9X4C+oIWeVK3GsL87GUsccvINWYzHWNJYRs91zGjRCGdaC8x/ehKzTICheMpTj8va+1WzgyEIsqK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740187308; c=relaxed/simple;
	bh=4+eop0VpyWEeUOPLw9t67tLLRXi2IEhOSIB9pqInSCk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=tKr3UvJKYmecjwaw8MW/XEwcfOBzhjWIRkCxLKFOKMJm++cfPAsNnjEZVV8D+PxmxW/0cvaCMCQjw5HaS+nxMPjJ/RxpYcrXUO23SMGgcmnB+rdThxbtOVVXcdHrwl+mXOig4RLQjdjKi0QTX3FusSeZIfdJ7Vau+Onc5DRTNrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z08Mv5GC2z4f3jry;
	Sat, 22 Feb 2025 09:21:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 68E831A058E;
	Sat, 22 Feb 2025 09:21:37 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXu1+eJrlnqZwiEg--.18110S3;
	Sat, 22 Feb 2025 09:21:37 +0800 (CST)
Subject: Re: [PATCH 08/12] badblocks: fix merge issue when new badblocks align
 with pre+1
To: Zheng Qixing <zhengqixing@huaweicloud.com>, axboe@kernel.dk,
 song@kernel.org, colyli@kernel.org, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
 dlemoal@kernel.org, yanjun.zhu@linux.dev, kch@nvidia.com, hare@suse.de,
 zhengqixing@huawei.com, john.g.garry@oracle.com, geliang@kernel.org,
 xni@redhat.com, colyli@suse.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-9-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b37f7500-f095-912f-cf81-aa0b214a53bf@huaweicloud.com>
Date: Sat, 22 Feb 2025 09:21:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250221081109.734170-9-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXu1+eJrlnqZwiEg--.18110S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CryUGF1kZF1xCFyDJr4UXFb_yoW8Wr15pr
	n8C3WakryqgF18u3W5u3W7XFW09w1fGF4UCanxJr1jkr9xA3WIqr1kXw4YqFyjgr4xKrs2
	q3W5uFykZ3WkG3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9qb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG
	6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F
	4UJbIYCTnIWIevJa73UjIFyTuYvjxUIoGQDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/02/21 16:11, Zheng Qixing Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> There is a merge issue when adding badblocks as follow:
>    echo 0 10 > bad_blocks
>    echo 30 10 > bad_blocks
>    echo 20 10 > bad_blocks
>    cat bad_blocks
>    0 10
>    20 10    //should be merged with (30 10)
>    30 10
> 
> In this case, if new badblocks does not intersect with prev, it is added
> by insert_at(). If there is an intersection with prev+1, the merge will
> be processed in the next re_insert loop.
> 
> However, when the end of the new badblocks is exactly equal to the offset
> of prev+1, no further re_insert loop occurs, and the two badblocks are not
> merge.
> 
> Fix it by inc prev, badblocks can be merged during the subsequent code.
> 
> Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   block/badblocks.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/block/badblocks.c b/block/badblocks.c
> index bb46bab7e99f..381f9db423d6 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -892,7 +892,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>   		len = insert_at(bb, 0, &bad);
>   		bb->count++;
>   		added++;
> -		hint = 0;
> +		hint = ++prev;
>   		goto update_sectors;
>   	}
>   
> @@ -947,7 +947,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>   	len = insert_at(bb, prev + 1, &bad);
>   	bb->count++;
>   	added++;
> -	hint = prev + 1;
> +	hint = ++prev;
>   
>   update_sectors:
>   	s += len;
> 

