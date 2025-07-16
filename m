Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39C04A11
	for <linux-raid@vger.kernel.org>; Wed, 16 Jul 2025 07:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752652558; cv=none; b=Ay8RW8CZeVQqgEIlt9uWG/cxyMlQRoL0Iy5VDUkdT+7960i8IbkZoet4mDVvnu098jz8d328CRfVnhVT3OcaBTIPXBF1u2CuOQKuw0pABKEDNFYn3z0OPmRGlODsj1SanhzD2s9LZVVeD0vqDAbY8CVYWrZx3LxEncBbhjmxkMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752652558; c=relaxed/simple;
	bh=Zhxzdt8JZxXV+IXp68NOnGAliX55l2LmcM0utWa7SHc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=XjVHP55NYfSfaA+CD4x8lW5M4eAOtJAr7zo+RryyYFdBKkNrVSlgo39A60DeDyCipIIe9zYbWwH2e1bY8gvaUTYmZ7iB2zNSCUYRuYDM+nUwy/4a/n0Cxr3LTwl0ZnsiFemAphKQWsdWQqbfaHgftoLRmuHh23P9Cc1+1kLlsKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bhpJn3jt0zYQvNj
	for <linux-raid@vger.kernel.org>; Wed, 16 Jul 2025 15:55:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4A07A1A1A7D
	for <linux-raid@vger.kernel.org>; Wed, 16 Jul 2025 15:55:52 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHgxMHW3do7zrBAQ--.3794S3;
	Wed, 16 Jul 2025 15:55:52 +0800 (CST)
Subject: Re: [PATCH] md/raid10: fix set but not used variable in
 sync_request_write()
To: John Garry <john.g.garry@oracle.com>, song@kernel.org, xni@redhat.com
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250709104814.2307276-1-john.g.garry@oracle.com>
 <f494f013-1698-43da-a0ca-ff524b1f305c@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6336c7bf-997f-40fe-6dba-a77046fa95aa@huaweicloud.com>
Date: Wed, 16 Jul 2025 15:55:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <f494f013-1698-43da-a0ca-ff524b1f305c@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHgxMHW3do7zrBAQ--.3794S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CFW7Jr15Cw4kCw4ruw4fGrg_yoW8AFyrpr
	4kJFyUAry5GF18Jr1DJr4UAryrKr1DJ34UJr1UtFy7Xr1UXryjgF4UXr1qgr1DXr4rJryU
	XF1UXwsrZF17Jr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwz
	uWDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/07/16 15:35, John Garry 写道:
> A friendly reminder on this one...
> 

Oops, I do missed this patch, I'll pick this when I return home.

Thanks,
Kuai

> On 09/07/2025 11:48, John Garry wrote:
>> Building with W=1 reports the following:
>>
>> drivers/md/raid10.c: In function ‘sync_request_write’:
>> drivers/md/raid10.c:2441:21: error: variable ‘d’ set but not used 
>> [-Werror=unused-but-set-variable]
>>   2441 |                 int d;
>>        |                     ^
>> cc1: all warnings being treated as errors
>>
>> Remove the usage of that variable.
>>
>> Fixes: 752d0464b78a ("md: clean up accounting for issued sync IO")
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index b74780af4c22..30b860d05dcc 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -2438,15 +2438,12 @@ static void sync_request_write(struct mddev 
>> *mddev, struct r10bio *r10_bio)
>>        * that are active
>>        */
>>       for (i = 0; i < conf->copies; i++) {
>> -        int d;
>> -
>>           tbio = r10_bio->devs[i].repl_bio;
>>           if (!tbio || !tbio->bi_end_io)
>>               continue;
>>           if (r10_bio->devs[i].bio->bi_end_io != end_sync_write
>>               && r10_bio->devs[i].bio != fbio)
>>               bio_copy_data(tbio, fbio);
>> -        d = r10_bio->devs[i].devnum;
>>           atomic_inc(&r10_bio->remaining);
>>           submit_bio_noacct(tbio);
>>       }
> 
> 
> .
> 

