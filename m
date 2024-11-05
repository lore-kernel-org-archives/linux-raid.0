Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C1118CC1B
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 08:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730795352; cv=none; b=sRB+ITgOW4AsrgJ0Ly9FNyWzI9jsEjA0b7PBsSpBVJddgnHAgIrqYyQszTWkk1g9fwhrE/hgoP6UxRi1gkDG1+n9isTPzRGhkgy0tFTmftIWt8oT/tf1OzXI0VJidCSadZp1XK15Fu9pg5ZkNKEN3QSi9AJPnrd9GHDWE4S8oqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730795352; c=relaxed/simple;
	bh=rzUKockLnTEbEEJJO7GunPrVqNRkE3qfSN9chSfu3bA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HDinA/kElffx/zchMS5j32BAx6FG1S2NbExlcurSQ8kBoet178fbaOFN5J4ZNBgaX7bSVP9kdcIFch+DEaoT2VVGmNY/JhLvdMtiRe/0WekVRWjTKVxh35MDv66FOjHN1+rVuFhCNnnZx28ccUxklNxlBjGBrrAF/qeQ9cDJAQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XjM1X1W5Xz4f3jXg
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 16:28:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 286541A018D
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 16:29:06 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXcYVQ1yln_22hAw--.57435S3;
	Tue, 05 Nov 2024 16:29:06 +0800 (CST)
Subject: Re: [PATCH RFC 1/1] md: Use pers->quiesce in mddev_suspend
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Xiao Ni <xni@redhat.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241105075733.66101-1-xni@redhat.com>
 <20241105091601.00001267@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <08186a07-57b4-9e8f-d088-0e009ebe8fa5@huaweicloud.com>
Date: Tue, 5 Nov 2024 16:29:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241105091601.00001267@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXcYVQ1yln_22hAw--.57435S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF4kuw43Kw4xtr1fCrW3ZFb_yoW8Ar4Dp3
	yktFy5AayUXry5C3Wjq3srury5tw48KrW2yrW7C3s0ya43Gw1fJrW5Wan0grsF9FyIkw4a
	va1Yqw1rur1v9rUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7I
	JmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/11/05 16:16, Mariusz Tkaczyk Ð´µÀ:
> On Tue,  5 Nov 2024 15:57:33 +0800
> Xiao Ni <xni@redhat.com> wrote:
> 
>> One customer reports a bug: raid5 is hung when changing thread cnt
>> while resync is running. The stripes are all in conf->handle_list
>> and new threads can't handle them.
> 
> Is issue fixed with this patch? Is is missing here :)
>>
>> Commit b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removes
>> pers->quiesce from mddev_suspend/resume, then we can't guarantee sync
>> requests finish in suspend operation. One personality knows itself the
>> best. So pers->quiesce is a proper way to let personality quiesce.
> 
>>
>> Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
>> Signed-off-by: Xiao Ni <xni@redhat.com>
>> ---
>>   drivers/md/md.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 67108c397c5a..7409ecb2df68 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -482,6 +482,9 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
>>   		return err;
>>   	}
>>   
>> +	if (mddev->pers)
>> +		mddev->pers->quiesce(mddev, 1);
>> +
> 
> Shouldn't it be implemented as below? According to b39f35ebe86d, some levels are
> not implementing this?
> 
> +	if (mddev->pers && mddev->pers->quiesce)
> +		mddev->pers->quiesce(mddev, 1);

It's fine, the fops is never NULL, just some levels points to an empty
function.

The tricky part here is that accessing "mddev->pers" is not safe here,
'reconfig_mutex' is not held in mddev_suspend(), and can concurrent
with, for example, change levels. :(

Thanks,
Kuai

> 
> Is it reproducible with upstream kernel?
> 
> Thanks,
> Mariusz
> 
> .
> 

