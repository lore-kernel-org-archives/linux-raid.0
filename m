Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4739D308F0D;
	Mon, 18 Aug 2025 08:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755507459; cv=none; b=pWrxc7Kd7GPFMT4esgm2/ImcknsoatpDIjFhfkRrRNlO4uxxWd4gjP+JnQRpZIEST41nTVKBa4Ylf58tLtu/gmyj6JLQPBxDKkTLwscRai9Ylbz1ue4O9NjQcf3zwr4SBcyHrTJ+pZ/WxAr3L1QDoHQRITUQYndkjb6MZpeJqvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755507459; c=relaxed/simple;
	bh=zJmJWLCrMtcA0HIwYJ6pf3MbKxT9ka3s4z733NNAPQI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rqJS9yp/ksSxBpv7C7ThTa7kp6gniI36U752NC9N4DOAwc/03V83fzh3pFxTUfEeZxtPVsnyT8wD8uQScSPbfBJO/lQ83OLcTPsZayMmuaDb3llqDJy5CdP0NeOtUzHWvBGIvEwykcoXWxcp73mDOILgTC/9E14A4PYUebsOuGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c566j0c1vzKHMVV;
	Mon, 18 Aug 2025 16:57:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 78CA01A18D8;
	Mon, 18 Aug 2025 16:57:32 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB3QBH66qJoAFJYEA--.55127S3;
	Mon, 18 Aug 2025 16:57:32 +0800 (CST)
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, colyli@kernel.org,
 linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <756b587d-2a5c-4749-a03b-cfc786740684@kernel.org>
 <ffa13f8c-5dfe-20d4-f67d-e3ccd0c70b86@huaweicloud.com>
 <fd5c1916-936b-4253-a7b8-ba53591653f3@kernel.org>
 <4aa48545-7398-c346-5968-5d08f29748c4@huaweicloud.com>
 <aKLAhOxV1KViVw7w@infradead.org>
 <de4fd44c-f8be-e787-27f4-9e9e09921e12@huaweicloud.com>
 <aKLFuQX8ndDxLTVs@infradead.org>
 <e00106ae-e373-9481-8377-5e69203f9de0@huaweicloud.com>
 <aKLdm4GPVfXOm0vO@infradead.org>
 <aa12bb2b-0767-a30d-f7a6-a13722711828@huaweicloud.com>
 <aKLg7HbvjVkqB8Uu@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <917dc054-8423-4e49-7101-1667e64aae10@huaweicloud.com>
Date: Mon, 18 Aug 2025 16:57:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aKLg7HbvjVkqB8Uu@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3QBH66qJoAFJYEA--.55127S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw1UJrykuw1fZr1rZFyDAwb_yoWftrX_Wa
	9FyFs7Gw4fZr18Jay7KF45t397Ka9xGryUJFs8XF4xKry0qrZ2gFW093s5AwnrJF4qyrZI
	gr15Zw4xK3s29jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUf8nOUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/08/18 16:14, Christoph Hellwig Ð´µÀ:
> On Mon, Aug 18, 2025 at 04:10:32PM +0800, Yu Kuai wrote:
>> Why? We just set the flag for mdraid disks first, and then inherit to
>> top devices that is stacked by mdraid, so md raid limits should always
>> be relevant. I still don't understand the problem that you said :(
> 
> The point is the fact how mdraid calculates the opt_io is somewhere
> between ireelevant and wrong for any layer above.  The layers above
> just care about the value.  And to calculate the value you don't
> need a special flag.  mdraid can simply override io_opt (or better
> max_hw_sectors) after stacking the lower level devices with a few
> lines of code (and hopefully a good comment).

Ok, let's ignore the case there are other drivers in the stack chains,
just in this case: mdraid on the top of another mdraid, which we already
have. And in order not to introduce regression, we can do this inside
mdraid.

Thanks,
Kuai

> 
> .
> 

