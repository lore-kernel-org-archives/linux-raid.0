Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3101F7066
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 11:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730978315; cv=none; b=Ms2YQDvJxUe4jE/6s8bqixG4jV4q8Ad+EQSVTlaER97tQ3G/ekuGxfM2uhiIpjjS+cMZ5QOftdTOlKsKHOAEhiuZVD5GL4TNq/pwGrm5nTBWKCk/ZxNdao0g4FFrPKLdE8fknTws/Ncdq93mCrHC4Wg733Rtw0NX5k6aNKLnYS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730978315; c=relaxed/simple;
	bh=BIaEE9mHL6woJwnppppDke5qGUn1JZ/o/AwkK0KkL/4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mzHrPuJVRo1fpeT6LQ9H9HTpEfeBpKHwzCvxp26MdYsGE1ho+W5r1a4Px1LJrk5xo3yCPxGTcCdfjfuchzlZjvKMUb6cmfYthTdw4+qG0oBU7QqsHR+DlyyBiZDa7xBmJvXQcFFUIaJ865Z5uVV4816JUcMu8rKBnoHLTd6JnfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Xkfh06t2Yz4f3jMx
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 19:18:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F08971A018C
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 19:18:26 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXc4cBoixnqvRrBA--.3835S3;
	Thu, 07 Nov 2024 19:18:26 +0800 (CST)
Subject: Re: [PATCH mdadm/master v2 4/4] mdadm: add support for new lockless
 bitmap
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, yangerkun@huawei.com,
 Song Liu <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <20241107081347.1947132-1-yukuai1@huaweicloud.com>
 <20241107081347.1947132-5-yukuai1@huaweicloud.com>
 <20241107100249.00000f51@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8c86ed1f-f8ea-193c-8d5f-9fb9c338f505@huaweicloud.com>
Date: Thu, 7 Nov 2024 19:18:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241107100249.00000f51@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXc4cBoixnqvRrBA--.3835S3
X-Coremail-Antispam: 1UD129KBjvJXoWrtFyUAFykZF13XFyUXry7Jrb_yoW8JrWfpr
	yUtwn5t3WrGF4xCF17Zw4xGr48Zrs3CayxCas8Jw1rZ3Z8AF1xWFnrKr4F9asF9FWIvw4Y
	vw4Yqry2kr4UZ37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUBVbkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/11/07 17:02, Mariusz Tkaczyk Ð´µÀ:
> On Thu,  7 Nov 2024 16:13:47 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> +	if (strcmp(val, "lockless") == 0) {
>> +		s->btype = BitmapLockless;
>> +		pr_info("Experimental lockless bitmap, use at your own
>> disk!\n");
>> +		return MDADM_STATUS_SUCCESS;
>> +	}
>> +
> 
> Hi Kuai,
> I'm fine with previous patches. For this one, I'm not sure If I can take it yet.
> The changes you added if for are not merged, therefore merging this looks bad
> from process point of view (I'm merging feature that is not available in
> kernel upstream). Am I missing something?

No, you're right that kernel changes are not ready yet. We just finish
testing the demo.
> 
> I would like to hear Song voice on that.
> 
> IMO, you should keep it as your own customization until development of new
> bitmap is done but I understand that the topic is not simple and you might want
> to people to test it so having mdadm build-in is an option.

Of course, I can remove this patch in the next version.
> 
> If you really want this I would need a detailed process of "way to stable" in commit
> message that I can always refer to. I'm challenging something like that first
> time so I hope Song can add something.

Thanks,
Kuai

> 
> Thanks,
> Mariusz
> 
> .
> 

