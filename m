Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAF32DCC0B;
	Mon, 26 May 2025 07:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748245549; cv=none; b=VbQ+V2M2UeLozMiM8MyH0TH08ZIXeTYMCPu3HeI99zeKHABIsFQtpPChpOuFFihVWPRjvwQrDOubXv2/JO4WXaQVt9OhI/ir8X9L6ed5vGJmtHBKknDmu+RjDQyhBInnAYJzUZ4D0bqVjXHWe4egey3+qWuIZhx13IMmzdoTCc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748245549; c=relaxed/simple;
	bh=IKPOttPlF0NgyQsdYLx3uMrMrLsnXJ7+pj+nFrwqMAo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=RQa0+V5NS9PwgrqtwrR75e7k0sgdxZYDgpeIQ/tGiYFT8G2y+mp+P/pX+n6W2jSTRRqsUjbG3ZYG3aOPW28YT7RS9ewHrOxIzTG1vghsGxILdUIJ3nZNiLqo4v5s0Y23L4hZqeJvmSLD0c4IqVHhM0T7sFX7gIkZjOqCSlv4jxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4b5SV966zYz4f3k5c;
	Mon, 26 May 2025 15:45:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E4ED11A16A0;
	Mon, 26 May 2025 15:45:41 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl8kHDRoqxQ2Ng--.6543S3;
	Mon, 26 May 2025 15:45:41 +0800 (CST)
Subject: Re: [PATCH 06/23] md/md-bitmap: add a new sysfs api bitmap_type
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, song@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-7-yukuai1@huaweicloud.com>
 <20250526063226.GB12811@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <577a1bf6-9f23-0ccd-c269-d625ae11890d@huaweicloud.com>
Date: Mon, 26 May 2025 15:45:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250526063226.GB12811@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl8kHDRoqxQ2Ng--.6543S3
X-Coremail-Antispam: 1UD129KBjvJXoW7trykGry8ur43Aw1DWF1xZrb_yoW8WrWxp3
	yfJ3ZxCFs5XFWFgw17uasF9FnYqw4DJF9IqryfX345Grn8XrsxWFWrWa1Dtw17A3W8ZF4D
	Za45JrW8WryUuaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/26 14:32, Christoph Hellwig Ð´µÀ:
> On Sat, May 24, 2025 at 02:13:03PM +0800, Yu Kuai wrote:
>> +  consistency_policy
> 
> .. these doc changes look unrelated, or am I missing something?

The position are moved to the front of the bitmap fields, because now
bitmap/xxx is not always here.

Before:

All md devices contain:
	level
	...
	bitmap/xxx
	bitmap/xxx
	consistency_policy
	uuid

After:
All md devices contain:
	level
	...
	consistency_policy
	uuid
	bitmap_type
		none xxx
		bitmap xxx
If bitmap_type is bitmap, then the md device will also contain:
	bitmap/xxx
	bitmap/xxx

> 
>> -static void mddev_set_bitmap_ops(struct mddev *mddev, enum md_submodule_id id)
>> +static bool mddev_set_bitmap_ops(struct mddev *mddev)
>>   {
>>   	xa_lock(&md_submodule);
>> -	mddev->bitmap_ops = xa_load(&md_submodule, id);
>> +	mddev->bitmap_ops = xa_load(&md_submodule, mddev->bitmap_id);
>>   	xa_unlock(&md_submodule);
>> -	if (!mddev->bitmap_ops)
>> -		pr_warn_once("md: can't find bitmap id %d\n", id);
>> +
>> +	if (!mddev->bitmap_ops) {
>> +		pr_warn_once("md: can't find bitmap id %d\n", mddev->bitmap_id);
>> +		return false;
>> +	}
>> +
>> +	return true;
> 
> This also looks unrelated and like another prep patch?

The new api will set mddev->bitmap_id, and the above change switch to
use mddev->bitmap_id to register bitmap_ops, perhaps I can factor the
change to a new prep patch, like:

md: add a new field mddev->bitmap_id

Before:
mddev_set_bitmap_ops(mddev, ID_BITMAP);

After:
mddev->bitmap_id = ID_BITMAP;
if (!mddev_set_bitmap_ops(mddev))
	return -EINVAL;

Thanks,
Kuai

> 
> .
> 

